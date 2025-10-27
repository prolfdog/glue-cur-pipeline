# Try the CLI command again (should work now!)
aws ce update-cost-allocation-tags-status \
  --region us-east-1 \
  --cost-allocation-tags-status \
    TagKey=aws:autoscaling:groupName,Status=Active \
    TagKey=aws:cloudformation:stack-name,Status=Active \
    TagKey=aws:cloudformation:stack-id,Status=Active \
    TagKey=aws:cloudformation:logical-id,Status=Active \
    TagKey=aws:elasticmapreduce:job-flow-id,Status=Active \
    TagKey=aws:elasticmapreduce:instance-group-role,Status=Active \
    TagKey=aws:elasticmapreduce:editor-id,Status=Active \
    TagKey=aws:ec2launchtemplate:id,Status=Active \
    TagKey=aws:ec2spot:fleet-request-id,Status=Active \
    TagKey=aws:ecs:clusterName,Status=Active \
    TagKey=aws:ecs:serviceName,Status=Active \
    TagKey=Project,Status=Active \
    TagKey=Owner,Status=Active