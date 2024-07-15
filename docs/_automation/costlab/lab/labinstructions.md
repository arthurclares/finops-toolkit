---
layout: default
title: Lab deployment instructions
description: 'Deploy the cost optimization lab.'
parent: Cost Optimization Lab
nav_order: 2
permalink: /lab/labinstructions
---


# How to Deploy the Cost Optimization Lab

These instructions will guide you through deploying the Cost Optimization Lab using Azure PowerShell. 

**Deployment**
⏳ Average Solution End to End Deployment time: 10 minutes

## Prerequisites

1. **Azure Subscription**: Ensure you have an active Azure subscription.
2. **Azure PowerShell**: Install Azure PowerShell modules.
3. **Bicep**: Install the Bicep CLI.

## Step 1: Install Azure PowerShell Modules

To install the Azure PowerShell module, open your PowerShell terminal and run the following command:

```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
```

After installing, you can verify the installation by running:

```powershell
Get-Module -Name Az -ListAvailable
```


## Step 2: Install Azure PowerShell Modules

```powershell
az bicep install
```

Verify the installation by running:

```powershell
az bicep version
```

## Step 3: Connect to Your Azure Account

Connect to your Azure account using the following command:

```powershell
Connect-AzAccount
```

Follow the prompts to log in. After logging in, you can view your subscriptions with:

```powershell
Get-AzSubscription
```

## Step 4: Set the Context to the Correct Subscription

Set the context to the subscription you want to use for the deployment:

```powershell
Set-AzContext -SubscriptionId <your-subscription-id>
```

Replace <your-subscription-id> with the ID of the subscription you want to use.

## Step 5: Clone the GitHub Repository

Clone the lab repository from GitHub to your local machine. 

```powershell
git clone --no-checkout https://github.com/arthurclares/finops-toolkit.git   
```


### Step 2: Navigate to the repository directory

```powershell
cd finops-toolkit
```

### Step 3: Enable the sparse-checkout feature

```powershell
git sparse-checkout init --cone
```

### Step 4: Configure the sparse-checkout to include only the desired folder

```powershell
git sparse-checkout set docs/_automation/costlab
```

### Step 5: Checkout the specific branch

```powershell
git checkout arclares-costoptlabs
```

## Step 6: Deploy the Lab

Run the following command to create a new deployment. 

```powershell
New-AzSubscriptionDeployment -Name <deployment-name> -Location <location> -TemplateFile <template-file>
```

Example:

```powershell
New-AzSubscriptionDeployment -Name CostOptimizatiobLab -Location italynorth -TemplateFile main.bicep
```

## Step 7: Run Day 2 Operations Script

After the Bicep deployment is complete, run the day2operation.ps1 script to complete additional setup steps. Navigate to the directory where the script is located and run:

```powershell
.\day2operation.ps1
```