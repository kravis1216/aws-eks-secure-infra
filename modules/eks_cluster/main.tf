#---------------------------------------------------------------
# terraform
#---------------------------------------------------------------
terraform {
  required_providers {
    helm = {
      source  = "helm"
      version = "~> 2.0"
    }
  }
}

#---------------------------------------------------------------
# aws_eks_cluster
#---------------------------------------------------------------
resource "aws_eks_cluster" "default" {
  name     = var.cluster_name
  version  = var.k8s_version
  role_arn = var.cluster_role_arn

  vpc_config {
    security_group_ids = var.cluster_security_group_ids
    subnet_ids         = var.subnet_ids
  }

  encryption_config {
    provider {
      key_arn = var.encryption_key_arn
    }
    resources = var.encryption_resources
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = var.tags
}
