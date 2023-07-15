output "gitlab_domain" {
  value       = var.gitlab_domain
  description = "Main domain e.g \"gitlab.fisch3r.net\"."
}

output "pages_domain" {
  value       = var.pages_domain
  description = "Pages domain e.g \"pages.fisch3r.net\"."
}

output "registry_domain" {
  value       = var.registry_domain
  description = "Container registry domain e.g \"registry.fisch3r.net\"."
}

output "https_port" {
  value       = var.https_port
  description = "The GitLab server's HTTPS bind port."
}

output "http_port" {
  value       = var.http_port
  description = "The GitLab server's HTTP bind port."
}

output "ssh_port" {
  value       = var.ssh_port
  description = "The GitLab server's SSH bind port."
}
