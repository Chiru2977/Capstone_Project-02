pipeline {
    agent any

    triggers {
        cron('H 2 25 * *')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
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

        stage('Set Application Image') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                        kubectl -n intellipaat set image deployment/intellipaat-website \
                          intellipaat-website=chiru0977/intellipaat-website:1.0

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
            echo 'Jenkins Kubernetes deployment PASSED.'
        }

        failure {
            echo 'Jenkins Kubernetes deployment FAILED.'
        }
    }
}
