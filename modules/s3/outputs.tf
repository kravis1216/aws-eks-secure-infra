output "bucket_name" {
  value = aws_s3_bucket.default.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.default.arn
}

output "bucket_id" {
  value = aws_s3_bucket.default.id
}
