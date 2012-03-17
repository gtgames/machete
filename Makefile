DOMAIN=$(shell cat config/config.json | grep -Po '"domain":.*?[^\\]",' | awk -v RS=',"' -F: '/^\"domain\"/ {print $2}' | sed -e 's/"/''/g')
DIR=$(shell pwd)


all: help

help:
	@echo make [upgrade,deps,help]
	@echo ---
	@echo [upgrade]: upgrades machete base to last version
	@echo [deps]: upgrades our dependencies

install: upgrade

upgrade:
	git fetch &&\
		git stash &&\
		git pull &&\
		git stash apply

submodule:
	git submodule init && git submodule update

deps: submodule uikit

uikit: submodule
	@cd $(DIR)/vendor/uikit && make
	@cp -r $(DIR)/vendor/uikit/build/* $(DIR)/public/javascripts/uikit
	@echo UIKIT upgraded


less:
	@cd $(DIR)/public/stylesheets &&\
		echo compile 'layout.less' &&\
		lessc layout.less > layout.css &&\
		echo compile 'admin.less'&&\
		lessc admin.less > admin.css


.PHONY: all help uikit submodule
