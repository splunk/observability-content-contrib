provider "signalfx" {
  auth_token = var.access_token
  api_url    = "https://api.${var.realm}.signalfx.com"
}

module "aws" {
  source     = "./modules/aws"
  alert_prefix = var.alert_prefix
}

module "host" {
  source     = "./modules/host"
  alert_prefix = var.alert_prefix

}

module "kafka" {
  source     = "./modules/kafka"
  alert_prefix = var.alert_prefix

}

module "azure" {
  source     = "./modules/azure"
  alert_prefix = var.alert_prefix
}

module "docker" {
  source     = "./modules/docker"
  alert_prefix = var.alert_prefix
}

module "gcp" {
  source     = "./modules/gcp"
  alert_prefix = var.alert_prefix
}

module "kubernetes" {
  source     = "./modules/kubernetes"
  alert_prefix = var.alert_prefix
}

