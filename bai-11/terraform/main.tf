provider "aws" {
  region  = "us-west-2"
}

output "dns" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3" {
  value = {
    pro     = aws_s3_bucket.s3_pro.bucket_domain_name
    pre_pro = aws_s3_bucket.s3_pre_pro.bucket_domain_name
  }
}
