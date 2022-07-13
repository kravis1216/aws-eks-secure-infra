variable "name_of_cluster" {
  type        = string
  description = "Name of Cluster."
}

variable "name_of_node_group" {
  type        = string
  description = "Name of EKS Node Group."
}

variable "node_role_arn" {
  type        = string
  description = "ARN of the IAM Role that provides permmsions for the EKS node group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to lanch resouces in."
  validation {
    condition = (
      length(var.subnet_ids) > 0
    )
    error_message = "You must specify at least 1 subnet to launch resouces in."
  }
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = <<-EOT
      Instance types to user for this node group. 
      Must be empty if the launch template configured by `launch_template_id` specifies an instance type.
    EOT
}

variable "scaling_config" {
  type = object({
    desirec_size = number
    max_size     = number
    min_size     = number
  })
  description = "Desired/Maximu/Minimum number of worker nodes. "
}

variable "launch_template_name" {
  type        = string
  description = "The name(not ID) of a custom launch template to use for the EKS node group."
}

variable "launch_template_user_data" {
  type        = string
  description = "Tha base64-encoded user data to provide when launching the instance."
}

variable "launch_template_tags" {
  type        = map(any)
  description = "Key-Value map of resource tags."
}

/*
variable "launch_template_version" {
  type        = string
  description = "The version of the specified launch template to use. Defaults to latest version."
}
*/

variable "labels" {
  type        = map(string)
  description = <<-EOF
      Key-Value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument.
      Other Kuberentes labels applied to the EKS Node Group will note be managed.
    EOF
  default     = {}
}

variable "node_tags" {
  type        = map(any)
  description = "Key-Value map of resource tags."
}
