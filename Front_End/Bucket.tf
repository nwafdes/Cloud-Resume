
# create the bucket
resource "aws_s3_bucket" "nawafdes-personal-static-website" {
    bucket = var.bucket_name
    tags = {
      name = "nawafdes-bucket"
      Environment = "production"
    }

}

# Enable Versioning
resource "aws_s3_bucket_versioning" "bucket-versioning" {
    bucket = aws_s3_bucket.nawafdes-personal-static-website.id
    versioning_configuration {
    status = "Enabled"
  }
}
# Enalb public access
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.nawafdes-personal-static-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# Upload files ( add for loop )
resource "aws_s3_object" "bucket-object" {
  bucket = aws_s3_bucket.nawafdes-personal-static-website.id

  for_each = toset(var.files)
  key    = each.value
  source = "../../../assets/${each.value}"

  content_type = lookup(
    {
      "html" = "text/html"
      "css"  = "text/css"
      "js"   = "application/javascript"
      "png"  = "image/png"
      "jpg"  = "image/jpeg"
      "svg"  = "image/svg+xml"
    },
    split(".", each.value)[length(split(".", each.value)) - 1],
    "application/octet-stream"
  )
}
# edit the bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.nawafdes-personal-static-website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.nawafdes-personal-static-website.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cd.arn
          }
        }
      }
    ]
  })
  depends_on = [aws_cloudfront_distribution.cd]
}
