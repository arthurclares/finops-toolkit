---
layout: default
title: Logic App
description: 'Deploy the waste alert logic app.'
parent: Cost Optimization Lab
nav_order: 2
permalink: /lab/logicapp
---


# How to Deploy the logic app

## Prerequisites

Description of the prerequisites for the deployment

1. You must have permission to create the deployed resources mentioned above.

<br>

## 📗 How to use this template

1. Download the bicep file from [this]() storage account and copy it to Azure Cloud Shell
2. Unzip the file and run the following command to install the bicep template
   1. ```powershell
        New-AzResourceGroupDeployment -TemplateFile main.bicep -ResourceGroupName xxxx -appName NewLogicApp
    ```
3. Authorize API connection
     > After the deployment has been completed, the API connection will have an error. This is expected and will be fixed after authorizing the connection.  
   - Click on the **API connection** resource, then click on **Edit API connection** in the General tab to authorize the connection.
   - Click on **Authorize**  
      > Be aware that the account authorizing the connection will be used to by the Logic App to send the Alerts.
   - **Save** your change after the authorization is successful
   - Go back to the **Overview** blade and verify that the **Status: Connected**
4. Create a system-assigned identity to allow the Logic App to "read" the resources in the subscription.
   - Navigate to the **WasteReductionApp**
   - Click on **Identity** under the Settings tab and toggle the Status to **On**
   - **Save** your changes and select **yes** to enable the system assigned managed identity
   - Go to **Azure role assignments** within the *system assigned* blade
   - Click on **Add role assignment** and assign the following permissions then click on **Save**
5. Configure the Logic App
   - Navigate to the **WasteReductionApp** and select **Logic App Designer** under the Development Tools tab
   - Configure the reoccurrence
   - Configure the alert recipient
   - Set subscriptions in scope
      > If the customer has multiple subscriptions, you can add them to the array, by using the following format: ["subscription1", "subscription2", "subscription3"]
   - Click on **Run** to test the Logic App

## 🖥️ About the Waste Reduction Logic App

Waste Reduction Logic App is part of the  [FinOps toolkit](https://aka.ms/finops/toolkit), an open-source collection of FinOps solutions that help you manage and optimize your cloud costs.

To contribute to the FinOps toolkit, [join us on GitHub](https://aka.ms/ftk).
