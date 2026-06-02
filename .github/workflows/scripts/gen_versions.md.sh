#!/usr/bin/bash

# Find available versions
readarray -t REMOTE_BRANCHES < <(git branch --remotes | sort)

VERSION_BRANCHES=()

for branch in ${REMOTE_BRANCHES[@]};
do
  VERSION=$(echo $branch | grep -Po "(?<=^|\/)(\d+\.)+\d+$")

  if [ -z "$VERSION" ];
  then
    continue
  fi

  VERSION_BRANCHES+=($VERSION)
done

# Sorting versions asc

# Export to github env variables
if [ -f "$GITHUB_ENV" ];
then
  echo "VERSIONS=${VERSION_BRANCHES[@]}" >> $GITHUB_ENV
fi

# Prepare for the template's variables
export LAST_UPDATE_DATE=$(date -R)
export VERSIONS=""
export LATEST="No latest version"

if [ -z "$GITHUB_REPOSITORY_URL" ];
then
  GITHUB_REPOSITORY_URL="https://github.com/fyn-jobboard/sdk"
fi

LAST_MD_LINK=""

for version in ${VERSION_BRANCHES[@]};
do
  MD_LINK="[$version]($GITHUB_REPOSITORY_URL/tree/$version)"
  if [ -n "$VERSIONS" ];
  then
    VERSIONS="\n$VERSIONS"
  fi

  VERSIONS="- $MD_LINK$VERSIONS"
  LATEST=$MD_LINK
done

echo "Versions:"
echo ${VERSIONS@E}

if [ -f "$1" -a -n "$2" ];
then
  envsubst < $1 > $2
else
  echo "::warning::Invalid template and/or output paths (received: '$1' (template) and '$2' (output))"
fi
