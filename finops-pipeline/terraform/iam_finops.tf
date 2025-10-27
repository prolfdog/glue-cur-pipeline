# IAM policy for Cost Explorer and Cost Allocation Tags
resource "aws_iam_policy" "cost_explorer_access" {
  name        = "CostExplorerTagManagement"
  description = "Allows managing cost allocation tags and viewing cost data"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ce:UpdateCostAllocationTagsStatus",
          "ce:ListCostAllocationTags",
          "ce:GetCostAndUsage",
          "ce:GetCostForecast",
          "ce:DescribeReport"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "cost-explorer-access"
    Environment = var.environment
  }
}

# Create FinOps group
resource "aws_iam_group" "finops_team" {
  name = "FinOpsTeam"
}

# Attach policy to group (not user!)
resource "aws_iam_group_policy_attachment" "finops_cost_explorer" {
  group      = aws_iam_group.finops_team.name
  policy_arn = aws_iam_policy.cost_explorer_access.arn
}

# Add user to group
resource "aws_iam_user_group_membership" "philip_finops" {
  user = "PhilipRolph"
  groups = [
    aws_iam_group.finops_team.name
  ]
}