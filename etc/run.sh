#!/usr/bin/env bash
set -ex
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(( $EUID == 0 )) && SUDO='' || SUDO='sudo'

if_install(){
  set -exu
  $1 $2 || ($SUDO pkgx install $1 && $1 $2)
}

(
  cd "$CWD/.."

  curl -o ./pkgx --compressed -f --proto '=https' https://pkgx.sh/$(uname)/$(uname -m)
  chmod +x pkgx && $SUDO mv pkgx /usr/local/bin

  if_install git -v
  if_install task -v
  if_install terraform -v
  if_install packer -v
  if_install ansible --version
  python3 -m venv .venv
  (
    . .venv/bin/activate
    export PATH="$PWD/.venv/bin:$PATH"
    python3 -m pip install pip -U
    python3 -m pip install Cython
    python3 -m pip install python-openstackclient
    openstack --version || (echo "no openstack install error" && exit 1)
    task init
    cp .constructor/build.env.sample build.env
    task
    task constructor:init
    task provisioner:init
    task constructor:fetch
  )
)
