RELEASE=jhub
NAMESPACE=iguide

helm upgrade --install $RELEASE jupyterhub/jupyterhub \
      --namespace $NAMESPACE  \
      --create-namespace \
      --version 3.0.0 \
      --debug \
      --values geoedf_config.yaml
##--values secrets.yaml
