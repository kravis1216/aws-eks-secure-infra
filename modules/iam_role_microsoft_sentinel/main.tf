#---------------------------------------------------------------
# data
#---------------------------------------------------------------
data "aws_iam_policy_document" "assume_role_with_externalID" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.identifier]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.conditon_value]
    }
  }
}

#---------------------------------------------------------------
# aws_iam_role
#---------------------------------------------------------------
resource "aws_iam_role" "default" {
  name                = var.name
  assume_role_policy  = data.aws_iam_policy_document.assume_role_with_externalID.json
  managed_policy_arns = var.managed_policy_arns
  tags                = var.tags
}

