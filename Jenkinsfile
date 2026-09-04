pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Release Image') {
            steps {
                script {
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse HEAD',
                        returnStdout: true
                    ).trim()

                    env.IMAGE_NAME = 'chiru0977/intellipaat-website'

                    echo "========================================="
                    echo "Release Image"
                    echo "========================================="
                    echo "Git Commit : ${env.IMAGE_TAG}"
                    echo "Docker Image: ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                }
            }
        }

        stage('Verify Kubernetes Access') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                        echo "========================================="
                        echo "Kubernetes Cluster"
                        echo "========================================="

                        kubectl get nodes -o wide
                    '''
                }
            }
        }

        stage('Deploy Namespace') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                        kubectl apply -f kubernetes/namespace.yaml
                    '''
                }
            }
        }

        stage('Deploy Application') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                        kubectl apply -f kubernetes/deployment.yaml
                        kubectl apply -f kubernetes/service.yaml
                    '''
                }
            }
        }

        stage('Deploy Release Image') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                        echo "========================================="
                        echo "Deploying Release Image"
                        echo "========================================="

                        kubectl -n intellipaat set image \
                          deployment/intellipaat-website \
                          intellipaat-website=$IMAGE_NAME:$IMAGE_TAG

                        echo "========================================="
                        echo "Waiting for Rolling Update"
                        echo "========================================="

                        kubectl -n intellipaat rollout status \
                          deployment/intellipaat-website \
                          --timeout=180s
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                        echo "========================================="
                        echo "Pods"
                        echo "========================================="

                        kubectl get pods \
                          -n intellipaat \
                          -o wide

                        echo "========================================="
                        echo "Deployment"
                        echo "========================================="

                        kubectl get deployment \
                          -n intellipaat

                        echo "========================================="
                        echo "Service"
                        echo "========================================="

                        kubectl get service \
                          -n intellipaat
                    '''
                }
            }
        }

        stage('Verify Image') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                        echo "========================================="
                        echo "Running Image"
                        echo "========================================="

                        kubectl get deployment intellipaat-website \
                          -n intellipaat \
                          -o jsonpath='{.spec.template.spec.containers[0].image}'

                        echo

                        echo "========================================="
                        echo "Expected Image"
                        echo "========================================="

                        echo "$IMAGE_NAME:$IMAGE_TAG"

                        echo "========================================="
                        echo "Verifying Image"
                        echo "========================================="

                        RUNNING_IMAGE=$(kubectl get deployment \
                          intellipaat-website \
                          -n intellipaat \
                          -o jsonpath='{.spec.template.spec.containers[0].image}')

                        test "$RUNNING_IMAGE" = "$IMAGE_NAME:$IMAGE_TAG"

                        echo "Image verification PASSED."
                    '''
                }
            }
        }

        stage('Verify Requirements') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                        READY=$(kubectl get deployment intellipaat-website \
                          -n intellipaat \
                          -o jsonpath='{.status.readyReplicas}')

                        REPLICAS=$(kubectl get deployment intellipaat-website \
                          -n intellipaat \
                          -o jsonpath='{.spec.replicas}')

                        NODEPORT=$(kubectl get service intellipaat-website \
                          -n intellipaat \
                          -o jsonpath='{.spec.ports[0].nodePort}')

                        echo "Ready replicas: $READY"
                        echo "Desired replicas: $REPLICAS"
                        echo "NodePort: $NODEPORT"

                        test "$READY" = "2"
                        test "$REPLICAS" = "2"
                        test "$NODEPORT" = "30008"

                        echo "========================================="
                        echo "All Kubernetes requirements PASSED"
                        echo "========================================="
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Jenkins Kubernetes release PASSED.'
        }

        failure {
            echo 'Jenkins Kubernetes release FAILED.'
        }
    }
}
