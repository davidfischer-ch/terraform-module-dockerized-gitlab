resource "docker_image" "server" {
  name         = "gitlab/gitlab-ee:${var.image_tag}"
  keep_locally = true # Prevent conflicts if other modules are using the image we are destroying
}

resource "docker_container" "server" {

  image = docker_image.server.image_id
  name  = var.identifier

  must_run = true
  start    = true
  restart  = "always"
  # wait   = true

  shm_size = 256 # MB

  env = concat([
    "GITLAB_LOG_LEVEL=${var.log_level}",
    "GITLAB_OMNIBUS_CONFIG=${join("\n", local.config)}"
  ], var.extra_env)

  dynamic "host" {
    for_each = var.hosts
    content {
      host = host.key
      ip   = host.value
    }
  }

  hostname = var.identifier

  networks_advanced {
    name = var.network_id
  }

  ports {
    internal = "22"
    external = var.ssh_port
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  # For pages
  ports {
    internal = "80"
    external = var.http_port
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  # For gitlab and registry
  ports {
    internal = "443"
    external = var.https_port
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  # Config owner root:root
  volumes {
    container_path = "/etc/gitlab"
    host_path      = "${var.data_directory}/config"
    read_only      = false
  }

  # Logs owner root:root
  volumes {
    container_path = "/var/log/gitlab"
    host_path      = "${var.data_directory}/logs"
    read_only      = false
  }

  # Logs owner root:root
  volumes {
    container_path = "/var/opt/gitlab"
    host_path      = "${var.data_directory}/data"
    read_only      = false
  }
}
