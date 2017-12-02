provider "aws" {
  region = "eu-west-1"
}

variable "cidr_block" {
  default = "10.10.0.0/16"
}

module "vpc" {
  source = "../modules/vpc"

  name = "devternity-paul"

  cidr = "${var.cidr_block}"

  private_subnets = [
    "${cidrsubnet(var.cidr_block, 3, 5)}", //10.10.160.0/19
    "${cidrsubnet(var.cidr_block, 3, 6)}", //10.10.192.0/19
    "${cidrsubnet(var.cidr_block, 3, 7)}"  //10.10.224.0/19
  ]

  public_subnets = [
    "${cidrsubnet(var.cidr_block, 5, 0)}", //10.10.0.0/21
    "${cidrsubnet(var.cidr_block, 5, 1)}", //10.10.8.0/21
    "${cidrsubnet(var.cidr_block, 5, 2)}"  //10.10.16.0/21
  ]

  availability_zones = ["${data.aws_availability_zones.zones.names}"]
}

data "aws_availability_zones" "zones" {}

data "aws_ami" "application_instance_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["application_instance-*"]
  }
  filter {
    name = "tag:Version"
    values = ["1.0.0"]
  }
}


