# --------------------------------
# VPC Outputs
# --------------------------------

output "vpc_id" {
  description = "ID of the DevOps Capstone VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}


# --------------------------------
# Jenkins Outputs
# --------------------------------

output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  description = "Jenkins public IP address"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_private_ip" {
  description = "Jenkins private IP address"
  value       = aws_instance.jenkins.private_ip
}


# --------------------------------
# Kubernetes Master Outputs
# --------------------------------

output "k8s_master_instance_id" {
  description = "Kubernetes master EC2 instance ID"
  value       = aws_instance.k8s_master.id
}

output "k8s_master_public_ip" {
  description = "Kubernetes master public IP address"
  value       = aws_instance.k8s_master.public_ip
}

output "k8s_master_private_ip" {
  description = "Kubernetes master private IP address"
  value       = aws_instance.k8s_master.private_ip
}


# --------------------------------
# Kubernetes Worker 1 Outputs
# --------------------------------

output "k8s_worker1_instance_id" {
  description = "Kubernetes worker 1 EC2 instance ID"
  value       = aws_instance.k8s_worker1.id
}

output "k8s_worker1_public_ip" {
  description = "Kubernetes worker 1 public IP address"
  value       = aws_instance.k8s_worker1.public_ip
}

output "k8s_worker1_private_ip" {
  description = "Kubernetes worker 1 private IP address"
  value       = aws_instance.k8s_worker1.private_ip
}


# --------------------------------
# Kubernetes Worker 2 Outputs
# --------------------------------

output "k8s_worker2_instance_id" {
  description = "Kubernetes worker 2 EC2 instance ID"
  value       = aws_instance.k8s_worker2.id
}

output "k8s_worker2_public_ip" {
  description = "Kubernetes worker 2 public IP address"
  value       = aws_instance.k8s_worker2.public_ip
}

output "k8s_worker2_private_ip" {
  description = "Kubernetes worker 2 private IP address"
  value       = aws_instance.k8s_worker2.private_ip
}
