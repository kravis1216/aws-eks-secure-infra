#---------------------------------------------------------------
# aws_launch_template
#---------------------------------------------------------------
resource "aws_launch_template" "default" {
  name = var.launch_template_name

  user_data = var.launch_template_user_data
  tags      = var.launch_template_tags
}

#---------------------------------------------------------------
# aws_eks_node_group 
#---------------------------------------------------------------
resource "aws_eks_node_group" "default" {
  node_group_name = var.name_of_node_group

  cluster_name   = var.name_of_cluster
  node_role_arn  = var.node_role_arn
  subnet_ids     = var.subnet_ids
  instance_types = sort(var.instance_types)

  scaling_config {
    desired_size = var.scaling_config.desirec_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  launch_template {
    id      = aws_launch_template.default.id
    version = aws_launch_template.default.latest_version
  }

  tags = var.node_tags
}
