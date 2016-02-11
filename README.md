ansible-marionette
==================

Orchestrate with Ansible a complex deployment driven by Puppet OpenStack modules.


#### Table of Contents

1. [Overview - What is ansible-marionette?](#overview)
2. [Quickstart with reference architecture](#quickstart)
3. [Advanced deployment with custom architecture](#advanced)
4. [Limitations](#limitations)



Overview
--------

ansible-marionette are composable Ansible playbooks for deploying OpenStack
environments driven by Puppet OpenStack modules. The key word here is
*composable*.

Too often, OpenStack deployment tools are able to deploy OpenStack with a
pre-defined set of roles - often called "controller", "compute", "network", "storage".
*ansible-marionette* aims to provide a way to deploy both reference architectures
but also complex deployments with custom designs.

__Reference architecture__

A reference architecture is a set of pre-defined profiles, that already contain
some roles. Deploying the reference architecture will help to deploy
out-of-the-box OpenStack, in a standard and tested way.

The reference architecture is defined in [profile
directory](https://github.com/EmilienM/ansible-marionette/tree/master/roles/profile).

Each profile has in charge of including the Ansible roles we will deploy.


__Roles__

A role is defined by an Ansible role, in 'roles' directory.
A role is an application and should be isolated from any other application
(think containers).

Example of roles: puppet, mysql, keystone.

Each role has in charge of:

* Feed hieradata to add the Puppet classes that deploy the application.
* Feed hieradata with Hiera parameters to override default values.
* Validate that the role is actually working post-deployment, by service
  validation.

__Profiles__

A profile has in charge of deploying a set of roles.
Example of profiles: controller, compute, storage, network.

__Advanced deployments__

Now we know what is *Reference Architecture*, *profiles* and *roles*, we need to understand
what are advanced deployments.

Advanced deployments are specific architectures, that fit with specific
use-cases. They require to break standards and install some services on some
nodes and isolate other ones. They don't fit with *Reference architecture* and
that is why this project can be useful: to compose yourself what you want to
deploy and validate.

Ansible will be useful here to dynamically generate Hieradata, run Puppet on
remote nodes and validate services.



Quickstart
----------

The quickstart is useful for anyone who wants to give a try to this project by
just deploying the reference architecture, aka pre-defined roles.

To get started, you'll need to prepare 2 files and run a script.

Prepare *deployment.yaml*. An example is provided, please look at it.

```yaml
---
# pick a host group name, here 'controllers' because it's pretty standard
- hosts: controllers
  roles:
    # Use controller role from Reference Architecture
    - profile/controller

# order does matter here, before validation
- hosts: all
  roles:
    - puppet-run

# Example with future profiles
#
# - hosts: computes
#   roles:
#     # the profile does not exist yet, but here for example.
#     - profile/compute
# 
#  create host groups as many profiles we support.
# Note: an host group can have multiple profiles.

# order does matter here, before validation
- hosts: all
  roles:
    - puppet-run

# after puppet runs, we want to validate services
- hosts: controllers
  roles:
    - profile/controller/validate

# Example with future profiles
#
# - hosts: computes
#   roles:
#     - profile/compute/validate
```

Now, prepare *inventory* file. An example is provided, please look at it.

```yaml
[controllers]
controller.openstack.org ansible_host=controller.openstack.org ansible_user=centos

# [computes]
# compute1.openstack.org ansible_host=compute1.openstack.org ansible_user=centos
# compute2.openstack.org ansible_host=compute2.openstack.org ansible_user=centos
# compute3.openstack.org ansible_host=compute3.openstack.org ansible_user=centos
```

You're ready to deploy.

```bash
./run_tests.sh

```

Advanced
--------

This is the right section if you want to learn how to deploy complex
environments.


__Customize role parameters__

Each role can contain parameters.
Example in *roles/mysql/defaults/main.yaml*:

```yaml
---
mysql_max_connections: 200
```

This value will be set for mysql::server::override_options in */etc/puppet/hieradata/common.yaml*.

Each parameters added in *roles/mysql/defaults/main.yaml* need to match with an
actual Puppet parameter in the class, defined in
*roles/mysql/install/tasks/main.yaml*.

That's a level of customization that allow to add standard parameters, so users
just have to change the value of the parameter if needed.


__Customize profile with advanced scenario__


* If the role does not provide the parameter you need (ie: not in
  *roles/mysql/defaults/main.yaml*).
* If you need to apply some parameters for all roles in a profile (ie: a
  specific password).
* If you want to add custom Puppet classes in a profile, that are not supported
  by existing roles.

Then you'll like it. Edit *roles/profile/controller/defaults/main.yaml* (example
with controller):

```yaml
---
# Extra Hiera parameters specific to a profile
hiera_params_extra: |
  keystone::token_expiration: 3000

# Though it's not recommanded, you can add any Puppet class
# in this block.
# The best practice is to create a role for the app you want to deploy,
# and add the role to the profile.
#
hiera_classes_extra:
#   classes:
#     - mymodule::myclass
```

That way, you can:

* Define custom Puppet parameters at a role level
* Define custom Puppet parameters at a profile level
* Define custom Puppet classes at a profile level


Note: if you define a Puppet class, you need to make sure the module is
installed. This repository is installing modules tested by OpenStack only.


Limitations
-----------

* Currently, it only works on Red Hat systems (centos7, fedora23 and rhel7).
* This is a proof-of-concept, we only support a few services now (mysql,
  keystone). But more is coming soon.
