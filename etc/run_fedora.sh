#!/usr/bin/env bash
set -ex
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(( $EUID == 0 )) && SUDO='' || SUDO='sudo'
(
  cd $CWD
  curl -V || $SUDO dnf install -y curl
  $SUDO dnf install -y gcc
  python3-config --libs || $SUDO dnf install -y python3-devel
  chmod +x run.sh && ./run.sh
)
