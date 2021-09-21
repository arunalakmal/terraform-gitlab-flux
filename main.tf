provider "flux" {}
provider "kubectl" {}
provider "kubernetes" {
  config_path = var.kube_config_path
}
provider "gitlab" {
  token = var.gitlab_token
}

locals {
  known_hosts  = "gitlab.com,172.65.251.78 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY="
  repo_ssh_url = "ssh://git@gitlab.com/${var.gitlab_repo_path}/${var.gitops_administrator_repo}"
  key_title    = "${var.gitlab_repo_path}-flux-key"
}

data "gitlab_group" "group" {
  full_path = var.gitlab_repo_path
}

data "gitlab_project" "gitopsadministrator" {
  id = var.gitlab_project_id
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "flux_install" "main" {
  target_path = var.target_path
}

data "flux_sync" "main" {
  target_path = var.target_path
  url         = local.repo_ssh_url
  branch      = var.branch
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = var.flux_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "gitlab_deploy_key" "flux_deploy_key" {
  project = data.gitlab_project.gitopsadministrator.id
  title   = local.key_title
  key     = tls_private_key.main.public_key_openssh
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = local.known_hosts
  }
}