#!/usr/bin/env bash

workload_name="hugo-static-app"
region=westeurope
environment="test"
tags="environment=$environment division=id subDivision=idci managedBy=azcli"

resource_group_name=$(printf "rg-%s-%s" "$workload_name" "$environment")
static_web_app_name=$(printf "stapp-%s-%s" "$workload_name" "$environment")
static_web_app_sku="Free"
repo_url=$(git remote -v | awk '/push/{gsub(/\.git$/, "", $2); print $2}')

az group create \
  --name "$resource_group_name" \
  --location $region \
  --tags $tags

az staticwebapp create \
  --name "$static_web_app_name" \
  --resource-group "$resource_group_name" \
  --location $region \
  --source "$repo_url" \
  --app-location "/" \
  --output-location "public" \
  --branch "main" \
  --sku "$static_web_app_sku" \
  --login-with-github \
  --tags $tags

webapp_url=$(az staticwebapp show --name "$static_web_app_name" --resource-group "$resource_group_name" --query "defaultHostname" -o tsv)

runtime="+1M"
endtime=$(date -v${runtime} +%s)

while [[ $(date +%s) -le $endtime ]]; do
  if curl -I -s "$webapp_url" >/dev/null; then
    break
  else
    sleep 5
  fi
done

echo ""
echo "You can now visit your web app at https://$webapp_url"
echo
echo "The rendered page will be visible as soon as the workflow action has been run successfully."
echo "See $repo_url/actions"
