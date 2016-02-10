ansible-marionette
==================

Orchestrate with Ansible complex deployments driven by Puppet OpenStack modules.


Quickstart
----------

Currently supported on Red hat systems (Fedora, Centos, Red hat).

```bash
./run_tests.sh
```

The script will:

* install Ansible
* install Puppet
* configure Hiera
* clone Puppet OpenStack modules and dependencies
* deploy OpenStack Keystone and dependencies with Puppet
