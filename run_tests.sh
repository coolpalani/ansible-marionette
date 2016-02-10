#!/bin/bash -ex

# install dependencies to deploy Ansible
sudo dnf install -y redhat-rpm-config python-devel wget
sudo dnf group install -y "C Development Tools and Libraries"

# install Ansible
pip install ansible --user

~/.local/bin/ansible-playbook -i inventory openstack.yaml
