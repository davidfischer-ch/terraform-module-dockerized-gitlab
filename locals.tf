locals {
  config = concat([
    # Add any other gitlab.rb configuration here, each on its own line
    "external_url 'https://${var.gitlab_domain}'",
    "gitlab_rails['time_zone'] = '${var.timezone}'",

    "gitlab_rails['gitlab_shell_ssh_port'] = ${var.ssh_port}",
    "gitlab_shell['log_level'] = '${upper(var.log_level)}'",

    # https://docs.gitlab.com/administration/pages/#access-control
    "gitlab_pages['access_control'] = true",

    # https://gitlab.fisch3r.net/help/administration/pages/index.md
    "pages_external_url 'http://${var.pages_domain}'",
    "pages_nginx['enabled'] = true",
    "pages_nginx['listen_port'] = 80",
    "pages_nginx['listen_https'] = false",
    "pages_nginx['redirect_http_to_https'] = false",

    "registry_external_url 'https://${var.registry_domain}'",
    "registry['enable'] = true",
    "registry['log_level'] = '${var.log_level}'",

    "nginx['error_log_level'] = 'error'",
    "gitlab_kas['log_level'] = '${var.log_level}'",
    "patroni['log_level'] = '${upper(var.log_level)}'",
    "spamcheck['log_level'] = '${var.log_level}'"
  ], var.extra_config)
}
