variable "name_of_cluster" {
  type = string
  description = "Name of Cluster."
}

variable "name_of_node_group" {
  type = string
  description = "Name of EKS Node Group."
}

variable "node_role_arn" {
    type = list(strin)
    default = [  ]
    description = "ARN of the IAM Role that provides permmsions for the EKS node group."
}

variable "subnet_ids" {
    type = list(string)
    description = "A list of subnet IDs to lanch resouces in."
    validation {
        condition = (
            length(var.subnet_ids) > 0
        )
        error_message = "You must specify at least 1 subnet to launch resouces in."
    }  
}

variable "instance_types" {
    type = list(string)
    default = ["t3.medium"]
    description = <<-EOT
      Instance types to user for this node group. 
      Must be empty if the launch template configured by `launch_template_id` specifies an instance type.
    EOT
}

variable "scaling_config" {
    type = object({
        desirec_size = number
        max_size = number
        mix_size = number
    })
    description = "Desired/Maximu/Minimum number of worker nodes. "
}

variable "launch_template_id" {
  type = list(string)
  default = [  ]
  description = "The ID(not name) of a custom launch template to use for the EKS node group. If provided, it must specify the AMI image ID."
}

variable "launch_template_version" {
    type = list(string)
    default = [  ]
    description = "The version of the specified launch template to use. Defaults to latest version."
    validation = {
        condition = (
            length(var.launch_template_version) < 2
        )
        error_message = "You may not specify more than one version."
    }
}

variable "labels" {
    type = map(string)
    description = <<-EOF
      Key-Value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument.
      Other Kuberentes labels applied to the EKS Node Group will note be managed.
    EOF
    default = {}
}

variable "tags" {
  type        = map(any)
  description = "Key-Value map of resource tags."
}
