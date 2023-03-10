/* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 SPDX-License-Identifier: MIT-0 */

# --- modules/sns/outputs.tf ---

output "sns_topic_arn" {
  value =  aws_sns_topic.gd_sns_topic.arn
  description =  "ARN of SNS topic to be called in the eventbridge rule"
}