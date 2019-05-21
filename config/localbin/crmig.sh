#!/bin/bash -

set -o nounset                                  # Treat unset variables as an error

MIGRATION_PREFIX=$1
FUNCTION_FILE=$2

if type knex >/dev/null 2>&1
then
    knexbin='knex'
else
    knexbin='./node_modules/.bin/knex'
fi

filename_soup=`"${knexbin[@]}" migrate:make "${1}_${2}"`

pattern='Created Migration: (.+\.js)'
[[ "$filename_soup" =~ $pattern ]] || (echo 'Could not create migration' && exit 1)

migration_file=${BASH_REMATCH[1]}
