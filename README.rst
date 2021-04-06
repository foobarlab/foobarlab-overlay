Foobarlab Stage3 Overlay
========================

This is stage3 patch overlay for Funtoo Linux used by [Funtoo Stage3 Vagrant box](https://github.com/foobarlab/funtoo-stage3-packer) packer script.

Usage
-----

Checkout the sources to ``/var/git/overlay/foobarlab-stage3`` and add the file
``/etc/portage/repos.conf/foobarlab-stage3`` with the following contents::

  [DEFAULT]
  main-repo = core-kit
  
  [foobarlab-stage3]
  location = /var/git/overlay/foobarlab-stage3
  auto-sync = no
  priority = 10

Doing ``ego sync`` afterwards will update your portage tree and make the ebuilds available.

To remove this overlay just remove above files and folders and do ``ego sync`` again.

=================================
How to Contribute to this Overlay
=================================

:author: Martin Eisenbarth
:contact: eyesee@foobarlab.net
:language: English, German, French

Greetings GitHub Users!
=======================

To contribute bug reports for this overlay, you can open up a GitHub issue or send
me a pull request.
