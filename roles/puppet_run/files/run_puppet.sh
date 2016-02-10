#!/bin/bash

sudo puppet apply --detailed-exitcodes --verbose --color=false --debug --hiera_config=/etc/puppet/hiera.yaml /etc/puppet/manifests/site.pp
