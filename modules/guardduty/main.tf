# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0 */
# --- modules/guardduty/main.tf ---

resource "aws_guardduty_detector" "project-gd" {
  enable = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}

# ADD THE EIP/MALICIOUS IP TO THE BUCKET AS A TEXT FILE
resource "aws_s3_object" "MyThreatIntelSet" {
  bucket = var.bucket
  content = var.malicious_ip
  key = "MyThreatIntelSet"
}

resource "aws_guardduty_threatintelset" "project-threat-list" {
    activate = true
    detector_id = aws_guardduty_detector.project-gd.id
    format = "TXT"
    location = "https://s3.amazonaws.com/${aws_s3_object.MyThreatIntelSet.bucket}/${aws_s3_object.MyThreatIntelSet.key}"
    name =  "MyThreatIntelSet"
  
}