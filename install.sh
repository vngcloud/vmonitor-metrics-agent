#!/bin/bash
  
VERSION=0.2

is_64_arch(){
  arch_os=$(uname -i)
  if [ $arch_os -z "x86_64" ]
  then
    return true
  else
    return false
  fi
}

get_distribution() {
  lsb_dist=""
  # Every system that we officially support has /etc/os-release
  if [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID_LIKE")"
  fi
  # Returning an empty string here should be alright since the
  # case statements don't act unless you provide an actual value
}

command_exists() {
  command -v "$@" > /dev/null 2>&1
}

set_environment() {
  list_env=( $API_KEY )
  printf "%s\n" "${list_env[@]}" > /etc/default/telegraf
}

get_distribution

if [[ "$lsb_dist" = "ubuntu" || "$lsb_dist" = "debian" ]]; then
  echo "install with deb"
  arch="aarch64"
  curl -L "https://github.com/vmonitor/monitoring/releases/download/${VERSION}/telegraf-1.16.0.1a3d8d7e-0.${arch}.rpm" -o /tmp/telegraf_temp.deb
  dpkg -i /tmp/telegraf_temp.deb
  set_environment
  service telegraf restart
fi
