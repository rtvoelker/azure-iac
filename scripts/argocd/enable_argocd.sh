#!/usr/bin/env bash

#generate deploy key for github
ssh-keygen -C "argocd@omnius.com" -t ed25519 -f argocd -q -N ""

#Create argocd namespace
kubectl create namespace argocd

#deploy argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#sleed 2 minutes
sleep 2m


#Prerequesites: Install Github-CLI https://cli.github.com/manual/installation
#Add deploy-key to github repository
gh repo deploy-key add <key>.pub --repo <GITHUB CLI reponame>

#Prerequesites: Install argocd-cli
#Port-Forward: kubectl port-forward svc/argocd-server -n argocd 9999:443
#username: admin
#password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
#login: argocd login <argocd server>
argocd repo add <repourl> --ssh-private-key-path argocd


#Apply root project and apps to argocd
kubectl apply -f project-infrastructure.yaml
kubectl apply -f project-apps.yaml
kubectl apply -f application-app-root.yaml
kubectl apply -f application-infrastructure-root.yaml

#Remove key
rm argocd argocd.pub