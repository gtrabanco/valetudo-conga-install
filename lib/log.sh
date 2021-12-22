#!/usr/bin/env bash

VALETUDO_LOG_FILE="${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-$(date +%s).log}"

echoerr() { echo "$@" 1>&2; }
log_header() { echoerr "---------- $* ----------"; }
log() {
  local msg
  local -r str_date="$(date +'%Y-%m-%d %H:%M:%S')"

  if [ $# -gt 0 ]; then
    for msg in "$@"; do
      printf "%s %s" "$str_date" "$msg" | tee -a "${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-${str_date}.log}"
    done
  fi

  if [ ! -t 0 ]; then
    log_header "start ${str_date}" | tee -a "${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-${str_date}.log}"
    tee -a "${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-$(date +%s).log}" < /dev/stdin
    log_header "end ${str_date}" | tee -a "${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-${str_date}.log}"
  fi
}
_log() { log "${@:-$(</dev/stdin)}" > /dev/null 2>&1; }
