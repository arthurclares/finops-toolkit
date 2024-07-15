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

[Use bicep](#-referencing-bicep-modules){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-4 }

<details open markdown="1">
   <summary class="fs-2 text-uppercase">On this page</summary>


</details>

---

<img src="./pizzalogo.jpg" alt="Donatello's Pizza Logo" style="width: 100%; max-width: 1024px; height: auto;">

# Cost Optimization Lab

Imagine you're responsible for deploying and configuring the Azure infrastructure for Donatelo's Pizza, a renowned pizza place known for its gourmet offerings. Donatelo's Pizza is launching a new line of gourmet pizzas. You've been tasked with optimizing the cloud infrastructure to ensure it can support this expansion. The marketing team has informed you that several new pizza flavors will be introduced this year, and each will require additional online and operational support. Your challenge is to optimize the existing cloud infrastructure, allowing Donatelo's Pizza to invest in new services and innovations.

In this workshop, we'll guide you through the best practices for cost optimization in cloud environments, utilizing Azure Cost Management tools. You'll learn how to:

    Identify and clean up idle resources
    Automate the detection of unused resources
    Analyze monthly costs of existing applications
    Review and optimize resource SKUs
    Implement advanced application optimizations

By the end of this workshop, you'll be equipped to efficiently manage your Azure infrastructure. This will enable Donatelo's Pizza to maximize business value from its cloud investments, freeing up resources to develop new services and ensure the seamless launch of new gourmet pizza flavors. This optimization will empower Donatelo's Pizza to stay ahead in a competitive market, offering the best products and experiences to its customers.
# Workshop Agenda


## Table of Contents

- [Table of Contents](#table-of-contents)
- [1. Welcome and Introduction](#1-welcome-and-introduction)
- [3. Identifying Idle Resources](#3-identifying-idle-resources)
- [4. Automating](#4-automating)
- [5. Enabling Azure Hybrid Benefit for Windows VMs](#5-enabling-azure-hybrid-benefit-for-windows-vms)
- [6. Cleaning Up Idle Resources](#6-cleaning-up-idle-resources)
- [7. Auto shutdown of non-production VMs](#7-auto-shutdown-of-non-production-vms)
- [7. Reviewing and Optimizing Resource SKUs](#7-reviewing-and-optimizing-resource-skus)
- [8. Backup optimization](#8-backup-optimization)
- [9. Q\&A and Wrap-Up](#9-qa-and-wrap-up)
- [7. Log Analytics Cost Analysis](#7-log-analytics-cost-analysis)


## 1. Welcome and Introduction
- Overview of Workshop Objectives
- Importance of Cost Optimization in Cloud Environments
- Brief Introduction to Azure Cost Management Tools

[ ] Concluded



2. Analyzing Monthly Costs of Existing Applications

Azure tags provide a powerful way to organize and manage resources. By tagging resources with relevant information, such as the environment, application name, owner, and project, we can filter cost management data to analyze the expenses related to specific parts of our infrastructure. This exercise aims to demonstrate how to use these tags to calculate and analyze the monthly cost of a specified application.

Donatello's pizza has two applications: the PizzaOrderPortal, which hosts Donatello's main website, and DoughDynasty, which manages the recipe database and ingredient supply chain. The PizzaOrderPortal is a production resource managed by the PizzaOpsTeam, ensuring seamless customer orders and deliveries. DoughDynasty, on the other hand, is still in development, managed by the DoughDevelopers team, focusing on perfecting the art of pizza dough and ingredient optimization.

**Exercise:**
In the cost management portal, identify the monthly cost of both applications, PizzaOrderPortal and DoughDynasty, and also calculate the total cost of the GourmetRollout project. By breaking down these costs, you will gain insights into which areas consume the most resources and can make informed decisions to optimize expenditure.

Note: If there isn't enough data to see the monthly cost, take the daily cost and multiply it by 30 to estimate the monthly expense.



## 3. Identifying Idle Resources

As Donatello's pizza business flourished, its cloud infrastructure expanded faster than dough in the summer sun to meet growing customer demands and ensure seamless operations.However, amongst this rapid growth, the PizzaOpsTeam overlooked regular maintenance and cleanup of the environment. This oversight allowed unused resources to accumulate, leading to unnecessary costs and operational inefficiencies.

Picture a storeroom filled with outdated ingredients and unused kitchen gadgets—items that were once vital but now gather dust. Similarly, Donatello's cloud environment became cluttered with idle virtual machines, unattached disks, and forgotten public IP addresses. This oversight started to weigh on the company's operational costs, diverting funds away from potential new features and innovations.

Note: Do note delete these resources now as they will be used in the next exercise.

**Exercise:**
Azure Advisor offers a Cost Optimization workbook specifically designed to identify unused resources. Your task is to use this workbook to review Donatello's cloud environment and identify production resources that are idle. 

- **Objective**: Utilizing the Azure Cost Optimization Workbook
- **Practical Exercise**: Identify idle resources such as Disks, Application Gateways, Public IP Addresses, and Private Endpoints
- **Tools**: Azure Advisor Cost Optimization Workbook

[ ] Concluded

## 4. Automating 

!!! To be added Waste reduction introduction !!!! 

Imagine the bustling kitchen of Donatello's, where every ingredient and tool serves a purpose in crafting the perfect pizza. Just like in a busy kitchen, efficiency in Donatello's cloud environment is crucial for maintaining operational excellence. Without automated oversight, resources such as idle virtual machines and unused storage could accumulate unnoticed, draining valuable resources and impacting operational budgets.

To address this challenge, the PizzaOpsTeam decided to deploy an automated solution using Azure Logic Apps. This solution integrates with Azure Advisor's Cost Optimization recommendations to periodically detect and alert about idle resources.

**Exercise:**
Your task is to deploy and configure an Azure Logic App that integrates with the Cost Optimization workbook in Azure Advisor. This app will automate the detection of idle resources in Donatello's cloud environment, providing timely alerts to the PizzaOpsTeam. Set up the logic app to run weekly to detect idle resources effectively.

Note: To validate that the automation is functioning correctly, manually trigger the logic app once after deployment. This step ensures that alerts are generated and received by the PizzaOpsTeam as expected.


### Autome Idle Resource Detection
- **Objective**: Deployment of a Logic App to Receive Alerts for New Idle Resources
- **Practical Exercise**: Create and test the alerting mechanism



[ ] Concluded

## 5. Enabling Azure Hybrid Benefit for Windows VMs

Imagine having a limited supply of premium ingredients in the kitchen. You would use these ingredients where they make the most impact on the menu, enhancing the dishes that are most popular or have the highest profit margins. Similarly, in this exercise, you will need to identify and prioritize the VMs that will benefit most from the Azure Hybrid Benefit.

One powerful cost-saving feature offered by Azure is the Azure Hybrid Benefit, which allows organizations to use their existing on-premises Windows Server licenses with Software Assurance to save up to 85% on Azure virtual machines.

However, Donatello's doesn't have enough licenses to enable Azure Hybrid Benefit across all VMs. This means the PizzaOpsTeam must strategically prioritize which VMs to apply this benefit to, ensuring the biggest return on investment.

**Exercise**
Your task is to apply the Azure Hybrid benefit for Windows VMs. However, keep in mind it needs to be prioritize to the VM(s) that will have hthe buggest return of invemestment. 
- **Objective**: Prioritizing and Enabling Hybrid Benefit
- **Practical Exercise**: Apply Azure Hybrid Benefit to selected VMs

[ ] Concluded


## 6. Cleaning Up Idle Resources


In previous exercises you have use the Advisor workbook to identify some unused resrouces. These unused resources not only add unnecessary costs but also complicate the management of the environment.
Exercise:

    Objective: Implement best practices for resource cleanup to optimize Donatello's cloud environment.
    Hands-On Activity:
        Use the Azure Advisor's Cost Optimization workbook to review the list of idle resources you identified in previous exercises.
        Safely delete or deallocate these idle resources to reduce costs and streamline the environment.

Tip: Some queries in the Azure Advisor workbook come with built-in functions to delete idle disks directly. Utilize these functions where applicable to streamline the cleanup process and ensure no unused resources are overlooked.

Note: Ensure that you double-check the resources before deleting them to avoid accidentally removing any critical resources.

## 7. Auto shutdown of non-production VMs 

Just as you wouldn't leave the ovens running overnight or the lights on in an empty pizzeria, it's equally important to manage cloud resources efficiently. Non-production virtual machines (VMs), like the experimental DoughDynasty environment, can consume valuable resources when left running outside of business hours.

Donatello's development team, the DoughDevelopers, often works on creating new recipes and refining the pizza ordering system in a non-production environment. These VMs, crucial for testing and development, do not need to be running 24/7. By implementing an auto-shutdown policy, Donatello's can save on operational costs and ensure resources are available when needed most.

Exercise:

Objective: Configure an auto-shutdown policy to automatically power off non-production VMs outside of business hours, optimizing resource usage and reducing costs.

Steps:

Review Non-Production VMs:
    Identify all non-production VMs in Donatello's cloud environment, particularly those used by the DoughDevelopers team for testing and development.

Configure Auto-Shutdown Policy:
    Set up an auto-shutdown policy for these non-production VMs to power them off automatically outside of business hours (e.g., from 7 PM to 7 AM, and during weekends).


[ ] Concluded



[ ] Concluded

## 7. Reviewing and Optimizing Resource SKUs

- **Objective**: Finding Cheaper and Newer SKUs for Virtual Machines and Web Applications

Just as Donatello's is always searching for better deals on ingredients to keep their pizzas affordable, optimizing cloud costs involves finding more efficient and cost-effective resources. Cloud services are constantly evolving, and newer, cheaper SKUs often become available, offering opportunities to reduce costs without sacrificing performance.

In Donatello's cloud environment, several virtual machines and web applications are essential for their operations. Some of these resources, like one particularly large virtual machine, have been using the same SKU for a while. Similarly, the web application plan currently in use might not be the most cost-effective option available today.

Note: For the purposes of this exercise, assume that the applications can run on different SKUs without issues.


<details>
  <summary>Click to view a hint about VM processors</summary>
  <div class="code-block">
    <pre><code> Virtual Machines: Some of the larger VMs might be using older SKUs. Evaluating different processor architectures, such as AMD or ARM, could lead to significant cost savings.
    Web Applications: The web application plan currently in use may not be the most optimal. Explore newer plans for potential savings.
    Learn more about other CPU architectures: https://learn.microsoft.com/en-us/azure/virtual-machines/dpsv5-dpdsv5-series
    Full list of Processors:     // ARM Processors
    vmSize has "Epsv5" or vmSize has "Epdsv5" or vmSize has "Dpsv5" or vmSize has "Dpdsv", "ARM",
    // AMD VM Types
    vmSize has "Standard_D2a" or vmSize has "Standard_D4a" or vmSize has "Standard_D8a" or vmSize has "Standard_D16a" or vmSize has "Standard_D32a" or vmSize has "Standard_D48a" or vmSize has "Standard_D64a" or vmSize has "Standard_D96a" or vmSize has "Standard_D2as" or vmSize has "Standard_D4as" or vmSize has "Standard_D8as" or vmSize has "Standard_D16as" or vmSize has "Standard_D32as" or vmSize has "Standard_D48as" or vmSize has "Standard_D64as" or vmSize has "Standard_D96as", "AMD",
    "Intel"
</code></pre>
  </div>
</details>

<details>
  <summary>Click to view a hint for the Web Application</summary>
  <div class="code-block">
    <pre><code> Comparing Web Application SKUs: v2 vs. v3: https://azure.microsoft.com/en-us/pricing/details/app-service/windows-previous/
</code></pre>
  </div>
</details>

## 8. Backup optimization

Just as Donatello's pizza business wouldn't store every ingredient the same way—some items require refrigeration while others can be kept on the shelf—not every virtual machine in your cloud environment needs the same backup policy. Efficiently managing backup policies can lead to significant cost savings and optimized resource usage.

As Donatello's cloud infrastructure grew, a uniform backup policy was applied across all VMs. However, it's clear that non-production VMs don't require the same level of backup frequency and retention as critical production systems.

***Exercise:**
Your task is to review and optimize the backup policies for Donatello's VMs. Evaluate which VMs can have less frequent backups or shorter retention periods, focusing on the non-production ones to reduce unnecessary costs.

### Backup Strategy for Production and Non-Production Resources
- **Objective**: Designing an Efficient Backup Strategy
- **Practical Exercise**: Implement a backup plan for production and non-production resources

[ ] Concluded



## 9. Q&A and Wrap-Up
- Open Floor for Questions and Discussions
- Summary of Key Takeaways
- Next Steps and Additional Resources

[ ] Concluded


// other ideas:

## 7. Log Analytics Cost Analysis
- **Objective**: Understanding Log Analytics Costs Per VM
- **Hands-On Activity**: Identify high-cost VMs and propose cost-saving measures

[ ] Concluded

### Azure Storage Account Optimization
- **Objective**: Performance Tuning and Data Lifecycle Management and Optimizing Storage Tiers
- **Practical Exercise**: Optimize a storage account's performance and cost

[ ] Concluded


