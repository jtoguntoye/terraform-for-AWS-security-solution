# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0 */

# --- modules/s3/outputs.tf ---

output "bucket_arn" {
  value       = aws_s3_bucket.vpc_log_bucket.arn
  description = "ARN of vpc logs bucket"
}

output "bucket_id" {
  value = aws_s3_bucket.vpc_log_bucket.id
}