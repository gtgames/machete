#DOMAIN=$(shell cat config/config.json | grep -Po '"domain":.*?[^\\]",' | awk -v RS=',"' -F: '/^\"domain\"/ {print $2}' | sed -e 's/"/''/g')
DIR=$(shell pwd)


all: help

help:
	@echo make [upgrade,deps,help]
	@echo ---
	@echo [upgrade]: upgrades machete base to last version
	@echo [deps]: upgrades our dependencies
	@echo 	[uikit]: copy the latest build to the public folder
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

submodule:
	git submodule init && git submodule update

submodule_update:
	git submodule -q foreach git pull -q origin master

deps: submodule uikit

uikit: submodule
	@cp -r $(DIR)/vendor/uikit/build/* $(DIR)/public/javascripts/uikit
	@echo UIKIT upgraded

less:
	@cd $(DIR)/public/stylesheets &&\
		echo compile 'layout.less' &&\
		lessc layout.less > layout.css &&\
		echo compile 'admin.less'&&\
		lessc admin.less > admin.css

watch_less:
	watch -i 5 make less

.PHONY: all help uikit submodule
