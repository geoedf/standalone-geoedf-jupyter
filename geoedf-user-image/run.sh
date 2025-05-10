#!/bin/sh
  
echo "sourcing condor.sh"

. /opt/condor/condor.sh

echo "ALLOW_WRITE = *" >> /opt/condor/local/config.d/00-personal-condor

echo "running condor_master"

condor_master

echo "running jupyterhub"

condor_config_val -set "ALLOW_WRITE = *"

bash /usr/local/bin/start-singleuser.sh "$@"
