resource "aws_glue_job" "customer_pipeline" {
  name     = "customer-pipeline-${var.environment}"
  role_arn = data.aws_iam_role.glue_job_role.arn

  command {
    script_location = "s3://${data.aws_s3_bucket.glue_bucket.id}/${aws_s3_object.customer_pipeline_script.key}"
    python_version  = "3"
  }

  # Glue version
  glue_version = "4.0"

  # Worker configuration
  worker_type       = "G.1X"
  number_of_workers = 2

  # Timeout and retries
  timeout           = 60  # minutes
  max_retries       = 1

  # Job parameters (passed to your script)
  default_arguments = {
    "--job-bookmark-option"   = "job-bookmark-disable"
    "--enable-metrics"        = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-spark-ui"       = "true"
    "--spark-event-logs-path" = "s3://${data.aws_s3_bucket.glue_bucket.id}/spark-logs/"
    
    # Your custom parameters
    "--DATABASE_NAME"      = var.glue_database_name
    "--TABLE_NAME"         = var.glue_table_name
    "--OUTPUT_PATH"        = "s3://${data.aws_s3_bucket.glue_bucket.id}/output/filtered-customers/"
    "--REVENUE_THRESHOLD"  = "1000"
    "--PREMIUM_THRESHOLD"  = "3000"
    "--GOLD_THRESHOLD"     = "1500"
  }

  tags = {
    Name        = "customer-pipeline"
    Environment = var.environment
  }
}