#!/usr/bin/env bash

VALETUDO_LOG_FILE="${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-$(date +%s).log}"

echoerr() { echo "$@" 1>&2; }
log_header() { echoerr "---------- $* ----------"; }
log() {
  local msg
  local -r str_date="$(date +'%Y-%m-%d %H:%M:%S')"



  if [ ! -t 0 ]; then
    header="$str_date"
    [ $# -gt 0 ] && header="$*"
    log_header "$header" | tee -a "${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-${str_date}.log}"
    tee -a "${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-$(date +%s).log}" < /dev/stdin
    log_header "$header" | tee -a "${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-${str_date}.log}"
  elif [ $# -gt 0 ]; then
    for msg in "$@"; do
      printf "%s %s" "$str_date" "$msg" | tee -a "${VALETUDO_LOG_FILE:-${HOME}/install-valetudo-${str_date}.log}"
    done
  fi
}
_log() { log "${@:-$(</dev/stdin)}" > /dev/null 2>&1; }

warning() {
  echoerr "[WARNING]: $*" | log
  exit 1
}

depends_on() {
  if
    [ -n "${1:-}" ] &&
    ! command -v "${1:-}" >/dev/null 2>&1
  then
    echo "Missing dependency: ${1:-}"
    exit 1
  fi

  [ $# -gt 1 ] &&  "${FUNCNAME[0]}" "${@:2}"
}

