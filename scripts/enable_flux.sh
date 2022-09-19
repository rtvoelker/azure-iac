#!/usr/bin/env bash

az feature register --namespace Microsoft.ContainerService --name AKS-ExtensionManager

az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration