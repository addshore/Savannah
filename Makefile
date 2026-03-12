DC := docker compose
SERVICE := web
PY := python manage.py

.PHONY: help up build logs shell migrate createsuperuser import tag_conversations tag_contributions manage run

help:
	@echo "Commands:"
	@echo " make up                    Start the stack (detached)"
	@echo " make logs                  Tail web logs"
	@echo " make shell                 Open shell in web container"
	@echo " make migrate               Run Django migrations"
	@echo " make createsuperuser       Create/update superuser (reads env vars)"
	@echo " make import TYPE=all       Run importer (slack|github|discourse|rss|all)"
	@echo " make tag_conversations     Run tag_conversations"
	@echo " make tag_contributions     Run tag_contributions"
	@echo " make manage CMD=\"<cmd>\"    Run arbitrary manage.py command"

up:
	$(DC) up -d --build

logs:
	$(DC) logs -f $(SERVICE)

shell:
	$(DC) run --rm $(SERVICE) /bin/bash

migrate:
	$(DC) run --rm $(SERVICE) $(PY) migrate

createsuperuser:
	$(DC) run --rm $(SERVICE) $(PY) createsuperuser

import:
ifeq ($(strip $(TYPE)),)
	@echo "Specify TYPE variable: slack|github|discourse|rss|all"
	@exit 1
else
	$(DC) run --rm $(SERVICE) $(PY) import $(TYPE)
endif

# Rebuild the web image before running the importer (useful if requirements changed)
import-build:
ifeq ($(strip $(TYPE)),)
	@echo "Specify TYPE variable: slack|github|discourse|rss|all"
	@exit 1
else
	$(DC) build $(SERVICE)
	$(DC) run --rm $(SERVICE) $(PY) import $(TYPE)
endif

tag_conversations:
	$(DC) run --rm $(SERVICE) $(PY) tag_conversations

tag_contributions:
	$(DC) run --rm $(SERVICE) $(PY) tag_contributions

manage:
ifeq ($(strip $(CMD)),)
	@echo 'Specify CMD variable, e.g., make manage CMD="shell"'
	@exit 1
else
	$(DC) run --rm $(SERVICE) $(PY) $(CMD)
endif

run:
	$(DC) run --rm $(SERVICE)
