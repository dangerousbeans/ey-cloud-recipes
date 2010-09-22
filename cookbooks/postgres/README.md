Postgresql Cookbook for AppCloud.  9.0.0 + 8.4.2
=========

PostgreSQL is a powerful, open source object-relational database system. It has more than 15 years of active development and a proven architecture that has earned it a strong reputation for reliability, data integrity, and correctness. It runs on all major operating systems, including Linux, UNIX (AIX, BSD, HP-UX, SGI IRIX, Mac OS X, Solaris, Tru64), and Windows. It is fully ACID compliant, has full support for foreign keys, joins, views, triggers, and stored procedures (in multiple languages). It includes most SQL:2008 data types, including INTEGER, NUMERIC, BOOLEAN, CHAR, VARCHAR, DATE, INTERVAL, and TIMESTAMP. It also supports storage of binary large objects, including pictures, sounds, or video. It has native programming interfaces for C/C++, Java, .Net, Perl, Python, Ruby, Tcl, ODBC, among others, and [exceptional documentation][1]

Overview
--------

This Cookbook provides the recipes to install/setup postgresql 9.0.0 by default.  This is one of many [tunable variables][2]  For example by modifying [postgres_version][3] to the alternate possibility of 8.4 to install 8.4.2 instead.

If you wish to use this in production you should consider customizing mysql's configuration files so it can use the minimal settings possible.  It currently is required to be enabled and running on AppCloud, so **disabling/turning** off **mysql** is **never** an option.

Warning
--------

This cookbook **deletes** the [mysql backup][4] crontab if you do not wish this behavior please change/delete/omit it here.  

This recipe currently offers **zero** replication support.  It may be added in the future.

Customization
--------

Ideally it's suggested if you need to make customizations to the configuration to modify /db/postgresql/[postgres_version][3]/custom.conf however you can just modify the attributes file to better suit your personal needs.

Usage
--------

Remove old postgres recipe from your ey-cloud-recipes fork, add this either as a submodule or copy this to your repo to overwrite the old postgres repo and then add the following to main/recipes/default.rb

``require_recipe "postgres::default"``

Cruft
--------

Pardon any cruft in this cookbook, there may be bits not used and bits that never did anything.  As a whole this recipe works as described however there is some more cleaning to be done.

Warranty
--------

Currently Postgresql is not supported on AppCloud.  This recipe is unsupported at this time, it should work 'as is'.  I currently do use some features that are not properly exposed which may in the future break things, I will try and keep this up to date if this happens.

[1]: http://www.postgresql.org/docs/manuals/
[2]: http://github.com/damm/ey-postgresql/blob/master/postgres/attributes/postgresql.rb
[3]: http://github.com/damm/ey-postgresql/blob/master/postgres/attributes/postgresql.rb#L1
[4]: http://github.com/damm/ey-postgresql/blob/master/postgres/recipes/eybackup.rb#L28-L32
