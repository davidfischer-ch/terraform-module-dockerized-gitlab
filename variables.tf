variable "identifier" {
  description = "Identifier (must be unique, used to name resources)."
  type        = string

  validation {
    condition     = regex("^[a-z]+(-[a-z0-9]+)*$", var.identifier) != null
    error_message = "Argument `identifier` must match regex ^[a-z]+(-[a-z0-9]+)*$."
  }
}

variable "enabled" {
  description = "Toggle the containers (started or stopped)."
  type        = bool
}

variable "image_tag" {
  description = "GitLab Server image's tag."
  type        = string
}

variable "data_directory" {
  description = "Where data will be persisted (volumes will be mounted as sub-directories)."
  type        = string
}

variable "gitlab_domain" {
  description = "Main domain e.g \"gitlab.fisch3r.net\"."
  type        = string
}

variable "pages_domain" {
  description = "Pages domain e.g \"pages.fisch3r.net\"."
  type        = string
}

variable "registry_domain" {
  description = "Container registry domain e.g \"registry.fisch3r.net\"."
  type        = string
}

variable "timezone" {
  description = "The timezone."
  default     = "UTC"
  type        = string
}

variable "log_level" {
  description = "See https://docs.gitlab.com/ee/administration/logs/"
  type        = string
  default     = "warn"

  validation {
    condition     = contains(["debug", "info", "warn", "error", "fatal", "unknown"], var.log_level)
    error_message = "Log level should be one of `debug`, `info`, `warn`, `error`, `fatal`, `unknown`"
  }
}

variable "extra_config" {
  description = "Any extra configuration (not managed by the module."
  type        = list(string)
  default     = []
}

# Networking

variable "network_id" {
  description = "Attach the containers to given network."
  type        = string
}

variable "https_port" {
  description = "Bind the GitLab server's HTTPS port."
  type        = number
  default     = 443
}

variable "http_port" {
  description = "Bind the GitLab server's HTTP port."
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "Bind the GitLab server's SSH port."
  type        = number
  default     = 22
}
