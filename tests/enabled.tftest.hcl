mock_provider "docker" {}

variables {
  identifier      = "gitlab"
  image_tag       = "17.0.0-ee.0"
  network_id      = "my-network"
  data_directory  = "/data/gitlab"
  gitlab_domain   = "gitlab.example.com"
  pages_domain    = "pages.example.com"
  registry_domain = "registry.example.com"
}

run "disabled_server_is_stopped" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition = !docker_container.server.must_run && !docker_container.server.start
    error_message = join(" ", [
      "`enabled = false` must stop the server,",
      "to leave its data alone during a maintenance.",
    ])
  }
}

run "enabled_server_runs" {
  command = plan

  assert {
    condition     = docker_container.server.must_run && docker_container.server.start
    error_message = "The server must run by default."
  }
}
