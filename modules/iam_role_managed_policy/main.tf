#---------------------------------------------------------------
# data
#---------------------------------------------------------------
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

#---------------------------------------------------------------
# aws_iam_role
#---------------------------------------------------------------
resource "aws_iam_role" "default" {
  name                = var.name
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = var.managed_policy_arns
  tags                = var.tags
}

