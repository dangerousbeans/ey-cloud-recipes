Sphinx Chef Cookbook for CLI Users -- Sphinx 0.9.9
=========
Sphinx is a full-text search engine, distributed under GPL version 2. Commercial licensing (eg. for embedded use) is also available upon request.

Generally, it's a standalone search engine, meant to provide fast, size-efficient and relevant full-text search functions to other applications. Sphinx was specially designed to integrate well with SQL databases and scripting languages.

Currently built-in data source drivers support fetching data either via direct connection to MySQL, or PostgreSQL, or from a pipe in a custom XML format. Adding new drivers (eg. to natively support some other DBMSes) is designed to be as easy as possible.

Search API is natively ported to PHP, Python, Perl, Ruby, Java, and also available as a pluggable MySQL storage engine. API is very lightweight so porting it to new language is known to take a few hours.

As for the name, Sphinx is an acronym which is officially decoded as SQL Phrase Index. Yes, I know about CMU's Sphinx project. 

Description
--------

This recipe installs [sphinx][1] 0.9.9 and attempts to deliver a straight forward method of using a combination of Chef recipes and Deploy Hooks.  

Design
--------

This recipe configures [sphinx][1] and searchd on the 'solo|app_master' instance.  It creates a sphinx.yml that is usable on the app instances to communicate with the searchd instance running on the app_master.  This is not meant to be a contradiction with other recipes that suggest to run on a utility instance if you need to change this behavior you can modify [default.rb][2] to change this logic.  Other portions of the recipe may need to be updated as well.

Warnings










[1]: http://sphinxsearch.com/
[2]: http://github.com/damm/ey-cloud-recipes/blob/sphinx_test/cookbooks/sphinx/recipes/default.rb#L151
[3]: http://github.com/damm/fds/blob/master/deploy/before_migrate.rb
[4]: http://docs.engineyard.com/appcloud/howtos/customizations/custom-chef-recipes
[5]: 
