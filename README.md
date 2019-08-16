#tss-postgres

**Solution:** tss-postgres
**Sourced From:** postgres\_basic

**Description:** This is the database container for the 3 container solution. It is intended to be a standalone postgres container that can support multiple apps running in their own containers on the same host.

**Last Updated** 15 Aug 19

## Notes/Variations
#### Location of data
- The data is mounted on a docker managed volume (db-data)

#### Networking
- The container will connect to the external postgres-network
- Solutions that want to use this container must connect to that network
- The only port exposed is the standard 5432 postgres port

##Installation/Configuration

#### Pre-installation
- Create the network the database will connect on
```console
docker network create postgres-network
```

#### Run the project-setup.sh script
```bash
./project-setup.sh {postgres user password}
```

#### Run the image (there is no build step)

```console
docker-compose up -d
```

* **Service name:** database

## Post Install Notes/FAQ

#### How do I remove the network
- To remove the internal docker network do this:
```console
docker network rm postgres-network
```
#### Things to know
- At this point you have a postgres database running with port 5432 exposed.
- **NOTE: Because this installation uses a shared (docker managed volume) the first time you deploy this image on a machine the 'postgres' user's password will be set.  This is the password you have to use from here on out!**

#### Why is there no build step?
This image is based directly on the postgres image and there is no special configuration needed. So there is no need for a Dockerfile at this moment.

#### Where is the data stored?
Right now the data is stored in a Docker managed volume named `db-data`. In the future you might want to store it on a host mounted volume.  There is a line in the `docker-compose.yml` file that shows how do this.  You will also have to create the `./data/pgdata` directory.

#### Connecting to the Postgres database (via psql)
You can launch into the database with this command:

```console
docker-compose run --rm database psql -U postgres -h database
```

#### How do I connect a rails app running in a separate container to this database?
- Adjust the rails project's `database.yml` as follows:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: postgres_database_1 # This may be different depending on how postgres was deployed
  username: postgres # configured in ./postgres/postgres.env
  password: tss_pgl_passwd1 # configured in ./postgres/postgres.env 
  pool: 5
  variables:
    statement_timeout: 5000

development:
  <<: *default
  database: app_development

test:
  <<: *default
  database: app_test

production:
  <<: *default
  database: app_production

```
- Ensure the rails project's `docker-compose.yml` file has the networks section defined as follows:

```yaml
networks:
  default:
    external:
      name: postgres-network
```
* This assumes you have connected the rails image to the same user defined network the postgres image is on.

#### Useful psql commands
```
\l - list the databases
\q - quit
CREATE DATABASE {db_name};
\c {db_name} - connect to a database
\dt - list tables
```
