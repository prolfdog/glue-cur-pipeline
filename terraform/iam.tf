# Reference existing IAM role instead of creating new one
data "aws_iam_role" "glue_job_role" {
  name = "AWSGlueServiceRole-myRole"
}