# Viziquer Tools

This repository contains scripts and initial data for starting your own copy of Viziquer Tools as a set of containers.

## Requirements

You should have some docker-compatible environment installed, e.g.

- Docker Desktop
- Podman
- ...

You should have free disk space of ca. `10 GB` on the volume where you will run the Viziquer Tools.

## First Start

Download this git repository, or clone it to a directory of your choice.

Create a file `.env` as a copy of `sample.env`, and configure your preferences (ports, passwords, etc.)

Then start the system by issuing the commands:

```
cd .../viziquer-tools
docker-compose up -d
```

To stop the Tools, issue the command

```
docker-compose down
```

## Using Viziquer Tools

The following addresses are shown assuming you used the default ports provided in `sample.env`

You can connect to the Viziquer via `http://localhost:80`

You can connect to the pgAdmin via `http://localhost:9001`; on first start you will be asked for the password for the rdfmeta user

You can connect to the DSS instance via `http://localhost:9005`

## (Re)starting from scratch

Data from the directories `./db/init/pg` and `./db/init/mongo` will be imported on first start of the system.

To restart later from scratch, remove the following directories:

- `./db/pg` to restart with a fresh DSS database content
- `./db/mongo` to restart with fresh content of Viziquer projects database

