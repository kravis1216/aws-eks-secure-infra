data "aws_ami" "eks_worker" {
  # EKSノードで利用するAMI IDを取得
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.default.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

resource "aws_launch_template" "default" {
  # 呼び出し時に起動テンプレートが提供されない場合、このデフォルトを使用します。

  # count = var.launch_template.createflag ? 1 : 0

  name = var.launch_template.name
  # image_id = data.aws_ami.eks_worker.image_id

  user_data = var.launch_template.userdata
  tags      = var.launch_template.tags
}

