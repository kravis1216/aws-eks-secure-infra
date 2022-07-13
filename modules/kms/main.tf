#---------------------------------------------------------------
# aws_kms_key
#---------------------------------------------------------------
resource "aws_kms_key" "default" {
  description         = var.description
  enable_key_rotation = true

  tags = var.tags
}

#---------------------------------------------------------------
# aws_kms_alias
#---------------------------------------------------------------
resource "aws_kms_alias" "default" {
  name          = var.alias_name
  target_key_id = aws_kms_key.default.key_id
}

