#!/bin/sh

# use the current environment
set -e

# copy the postgres.env file into the directory just created
cp ./postgres/postgres.env ./data/postgres

if [[ "$OSTYPE" == "linux-gnu" ]]; then
   sed -i '' -e "s/PASSWORD_TO_USE/$1/g"  $PWD/data/postgres/postgres.env
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # have to do it this way because of mac OSX, will need to adjust for different OS's
    sed -i '' -e "s/PASSWORD_TO_USE/$1/g"  $PWD/data/postgres/postgres.env
else
    sed -i '' -e "s/PASSWORD_TO_USE/$1/g"  $PWD/data/postgres/postgres.env
fi

