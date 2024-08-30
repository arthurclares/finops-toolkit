---
layout: default
parent: Best practices
permalink: /bestpractices/databases
nav_order: 2
title: Databases
author: arclares
ms.date: 08/16/2024
ms.service: finops
description: 'Discover essential FinOps best practices to optimize cost efficiency and governance for your Azure resources.'

---

# 📇 Table of Contents

1. [Cosmos DB](#cosmos-db)
2. [SQL DB](#sql-db)
2. [SQL Elastic Pool](#sql-elastic-pool)

<br>

<br>

## Cosmos DB

### Query: Confirm Cosmos DB request units

This Azure Resource Graph (ARG) query analyzes Cosmos DB accounts within your Azure environment to ensure they are configured with the appropriate Request Units (RUs).

#### Description

This query identifies Cosmos DB accounts with recommendations for optimizing their Request Units (RUs) based on usage patterns. It surfaces recommendations from Azure Advisor to adjust RUs for cost efficiency.

#### Category

Optimization

#### Benefits

- **Cost optimization:** Identifies opportunities to optimize the cost of Cosmos DB by adjusting the provisioned RUs according to the recommendations, leading to potential savings.
- **Performance management:** Ensures that Cosmos DB accounts are provisioned with the correct RUs, maintaining performance while avoiding over-provisioning.

#### Query

#### Query

<details>
  <summary>Click to view the code</summary>
  ```kql
  advisorresources
  | where type =~ 'microsoft.advisor/recommendations'
  | where properties.impactedField == 'microsoft.documentdb/databaseaccounts'
      and properties.recommendationTypeId == '8b993855-1b3f-4392-8860-6ed4f5afd8a7'
  | order by id asc
  | project 
      id, subscriptionId, resourceGroup,
      CosmosDBAccountName = properties.extendedProperties.GlobalDatabaseAccountName,
      DatabaseName = properties.extendedProperties.DatabaseName,
      CollectionName = properties.extendedProperties.CollectionName,
      EstimatedAnnualSavings = bin(toreal(properties.extendedProperties.annualSavingsAmount), 1),
      SavingsCurrency = properties.extendedProperties.savingsCurrency
  ```
</details>

### Query: Cosmos DB collections that would benefit from switching to another throughput mode

This Azure Resource Graph (ARG) query identifies Cosmos DB collections within your Azure environment that would benefit from switching their throughput mode, based on Azure Advisor recommendations.

#### Description

This query surfaces Cosmos DB collections that have recommendations to switch their throughput mode (e.g., from manual to autoscale or vice versa) to optimize performance and cost. It leverages Azure Advisor recommendations to highlight potential improvements.

#### Category

Optimization

#### Benefits

- **Cost optimization:** Identifies Cosmos DB collections that can save costs by switching to a more appropriate throughput mode based on usage patterns and recommendations.
- **Performance management:** Ensures that Cosmos DB collections are using the optimal throughput mode, enhancing performance and avoiding over-provisioning or under-provisioning.

#### Query

<details>
  <summary>Click to view the code</summary>
  ```kql
  advisorresources
  | where type =~ 'microsoft.advisor/recommendations'
  | where properties.impactedField == 'microsoft.documentdb/databaseaccounts'
      and properties.recommendationTypeId in (' cdf51428-a41b-4735-ba23-39f3b7cde20c', ' 6aa7a0df-192f-4dfa-bd61-f43db4843e7d')
  | order by id asc
  | project 
      id, subscriptionId, resourceGroup,
      CosmosDBAccountName = properties.extendedProperties.GlobalDatabaseAccountName,
      DatabaseName = properties.extendedProperties.DatabaseName,
      CollectionName = properties.extendedProperties.CollectionName,
      EstimatedAnnualSavings = bin(toreal(properties.extendedProperties.annualSavingsAmount), 1),
      SavingsCurrency = properties.extendedProperties.savingsCurrency
  ```
</details>

### Query: Cosmos DB backup mode details

This Azure Resource Graph (ARG) query analyzes Cosmos DB accounts within your Azure environment to ensure they are using an optimal backup mode.

#### Description

This query identifies Cosmos DB accounts that use the 'Periodic' backup policy and do not have multiple write locations enabled. It highlights accounts with a high number of backup copies, indicating a potential for cost optimization and resource management.

#### Category

Optimization

#### Benefits

- **Cost optimization:** Identifies opportunities to optimize the cost of Cosmos DB by adjusting the backup retention and interval settings, ensuring cost-effective backup strategies.
- **Resource management:** Ensures that Cosmos DB accounts have an optimal backup configuration, balancing backup frequency and retention to meet data protection requirements without unnecessary cost.

#### Query

<details>
  <summary>Click to view the code</summary>
  <div class="code-block">
    <pre><code> resources
| where type == "microsoft.documentdb/databaseaccounts"
| where resourceGroup in ({ResourceGroup})
| where properties.backupPolicy.type == 'Periodic' and tobool(properties.enableMultipleWriteLocations) == false
| extend BackupCopies=toreal(properties.backupPolicy.periodicModeProperties.backupRetentionIntervalInHours) / (toreal(properties.backupPolicy.periodicModeProperties.backupIntervalInMinutes) / real(60))
| where BackupCopies >= 10 or (BackupCopies > 2 and toint(properties.backupPolicy.periodicModeProperties.backupRetentionIntervalInHours) <= 168)
| order by id asc
| project id, CosmosDBAccountName=name, resourceGroup, subscriptionId, BackupCopies
</code></pre>
  </div>
</details>

## SQL DB

### Query: SQL DB Idle

This Azure Resource Graph (ARG) query identifies potentially idle SQL databases within your Azure environment.

#### Description

This query identifies SQL databases with names indicating they might be old, in development, or used for testing purposes. By identifying these databases, you can review and determine if they are still needed, helping to optimize costs and resource usage.

#### Category

Optimization

#### Potential Benefits

- **Cost Optimization:** Identifies potentially idle SQL databases that can be decommissioned or scaled down, reducing costs associated with maintaining unnecessary databases.
- **Resource Management:** Helps in managing database resources more efficiently by identifying and reviewing databases that may no longer be in active use.


<details>
  <summary>Click to view the code</summary>
  <div class="code-block">
    <pre><code> resources 
| where type == "microsoft.sql/servers/databases"
| where name contains "old" or name contains "Dev"or  name contains "test"
| where resourceGroup in ({ResourceGroup})
| extend SQLDBName=name, Type=sku.name, Tier=sku.tier, Location=location
| order by id asc
| project id, SQLDBName, Type, Tier, resourceGroup, Location, subscriptionId
</code></pre>
  </div>
</details>



## SQL Elastic Pool

### Query: Unused Elastic Pools Analysis

This Azure Resource Graph (ARG) query identifies potentially idle SQL databases within your Azure environment.

#### Description

This query identifies unused Elastic Pools in your Azure SQL environment by analyzing the number of databases associated with each Elastic Pool. It highlights Elastic Pools that do not contain any databases, enabling cost-saving opportunities by deallocating unnecessary resources.

#### Category

Optimization

#### Potential Benefits

- **Cost Optimization:** Identifies Elastic Pools with no databases, which could be candidates for deletion to reduce unnecessary costs.
- **Resource Optimization:** Helps in managing Azure SQL resources by providing insights into unused Elastic Pools, allowing for better allocation of resources.

<details>
  <summary>Click to view the code</summary>
  <div class="code-block">
    <pre><code> resources
| where type == "microsoft.sql/servers/elasticpools"
| extend elasticPoolId = tolower(tostring(id)), elasticPoolName = name, elasticPoolRG = resourceGroup,skuName=tostring(sku.name),skuTier=tostring(sku.tier),skuCapacity=tostring(sku.capacity)
| join kind=leftouter (
    resources
    | where type == "microsoft.sql/servers/databases"
    | extend elasticPoolId = tolower(tostring(properties.elasticPoolId))
) on elasticPoolId
| summarize databaseCount = countif(isnotempty(elasticPoolId1)) by elasticPoolId, elasticPoolName,serverResourceGroup=resourceGroup,name,skuName,skuTier,skuCapacity,elasticPoolRG
| where databaseCount == 0
| project elasticPoolId, elasticPoolName, databaseCount, elasticPoolRG ,skuName,skuTier ,skuCapacity
</code></pre>
  </div>
</details>