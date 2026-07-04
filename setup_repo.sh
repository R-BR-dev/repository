#!/bin/bash

is_user_root ()
{
    [ "$(id -u)" -eq 0 ]
}


setup_RHEL ()
{
  url="https://raw.githubusercontent.com/R-BR-dev/repository/refs/heads/main/rpm.rnbr-dev.repo"
  repo_file="/etc/yum.repos.d/repo.rnbr-dev.repo"
  wget_installed=0
  which wget 2>/dev/null 1>/dev/null && wget_installed=1
  if [ $wget_installed == 1 ]; then
    wget $url -O $repo_file
  else
    curl -fsSL $url -o $repo_file
  fi;
}

setup_DEB ()
{
  apt-get update
  apt-get install gpg -y
  curl -fsSL https://repo.rnbr-dev.com/rpm/repo-key.asc \
    | gpg --dearmor -o /etc/apt/keyrings/repo.rnbr_dev.gpg
  chmod 644 /etc/apt/keyrings/repo.rnbr_dev.gpg
  
  url="https://raw.githubusercontent.com/R-BR-dev/repository/refs/heads/main/deb.rnbr-dev.repo.sources"
  repo_file="/etc/apt/sources.list.d/deb.rnbr-dev.repo.sources"
  wget_installed=0
  which wget 2>/dev/null 1>/dev/null && wget_installed=1
  if [ $wget_installed == 1 ]; then
    wget $url -O $repo_file
  else
    curl -fsSL $url -o $repo_file
  fi;
}


if is_user_root;
then (
  if [[ -e /etc/almalinux-release || -e /etc/rocky-release || -e /etc/centos-release || -e /etc/fedora-release || $FORCE_RHEL ]]; then
    setup_RHEL;
  elif [[ -e /etc/debian_version || $FORCE_DEB ]]; then
  setup_DEB;
  else
    echo "Not supported system."
  fi;
  

  echo -e "\033[32mdone\033[0m!"
)
  else echo -e "Please, run script as \033[31mroot\033[0m!";
fi

