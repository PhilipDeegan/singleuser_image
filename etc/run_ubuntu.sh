#!/usr/bin/env bash
set -ex
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(( $EUID == 0 )) && SUDO='' || SUDO='sudo'
(
  cd $CWD && $SUDO apt-get update
  curl -V || $SUDO apt-get install -y curl
  $SUDO apt-get install -y gcc
  python3 -m venv -h || $SUDO apt-get install -y python3-venv
  python3-config --libs || $SUDO apt-get install -y python3-dev
  chmod +x run.sh && ./run.sh
)
