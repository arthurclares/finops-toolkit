---
layout: default
title: Cost Optimization Lab
has_children: true
description: 'Learn how to optimize costs in cloud environments using Azure tools and best practices.'
permalink: /lab
---

<span class="fs-9 d-block mb-4">Cost Optimization Lab</span>
Learn how to optimize costs in cloud environments using Azure tools and best practices.
{: .fs-6 .fw-300 }

<details open markdown="1">
   <summary class="fs-2 text-uppercase">On this page</summary>


</details>

---


<img src="https://raw.githubusercontent.com/arthurclares/finops-toolkit/arclares-costoptlabs/docs/_automation/costlab/lab/pizzalogo.jpg" alt="Northwind's Pizza Logo" style="width: 100%; max-width: 1024px; height: auto;">

# Cost Optimization Lab

Imagine you're responsible for deploying and configuring the Azure infrastructure for Northwind's Pizza, a renowned pizza place known for its gourmet offerings. Northwind's Pizza is launching a new line of gourmet pizzas. You've been tasked with optimizing the cloud infrastructure to ensure it can support this expansion. The marketing team has informed you that several new pizza flavors will be introduced this year, and each will require additional online and operational support. Your challenge is to optimize the existing cloud infrastructure, allowing Northwind's Pizza to invest in new services and innovations.

In this workshop, we'll guide you through the best practices for cost optimization in cloud environments, utilizing Azure Cost Management tools. You'll learn how to:

    Identify and clean up idle resources
    Automate the detection of unused resources
    Analyze monthly costs of existing applications
    Review and optimize resource SKUs
    Implement advanced application optimizations

By the end of this workshop, you'll be equipped to efficiently manage your Azure infrastructure. This will enable Northwind's Pizza to maximize business value from its cloud investments, freeing up resources to develop new services and ensure the seamless launch of new gourmet pizza flavors. This optimization will empower Northwind's Pizza to stay ahead in a competitive market, offering the best products and experiences to its customers.

# Workshop Agenda

## Table of Contents

