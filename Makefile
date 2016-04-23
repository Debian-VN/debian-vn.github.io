# Makefile for updating bits.debian.org
# This makefile can also be used in local to recreate the blog.

PY?=python
PELICAN?=pelican
PELICANOPTS=-v

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py
# Directory where the generated blog must be copied in master.debian.org
OUTPUTDIRMASTER=/srv/bits-master.debian.org/htdocs

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                              '
	@echo '                                                                             '
	@echo 'Usage:                                                                       '
	@echo '   make html                           (re)generate the web site                '
#	@echo '   make clean                          remove the generated files               '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          start/restart develop_server.sh    '
	@echo '   make stopserver                     stop local server                  '
#	@echo '   make publish                        generate using production settings       '

	@echo '                                                                             '

######################################
# Rules to generate the blog locally #
######################################

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	@echo 'Done'

#clean:
#	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
#	touch $(OUTPUTDIR)/.gitkeep

#regenerate:
#	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

serve-global:
ifdef SERVER
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 $(SERVER)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 0.0.0.0
endif


devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	$(BASEDIR)/develop_server.sh stop
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

#publish:
#	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)


.PHONY: html help serve serve-global devserver stopserver #publish clean regenerate
