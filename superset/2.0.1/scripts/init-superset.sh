#!/bin/bash

############################################################################
#
# Init script for the Superset image
#
############################################################################

set -e

############################################################################
# Wait for services + Install local dependencies
############################################################################
/scripts/entrypoint.sh

STEP_CNT=4

echo_step() {
cat <<EOF

######################################################################


Init Step ${1}/${STEP_CNT} [${2}] -- ${3}


######################################################################

EOF
}

SUPERSET_USER_NAME=${SUPERSET_USER_NAME:="admin"}
SUPERSET_USER_PASS=${SUPERSET_USER_PASS:="admin"}

ADMIN_PASSWORD="admin"

############################################################################
# Initialize + Upgrade database
############################################################################

echo_step "1" "Starting" "Applying DB migrations"
superset db upgrade
echo_step "1" "Complete" "Applying DB migrations"

############################################################################
# Create Superset user
############################################################################

echo_step "2" "Starting" "Setting up admin user ( admin / ${SUPERSET_USER_PASS} )"
superset fab create-admin \
    --username admin \
    --firstname Superset \
    --lastname Admin \
    --email admin@superset.com \
    --password ${SUPERSET_USER_PASS}
echo_step "2" "Complete" "Setting up admin user"

############################################################################
# Create default roles and permissions
############################################################################

echo_step "3" "Starting" "Setting up roles and perms"
superset init
echo_step "3" "Complete" "Setting up roles and perms"

############################################################################
# Load Examples
############################################################################

if [ "$SUPERSET_LOAD_EXAMPLES" = "yes" ]; then
    # Load some data to play with
    echo_step "4" "Starting" "Loading examples"
    superset load_examples
    echo_step "4" "Complete" "Loading examples"
fi
