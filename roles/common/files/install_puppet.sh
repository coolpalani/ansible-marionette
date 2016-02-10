#!/bin/bash

rm -rf /tmp/puppet.rpm
wget https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm -O /tmp/puppet.rpm

sudo rpm -ivh /tmp/puppet.rpm
sudo yum -y remove facter puppet rdo-release
sudo yum -y install libxml2-devel libxslt-devel ruby-devel rubygems puppet
sudo yum -y groupinstall "Development Tools"
