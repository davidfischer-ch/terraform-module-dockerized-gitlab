resource "docker_image" "server" {
  name         = "gitlab/gitlab-ee:${var.image_tag}"
  keep_locally = true # Prevent conflicts if other modules are using the image we are destroying
}

resource "docker_container" "server" {

  image = docker_image.server.image_id
  name  = var.identifier

  must_run = true
  start    = true

  # Bounded rather than "always". A container that cannot finish its boot fails the same way on
  # every attempt, and an unlimited policy turns that into an endless loop. Each attempt runs a
  # full reconfigure, which the host pays for, and nothing reports a fault because the container
  # is always about to come back.
  #
  # Five attempts, then it stays down and is visibly down, which is the more actionable failure.
  restart         = "on-failure"
  max_retry_count = 5
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

  network_mode = "bridge"

  # SSH for git, HTTP for pages, HTTPS for gitlab and registry
  dynamic "ports" {
    for_each = [
      for port in [
        { internal = 22, external = var.ssh_port },
        { internal = 80, external = var.http_port },
        { internal = 443, external = var.https_port },
      ] : port if port.external != null
    ]
    content {
      internal = ports.value.internal
      external = ports.value.external
      ip       = var.listener_address
      protocol = "tcp"
    }
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
