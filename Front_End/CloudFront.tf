# what are locals?
locals {
  s3_origin_id = "myS3origin"
}

# delcare the OAC (Origin Access Control)
resource "aws_cloudfront_origin_access_control" "OAC" {
  name = "Sahaba-OAC"
  description = "Deploying OAC using Terraform"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}
# creating the Cloudfront distribution
resource "aws_cloudfront_distribution" "cd" {
  origin {
    domain_name = aws_s3_bucket.nawafdes-personal-static-website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id
    origin_id = local.s3_origin_id
  }
enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "about.html"
 
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    # cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"

    # viewer policy 


    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
