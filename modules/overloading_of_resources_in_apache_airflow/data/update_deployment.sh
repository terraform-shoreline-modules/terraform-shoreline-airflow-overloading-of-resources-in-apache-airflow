bash

#!/bin/bash



# Set the parameters

NAMESPACE=${AIRFLOW_NAMESPACE}

DEPLOYMENT=${DEPLOYMENT_NAME}

PARALLELISM=${DESIRED_PARALLELISM}

CONCURRENCY=${DESIRED_CONCURRENCY}



# Update the deployment

kubectl -n $NAMESPACE patch deployment $DEPLOYMENT --type=json -p='[{"op": "replace", "path": "/spec/replicas", "value": '$PARALLELISM'},{"op": "replace", "path": "/spec/template/spec/containers/0/resources/limits/cpu", "value": "500m"},{"op": "replace", "path": "/spec/template/spec/containers/0/resources/limits/memory", "value": "512Mi"},{"op": "replace", "path": "/spec/template/spec/containers/0/resources/requests/cpu", "value": "200m"},{"op": "replace", "path": "/spec/template/spec/containers/0/resources/requests/memory", "value": "256Mi"},{"op": "replace", "path": "/spec/template/spec/containers/0/env/0/value", "value": "--parallelism='$PARALLELISM'"},{"op": "replace", "path": "/spec/template/spec/containers/0/env/1/value", "value": "--concurrency='$CONCURRENCY'"}]'