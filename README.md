# Introduction
The repo contains the **Terraform Modular Code** for Azure Cloud to Provision a Web Tier Server containing **nginx** server pre-installed. Also, an Azure DevOps .yml pipeline file is present to automate the execution of Terraform Scripts.

# Terraform Code Overview

- Each Component is available in a module so that its reusable
- Virtual Machine Admin Username has to be provided to variable **vm_uname**
- Virtual Machine Admin Password is randomly generated. The value can be retrieved from .tfstate file post *apply*
- Web Server VM is not enabled with Public IP for security reasons. To ssh into VM, provision a JumpHost or Bastion
- Http Traffic to WebServer is routed via a Load Balancer listening to a public ip address on port 80

# Azure Pipeline Overview

- Pipeline is enabled with Continuous Integration (trigger) on *main* and *master* branch
- Assumes the Terraform Code to be available on Azure Repos where azure-pipeline-terraform.yml file is present
- Create a secret variable named **vm_uname_sensitive** to inject vm username at runtime
- Pipeline contains 3 jobs
    - Job1: Performs Terraform Plan and outputs the plan to stdout log console
    - Job2: Manual Validation job where the Manual Approval is notified and requested via email. Till Approval, pipeline execution is halted
    - Job3: Once the Approval is done, infra is provisioned via terraform apply

# Steps to Provision

## Manual Execution

1. cd into terraform parent module *infra-env/poc/webtier*
```bash
cd infra-env/poc/webtier
```
2. Authenticate to Azure Account
```bash
az login
az account set -s <subscription_id>
```
3. Terraform Init
```bash
terraform init
```
4. Terraform Apply
```bash
terraform apply -auto-approve -var "vm_uname=<vm_admin_uname>"
```

## Using Azure yml Pipeline
1. Push the Code to Azure Repos
2. Import the yaml pipeline and create a secret variable named **vm_uname_sensitive**
3. Create a Service Connection named **Azure-Account-Service-Connection** to your Azure Account
4. Update the terraform init task to point to correct Azure Storage Account to save the .tfstate file
5. Run the Pipeline

# Steps to Access the Default Nginx Web Application
Nginx Default page is available on **http://<load_balancer_frontend_pip>:80**
