provider "signalfx" {
  auth_token = var.access_token
  api_url    = "https://api.${var.realm}.signalfx.com"
}

module "aws" {
  source     = "./modules/aws"
  sfx_prefix = var.sfx_prefix
}

module "host" {
  source     = "./modules/host"
  sfx_prefix = var.sfx_prefix

}

module "kafka" {
  source     = "./modules/kafka"
  sfx_prefix = var.sfx_prefix

}

module "azure" {
  source     = "./modules/azure"
  sfx_prefix = var.sfx_prefix
}

module "docker" {
  source     = "./modules/docker"
  sfx_prefix = var.sfx_prefix
}

module "gcp" {
  source     = "./modules/gcp"
  sfx_prefix = var.sfx_prefix
}

module "kubernetes" {
  source     = "./modules/kubernetes"
  sfx_prefix = var.sfx_prefix
}

