knewton-chef-jmxtrans
=====================

An cookbook for opscode chef that installs jmxtrans from the knewton fork (with ratios).
This is distinct and different from the community cookbook provided from opscode.

This cookbook uses runit to launch jmxtrans, and puts logs into
/var/log/jmxtrans.  Runit manages logfile rotation.  Jmxtrans can be verbose.

A note on versions
==================

The jmxtrans maintainer relied on svn commit numbers in the past, and
now that jmxtrans is on github he suggests that upon installation the
git hash be used instead of a version.  Since this doesn't give a good
idea of what version you're running, specifically whether it's older
or newer than the one you installed last time, we're building our own
jar and adding a version number starting with 1.0.0.

If this is used outside of knewton, you should build a jar and put it
at a place where it can be downlaoded and chose your own versioning
scheme unless the maintainer of jmxtrans decides to maintain a release
numbering scheme in the future.

The cookbook expects a jar name too look something like
"jmxtrans-1.0.0-standalone.jar".

Attributes
==========
Configuration for this cookbook lives in node["jmxtrans"].

The following attributes are defined:

node[:jmxtrans][:version]   - the version string in the jar, e.g. 1.0.0
node[:jmxtrans][:etc]       - the directory where configuration json files will go.  E.g. /var/lib/jmxtrans.
node[:jmxtrans][:lib]       - Directory that will be added to the java CLASSPATH.  E.g. /usr/share/jmxtrans.
node[:jmxtrans][:log]       - Log directory where runit will output logs to.
node[:jmxtrans][:log_level] - Log level that jmxtrans will log at
node[:jmxtrans][:url]       - An url from which the jar can be fetched.