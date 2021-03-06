variable "cluster_name" {}
variable "k8s_version" {}
variable "cluster_role_arn" {}
variable "cluster_security_group_ids" {}
variable "encryption_key_arn" {}
variable "encryption_resources" {}
variable "enabled_cluster_log_types" {}
variable "node_role_arn" {}
variable "subnet_ids" {}
variable "instance_types" {}
variable "desired_capacity" {}
variable "max_capacity" {}
variable "min_capacity" {}
variable "node_labels" {}
variable "tags" {}

variable "istio_namespace" {}
variable "helm_istio_base_release_name" {}
variable "helm_istio_base_chart" {}
variable "helm_istio_discovery_release_name" {}
variable "helm_istio_discovery_chart" {}
variable "istio_discovery_set" { default = null }

variable "helm_aws-lb-controller_release_name" {}
variable "helm_aws-lb-controller_chart" {}
variable "helm_aws-lb-controller_namespace" {}
variable "helm_aws-lb-controller_repository" {}
variable "aws-lb-controller_set" {}

variable "launch_template" {
  default = {
    # createflag = false
    name     = ""
    userdata = ""
    tags     = ""
  }
}

