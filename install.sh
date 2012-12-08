#!/bin/bash

# This runs as root on the server

chef_version=10.16.2
chef_binary=/var/lib/gems/1.9.1/gems/chef-$chef_version/bin/chef-solo

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    aptitude update &&
    apt-get -o Dpkg::Options::="--force-confnew" \
        --force-yes -fuy dist-upgrade &&
    # Install Ruby and Chef
    aptitude install -y ruby1.9.1 ruby1.9.1-dev make &&
    sudo gem1.9.1 install --no-rdoc --no-ri chef --version $chef_version
fi &&

"$chef_binary" -c solo.rb -j solo.json
