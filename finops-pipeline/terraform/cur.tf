# Glue database for CUR data
resource "aws_glue_catalog_database" "cur_database" {
  name        = "cur"
  description = "AWS Cost and Usage Report data"

  tags = {
    Name        = "cur-database"
    Environment = var.environment
  }
}

resource "aws_glue_crawler" "cur_crawler" {
  name          = "cur-crawler-${var.environment}"
  role          = data.aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.cur_database.name
  
  # Point to the base path, not /data/
  s3_target {
    path = "s3://${var.cur_bucket}/cur/MyCostExport/"
  }

  # Optional: add table prefix
  # table_prefix = "cost_"

  schedule = "cron(0 6 * * ? *)"

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
      Tables = { AddOrUpdateBehavior = "MergeNewColumns" }
    }
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    }
  })

  tags = {
    Name        = "cur-crawler"
    Environment = var.environment
    Purpose     = "FinOps"
  }
}