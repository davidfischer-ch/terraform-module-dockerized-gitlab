# On-demand operations on GitLab, run with `terraform apply -invoke=<action address>`.
# Each runs in the GitLab container, as root.

# Backup -------------------------------------------------------------------------------------------

# Write a backup of the database, the repositories and the uploads to
# {data_directory}/data/backups/<id>_gitlab_backup.tar, copying the files first for a consistent
# archive of a running instance. gitlab.rb and gitlab-secrets.json are not in it. The older archives
# are removed once the new one is complete, and a failed run removes the archive it wrote: the
# newest complete archive is always kept.
action "docker_exec" "backup" {
  config {
    container = docker_container.server.name
    command = ["sh", "-c", <<-EOT
      set -eu
      cd /var/opt/gitlab/backups
      start=$(mktemp)
      if ! gitlab-backup create STRATEGY=copy; then
        find . -maxdepth 1 -name '*_gitlab_backup.tar' -newer "$start" -delete
        rm -f "$start"
        exit 1
      fi
      rm -f "$start"
      newest=
      for archive in *_gitlab_backup.tar; do
        [ ! -f "$archive" ] || newest=$archive
      done
      for archive in *_gitlab_backup.tar; do
        [ "$archive" = "$newest" ] || rm -f "$archive"
      done
    EOT
    ]
  }
}

# Restore the newest backup of {data_directory}/data/backups over the instance's data, Puma and
# Sidekiq stopped meanwhile, then restart GitLab whatever the outcome.
action "docker_exec" "restore" {
  config {
    container = docker_container.server.name
    command = ["sh", "-c", <<-EOT
      set -eu
      cd /var/opt/gitlab/backups
      backup=
      for archive in *_gitlab_backup.tar; do
        [ ! -f "$archive" ] || backup=$${archive%_gitlab_backup.tar}
      done
      if [ -z "$backup" ]; then
        echo 'No *_gitlab_backup.tar in /var/opt/gitlab/backups to restore.' >&2
        exit 1
      fi
      gitlab-ctl stop puma
      gitlab-ctl stop sidekiq
      status=0
      gitlab-backup restore BACKUP="$backup" force=yes || status=$?
      gitlab-ctl restart
      exit "$status"
    EOT
    ]
  }
}

# Maintenance --------------------------------------------------------------------------------------

# Run GitLab's own consistency checks, the project names left out of the output, failing when the
# report holds a failed check: the rake task exits 0 on one.
action "docker_exec" "check" {
  config {
    container = docker_container.server.name
    command = ["sh", "-c", <<-EOT
      status=0
      report=$(gitlab-rake gitlab:check SANITIZE=true 2>&1) || status=$?
      printf '%s\n' "$report"
      case "$report" in
        *'Try fixing it:'* | *'Please fix the error above'* | *'Exception: '*) exit 1 ;;
      esac
      exit "$status"
    EOT
    ]
  }
}

# Report the data GitLab can no longer decrypt with the current gitlab-secrets.json, failing when
# the report holds a model with failures: the rake task exits 0 on one.
action "docker_exec" "check_secrets" {
  config {
    container = docker_container.server.name
    command = ["sh", "-c", <<-EOT
      status=0
      report=$(gitlab-rake gitlab:doctor:secrets 2>&1) || status=$?
      printf '%s\n' "$report"
      case "$report" in
        *'failures: '[1-9]*) exit 1 ;;
      esac
      exit "$status"
    EOT
    ]
  }
}

# Apply gitlab.rb again without recreating the container.
action "docker_exec" "reconfigure" {
  config {
    container = docker_container.server.name
    command   = ["gitlab-ctl", "reconfigure"]
  }
}

# Delete the container registry's untagged manifests, then free the layers no manifest references.
# The registry is stopped for the whole collection: pulls fail as well as pushes.
action "docker_exec" "collect_registry_garbage" {
  config {
    container = docker_container.server.name
    command   = ["gitlab-ctl", "registry-garbage-collect", "-m"]
  }
}

# Empty GitLab's cache in Redis.
action "docker_exec" "clear_cache" {
  config {
    container = docker_container.server.name
    command   = ["gitlab-rake", "cache:clear"]
  }
}
