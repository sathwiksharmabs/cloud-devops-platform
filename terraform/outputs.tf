output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.platform_demo.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.platform_demo.arn
}

output "s3_bucket_region" {
  description = "AWS region of the S3 bucket"
  value       = aws_s3_bucket.platform_demo.region
}
