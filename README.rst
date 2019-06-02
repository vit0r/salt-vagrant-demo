=================
Salt Vagrant Demo
=================

A Salt Demo using Vagrant.


Instructions
============

Run the following commands in a terminal. Git, VirtualBox and Vagrant must
already be installed.

.. code-block:: bash

    git clone https://github.com/UtahDave/salt-vagrant-demo.git
    cd salt-vagrant-demo
    vagrant plugin install vagrant-vbguest
    vagrant up


This will download an Ubuntu  VirtualBox image and create three virtual
machines for you. One will be a Salt Master named `master` and two will be Salt
Minions named `minion1` and `minion2`.  The Salt Minions will point to the Salt
Master and the Minion's keys will already be accepted. Because the keys are
pre-generated and reside in the repo, please be sure to regenerate new keys if
you use this for production purposes.

You can then run the following commands to log into the Salt Master and begin
using Salt.

.. code-block:: bash

    vagrant ssh master
    sudo salt \* test.ping


Setup
=====

.saltstack.salt
├── pillars
│   ├── dev
│   │   ├── top.sls
│   │   └── work_dev.sls
│   └── dev-test
│   |    ├── top.sls
│   |    └── work_dev-test.sls
│   └── preprod
│   |    ├── top.sls
│   |    └── work_preprod.sls
│   └── prod
│   |    ├── top.sls
│   |    └── work_prod.sls
│   └── stg
│       ├── top.sls
│       └── work_stg.sls
└── states
    ├── top.sls
    ├── common
    │   └── init.sls
    │   └── packages.sls
    ├── work
    │   └── init.sls
    └── work_file_template.txt

Master file etc
===============

/etc/master
 pillar_roots:
   dev:
     - /srv/salt/pillars/dev
   dev-test:
     - /srv/salt/pillars/dev-test
   stg:
     - /srv/salt/pillars/stg
   preprod:
     - /srv/salt/pillars/preprod
   prod:
     - /srv/salt/pillars/prod

 file_roots:
   base:
     - /srv/salt/states/
   dev:
     - /srv/salt/states/
   dev-test:
     - /srv/salt/states/
   stg:
     - /srv/salt/states/
   preprod:
     - /srv/salt/states/
   prod:
     - /srv/salt/states/


Run test
========

.. code-block:: bash

    salt '*' pillar.items pillarenv=prod
    salt '*' pillar.items pillarenv=preprod
    salt '*' pillar.items pillarenv=stg
    salt '*' pillar.items pillarenv=dev
    salt '*' pillar.items pillarenv=dev-test

.. code-block:: bash

    minion1 or minion2:
    ----------
    echo_env:
        file from pillar {{saltenv}} == stg,dev,dev-test,prod,preprod

    
    root@saltmaster:/home/vagrant# salt '*' pillar.items pillarenv=dev
      minion2:
      ----------
        echo_env:
          file from pillar dev
      minion1:
      ----------
        echo_env:
          file from pillar dev