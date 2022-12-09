#!/bin/sh

GLOBAL_DATABASE_FILENAME=""
SCRIPT_PROMPT="
Q1 (first.os1db):
1) Add a new record
2) Delete a record
3) Search for a record
4) Update a record

Please enter a number from the list above, or (q) to quit:"


function encode_key() {
  key=$1
  echo $key | base64
}

function insert_key_value_record_to_file() {
  read -p "Enter key:" KEY
  read -p "Enter value:" VALUE
  
  # if key already exists return

  echo "$KEY: $VALUE" >> $GLOBAL_DATABASE_FILENAME
}

function delete_record_by_key() {
  read -p "Enter the key that you want to delete its record:" KEY
  # if key doesn't exist return BRO I NEED VALID KEYS
  # else deleter record peacefully
}

function search_for_record_by_key() {
  read -p "Enter the key that you want to serach for:" KEY
  # return grep magic
}

function write_project_version_to_database() {
  echo "VERSION 1 (OS 1)" > GLOBAL_DATABASE_FILENAME
}

function initialize_database() {
  read -p "Enter "
  filename_provided_by_user=blabla

  if [[ $# = 2 && $1 = "--create" ]] then echo "hey";

  fi
}

# function main_loop() {
#   user_input=""

#   while [ "$user_input" != "q" ]
#   do
#     echo "$__script_prompt"
#     read user_input
#     echo "You typed: $user_input"
#   done
# }

# initialize_database
# main_loop
