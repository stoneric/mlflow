#!/usr/bin/env bash

if [[ -z "$BACKEND_STORE_URI" ]]; then

   BACKEND_STORE_URI_OPT="--backend-store-uri $BACKEND_STORE_URI"

fi

if [[ -z "$DEFAULT_ARTIFACT_ROOT" ]]; then
   DEFAULT_ARTIFACT_ROOT_OPT="--default-artifact-root $DEFAULT_ARTIFACT_ROOT"
fi

sudo service apache2 start && mlflow server -h 0.0.0.0 -p 5000 $BACKEND_STORE_URI_OPT $DEFAULT_ARTIFACT_ROOT_OPT
