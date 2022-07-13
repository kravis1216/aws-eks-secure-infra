output "kms_key_arn" {
  value = aws_kms_key.default.arn
}

output "kms_key_id" {
  value = aws_kms_key.default.key_id
}
output "kms_alias_arn" {
  value = aws_kms_alias.default.arn
}

