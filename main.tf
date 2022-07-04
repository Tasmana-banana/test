locals {
  dynamo_name = "test-${var.team}-dynamodb-${var.environment}-${var.default_region}"
  ec2_name    = "test-${var.team}-ec2-${var.environment}-${var.default_region}"
  kms_name    = "test-${var.team}-kms-key-${var.environment}-${var.default_region}"
  role_name   = "test-${var.team}-role-${var.environment}-${var.default_region}"
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_policy" {

  statement {
    effect = "Allow"

    actions = ["kms:Decrypt"]

    resources = [
      aws_kms_key.test-devops-kms-key-dev-eu-west-1.arn
    ]
  }
  statement {
    effect = "Allow"

    actions = [
        "dynamodb:GetRecords",
        "dynamodb:GetItem",
        "dynamodb:PutItem"
                ]

    resources = [
      module.dynamodb_table.dynamodb_table_arn
    ]   
  }
}

resource "aws_kms_key" "test-devops-kms-key-dev-eu-west-1" {
  description             = local.kms_name
  deletion_window_in_days = 20
}

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "1.0.0"

  name           = local.dynamo_name
  hash_key       = "id"
  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]
}

resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = "t3.medium"
  iam_instance_profile        = "${aws_iam_instance_profile.test_profile.name}" 

  tags = {
    Name = local.ec2_name
  }
}

resource "aws_iam_role" "role" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json

  inline_policy {
    name   = local.role_name
    policy = data.aws_iam_policy_document.ec2_policy.json
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name = local.role_name
  role = "${aws_iam_role.role.name}"
}