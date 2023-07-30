locals {
  lifecycle_configuration_rules = [{
    enabled = true
    id      = "v2rule"

    abort_incomplete_multipart_upload_days = 1

    filter_and = null
    expiration = {
      days = 120
    }
    noncurrent_version_expiration = {
      newer_noncurrent_versions = 3
      noncurrent_days           = 60
    }
    transition = [{
      days          = 30
      storage_class = "STANDARD_IA"
      },
      {
        days          = 60
        storage_class = "ONEZONE_IA"
    }]
    noncurrent_version_transition = [{
      newer_noncurrent_versions = 3
      noncurrent_days           = 30
      storage_class             = "ONEZONE_IA"
    }]
  }]

  privileged_principal_arns = [{
    "arn:aws:iam::510430971399:role/AWSReservedSSO_AdministratorAccess_d214e011273b94bd" = [""]
  }]

  privileged_principal_actions = [
    "s3:PutObject",
    "s3:PutObjectAcl",
    "s3:GetObject",
    "s3:DeleteObject",
    "s3:ListBucket",
    "s3:ListBucketMultipartUploads",
    "s3:GetBucketLocation",
    "s3:AbortMultipartUpload"
  ]
}