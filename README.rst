Foobarlab Overlay
=================

This is my personal overlay to use as the starting point for collaborating with Funtoo Linux.

Usage
-----

Checkout the sources to ``/var/git/overlay/foobarlab`` and add the file
``/etc/portage/repos.conf/foobarlab`` with the following contents::

  [DEFAULT]
  main-repo = core-kit
  
  [foobarlab]
  location = /var/git/overlay/foobarlab
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
