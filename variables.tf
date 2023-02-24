variable "naming_prefix" {
  type        = string
  description = "Prefix for naming resources"
  default     = "globoweb"
}
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR Blocks for vpc"
  default     = "10.0.0.0/16"
}
variable "vpc_subnets_cidr_blocks" {
  type        = list(string)
  description = "CIDR Blocks for subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets to create"
  default     = 2
}

variable "instance_type" {
  type        = string
  description = "value for dos"
  default     = "t4g.micro"
}

variable "instances_nginx_servers_count" {
  type        = number
  description = "Number of subnets to create"
  default     = 2
}

variable "instance_ami" {
  type        = string
  description = "value for instance AMI"
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2"

}

variable "company" {
  type        = string
  description = "value for company"
  default     = "Globomatics"
}

variable "project" {
  type        = string
  description = "value for project"
}

variable "billing_code" {
  type        = string
  description = "value for billing_code"
}