#!/bin/bash

export GEM_HOME=`pwd`/.bundled_gems
export GEM_BIN_DIR=${GEM_HOME}/bin/
#export PUPPETFILE_DIR=/etc/puppet/modules

gem install r10k --no-ri --no-rdoc
rm -rf /etc/puppet/modules/*
wget https://raw.githubusercontent.com/openstack/puppet-openstack-integration/master/Puppetfile -O /tmp/Puppetfile
sudo PUPPETFILE_DIR=/etc/puppet/modules PUPPETFILE=/tmp/Puppetfile ${GEM_BIN_DIR}r10k puppetfile install -v
