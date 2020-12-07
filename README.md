mongodb-backup
======

[![License](https://img.shields.io/github/license/qwerty-iot/coap)](https://opensource.org/licenses/MPL-2.0)

https://github.com/qwerty-iot/mongodb-backup

Overview
--------
This is a simple container that performs a mongodump, then uploads the file to an azure blob store.  In the future it will be extended for more targets, but the goal is to use it simply with Kubernetes CronJob tasks to automate backups of small mongodb clusters.

License
-------

Mozilla Public License Version 2.0
