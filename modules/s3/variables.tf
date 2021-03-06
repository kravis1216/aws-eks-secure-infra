variable "bucket" {}

variable "create_acl" {
  type    = bool
  default = false
}

variable "bucket_public_access_block" {
  type = object({
    create_bucket_public_access_block = bool
    block_public_acls                 = bool
    block_public_policy               = bool
    ignore_public_acls                = bool
    restrict_public_buckets           = bool
  })

  default = {
    create_bucket_public_access_block = false
    block_public_acls                 = true
    block_public_policy               = true
    ignore_public_acls                = true
    restrict_public_buckets           = true
  }
}

variable "bucket_acl" {
  type = object({
    create_bucket_acl = bool
    acl               = string
  })

  default = {
    create_bucket_acl = false
    acl               = "default"
  }
}

variable "bucket_policy" {
  type = object({
    create_bucket_policy = bool
    bucket_policy        = string
  })

  default = {
    create_bucket_policy = false
    bucket_policy        = ""
  }
}

variable "bucket_sse_config" {
  type = object({
    create_bucket_sse_config = bool
    kms_key_arn              = string
    sse_algorithm            = string
  })

  default = {
    create_bucket_sse_config = false
    kms_key_arn              = ""
    sse_algorithm            = "aws:kms"
  }

}

variable "tags" {}
