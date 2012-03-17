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

deps: uikit

uikit:
	@echo upgrading UIKIT...
	@git clone https://github.com/aliem/uikit.git $(DIR)/tmp/uikit/
	@cd $(DIR)/tmp/uikit && make
	@rm -rf $(DIR)/public/javascripts/uikit
	@cp -r $(DIR)/tmp/uikit/build $(DIR)/public/javascripts/uikit
	@rm -rf $(DIR)/tmp/uikit
	@echo UIKIT upgraded

less:
	@cd $(DIR)/public/stylesheets &&\
		echo compile 'layout.less'\
		lessc layout.less > layout.css\
		echo compile 'admin.less'\
		lessc admin.less > admin.css


.PHONY: all, help, uikit
