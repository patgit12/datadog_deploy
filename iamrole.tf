data "aws_iam_policy_document" "datadog_assume_role" {
  statement {
    sid    = "AllowDatadogAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::464622532012:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [datadog_integration_aws.sandbox.external_id]
    }
  }
}

resource "aws_iam_role" "datadog" {
  name               = "DatadogIntegrationRole"
  assume_role_policy = data.aws_iam_policy_document.datadog_assume_role.json
}

resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.datadog.name
  policy_arn = aws_iam_policy.datadog_policy.arn
}

resource "aws_iam_policy" "datadog_policy" {
  name   = "DatadogIntegrationPolicy"
  policy = data.aws_iam_policy_document.datadog.json
}

# Create a new Datadog - Amazon Web Services integration
resource "datadog_integration_aws" "sandbox" {
  #account_id = "411854276167"
  account_id                 = data.aws_caller_identity.current.account_id
  role_name                  = "DatadogIntegrationRole"
  metrics_collection_enabled = "true"
  filter_tags                = ["Name:Ansible-Ubuntu"]
  host_tags                  = ["Name:Ansible-Ubuntu"]
  account_specific_namespace_rules = {
    auto_scaling = false
    opsworks     = false
  }
  #excluded_regions = ["us-east-1", "us-west-2"]
}