provider "signalfx" {
  auth_token = var.api_token
  api_url    = "https://api.${var.realm}.signalfx.com"
}

module "aws" {
  source     = "./modules/aws"
  o11y_prefix = var.o11y_prefix
}

module "host" {
  source     = "./modules/host"
  o11y_prefix = var.o11y_prefix

}

module "kafka" {
  source     = "./modules/kafka"
  o11y_prefix = var.o11y_prefix

}

module "azure" {
  source     = "./modules/azure"
  o11y_prefix = var.o11y_prefix
}

module "docker" {
  source     = "./modules/docker"
  o11y_prefix = var.o11y_prefix
}

module "gcp" {
  source     = "./modules/gcp"
  o11y_prefix = var.o11y_prefix
}

module "kubernetes" {
  source     = "./modules/kubernetes"
  o11y_prefix = var.o11y_prefix
}

module "pivotal" {
  source     = "./modules/pivotal"
  o11y_prefix = var.o11y_prefix
}

module "usage_dashboard" {
  source     = "./modules/dashboards/usage"
  o11y_prefix = var.o11y_prefix
}

module "parent_child_dashboard" {
  source     = "./modules/dashboards/parent"
  o11y_prefix = var.o11y_prefix
}

module "rum_and_synthetics_dashboard" {
  source     = "./modules/dashboards/rum_and_synthetics"
  o11y_prefix = var.o11y_prefix
}

module "executive-dashboards" {
  source     = "./modules/dashboards/executive-dashboards"
  o11y_prefix = var.o11y_prefix
}