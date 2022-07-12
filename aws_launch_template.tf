#---------------------------------------------------------------
# local variables
#---------------------------------------------------------------
locals {
  inhouse_worker_template_name                  = "${local.launch_template_name_prefix}_main_worker"
}

#---------------------------------------------------------------
# aws_launch_template 
#---------------------------------------------------------------
resource "aws_launch_template" "inhouse_worker" {
  name = local.inhouse_worker_template_name

  userdata   = base64encode(file("./data/eks_nodes_userdata.tpl"))
  tags = merge(local.tags, {
      Name = local.inhouse_worker_template_name
      Type = "${local.type_launch_template}"
  })
}
