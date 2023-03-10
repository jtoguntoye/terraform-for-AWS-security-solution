# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0 */

# --- modules/s3/main.tf ---

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "vpc_log_bucket" {
  bucket        = "guarduty-example-${data.aws_caller_identity.current.account_id}-us-east-1"
  force_destroy = true
}

resource "aws_flow_log" "name" {
  log_destination      = aws_s3_bucket.vpc_log_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id

}

