# Deploy a Hugo site to Azure Static Web Apps

This repository represents a Hugo site that is deployed to Azure Static Web
Apps. It's based on the example in the
[documentation](https://learn.microsoft.com/en-us/azure/static-web-apps/publish-hugo)
and features everything to create a static web app and to deploy the Hugo site
into it.

Fork this repo to your account/organisation and start provisioning and deploying
to a subscription of yours.

## Prerequisites

* An fork of this repo on GitHub, where you have full access to it
* An Azure subscription with permission to create resources
* The tools `git` and `az` (Azure CLI) installed on your machine

## Setup

Clone your fork to your local machine and run the provisioning script. You have
to be logged in to the Azure CLI and have selected the right subscription.
Follow the onscreen instructions.

```bash
az login
./infra/provision.sh
```

The provisioning script creates a resource group and static web app resources.
During this tasks, you are requested to authenticate with GitHub. This allows
the Azure CLI to commit the GitHub Actions workflow file to your repo. This
workflow will later deploy your Hugo site to the static web app.

Congratulation, your static web app is created, but the first run
of the deployment workflow failed.  
By default, a very old version of Hugo is installed that is no longer compatible
with the theme `ananke`. Therefore, a newer version of Hugo needs to be requested.

You can do so by setting an environment variable HUGO_VERSION, see [Custom Hugo
version](https://learn.microsoft.com/en-us/azure/static-web-apps/publish-hugo#custom-hugo-version).
You can make this change by following the commands below.

```bash
git pull origin main
patch .github/workflows/azure-static-web-apps-*.yml < add_hugo_version.diff;
git add .github/workflows/azure-static-web-apps-*.yml
git ci -m "build: request newer Hugo version"
git push origin main
```

Now the workflow to deploy your Hugo site runs successfully and the site is
online.
