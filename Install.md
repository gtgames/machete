# Installation

## Hard dependencies

Machete has been tested on **Mac OS X** *10.6* and *10.7*, **Linux 2.6.x** along with **Ruby 1.9.2-p290**, **node.js 0.6**, **MongoDB v2.0** and **NGiNX 0.8.54**.

The application server of choice for Machete is [thin](http://code.macournoyer.com/thin/) since it's built around [EventMachine](http://rubyeventmachine.com/) and [rack-fiber_pool](https://github.com/mperham/rack-fiber_pool) to support an event based request handling.

Machete must have access to the [Image Magick](http://www.imagemagick.org/) executable, the [file](http://en.wikipedia.org/wiki/File_(command)) command and the [less](http://lesscss.org) [node.js](http://nodejs.org/) module (executable `lessc`).

File uploading is supported using the [NGiNX](http://nginx.org) plugin [nginx_upload_module](http://www.grid.net.ru/nginx/upload.en.html) configured to support XmlHttpRrequest v2 uploads:

    location /base/upload {
        upload_pass   @app;
        upload_resumable on; # XHR uploads
        upload_pass_args on; #  "    "
    
        upload_store_access user:rw group:rw all:rw;
        # Store files to this location
        upload_store /tmp/uploads;
        # Set specified fields in request body
        upload_set_form_field filename "$upload_file_name";
        upload_set_form_field name "$upload_field_name";
        upload_set_form_field tempfile "$upload_tmp_path";
        upload_pass_form_field "^form_id$";
        upload_cleanup 400 404 499 500-505;
    }


Machete expects an SMTP server listening on *127.0.0.1* port *25* (configurable inside config/apps.rb).

## getting started

Once you have configured the dependencies you can clone the [repository](http://github.com/gtgames/machete.git):

    $ git clone http://github.com/gtgames/machete.git project_name
    …
    $ cd project_name

Install ruby dependecies with [Bundler](http://gembundler.com/):

    $ bundle install

to install basic random content issue the command:

    $ make seed

install vendor dependencies (javascript libraries):

    $ make deps

now you are ready to modify templates, stylesheets or anything else.

To start a development server just issue the command:

    $ bundle exec thin start

The admin sub-application is tied to a subdomain `admin.*`, for development add to your `/etc/hosts` something like:

    127.0.0.1 machete.dev
    127.0.0.1 admin.machete.dev


### useful Makefile commands

* *upgrade*: upgrades machete base to latest git master version
* *deps*: upgrades external dependencies
    * *uikit*: upgrade and copy the latest build to the public folder
    * *kalendae*: copy the latest build to the public folder
* *less*: produce css files from the less source
* *watch_less*: compiles less files every 5 seconds (uses [watch(1)](https://github.com/visionmedia/watch))
