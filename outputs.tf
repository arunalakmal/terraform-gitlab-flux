output "flux_namespace" {
  value = var.flux_namespace
}

output "install_manifests" {
  value = data.flux_install.main.content
}

output "sync_manifests" {
  value = data.flux_sync.main.content
}