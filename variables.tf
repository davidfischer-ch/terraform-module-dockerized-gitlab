variable "identifier" {
  type = string
}

variable "enabled" {
  type = bool
}

variable "image_tag" {
  type = string
}

variable "data_directory" {
  type = string
}

variable "gitlab_domain" {
  type = string
}

variable "pages_domain" {
  type = string
}

variable "registry_domain" {
  type = string
}

variable "log_level" {
  type        = string
  default     = "warn"
  description = "See https://docs.gitlab.com/ee/administration/logs/"

  validation {
    condition     = contains(["debug", "info", "warn", "error", "fatal", "unknown"], var.log_level)
    error_message = "Wrong log level"
  }
}

# Networking

variable "network_id" {
  type = string
}

variable "https_port" {
  type    = number
  default = 443
}

variable "http_port" {
  type    = number
  default = 80
}

variable "ssh_port" {
  type    = number
  default = 22
}
