terraform {
  required_version = "1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }

    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.2.1-rc.3"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

provider "scaleway" {
  profile = "vinyl-catalog"
  zone    = "fr-par-1"
  region  = "fr-par"
}

provider "aws" {
  region  = "eu-central-1"
}

provider "helm" {
  kubernetes {
    config_context = "admin@vinyl-catalog-cluster-3a660f45-2710-424a-9706-872002af88f1"
    config_path = "~/.kube/config"
  }
}

module "aws_resources" {
  source = "./aws"
  project_name = var.project_name
  tag_environment = var.tag_environment
  vpc_cidr = var.vpc_cidr
  public_subnet_range = var.public_subnet_range
  public_subnet_range_2 = var.public_subnet_range_2
  public_subnet_range_3 = var.public_subnet_range_3
  scaleway_ips = var.scaleway_ips
  #  private_subnet_range = var.private_subnet_range
}

module "scaleway_resources" {
  source = "./scaleway"
  project_name = var.project_name
  tag_environment = var.tag_environment
}

module "k8s_resources" {
  source = "./k8s"
  project_name = var.project_name
  tag_environment = var.tag_environment
  nginx_ip = module.scaleway_resources.nginx-ip
  nginx_zone = module.scaleway_resources.nginx-ip-zone
  # Ensures that when destroying, the k8s_resources are destroyed
  # before the cluster, so it does not try to do it after the cluster is killed
  # which leads to an error (Kubernetes cluster unreachable)
  depends_on = [module.scaleway_resources]
}