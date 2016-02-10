#!/bin/bash -ex

# install dependencies to deploy Ansible
sudo dnf install -y redhat-rpm-config python-devel wget
sudo dnf group install -y "C Development Tools and Libraries"

# install Ansible and dependencies
pip install ansible shade --user

# Deployment
ansible-playbook -i inventory openstack.yaml --skip-tags "validation"

# Validation
ansible-playbook -i inventory openstack.yaml --tags "validation"
