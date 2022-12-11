# Operating Systems (1) - Final Project

In the final project for the Operating Systems course at Damascus University, fourth yeat, we were given a task to create a simple key-value database and add some basic features to it using Bash.

## Overview

The project consists of 5 questions:

1. Interaction with database:

We have to interact with a text-file database using operations the will be described below. The script can be invoked like this `./q1-database-interaction.bash db_name` in the case there already exists a db file. Or, you can do this `./q1-database-interaction.bash --create db_name` to create a new db file.

Operations that we have to support:

-   Adding a record
-   Updating a record
-   Removing a record
-   Searching for a record in the database using its key

Values are saved in the DB in `base64` format.

2. Backing up the database:
3. Monitor the database operations
4. Upload/Download database related data from a local FTP server
5. ???

## Code

### Naming Conventions

Please try to follow this guideline to ensure consistency across the codebase:

-   `snake_case` for function names
-   `UPPERCASE` for variables

## Collaborators
