# Operating Systems (1) - Final Project

In the final project for the Operating Systems course at Damascus University, fourth year, we were given some tasks that we have to solve using Bash. They cover different aspects of shell scripting such as managing files,

## Overview

The project consists of 5 questions:

1. Interaction with text files:

We have to interact with a simple text file database (key-value pair) using operations that will be described below. The script can be invoked like this `./q1-database-interaction.bash db_name` in the case there already exists a db file. Or, you can do this `./q1-database-interaction.bash --create db_name` to create a new db file.

Operations that we have to support:

-   Adding a record
-   Updating a record
-   Removing a record
-   Searching for a record in the database using its key

Values are saved in the DB in `base64` format.

2. Backing up the database:

This question is built on top of the previous one.

3. Monitoring performance

4. Setting up a simple FTP server for downloading/uploading
5. ???

## Code

### Naming Conventions

Please try to follow this guideline to ensure consistency across the codebase:

-   `snake_case` for function names
-   `UPPERCASE` for variables
-   append functions with the `function` keyword

## Collaborators
