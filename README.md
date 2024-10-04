# ViziQuer Tools

This repository contains scripts and initial data for starting your own copy of ViziQuer Tools as a set of interlinked containers.

This repository is just a glue + initial data; the tools itself come from repositories [ViziQuer](https://github.com/LUMII-Syslab/viziquer), [Data Shape Server](https://github.com/LUMII-Syslab/data-shape-server), [OBIS-SchemaExtractor](https://github.com/LUMII-Syslab/OBIS-SchemaExtractor).

For more information on the ViziQuer tools family, please visit [viziquer.lumii.lv](https://viziquer.lumii.lv/).

## Requirements

You should have some docker-compatible environment installed, e.g.

- [Docker Desktop](https://www.docker.com/products/docker-desktop/),
- [Podman](https://podman.io/),
- [OrbStack](https://orbstack.dev/),
- ...

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

On the first start, the databases will be populated with starter data.

To stop the Tools, issue the command

```bash
cd viziquer-tools
docker-compose down
```

Note: Depending on your version of container tools, instead of `docker-compose ...` you may need to use `docker compose ...`.

## Using ViziQuer Tools

ViziQuer Tools are availble via any modern Internet browser via addresses `http://localhost:%port%`.

The following addresses are shown assuming you used the default ports provided in `sample.env`

You can connect to the ViziQuer via `http://localhost:80`

You can connect to the pgAdmin via `http://localhost:9001`; on first start you will be asked for the password for the rdfmeta user

You can connect to the DSS instance via `http://localhost:9005`

## (Re)starting from scratch

Data from the directories `./db/init/pg` and `./db/init/mongo` will be imported on first start of the system.

To restart later from scratch, remove the following directories:

- `./db/pg` to restart with a fresh DSS database content
- `./db/mongo` to restart with fresh content of ViziQuer projects database

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
