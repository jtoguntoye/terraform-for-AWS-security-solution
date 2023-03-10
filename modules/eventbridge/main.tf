# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0 */

# --- modules/eventbridge/main.tf ---

# Event rule resource
resource "aws_cloudwatch_event_rule" "Guardduty-Event-EC2-MaliciousIPCaller" {
  name = "Guardduty-Event-EC2-MaliciousIPCaller"
  description = "Guardduty Event: UnauthorizedAccess:EC2/MaliciousIPCaller.Custom"

  event_pattern = <<EOF
  {
    "source": ["aws.guardduty"],
    "detail": {
        "type": ["UnauthorizedAccess:EC2/MaliciousIPCaller.Custom"]
     }     
  }
  EOF
}

resource "aws_cloudwatch_event_rule" "Guardduty-Event-IAMUser-MaliciousIPCaller" {
   name = "Guardduty-Event-IAMUser-MaliciousIPCaller"
  description = "Guardduty Event: UnauthorizedAccess:IAM/MaliciousIPCaller.Custom"

  event_pattern = <<EOF
  {
    "source": ["aws.guardduty"],
    "detail": {
        "type": ["UnauthorizedAccess:IAMUser/MaliciousIPCaller.Custom"]
     }     
  }
  EOF
}



 resource "aws_cloudwatch_event_target" "ec2_sns" {

   rule      = aws_cloudwatch_event_rule.Guardduty-Event-EC2-MaliciousIPCaller.name
   target_id = "GuardDuty-Example"
   arn       = var.sns_topic_arn

   input_transformer {
     input_paths = {
       gdid     = "$.detail.id",
       region   = "$.detail.region",
       instanceid = "$.detail.resource.instanceDetails.instanceId"
     }
     input_template = "\"GuardDuty Finding for the BOA313 Workshop on Terraform and AWS Security Solutions. | ID:<gdid> | The EC2 instance: <instanceid>, may be compromised and should be investigated. Go to https://console.aws.amazon.com/guardduty/home?region=<region>#/findings?macros=current&fId=<gdid>\""
   }
 }



 resource "aws_cloudwatch_event_target" "Iam_sns" {

   rule      = aws_cloudwatch_event_rule.Guardduty-Event-IAMUser-MaliciousIPCaller.name
   target_id = "GuardDuty-Example"
   arn       = var.sns_topic_arn

   input_transformer {
     input_paths = {
       gdid     = "$.detail.id",
       region   = "$.detail.region",
       userName = "$.detail.resource.accessKeyDetails.userName"
     }
     input_template = "\"GuardDuty Finding also for re:Inforce 2022 | ID:<gdid> | AWS Region:<region>. An AWS API operation was invoked (userName: <userName>) from an IP address that is included on your threat list and should be investigated.Go to https://console.aws.amazon.com/guardduty/home?region=<region>#/findings?macros=current&fId=<gdid>\""
   }
 }

 #Event target resource for lambda remediation function

 resource "aws_cloudwatch_event_target" "lambda_function_target" {
   rule =  aws_cloudwatch_event_rule.Guardduty-Event-IAMUser-MaliciousIPCaller.name
   target_id = "Guardduty-finding-lambda-remediation"

   arn =  var.lambda_remediation_function_arn
 }