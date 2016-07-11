#!/bin/bash -
#===============================================================================
# vim: ai ts=2 sw=2 et ft=sh
#          FILE: sync_uncommited.sh
#
#         USAGE: ./sync_uncommited.sh [-q|--quiet] <server>
#
#   DESCRIPTION: Sync all uncommited changes to <server>. If --quiet flag is
#                specified, confirmation of every file is supressed
#
#       OPTIONS: ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

ARG_CONFIRM="yes"

# read the options
TEMP=`getopt -o q --long quiet -n 'sync_uncommited.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -q|--quiet) ARG_CONFIRM="no" ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

for line in $(git status -s | awk '{ print $2 }')
do
  if [ "${ARG_CONFIRM}" == "yes" ]
  then
    read -r -p "$line Are you sure? [Y/n]" response
    response=${response,,} # tolower
    if [[ $response =~ ^(yes|y| ) ]]; then
      scp -Cp $line "$1:Repo/Bundle/$line"
    fi
  else
    scp -Cp $line "$1:Repo/Bundle/$line"
  fi
done

