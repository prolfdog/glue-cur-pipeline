# Reference the existing S3 bucket
data "aws_s3_bucket" "glue_bucket" {
  bucket = var.output_bucket
}

# Upload the Glue script to S3
resource "aws_s3_object" "customer_pipeline_script" {
  bucket = data.aws_s3_bucket.glue_bucket.id
  key    = "scripts/customer_pipeline.py"
  source = "${path.module}/../scripts/customer_pipeline.py"
  etag   = filemd5("${path.module}/../scripts/customer_pipeline.py")

  tags = {
    Name        = "customer-pipeline-script"
    Environment = var.environment
  }
}