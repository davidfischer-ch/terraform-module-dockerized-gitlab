variable "identifier" {
  type        = string
  description = "Identifier (must be unique, used to name resources)."
  validation {
    condition     = regex("^[a-z]+(-[a-z0-9]+)*$", var.identifier) != null
    error_message = "Argument `identifier` must match regex ^[a-z]+(-[a-z0-9]+)*$."
  }
}

variable "enabled" {
  type        = bool
  description = "Toggle the containers (started or stopped)."
}

variable "image_tag" {
  type        = string
  description = "GitLab Server image's tag."
}

variable "data_directory" {
  type        = string
  description = "Where data will be persisted (volumes will be mounted as sub-directories)."
}

variable "gitlab_domain" {
  type        = string
  description = "Main domain e.g \"gitlab.fisch3r.net\"."
}

variable "pages_domain" {
  type        = string
  description = "Pages domain e.g \"pages.fisch3r.net\"."
}

variable "registry_domain" {
  type        = string
  description = "Container registry domain e.g \"registry.fisch3r.net\"."
}

variable "log_level" {
  type        = string
  default     = "warn"
  description = "See https://docs.gitlab.com/ee/administration/logs/"

  validation {
    condition     = contains(["debug", "info", "warn", "error", "fatal", "unknown"], var.log_level)
    error_message = "Log level should be one of `debug`, `info`, `warn`, `error`, `fatal`, `unknown`"
  }
}

# Networking

variable "network_id" {
  type        = string
  description = "Attach the containers to given network."
}

variable "https_port" {
  type        = number
  default     = 443
  description = "Bind the GitLab server's HTTPS port."
}

variable "http_port" {
  type        = number
  default     = 80
  description = "Bind the GitLab server's HTTP port."
}

variable "ssh_port" {
  type        = number
  default     = 22
  description = "Bind the GitLab server's SSH port."
}
