#!/bin/bash

sudo mkdir -p /etc/puppet/hieradata/
sudo bash -c "cat > /etc/puppet/hiera.yaml" << EOF
---
:backends:
  - yaml

:hierarchy:
  - "%{::role}/common"
  - common

:yaml:
  :datadir: /etc/puppet/hieradata
EOF

sudo mkdir -p /etc/facter/facts.d/
sudo bash -c "cat > /etc/facter/facts.d/environment.txt" << EOL
role=$ROLE
EOL

sudo mkdir -p /etc/puppet/manifests
sudo bash -c "cat > /etc/puppet/manifests/site.pp" << EOL
Exec {
  path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'
}
hiera_include('classes')
EOL
