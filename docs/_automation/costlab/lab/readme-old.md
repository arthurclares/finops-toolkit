
## 2. Analyzing Monthly Costs of Existing Applications

Azure tags provide a powerful way to organize and manage resources. By tagging resources with relevant information, such as the environment, application name, owner, and project, we can filter cost management data to analyze the expenses related to specific parts of our infrastructure. This exercise aims to demonstrate how to use these tags to calculate and analyze the monthly cost of a specified application.

Northwind's pizza has two applications: the PizzaOrderPortal, which hosts Northwind's main website, and DoughDynasty, which manages the recipe database and ingredient supply chain. The PizzaOrderPortal is a production resource managed by the PizzaOpsTeam, ensuring seamless customer orders and deliveries. DoughDynasty, on the other hand, is still in development, managed by the DoughDevelopers team, focusing on perfecting the art of pizza dough and ingredient optimization.

**Exercise:**
In the cost management portal, identify the monthly cost of both applications, PizzaOrderPortal and DoughDynasty, and also calculate the total cost of the GourmetRollout project. By breaking down these costs, you will gain insights into which areas consume the most resources and can make informed decisions to optimize expenditure.

Note: If there isn't enough data to see the monthly cost, take the daily cost and multiply it by 30 to estimate the monthly expense.

## 3. Identifying Idle Resources

As Northwind's pizza business flourished, its cloud infrastructure expanded faster than dough in the summer sun to meet growing customer demands and ensure seamless operations.However, amongst this rapid growth, the PizzaOpsTeam overlooked regular maintenance and cleanup of the environment. This oversight allowed unused resources to accumulate, leading to unnecessary costs and operational inefficiencies.

Picture a storeroom filled with outdated ingredients and unused kitchen gadgets—items that were once vital but now gather dust. Similarly, Northwind's cloud environment became cluttered with idle virtual machines, unattached disks, and forgotten public IP addresses. This oversight started to weigh on the company's operational costs, diverting funds away from potential new features and innovations.

Note: Do note delete these resources now as they will be used in the next exercise.

**Exercise:**
Azure Advisor offers a Cost Optimization workbook specifically designed to identify unused resources. Your task is to use this workbook to review Northwind's cloud environment and identify production resources that are idle. 

- **Objective**: Utilizing the Azure Cost Optimization Workbook
- **Practical Exercise**: Identify idle resources such as Disks, Application Gateways, Public IP Addresses, and Private Endpoints
- **Tools**: Azure Advisor Cost Optimization Workbook

## 4. Automating 

Imagine the bustling kitchen of Northwind's, where every ingredient and tool serves a purpose in crafting the perfect pizza. Just like in a busy kitchen, efficiency in Northwind's cloud environment is crucial for maintaining operational excellence. Without automated oversight, resources such as idle virtual machines and unused storage could accumulate unnoticed, draining valuable resources and impacting operational budgets.

To address this challenge, the PizzaOpsTeam decided to deploy an automated solution using Azure Logic Apps. This solution integrates with Azure Advisor's Cost Optimization recommendations to periodically detect and alert about idle resources.

**Exercise:**
Your task is to deploy and configure an Azure Logic App that integrates with the Cost Optimization workbook in Azure Advisor. This app will automate the detection of idle resources in Northwind's cloud environment, providing timely alerts to the PizzaOpsTeam. Set up the logic app to run weekly to detect idle resources effectively.

Note: To validate that the automation is functioning correctly, manually trigger the logic app once after deployment. This step ensures that alerts are generated and received by the PizzaOpsTeam as expected.

<!-- TODO: Review the requirements to deploy this logic as it seems to be impossible to deploy at the resource group. Only to the subscription -->

### Automate Idle Resource Detection
- **Objective**: Deployment of a Logic App to Receive Alerts for New Idle Resources
- **Practical Exercise**: Create and test the alerting mechanism

## 5. Enabling Azure Hybrid Benefit for Windows VMs

Imagine having a limited supply of premium ingredients in the kitchen. You would use these ingredients where they make the most impact on the menu, enhancing the dishes that are most popular or have the highest profit margins. Similarly, in this exercise, you will need to identify and prioritize the VMs that will benefit most from the Azure Hybrid Benefit.

