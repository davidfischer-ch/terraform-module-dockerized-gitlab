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

run "outputs_describe_the_server" {
  command = plan

  assert {
    condition     = output.host == "gitlab"
    error_message = "`host` must be the container's hostname, its identifier."
  }

  assert {
    condition = (
      output.gitlab_domain == "gitlab.example.com"
      && output.pages_domain == "pages.example.com"
      && output.registry_domain == "registry.example.com"
    )
    error_message = "The domain outputs must be the GitLab, Pages and registry domains."
  }

  assert {
    condition     = output.https_port == 443 && output.http_port == 80 && output.ssh_port == 22
    error_message = "`https_port`, `http_port` and `ssh_port` must be the published ports."
  }
}
