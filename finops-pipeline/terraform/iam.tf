# Reference existing IAM role for Glue
data "aws_iam_role" "glue_role" {
  name = "AWSGlueServiceRole-myRole"
}

# Add S3 permissions for CUR bucket
resource "aws_iam_role_policy" "cur_s3_access" {
  name = "cur-s3-access-${var.environment}"
  role = data.aws_iam_role.glue_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.cur_bucket}",
          "arn:aws:s3:::${var.cur_bucket}/*"
        ]
      }
    ]
  })
}