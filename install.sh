#!/bin/bash
set -e

ssh-keygen -t rsa -N "" -f my_rsa_key <<< y
aws ec2-instance-connect send-ssh-public-key --instance-id <<project.metadata.instance_id>> --availability-zone <<project.metadata.instance_az>> --instance-os-user <<project.metadata.runtime_user>> --ssh-public-key file://my_rsa_key.pub

ssh -o StrictHostKeyChecking=no -i my_rsa_key <<project.metadata.runtime_user>>@<<project.metadata.instance_priv_dns>> "bash -s" <<ENDSSH
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get install -y libssl-dev libncurses-dev perl cmake make build-essential g++ bison pkg-config
    mkdir ~/logn_mysql
    cd ~/logn_mysql
    git init
    git remote add origin https://x-access-token:<<vcs.token>>@github.com/<<vcs.owner>>/<<vcs.repo>>.git
    git fetch origin <<vcs.hash>>
    git reset --hard FETCH_HEAD
    mkdir build
    cd build
    sudo cmake ../ -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/boost_1_73_0
    sudo make -j<<project.metadata.cores>>
ENDSSH