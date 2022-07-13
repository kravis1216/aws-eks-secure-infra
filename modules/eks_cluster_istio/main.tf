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

#---------------------------------------------------------------
# aws_eks_node_group
#---------------------------------------------------------------
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.default.name
  node_group_name = format("%s_node_group", aws_eks_cluster.default.name)
  node_role_arn   = var.node_role_arn

  subnet_ids = var.subnet_ids

  instance_types = var.instance_types

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  launch_template {
    id      = aws_launch_template.default.id
    version = aws_launch_template.default.latest_version
  }

  labels = var.node_labels

  tags = var.tags

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}

#---------------------------------------------------------------                             
# helm(istio)                            
#---------------------------------------------------------------
resource "helm_release" "istio_base" {
  name             = var.helm_istio_base_release_name
  chart            = var.helm_istio_base_chart
  namespace        = var.istio_namespace
  create_namespace = true
}

resource "helm_release" "istio_discovery" {
  name             = var.helm_istio_discovery_release_name
  chart            = var.helm_istio_discovery_chart
  namespace        = var.istio_namespace
  create_namespace = true

  dynamic "set" {
    iterator = item
    for_each = var.istio_discovery_set == null ? [] : var.istio_discovery_set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}

#---------------------------------------------------------------
# helm(lb_controller)
#---------------------------------------------------------------
resource "helm_release" "aws-lb-controller" {
  name             = var.helm_aws-lb-controller_release_name
  chart            = var.helm_aws-lb-controller_chart
  namespace        = var.helm_aws-lb-controller_namespace
  repository       = var.helm_aws-lb-controller_repository
  create_namespace = true

  dynamic "set" {
    iterator = item
    for_each = var.aws-lb-controller_set == null ? [] : var.aws-lb-controller_set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}

