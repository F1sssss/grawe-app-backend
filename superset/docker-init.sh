#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

STEP_CNT=4

echo_step() {
cat <<EOF

######################################################################


Init Step ${1}/${STEP_CNT} [${2}] -- ${3}


######################################################################

EOF
}

# Get admin password from environment or use default
ADMIN_PASSWORD=${ADMIN_PASSWORD:-"admin"}
ADMIN_USERNAME=${ADMIN_USERNAME:-"admin"}
ADMIN_FIRSTNAME=${ADMIN_FIRSTNAME:-"Superset"}
ADMIN_LASTNAME=${ADMIN_LASTNAME:-"Admin"}
ADMIN_EMAIL=${ADMIN_EMAIL:-"admin@superset.com"}

# If Cypress run – overwrite the password for admin and export env variables
if [ "$CYPRESS_CONFIG" == "true" ]; then
    ADMIN_PASSWORD="general"
    export SUPERSET_CONFIG=tests.integration_tests.superset_test_config
    export SUPERSET_TESTENV=true
    export SUPERSET_SQLALCHEMY_DATABASE_URI=${SQLALCHEMY_DATABASE_URI}
fi

# Initialize the database
echo_step "1" "Starting" "Applying DB migrations"
superset db upgrade
echo_step "1" "Complete" "Applying DB migrations"

# Create an admin user
echo_step "2" "Starting" "Setting up admin user ( $ADMIN_USERNAME / $ADMIN_PASSWORD )"
superset fab create-admin \
              --username $ADMIN_USERNAME \
              --firstname $ADMIN_FIRSTNAME \
              --lastname $ADMIN_LASTNAME \
              --email $ADMIN_EMAIL \
              --password $ADMIN_PASSWORD
echo_step "2" "Complete" "Setting up admin user"

# Create default roles and permissions
echo_step "3" "Starting" "Setting up roles and perms"
superset init
echo_step "3" "Complete" "Setting up roles and perms"

if [ "$SUPERSET_LOAD_EXAMPLES" = "yes" ]; then
    # Load some data to play with
    echo_step "4" "Starting" "Loading examples"
    # If Cypress run which consumes superset_test_config – load required data for tests
    if [ "$CYPRESS_CONFIG" == "true" ]; then
        superset load_test_users
        superset load_examples --load-test-data
    else
        superset load_examples --force
    fi
    echo_step "4" "Complete" "Loading examples"
fi

# Start the Superset server
superset run -h 0.0.0.0 -p ${SUPERSET_PORT:-8088}