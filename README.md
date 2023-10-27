
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Overloading of Resources in Apache Airflow
---

This incident type involves managing the level of parallelism and concurrency for tasks in Apache Airflow to prevent overloading of system resources. Apache Airflow is a platform used for scheduling and monitoring workflows. When the level of parallelism or concurrency is too high, it can cause resource exhaustion, leading to failure of tasks or even the entire system. This incident requires careful management of the number of tasks that can run simultaneously and the resources they require to ensure smooth performance of the system.

### Parameters
```shell
export AIRFLOW_NAMESPACE="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export SCHEDULER_POD_NAME="PLACEHOLDER"

export DESIRED_PARALLELISM="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"

export DESIRED_CONCURRENCY="PLACEHOLDER"
```

## Debug

### List all running pods in the Airflow namespace
```shell
kubectl get pods -n ${AIRFLOW_NAMESPACE}
```

### View the logs of a specific pod
```shell
kubectl logs ${POD_NAME} -n ${AIRFLOW_NAMESPACE}
```

### Check the status of the Airflow scheduler
```shell
kubectl exec ${SCHEDULER_POD_NAME} -n ${AIRFLOW_NAMESPACE} airflow list_dags
```

### Check the resource usage of a specific pod
```shell
kubectl top pods ${POD_NAME} -n ${AIRFLOW_NAMESPACE}
```

### Check the resource usage of all pods in the Airflow namespace
```shell
kubectl top pods -n ${AIRFLOW_NAMESPACE}
```

### Check the resource requests and limits for a specific pod
```shell
kubectl describe pod ${POD_NAME} -n ${AIRFLOW_NAMESPACE}
```

### Check the resource requests and limits for all pods in the Airflow namespace
```shell
kubectl describe pods -n ${AIRFLOW_NAMESPACE}
```

## Repair

### Review the current parallelism and concurrency settings in Apache Airflow and adjust them to a level that can be supported by the available system resources.
```shell
bash

#!/bin/bash



# Set the parameters

NAMESPACE=${AIRFLOW_NAMESPACE}

DEPLOYMENT=${DEPLOYMENT_NAME}

PARALLELISM=${DESIRED_PARALLELISM}

CONCURRENCY=${DESIRED_CONCURRENCY}



# Update the deployment

kubectl -n $NAMESPACE patch deployment $DEPLOYMENT --type=json -p='[{"op": "replace", "path": "/spec/replicas", "value": '$PARALLELISM'},{"op": "replace", "path": "/spec/template/spec/containers/0/resources/limits/cpu", "value": "500m"},{"op": "replace", "path": "/spec/template/spec/containers/0/resources/limits/memory", "value": "512Mi"},{"op": "replace", "path": "/spec/template/spec/containers/0/resources/requests/cpu", "value": "200m"},{"op": "replace", "path": "/spec/template/spec/containers/0/resources/requests/memory", "value": "256Mi"},{"op": "replace", "path": "/spec/template/spec/containers/0/env/0/value", "value": "--parallelism='$PARALLELISM'"},{"op": "replace", "path": "/spec/template/spec/containers/0/env/1/value", "value": "--concurrency='$CONCURRENCY'"}]'


```