- [Table of Contents](#table-of-contents)
- [1. Welcome and Introduction](#1-welcome-and-introduction)
- [2. Data Ingestion](#2-data-ingestion)
- [3. Allocation](#3-allocation)
- [4. Reporting and Analytics](#4-reporting-and-analytics)
- [5. Anomaly Management](#5-anomaly-management)
- [6. Forecasting](#6-forecasting)
- [7. Unit Economics](#7-unit-economics)
- [8. Workload Optimization](#8-workload-optimization)
- [9. Licensing and SaaS](#9-licensing-and-saas)
- [10. Rate Optimization --- Requires RI purchase](#10-rate-optimization-----requires-ri-purchase)
- [11. Invoicing and Chargeback](#11-invoicing-and-chargeback)

## 1. Welcome and Introduction
- Overview of Workshop Objectives
- Importance of Cost Optimization in Cloud Environments
- Brief Introduction to Azure Cost Management Tools

## 2. Data Ingestion
Optimizing log analytics involves ensuring that only the necessary data is ingested into your Azure Log Analytics workspace. Sending more logs than needed can significantly increase costs without providing additional value. By carefully selecting which logs to send, and optimizing the retention and query settings, you can reduce costs and improve performance.

Exercise:
Optimize the logs sent to the Log Analytics workspace by configuring data collection rules and retention policies. Focus on sending only the most relevant logs and optimizing query performance.

    Objective: Minimize costs by reducing unnecessary log ingestion.
    Practical Exercise: Configure data collection rules and retention policies in Azure Log Analytics.

## 3. Allocation
Cost allocation involves distributing cloud costs to the appropriate business units, projects, or departments based on defined rules and tags. Custom cost allocation rules can help ensure that each team is accountable for its cloud usage and spending.

Exercise:
Configure custom cost allocation rules based on tags to ensure accurate cost distribution among Northwind's Pizza's different projects and departments.

    Objective: Implement custom cost allocation rules for accurate cost tracking.
    Practical Exercise: Set up tag-based cost allocation in Azure Cost Management.

## 4. Reporting and Analytics
Deploying FinOps Hubs enables centralized financial operations management, providing visibility into cloud spending, budget adherence, and cost optimization opportunities. These hubs facilitate better decision-making and accountability across the organization.

Exercise:
Deploy FinOps Hubs to centralize financial operations management and enhance visibility into cloud spending and optimization opportunities.

    Objective: Enhance financial operations management and reporting.
    Practical Exercise: Set up and configure FinOps Hubs in Azure.

## 5. Anomaly Management

Cost anomalies can indicate unexpected spending patterns that need investigation. Configuring cost anomaly detection **at scale** helps to automatically identify and alert on unusual spending, allowing for timely intervention and cost control.

Exercise:
Configure cost anomaly detection at scale to automatically identify and alert on unusual spending patterns in Northwind's Pizza's cloud environment.

    Objective: Detect and manage cost anomalies effectively.
    Practical Exercise: Set up cost anomaly detection in Azure Cost Management.

## 6. Forecasting

Accurately forecasting cloud costs helps in budgeting and financial planning. After optimizing the infrastructure, forecasting the cost of the application can provide insights into future spending and help in setting realistic budgets.

Exercise:
Forecast the cost of Northwind's Pizza's applications after implementing optimizations, using historical data and trend analysis.

    Objective: Provide accurate cost forecasts for budgeting and planning.
    Practical Exercise: Use Azure Cost Management tools to forecast future costs.

## 7. Unit Economics

Unit economics involves understanding the cost of cloud resources per unit of business output, such as the cost per pizza. This analysis helps in determining how cloud costs impact the overall profitability of the business.

Exercise:
Calculate how much the current cloud cost impacts the cost of producing each pizza, helping Northwind's Pizza understand the financial implications of their cloud spending.

    Objective: Analyze cloud cost impact on unit economics.
    Practical Exercise: Calculate the per-unit cost of cloud resources.

## 8. Workload Optimization
Workload optimization ensures that resources are used efficiently. This includes identifying and cleaning up idle resources, optimizing backup strategies, and implementing auto-shutdown policies for non-production environments.

Exercise:
Identify and clean up idle resources, optimize backup strategies, and configure auto-shutdown policies to ensure efficient resource usage.

    Objective: Optimize workloads for cost efficiency.
    Practical Exercise: Perform resource cleanup, backup optimization, and configure auto-shutdown policies.

## 9. Licensing and SaaS
Enabling Azure Hybrid Benefit (AHB) allows organizations to use their existing on-premises Windows Server and SQL Server licenses with Software Assurance to save on Azure VMs. This can lead to significant cost savings.

Exercise:
Enable Azure Hybrid Benefit for applicable Windows VMs to take advantage of existing licenses and reduce costs.

    Objective: Utilize existing licenses to save on Azure costs.
    Practical Exercise: Apply Azure Hybrid Benefit to selected VMs.

## 10. Rate Optimization --- Requires RI purchase

Purchasing Reserved Instances (RIs) and Spot Instances (SPs) can significantly reduce costs compared to pay-as-you-go rates. RIs provide a discount in exchange for a commitment to use a specific VM size for a set period, while SPs offer substantial savings for workloads that can tolerate interruptions.

Exercise:
Purchase Reserved Instances and Spot Instances to optimize rates and reduce costs for Northwind's Pizza's cloud environment.

    Objective: Achieve cost savings through rate optimization.
    Practical Exercise: Evaluate and purchase Reserved Instances and Spot Instances.

## 11. Invoicing and Chargeback

Showback involves reporting the cost of cloud resources to the relevant teams, while chargeback involves billing those teams for their usage. This encourages accountability and helps in tracking cost avoidance based on optimizations.

Exercise:
Showback the cost of Reserved Instances and calculate the cost avoidance achieved by cleaning up idle resources. Implement a chargeback mechanism to bill teams for their cloud usage.

    Objective: Promote accountability through showback and chargeback.
    Practical Exercise: Implement showback and chargeback for cloud resource costs.
