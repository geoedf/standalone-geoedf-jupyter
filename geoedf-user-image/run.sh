#!/bin/sh

echo "sourcing condor.sh"

. /opt/condor/condor.sh

echo "running condor_master"

condor_master

echo "running jupyterhub"

jupyterhub-singleuser "$@"
