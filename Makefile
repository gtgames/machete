#DOMAIN=$(shell cat config/config.json | grep -Po '"domain":.*?[^\\]",' | awk -v RS=',"' -F: '/^\"domain\"/ {print $2}' | sed -e 's/"/''/g')
DIR=$(shell pwd)


all: help

help:
	@echo make [upgrade] [deps] [less] [help]
	@echo ---
	@echo [upgrade]: upgrades machete base to last version
	@echo [deps]: upgrades our dependencies
	@echo 	[uikit]: copy the latest build to the public folder
	@echo 	[kalendae]: copy the latest build to the public folder
	@echo ---
	@echo [less]: produce css files from the less source
	@echo 	[watch_less]: compiles less files every 5 seconds

install: upgrade

upgrade:
	git fetch &&\
		git stash &&\
		git pull &&\
		$(submodule_update) &&\
		git stash apply

#
# Vendor libraries
#

submodule:
	git submodule init && git submodule update

submodule_update:
	git submodule -q foreach git pull -q origin master

deps: submodule uikit

uikit: submodule
	@mkdir -p $(DIR)/public/javascripts/uikit
	@cp -r $(DIR)/vendor/uikit/build/* $(DIR)/public/javascripts/uikit
	@echo UIKIT upgraded

kalendae: submodule
	@mkdir -p $(DIR)/public/javascripts/kalendae
	@cp -r $(DIR)/vendor/kalendae/build/* $(DIR)/public/javascripts/kalendae
	@echo KALENDAE upgraded


#
# Less files
#

less:
	@cd $(DIR)/public/stylesheets &&\
		echo compile 'layout.less' &&\
		lessc layout.less > layout.css &&\
		echo compile 'admin.less'&&\
		lessc admin.less > admin.css

watch_less:
	watch -i 5 make less

pack_css:
	cd $(DIR)/public/stylesheets &&\
		sqwish admin.css -o admin.css --strict &&\
		sqwish layout.css -o layout.css --strict

pack_js:
	cd $(DIR)/public/javascripts &&\
		uglifyjs application.js > application.min.js
.PHONY: all help uikit submodule
