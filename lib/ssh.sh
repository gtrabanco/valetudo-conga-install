#!/usr/bin/env bash

test_ssh_connection() {
  timeout 5 sh -c "</dev/tcp/${1:-}/${2:-22}" >/dev/null 2>&1
}

test_ssh_login() {
  exec ssh -o BatchMode=yes "$@" "exit 0" >/dev/null 2>&1 || return 1
}

has_ssh_keys() {
  [ -d ~/.ssh ] && [ -f ~/.ssh/id_rsa ] && return
  [ -n "$(ssh-add -l)" ] && return

  return 1
}

generate_ssh_key() {
  ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)"
}
