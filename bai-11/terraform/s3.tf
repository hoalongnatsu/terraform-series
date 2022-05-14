resource "aws_s3_bucket" "s3_pro" {
  bucket        = "terraform-serries-s3-pro"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "s3_pro" {
  bucket = aws_s3_bucket.s3_pro.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "s3_pro" {
  bucket = aws_s3_bucket.s3_pro.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

data "aws_iam_policy_document" "s3_pro" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_pro.arn}/*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_pro" {
  bucket = aws_s3_bucket.s3_pro.id
  policy = data.aws_iam_policy_document.s3_pro.json
}
