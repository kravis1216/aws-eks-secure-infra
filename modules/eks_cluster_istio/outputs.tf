output "cluster_id" {
  value = aws_eks_cluster.default.id
}

output "cluster_name" {
  value = aws_eks_cluster.default.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.default.endpoint
}

output "cluster_authority_data" {
  value = aws_eks_cluster.default.certificate_authority[0].data
}