One powerful cost-saving feature offered by Azure is the Azure Hybrid Benefit, which allows organizations to use their existing on-premises Windows Server licenses with Software Assurance to save up to 85% on Azure virtual machines.

However, Northwind's doesn't have enough licenses to enable Azure Hybrid Benefit across all VMs. This means the PizzaOpsTeam must strategically prioritize which VMs to apply this benefit to, ensuring the biggest return on investment.

**Exercise**
Your task is to apply the Azure Hybrid benefit for Windows VMs. However, keep in mind it needs to be prioritized to the VM(s) that will have the biggest return on investment. 
- **Objective**: Prioritizing and Enabling Hybrid Benefit
- **Practical Exercise**: Apply Azure Hybrid Benefit to selected VMs

<details>
  <summary>Click to view a hint about Azure Hybrid Benefit</summary>
  <div class="code-block">
    <pre><code> You can use the [Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/) to simulate and prioritize the Hybrid benefit to different VM sizes.
    Also, the [Azure Hybrid Benefit Calculator](https://azure.microsoft.com/en-gb/pricing/hybrid-benefit/#overview) can be used to know how many cores you are entitled to use on the cloud.
</code></pre>
  </div>
</details>

## 6. Auto shutdown of non-production VMs 

Just as you wouldn't leave the ovens running overnight or the lights on in an empty pizzeria, it's equally important to manage cloud resources efficiently. Non-production virtual machines (VMs), like the experimental DoughDynasty environment, can consume valuable resources when left running outside of business hours.

Northwind's development team, the DoughDevelopers, often works on creating new recipes and refining the pizza ordering system in a non-production environment. These VMs, crucial for testing and development, do not need to be running 24/7. By implementing an auto-shutdown policy, Northwind's can save on operational costs and ensure resources are available when needed most.

**Exercise:**
Your task is to configure an auto-shutdown policy for Northwind's non-production VMs, like DoughDynasty, during non-business hours. This policy ensures that development resources are available during working hours and powered down during off-hours, optimizing cost efficiency.

<!-- TODO: Review the requirements to deploy this logic as it seems to be impossible to deploy at the resource group. Only to the subscription -->

### Auto shutdown
- **Objective**: Implementing Auto-Shutdown Policies for Non-Production VMs
- **Practical Exercise**: Configure and test auto-shutdown settings

<details>
  <summary>Click to view a hint about auto-shutdown</summary>
  <div class="code-block">
    <pre><code> Here are the main steps to auto-shutdown the VM
- Open the virtual machine in the Azure portal.
- In the left menu, under Operations, select "Auto-shutdown."
- On the Auto-shutdown page, configure the shutdown schedule.
- Specify the time and time zone for the shutdown.
- Optionally, you can send a notification before the VM shuts down.
- Save your settings.
</code></pre>
  </div>
</details>

## 7. Reviewing and Optimizing Resource SKUs

Imagine that Northwind's offers a range of pizzas, each with different sizes and ingredients to cater to varying customer preferences. Just as selecting the right pizza size and ingredients is crucial for customer satisfaction and cost management, choosing the appropriate Azure SKU (Stock Keeping Unit) for resources is vital for optimal performance and cost efficiency.

In this exercise, you will review the current SKUs used for virtual machines, storage accounts, and other resources in Northwind's cloud environment. The goal is to identify opportunities to optimize costs by selecting more suitable SKUs based on usage patterns and performance requirements.

**Exercise:**
Your task is to review and optimize the SKUs for various resources in Northwind's cloud environment. By analyzing resource utilization and performance metrics, you'll recommend and implement changes to ensure the most cost-effective and efficient use of Azure resources.

### SKU Optimization
- **Objective**: Reviewing and Optimizing Resource SKUs
- **Practical Exercise**: Analyze and update SKUs for selected resources

<details>
  <summary>Click to view a hint about SKU optimization</summary>
  <div class="code-block">
    <pre><code> You can use Azure Advisor and Cost Management + Billing to review SKU recommendations.
</code></pre>
  </div>
</details>

## 8. Backup optimization

In a bustling pizza kitchen, having a robust backup plan for ingredients and recipes is crucial to ensure continuity during unexpected disruptions. Similarly, in Northwind's cloud environment, implementing an effective backup strategy is essential to safeguard critical data and maintain operational resilience.

While backups are vital for disaster recovery, it's important to balance the need for data protection with cost efficiency. Over-allocating resources for backup storage or retaining unnecessary backups can lead to increased costs. In this exercise, you'll optimize the backup strategy for Northwind's cloud environment, ensuring data protection while minimizing expenses.

**Exercise:**
Your task is to review and optimize the backup strategy for Northwind's cloud environment. By evaluating backup policies, storage tiers, and retention periods, you'll make recommendations to balance data protection and cost efficiency.

<!-- TODO: Update the RSV to not have "purge protection" enabled -->

### Backup Strategy Optimization
- **Objective**: Reviewing and Optimizing Backup Policies
- **Practical Exercise**: Analyze and update backup policies for selected resources

<details>
  <summary>Click to view a hint about backup optimization</summary>
  <div class="code-block">
    <pre><code> You can use Azure Backup and Recovery Services to review and optimize backup policies.
</code></pre>
  </div>
</details>

## 9. Azure Copilot for Cost Analysis

Northwind's Pizza has decided to leverage Azure Copilot to get more precise insights into the costs of their applications based on tags. This powerful tool will help them understand where their money is going and identify opportunities to optimize their spending.

**Exercise:**
Use Azure Copilot to identify the cost of an application based on tags. This will allow you to get a detailed breakdown of expenses and find areas where you can reduce costs.

### Cost Analysis with Azure Copilot
- **Objective**: Using Azure Copilot to Analyze Costs Based on Tags
- **Practical Exercise**: Identify the cost of an application based on tags

<details>
  <summary>Click to view a hint about Azure Copilot</summary>
  <div class="code-block">
    <pre><code> Azure Copilot integrates with Azure Cost Management and Billing to provide detailed insights.
</code></pre>
  </div>
</details>

## 10. Cleaning Up Idle Resources

To ensure Northwind's cloud environment remains optimized, it's crucial to regularly clean up idle resources. These resources, if left unchecked, can accumulate and lead to unnecessary costs. 

**Exercise:**
Now that we've identified the idle resources, the next step is to clean them up. This exercise focuses on removing or repurposing these resources to ensure optimal cost efficiency.

### Resource Cleanup
- **Objective**: Cleaning Up Idle Resources
- **Practical Exercise**: Remove or repurpose identified idle resources

<details>
  <summary>Click to view a hint about cleaning up idle resources</summary>
  <div class="code-block">
    <pre><code> Use Azure Advisor and Cost Management tools to identify and clean up idle resources.
</code></pre>
  </div>
</details>

## 11. Q&A and Wrap-Up
- Recap of Key Learnings
- Q&A Session
- Next Steps and Additional Resources

---
<!---- 
# Other Ideas for Cost Optimization

In addition to the exercises covered in this workshop, there are several other strategies and best practices for cost optimization in Azure environments. Here are some additional ideas to consider:

1. **Azure Reservations**: Take advantage of Azure Reserved VM Instances to save up to 72% on pay-as-you-go prices.
2. **Right-sizing Resources**: Continuously monitor and adjust the size of your resources based on actual usage patterns to avoid over-provisioning.
3. **Spot VMs**: Use Azure Spot VMs for workloads that can tolerate interruptions to significantly reduce costs.
4. **Optimize Azure AI**: Implement strategies to optimize the use of Azure AI services, reducing costs while maintaining performance.

Remember, the key to effective cost optimization is continuous monitoring and adaptation to changing usage patterns and business needs.


Data ingestion:
OPtimize logs in LA workspace. Send more logs than needed to the workspace and optimitize it

Allocation:
Configure custom cost allocation rule based on tags

Reporting and analytics
Deploy FinOps Hubs

Anomaly Management
COnfigure cost anomly at scale 

Forecasting
Forecast the cost of the applicaiton after optimization

Unit Economics
Calculate how much the current cloud cost impacts on the pizza cost


Workload optimization
Idle resources, backup optimization, 

Licensing and SaaS 
Enable AHB

Rate Optimization
Purchase RI and SP

Invoicing and CHargeback
Showback RI costs and calculate cost avoidance based on the cleaned up resources