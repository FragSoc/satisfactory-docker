#!/bin/bash
set -eo pipefail

$INSTALL_LOC/FactoryServer.sh -log -unattended \
    -ServerQueryPort=${QUERY_PORT} \
    -BeaconPort=${BEACON_PORT} \
    -Port=${PORT} \
    $@
