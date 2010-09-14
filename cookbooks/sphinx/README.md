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
--------

You **MUST** update the [deloy hook][3] application name in order for sphinx to be monitored properly.  Failure to do so may cause searchd to be unmonitored and cause unacceptable behavior.  Additionally the [deploy hook][3] assumes that thinking_sphinx is configured in Bundler.  If you do not follow this behavior you will need to remove the 'bundle exec' in the [deploy hook][3].

Usage
--------

To enable this recipe you first must uncomment the [require_recipe][9] statement in main/recipes/default.rb.  Once you have done that you then need to update the [appname][8] in sphinx/recipes/default.rb.  Then commit those changes and use the [engineyard][10] and upload the recipes to the environment in question,

``ey recipes upload -e <environment>``.  

Then either apply the recipes,

``ey recipes apply -e <environment>``. 

or boot the environment in question.  Then install the [deploy hook][3] in question in your application root in a folder called 'deploy' called before_migrate.rb with the modified [appname][3] and commit that to your application repo and then deploy.  On an **initial** environment it may **fail** to start searchd initially until deploying. 


Notes
--------

If you wish to change the behavior of how searchd is restarted to a more graceful restart you are more then welcome to modify the [deploy hook][3] to your tastes.  Suggestions are open on this for an default of course.   


Bugs / Comments
--------

If you have any problems with this [recipe][5] please either comment and supply a pull with the patched code.  Otherwise if you have [support][6] please open a ticket at our [support][6] page if you lack support please use our [community][7] forums.

[1]: http://sphinxsearch.com/
[2]: http://github.com/damm/ey-cloud-recipes/blob/sphinx_test/cookbooks/sphinx/recipes/default.rb#L151
[3]: http://github.com/damm/ey-cloud-recipes/blob/sphinx_test/cookbooks/sphinx/before_migrate.rb
[4]: http://docs.engineyard.com/appcloud/howtos/customizations/custom-chef-recipes
[5]: http://github.com/damm/ey-cloud-recipes/tree/sphinx_test/cookbooks/sphinx
[6]: http://support.cloud.engineyard.com/
[7]: http://community.engineyard.com/
[8]: http://github.com/damm/ey-cloud-recipes/blob/sphinx_test/cookbooks/sphinx/recipes/default.rb#L7
[9]: http://github.com/damm/ey-cloud-recipes/blob/sphinx_test/cookbooks/main/recipes/default.rb#L17
[10]: http://docs.engineyard.com/appcloud/guides/deployment/home#engine-yard-cli-user-guide
