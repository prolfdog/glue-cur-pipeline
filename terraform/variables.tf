variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "glue_database_name" {
  description = "Glue database name"
  type        = string
  default     = "job-pipeline-glue"
}

variable "glue_table_name" {
  description = "Glue table name"
  type        = string
  default     = "customers"
}

variable "output_bucket" {
  description = "S3 bucket for output"
  type        = string
  default     = "glue-practice-136513167152"
}