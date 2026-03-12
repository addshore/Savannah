# Savannah

Learn more at [SavannahHQ.com](https://savannahhq.com)

![Community Dashboard](./docs/screenshots/Dashboard.png)

Try a live demo at [demo.savannahhq.com](https://demo.savannahhq.com)!

## Create a Development environment

To get started running Savannah in your development environment, first create a Python virtualenv:

```
virtualenv --python=python3 ./env
```

Then install the requirements:

```
./env/bin/pip install -r requirements.txt
```

You'll need to set up a `.env` file in the root of the project, see `.env.example` for an example.

Next you'll need to initialize the database and create an admin account:

```
./env/bin/python manage.py migrate
./env/bin/python manage.py createsuperuser
```

This will create an SQLite database at ./db.sqlite in your local directory.

Finally run the development server:

```
./env/bin/python manage.py runserver
```

## Setting up Savannah

To log in to Savannah go to http://localhost:8000/login and log in.

Once logged in you will need to go to the Django admin (http://localhost:8000/admin) and create a new `Community` record.

You can now view the Savannah dashboard at http://localhost:8000/dashboard/1/

Savannah can import data from Slack, Github, Discourse and RSS feeds. To import, create a `Source` from the `Sources` page.


### Running importers

Once you've created your `Source` you can run the importers with

```
./env/bin/python manage.py import all
```

### Tagging data

You can create `Tags` for your members and conversations from the Django admin interface. If you specify keywords for your tag, all imported conversations will be checked for those keywords and, if found, that `Tag` will be automatically applied to them.

Some useful tags to consider are `thankful` with keywords `thanks, thank you`, and `greeting` with keywords `welcome, hello, hi`.

To auto-tag conversations & contributions, run:
```
./env/bin/python manage.py tag_conversations
./env/bin/python manage.py tag_contributions
```

## Running with Docker

Savannah ships with a Docker configuration that builds the application, runs migrations, and creates (or refreshes) a superuser automatically. The cosmetic UI is served from `http://localhost:8000`.

1. Start (or rebuild) the stack:
	```
	docker compose up -d --build
	```

The Compose stack mounts `.` into `/app` so code changes are reflected immediately and stores SQLite data in the `dbdata` volume mounted at `/data`. The database file path can be overridden via the `SQLITE_DB_PATH` environment variable inside `.env`.

Before launching, edit `.env` to set your desired `DJANGO_SUPERUSER_USERNAME`, `DJANGO_SUPERUSER_EMAIL`, and `DJANGO_SUPERUSER_PASSWORD`. The entrypoint script will run migrations, ensure the default Site record exists, and create/update the superuser on container startup.

If you need to run additional management commands (e.g., `import` or `tag_*`), prepend them to the service like this:
```sh
docker compose run --rm web python manage.py import all
```

Makefile
--------

This repository includes a `Makefile` with convenient shortcuts for common docker-compose workflows. Examples:

```sh
# Start the stack (detached)
make up

# Run the importer (set TYPE to slack|github|discourse|rss|all)
make import TYPE=all

# Rebuild the web image then run the importer (use if dependencies changed)
make import-build TYPE=all

# Run a one-off manage.py command
make manage CMD="migrate"

# Open a shell in the web container
make shell
```
