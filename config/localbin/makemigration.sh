#!/bin/bash -

set -o nounset                                  # Treat unset variables as an error

MIGRATION_DIR='migrations'

# Update master
git push . origin/master:master

# Create temporary file
uptemp="$(mktemp)"

# Pad file with 8 spaces for migration and remove excess whitespace
pr -t -o 8 $1 | sed -r 's/^\s+$//' > "${uptemp}"

# Create temporary file
downtemp="$(mktemp)"

# Get file from master, pad file with 8 spaces for migration and
# remove spaces from a line, that contain only spaces
git show "master:${1}" | pr -t -o 8 | sed -r 's/^\s+$//' > "${downtemp}"

# sed command to replace a string <<UP>> with file $uptemp
up="/<<UP>>/ {
r $uptemp
d
}"

# sed command to replace a string <<UP>> with file $uptemp
down="/<<DOWN>>/ {
r $downtemp
d
}"

migration=$(date +"%Y%m%d%H%M%S")

sed -e "${up}" ~/.local/bin/js.stub > "${MIGRATION_DIR}/${migration}_${2}_$(basename $1)"
sed -i -e "${down}" "${MIGRATION_DIR}/${migration}_${2}_$(basename $1)"

mv "${MIGRATION_DIR}/${migration}_${2}_$(basename $1)" `echo "${MIGRATION_DIR}/${migration}_${2}_$(basename $1)" | sed 's/\(.*\.\)[pg]*sql/\1js/'`
