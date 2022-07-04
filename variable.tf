variable "provider_role_arn" {
  type        = string
  description = "Provider Role ARN to assume"
}

variable "default_region" {
  type        = string
  description = "AWS default region"
  default     = "eu-west-1"
}

variable "environment" {
  type        = string
  description = "Environment selector"
  default = "dev"
}

variable "ami_id" {
  type        = string
  description = "Instance AMI id"
  default     = "ami-0d71ea30463e0ff8d"
}

variable "team" {
  type    = string
  default = "devops"
}

variable "enabled" {
  default = 0
}


##Dynamo

variable "create_table" {
  description = "Controls if DynamoDB table and associated resources are created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type        = list(map(string))
  default     = []
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
  type        = string
  default     = null
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity. The valid values are PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}

variable "read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = null
}