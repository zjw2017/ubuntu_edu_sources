#!/bin/bash
# shellcheck disable=SC2162

codename=$(lsb_release -c | grep "Codename" | awk '{print $2}')
moderm_ver="trusty xenial bionic focal jammy lunar mantic noble oracular"
is_moderm=false
for i in $moderm_ver; do
  if [[ "$codename" == "$i" ]]; then
    is_moderm=true
    break
  fi
done
mkdir -p ./target
if [[ "$is_moderm" == "true" ]]; then
  cat <<EOF >./target/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.nju.edu.cn/ubuntu/ $codename main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu/ $codename main restricted universe multiverse
deb https://mirrors.nju.edu.cn/ubuntu/ $codename-updates main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu/ $codename-updates main restricted universe multiverse
deb https://mirrors.nju.edu.cn/ubuntu/ $codename-backports main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu/ $codename-backports main restricted universe multiverse
deb https://mirrors.nju.edu.cn/ubuntu/ $codename-security main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu/ $codename-security main restricted universe multiverse
# deb https://security.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse
# deb-src https://security.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.nju.edu.cn/ubuntu/ $codename-proposed main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu/ $codename-proposed main restricted universe multiverse
EOF
else
  cat <<EOF >./target/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename main restricted universe multiverse
deb https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename-updates main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename-updates main restricted universe multiverse
deb https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename-backports main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename-backports main restricted universe multiverse
deb https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename-security main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename-proposed main restricted universe multiverse
# deb-src https://mirrors.nju.edu.cn/ubuntu-old-releases/ubuntu/ $codename-proposed main restricted universe multiverse
EOF
fi

sudo mv -f ./target/sources.list /etc/apt
rm -rf ./target
sudo apt-get clean
sudo rm -rf /etc/apt/sources.list.d/*
sudo rm -rf /var/lib/apt/lists/*

read -p "是否需要更新软件列表？可能需要一段时间[y/n]" yn
if [[ $yn == "y" ]]; then
  sudo apt-get update
  sudo apt-get -y autoremove
fi

read -p "是否需要更新软件？可能需要一段时间[y/n]" yn2
if [[ $yn2 == "y" ]]; then
  sudo apt-get -y upgrade
fi
