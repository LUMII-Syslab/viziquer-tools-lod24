# ViziQuer Tools LOD24

This repository contains scripts and initial data for starting your own copy of ViziQuer Tools, 
LOD24 edition, as a set of interlinked containers.

It provides the supporting material for the KGSWC'24 paper 
"Visual Presentation and Summarization of Linked Data Schemas".

This repository is a fork of [ViziQuer Tools](https://github.com/LUMII-Syslab/viziquer-tools), 
extended with a set of schemas from 24 popular Linked Open Data endpoints.

The `diagrams` folder contains visual presentations of the included schema diagrams.

This repository is just a glue + initial data; the tools themselves come from the following repositories:
- [ViziQuer](https://github.com/LUMII-Syslab/viziquer)
- [Data Shape Server](https://github.com/LUMII-Syslab/data-shape-server)

For more information on the ViziQuer tools family, please visit [viziquer.lumii.lv](https://viziquer.lumii.lv/).

## Requirements

You should have a Docker-compatible environment installed (e.g. [Docker Desktop](https://www.docker.com/products/docker-desktop/), [Podman](https://podman.io/), [OrbStack](https://orbstack.dev/), ...).

Any Linux server with Docker components installed will also be sufficient, either on cloud or on-premise.

You should have some free disk space for the data and for container images.

## Before First Start

Download this git repository, or clone it to a local directory of your choice.

Create a file `.env` as a copy of `sample.env`, and configure it to your preferences (ports, passwords, etc.)

## Start/Stop the Tools

Start the Tools by issuing the commands:

```bash
cd viziquer-tools
docker-compose up -d
```

On the first start, the required images will be pulled from registries, and the databases will be populated with starter data.

To stop the Tools, issue the command

```bash
cd viziquer-tools
docker-compose down
```

Note: Depending on your version of container tools, instead of `docker-compose ...` you may need to use `docker compose ...`.

## Using ViziQuer Tools

ViziQuer Tools are available via any modern Internet browser via addresses `http://localhost:%port%`.

The following addresses are shown assuming you used the default ports provided in `sample.env`

You can connect to the ViziQuer via `http://localhost:80`

You can connect to the pgAdmin via `http://localhost:9001`; on first start you will be asked for the password for the rdfmeta user

The DSS instance API is available via `http://localhost:9005`

The Postgres server is available at `localhost:5433`

## Populating the Data

Initially, two example schemas are included: *Nobel_prizes* and *Starwars*.

To add a schema for another endpoint, whether public or your own, follow these two steps:

- extract the schema from the endpoint
- import the schema into ViziQuer Tools

Note: these steps will be automated in one of the next releases.

Alternatively, existing schemas (e.g., created on other servers) can be uploaded.

### Extracting the schema from the endpoint

To extract a schema from an endpoint, you should use [OBIS-SchemaExtractor](https://github.com/LUMII-Syslab/OBIS-SchemaExtractor), version 2, and follow the instructions there.

### Importing the schema into ViziQuer Tools

Once you have obtained a JSON file with the extracted schema, you need to import this JSON file into ViziQuer Tools. 

Currently, to import the schema, use the [importer module](https://github.com/LUMII-Syslab/data-shape-server/tree/main/import-generic)
from the Data Shape Server repository.

### Data schema uploading

An existing SQL database schema script (like the ones in `./db/init/pg` directory) can be executed against the database instance to create a new schema. 
Manual updates of tables `schemata` and `endpoints` in the `public` schema are needed to make this information accessible from the visual environment.

## (Re)starting from scratch

Data from the directories `./db/init/pg` and `./db/init/mongo` will be imported on first start of the system.

To restart later from scratch, remove the following directories:

- `./db/pg` to restart with a fresh DSS database content
- `./db/mongo` to restart with fresh content of ViziQuer projects database

and then restart the Tools, as in the following commands:

```bash
cd viziquer-tools
docker-compose down
rm -rf db/pg
docker-compose up -d
```

## Updating components

```bash
cd viziquer-tools
docker-compose down
docker-compose pull
docker-compose up -d
```

## Uninstalling ViziQuer Tools

Just delete the directory `./viziquer-tools` with all its subdirectories.

Note: Don't forget to export your project data before uninstalling ViziQuer Tools.
