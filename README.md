ansible-marionette
==================

Orchestrate with Ansible a complex deployment driven by Puppet OpenStack modules.


Quickstart
----------

Prepare your environment by editing openstack.yaml file.
An example is provided with openstack-example.yaml.
This is a simple example that will deploy and validate OpenStack Keystone.
```yaml
---
- hosts: controllers
  become: yes
  roles:
    - common
    - mysql
    - keystone
    - puppet_run
  vars:
    puppet_role: controller
```

Soon, you'll be able to deploy complex deployments such as this example:
```yaml
---
- hosts: controllers
  become: yes
  roles:
    - common
    - mysql
    - keystone
    - nova-api
    - nova-scheduler
    (...)
    - puppet_run
  vars:
    puppet_role: controller

- hosts: computes
  become: yes
  roles:
    - common
    - nova-compute
    (...)
    - puppet_run
  vars:
    puppet_role: compute
```

You'll also need to build your inventory by creating "inventory" file.
An example is given in inventory_example.

```yaml
[controllers]
controller.openstack.org ansible_host=controller.openstack.org

[computes]
compute1.openstack.org ansible_host=compute2.openstack.org
compute2.openstack.org ansible_host=compute2.openstack.org
```

The archiecture of this module makes easy to compose roles.
Any deployment can be different, by just editing openstack.yaml and the
inventory.

Run the deployment and validation:
```bash
./run_tests.sh
```


Steps of deployment
-------------------

* Ansible & dependencies will be installed where Ansible is run.
* Puppet will be installed, configured and tested on remote nodes.
* Each node will have correct Hieradata to deploy the services we want.
* Puppet will be run remotely, in masterless.
* After the deployment, services will be validated.


Limitations
-----------

* only work on centos7, fedora and rhel.
