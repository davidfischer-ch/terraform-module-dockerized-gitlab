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
  default     = true
}

# Process ------------------------------------------------------------------------------------------

variable "image_tag" {
  type        = string
  description = "GitLab Server image's tag."
}

# Networking ---------------------------------------------------------------------------------------

variable "hosts" {
  type        = map(string)
  description = "Add entries to container hosts file."
  default     = {}
}

variable "network_id" {
  type        = string
  description = "Attach the containers to given network."
}

variable "https_port" {
  type        = number
  description = "Bind the GitLab server's HTTPS port."
  default     = 443

  validation {
    condition     = var.https_port >= 1 && var.https_port <= 65535
    error_message = "Argument `https_port` must be between 1 and 65535."
  }
}

variable "http_port" {
  type        = number
  description = "Bind the GitLab server's HTTP port."
  default     = 80

  validation {
    condition     = var.http_port >= 1 && var.http_port <= 65535
    error_message = "Argument `http_port` must be between 1 and 65535."
  }
}

variable "ssh_port" {
  type        = number
  description = "Bind the GitLab server's SSH port."
  default     = 22

  validation {
    condition     = var.ssh_port >= 1 && var.ssh_port <= 65535
    error_message = "Argument `ssh_port` must be between 1 and 65535."
  }
}

# Storage ------------------------------------------------------------------------------------------

variable "data_directory" {
  type        = string
  description = "Where data will be persisted (volumes will be mounted as sub-directories)."
}

# Application --------------------------------------------------------------------------------------

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

variable "timezone" {
  type        = string
  description = "The timezone."
  default     = "UTC"
}

variable "log_level" {
  type        = string
  description = "See https://docs.gitlab.com/ee/administration/logs/"
  default     = "warn"

  validation {
    condition     = contains(["debug", "info", "warn", "error", "fatal", "unknown"], var.log_level)
    error_message = "Log level should be one of `debug`, `info`, `warn`, `error`, `fatal`, `unknown`"
  }
}

variable "extra_config" {
  type        = list(string)
  description = "Any extra configuration (not managed by the module)."
  default     = []
}

variable "extra_env" {
  type        = list(string)
  description = "Any extra environment variables (not managed by the module)."
  default     = []
}
