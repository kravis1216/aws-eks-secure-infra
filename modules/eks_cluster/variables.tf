variable "cluster_name" {
  type        = string
  description = "Name of the cluster."
}

variable "k8s_version" {
  type        = string
  description = "Desired Kubernetes version."
}

variable "cluster_role_arn" {
  type        = string
  description = "ARN of the IAM role that provides permission for the Kubernetes Control Plane to make calles to AWS API operation on your behalf."
}

variable "encryption_key_arn" {
  type        = string
  default     = ""
  description = "KMS Key ID to use for cluster encryption config."
}

variable "encryption_resources" {
  type        = list(any)
  default     = ["secrets"]
  description = "List of strings with resource to be encrypted."
}

variable "enabled_cluster_log_types" {
  type        = list(any)
  default     = ["api", "audit"]
  description = "List of the desired control plane logging to enable."
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of the subnet IDs. Must be in at least two defferent availability zones."
}

variable "cluster_security_group_ids" {
  type        = list(any)
  description = "List of security group ids for the cross-account the elastic network interfaces that EKS create to allow communication between your worker nodes and Kubernetes Control Plane."
}

variable "tags" {
  type        = map(any)
  description = "Key-Value map of resource tags."
}
