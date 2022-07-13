output "eks_cluster_id" {
  description = "The id of the cluster."
  value       = join("", aws_eks_cluster.default.*.id)
}

output "eks_cluster_name" {
  description = "The name of the cluster."
  value       = join("", aws_eks_cluster.default.*.name)
}

output "eks_cluster_arn" {
  description = "The ARN of the cluster."
  value       = join("", aws_eks_cluster.default.*.arn)
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS Kubernetes endpoint."
  value       = join("", aws_eks_cluster.default.*.endpoint)
}
