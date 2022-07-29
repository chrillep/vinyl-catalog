terraform {
  required_version = "1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.2.0"
    }
  }
}

data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

resource "random_password" "rds-master-password" {
  length           = 32
  special          = true
  override_special = "!$%&*()-_=+[]{}<>:?"
}

locals {
  tags = {
    "project" : var.project_name
    "env" : var.tag_environment
  }
  ifconfig_json = jsondecode(data.http.my_public_ip.body)
}