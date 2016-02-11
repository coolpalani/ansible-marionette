ansible-marionette
==================

Orchestrate with Ansible a complex deployment driven by Puppet OpenStack modules.


#### Table of Contents

1. [Overview - What is ansible-marionette?](#overview)
2. [Quickstart with reference architecture](#quickstart)
3. [Advanced deployment with custum architecture](#advanced)
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

A reference architecture is a set of pre-defined roles, that already contain
some services. Deploying the reference architecture will help to deploy
out-of-the-box OpenStack, in a standard and tested way.

The reference architecture is defined in [profile
directory](https://github.com/EmilienM/ansible-marionette/tree/master/roles/profile).

Each profile has in charge of including the Ansible roles we will deploy.


__Roles__

A role is defined by an Ansible role, in 'roles' directory
A role is an application and should be isolated from any other application
(think containers).

Example of roles: puppet, mysql, keystone.

Each role has in charge of:

* Feed hieradata to add the Puppet classes that deploy the application.
* Feed hieradata with Hiera parameters to override default values.
* Validate that the role is actually working post-deployment, by service
  validation.

__Advanced deployments__

Now we know what is *Reference Architecture* and *roles*, we need to understand
what are advances deployments.

Advances deployments are specific architectures, that fit with specific
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

# Example with future profiles
#
# - hosts: computes
#   roles:
#     # the profile does not exist yet, but here for example.
#     - profile/compute
# 
#  create host groups as many profiles we support.
# Note: an host group can have multiple profiles.
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

This section is work in progress, since the feature is still under development.
Documentation will come in a next iteration.


Limitations
-----------

* Currently, it only works on Red Hat systems (centos7, fedora23 and rhel7).
* This is a proof-of-concept, we only support a few services now (mysql,
  keystone). But more is coming soon.
