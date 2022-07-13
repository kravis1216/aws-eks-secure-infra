#---------------------------------------------------------------
# aws_s3_bucket
#---------------------------------------------------------------
resource "aws_s3_bucket" "default" {
  bucket = var.bucket
  tags   = var.tags
}

#---------------------------------------------------------------
# aws_s3_bucket_public_access_block
#---------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "default" {
  count = var.bucket_public_access_block.create_bucket_public_access_block ? 1 : 0

  bucket = var.bucket

  block_public_acls       = var.bucket_public_access_block.block_public_acls
  block_public_policy     = var.bucket_public_access_block.block_public_policy
  ignore_public_acls      = var.bucket_public_access_block.ignore_public_acls
  restrict_public_buckets = var.bucket_public_access_block.restrict_public_buckets
}

#---------------------------------------------------------------
# aws_s3_bucket_acl
#---------------------------------------------------------------
resource "aws_s3_bucket_acl" "default" {
  count = var.bucket_acl.create_bucket_acl ? 1 : 0

  bucket = aws_s3_bucket.default.id
  acl    = var.bucket_acl.acl
}

#---------------------------------------------------------------
# aws_s3_bucket_policy
#---------------------------------------------------------------
resource "aws_s3_bucket_policy" "default" {
  count = var.bucket_policy.create_bucket_policy ? 1 : 0

  bucket = aws_s3_bucket.default.id
  policy = var.bucket_policy.bucket_policy
}

#---------------------------------------------------------------
# aws_s3_bucket_server_side_encryption_configuration
#---------------------------------------------------------------
## Session
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  count = var.bucket_sse_config.create_bucket_sse_config ? 1 : 0

  bucket = aws_s3_bucket.default.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.bucket_sse_config.sse_algorithm
      kms_master_key_id = var.bucket_sse_config.kms_key_arn
    }
  }
}



