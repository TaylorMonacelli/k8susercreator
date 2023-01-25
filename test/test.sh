#!/usr/bin/env sh

set -x
set -e
set -u

kubectl create namespace finance
kubectl create deployment nginx --image nginx --namespace finance
kubectl rollout status deployment/nginx --namespace finance
kubectl create role myuser-finance --verb get,list --resource=deployments --namespace finance
kubectl create rolebinding finance-rolebinding --role myuser-finance --user myuser --namespace finance

timeout --verbose 1m \
    ./dist/k8suser_linux_amd64_v1/k8suser \
    --orgUnit DevOps \
    --username myuser \
    --email 'myuser@gmail.com' \
    --country US \
    --city IL \
    --orgazniation acmecorp \
    --province Chicago \
    --cluster kind-kind

kubectl --kubeconfig ./myuser get deployment nginx --namespace finance
