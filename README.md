# Postgres with Pgadmin4 using docker

Project with docker-compose creating 2 containers. One container with the Postgres database and the other with PgAdmin4.

The docker-compose file contains the container information and can be modified freely. You can change the root user, password and change the server ports.

The main names of the containers are `pgsql` for Postgresql and` pgadmin4` for Pgadmin4. With that, all the scripts took into account these container names.

# Starting the project

Have the docker and docker-compose installed on your machine.

## `Docker_scripts` directory

This directory contains some scripts for managing the containers.

`logs.sh`: Displays the Postgres container log.

`start.sh`: Start the Postgres and PgAdmin4 containers.

`stop.sh`: Stop containers.

`remove.sh`: Pause and remove containers.

`remove_volumes.sh`: Pause, remove containers and delete all volumes.

## `restore_dump_scripts` directory

This directory contains the dump and restore scripts that will be executed in the containers.

To restore a bank, it is necessary to add the file in this directory (`* .dmp`).

`restore.sh`: The script will copy the file to the volume (`. / data`) of the container and execute the restore command.

At this point, all processes in the bank are killed, the selected database is removed and a new bank is created.

`dump.sh`: Dump the database by creating the file in this same location and later compressing a copy in` tar`.

## `scripts` directory

This directory contains all the common scripts that will be executed inside the container.

Basic commands like creating a new database, new role and running `sql` files.

They can be used as examples of executing commands inside the container.