provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "static" {
  bucket = "terraform-series-bai3"
  acl    = "public-read"
  policy = file("s3_static_policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

locals {
  mime_types = {
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    woff  = "font/woff"
    woff2 = "font/woff2"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    jpg   = "image/jpeg"
    png   = "image/png"
    svg   = "image/svg+xml"
    eot   = "application/vnd.ms-fontobject"
  }
}

resource "aws_s3_bucket_object" "object" {
  for_each     = fileset(path.module, "static-web/**/*")
  bucket       = aws_s3_bucket.static.id
  key          = replace(each.value, "static-web", "")
  source       = each.value
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}
