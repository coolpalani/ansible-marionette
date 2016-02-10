#!/bin/bash -ex

# make sure environment is ready
if [ ! -f inventory ]; then
    echo "inventory file does not exist. Please read README if you need help to create it."
    exit 1
fi

if [ ! -f deployment.yaml ]; then
    echo "deployment.yaml file does not exist. Please read README if you need help to create it."
    exit 1
fi

# install dependencies to deploy Ansible
sudo dnf install -y redhat-rpm-config python-devel wget
sudo dnf group install -y "C Development Tools and Libraries"

# install Ansible and dependencies
pip install ansible shade --user

# Deployment
ansible-playbook -i inventory deployment.yaml --skip-tags "validation"

# Validation
ansible-playbook -i inventory deployment.yaml --tags "validation"
