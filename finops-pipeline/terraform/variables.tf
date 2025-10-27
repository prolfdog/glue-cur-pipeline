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

variable "cur_bucket" {
  description = "S3 bucket containing CUR data"
  type        = string
  default     = "cur-136513167152"
}

variable "cur_report_path" {
  description = "Path to CUR data in S3"
  type        = string
  default     = "cur/MyCostExport/data/"
}