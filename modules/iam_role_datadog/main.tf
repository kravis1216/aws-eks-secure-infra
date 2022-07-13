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
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role_with_externalID.json
  tags               = var.tags
}

resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}
