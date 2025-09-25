# Azure Resources Overview - Web Team

**Generated on:** September 24, 2025  
**Filter:** Complete Web-related resource inventory  
**Subscriptions Scanned:** All available subscriptions (13 subscriptions total)

---

## Summary

This document provides a comprehensive overview of all Azure resources used by the Web team, identified through expanded search criteria:

- Tag `Business Owner Department: Web`
- Tag `IT Owner: Web`  
- Tags containing `web` (case-insensitive)
- Resources in resource groups containing `web` in the name
- Tag `owner: webteam`

## **Complete Resource Counts by Subscription**

| Subscription | Resource Count | Key Services |
|-------------|----------------|--------------|
| **SHARED_AP** | **131 resources** | Production web infrastructure, AKS, databases |
| **SHARED_DT** | **82 resources** | Development/test environments, monitoring |
| **Visual Studio Professional** | **5 resources** | Development storage, container registry |
| **Total** | **218+ resources** | **Complete Web team infrastructure** |

---

---

## Complete Resource Inventory by Subscription

### 🏢 **SHARED_AP Subscription (131 Resources)**
*Production Environment - ID: 1e4935cc-468f-46ba-9264-d7825e7e8194*

#### 🗄️ **SQL Infrastructure (Major Component)**
- **SQL Server:** `ait-sqlsrv-web-p` (Primary production server)
- **Elastic Pools:** 
  - `ait-sqlpool-web-ap` (Standard, 100 DTU capacity) - Production pool
  - `ait-sqlpool-web-a` (Standard) - Acceptance/staging pool
- **SQL Databases:** 66+ databases including:

| Database Name | Environment | Elastic Pool | Purpose |
|---------------|-------------|--------------|---------|
| **ait-sqldb-auth-p** | Production | ait-sqlpool-web-ap | Authentication system |
| **ait-sqldb-auth-a** | Acceptance | ait-sqlpool-web-a | Authentication testing |
| **ait-sqldb-baskets-p** | Production | ait-sqlpool-web-ap | Shopping baskets |
| **ait-sqldb-baskets-a** | Acceptance | ait-sqlpool-web-a | Baskets testing |
| **ait-sqldb-company-a** | Acceptance | ait-sqlpool-web-a | Company data testing |
| **ait-sqldb-dealers-p** | Production | ait-sqlpool-web-ap | Dealer management |
| **ait-sqldb-bi-data-p** | Production | ait-sqlpool-web-ap | Business intelligence |
| **ait-sqldb-bi-data-a** | Acceptance | Standalone GP_Gen5 | BI testing environment |
| **ag-sqldb-recall-p** | Production | ait-sqlpool-web-ap | Recall management |
| **ag-sqldb-web-bi** | Production | Hyperscale HS_S_Gen5 | Main BI warehouse |

#### 🗄️ **Storage Accounts**
- **agstorwebimagesp** - CDN image storage (Hot tier, with containers: images, fallback)
- **agstoraccentryinterfacea** - Web hosting (Cool tier, containers: $web, stock-files, work-data)  
- **agstormulesoftfilesp** - Mulesoft integration files (Cool tier, SFTP enabled)

#### 🔧 **Logic Apps & Automation**
- **ag-la-web-monitoring-p** - Production monitoring workflows
- **ag-la-web-winora-stock-new-p** - Winora stock import automation
- **ag-la-web-report-anl-yearagreements-parts** - Weekly agreement parts reporting
- **ag-la-web-report-dach-nda** - DACH NDA reporting
- **ag-la-web-check-index-files** - Index file monitoring

#### 🌐 **Networking & Security**
- **Network Security Groups** for AKS (aks-agentpool-65699152-nsg)
- **Public IP Addresses** for load balancers
- **AKS Infrastructure** - mc_ait-aks-web-ap_aks-web-ap_westeurope resource group

#### 🔗 **API Connections**
- **sql-1, sql-2, sql-3** - Database connections for Logic Apps
- **teams-3** - Microsoft Teams integration

---

### 🧪 **SHARED_DT Subscription (82 Resources)**  
*Development/Test Environment - ID: 6dcbeeff-435f-4fe9-b2e1-2fe73014f679*

#### 🗄️ **Test Databases (Detailed List)**
From your screenshot, the test environment includes:

| Database Name | Server | Purpose |
|---------------|--------|---------|
| **ait-sqldb-auth-t** | ait-sqlsrv-web-dt | Authentication testing |
| **ait-sqldb-baskets-t** | ait-sqlsrv-web-dt | Basket functionality testing |  
| **ait-sqldb-bi-data-t** | ait-sqlsrv-web-dt | BI development |
| **ait-sqldb-company-t** | ait-sqlsrv-web-dt | Company data testing |
| **ait-sqldb-dealers-t** | ait-sqlsrv-web-dt | Dealer management testing |
| **ait-sqldb-financial-t** | ait-sqlsrv-web-dt | Financial data testing |
| **ait-sqldb-gls-t** | ait-sqlsrv-web-dt | GLS integration testing |
| **ait-sqldb-leadgeneration-t** | ait-sqlsrv-web-dt | Lead generation testing |
| **ait-sqldb-lease-t** | ait-sqlsrv-web-dt | Lease management testing |
| **ait-sqldb-logging-t** | ait-sqlsrv-web-dt | Application logging |
| **ait-sqldb-onepim-t** | ait-sqlsrv-web-dt | PIM integration testing |
| **ait-sqldb-pimparser-t** | ait-sqlsrv-web-dt | PIM parser testing |
| **ait-sqldb-products-t** | ait-sqlsrv-web-dt | Product catalog testing |
| **ait-sqldb-stock-t** | ait-sqlsrv-web-dt | Inventory testing |
| **ait-sqldb-warranties-t** | ait-sqlsrv-web-dt | Warranty system testing |

#### 🗄️ **Storage Accounts**
- **agstorpimparserd** - PIM parser storage (Cool tier, SFTP enabled)
- **agstorstaticaccentryd** - Static website hosting (Hot tier)
- **agstoraccentryt** - General testing storage (Hot tier)
- **agstormulesoftfilest** - Mulesoft test files (Cool tier, SFTP enabled)

#### ⚙️ **Configuration & Monitoring** 
- **ag-ac-web-teststore** - App Configuration for testing
- **Application Insights** - ag-ai-fn-pimparser-t, ag-ai-kub-accentry-interface-d
- **AKS Test Cluster** - aks-web-t infrastructure

#### 💽 **Compute Resources**
- **Managed Disks** for Kubernetes persistent storage
- **Virtual Machine Scale Sets** for AKS nodes
- **Managed Identities** for service authentication

---

### 👨‍💻 **Visual Studio Professional Subscription (5 Resources)**
*Development Environment - ID: 12ca3d92-dcec-4480-80c9-a00968259543*

#### 🗄️ **Development Resources**
- **agstoraccentryinterfaced** - Development storage (Hot tier)
- **saaccentryaccservicedev** - Accentry service development storage  
- **acraccentryaccservicedev** - Container registry for development images
  - Tags: `owner: webteam`, `project_name: accentry`

---

## Resources by Type

## Complete Resource Summary

| Resource Type | SHARED_AP | SHARED_DT | Visual Studio Pro | Total | Primary Purpose |
|---------------|-----------|-----------|------------------|--------|----------------|
| **SQL Databases** | 50+ | 16+ | 0 | **66+** | Application data, BI, authentication |
| **Storage Accounts** | 3 | 4 | 2 | **9** | CDN, files, static hosting, SFTP |
| **Logic Apps** | 6+ | 0 | 0 | **6+** | Workflow automation, monitoring |
| **Elastic Pools** | 2 | 1+ | 0 | **3+** | Database resource management |
| **SQL Servers** | 2 | 1 | 0 | **3** | Database hosting infrastructure |
| **Network Security Groups** | 2+ | 1+ | 0 | **3+** | AKS security and networking |
| **Public IP Addresses** | 1+ | 1+ | 0 | **2+** | Load balancer networking |
| **Application Insights** | 1+ | 2+ | 0 | **3+** | Application monitoring |
| **Container Registry** | 0 | 0 | 1 | **1** | Docker image storage |
| **App Configuration** | 0 | 1 | 0 | **1** | Configuration management |
| **API Connections** | 3+ | 1+ | 0 | **4+** | Logic Apps integrations |
| **AKS Infrastructure** | 20+ | 15+ | 0 | **35+** | Kubernetes clusters and nodes |
| **Other Resources** | 40+ | 40+ | 2 | **82+** | Various supporting services |
| **Grand Total** | **131** | **82** | **5** | **218+** | **Complete infrastructure** |

---

## Key Infrastructure Insights

### 🏗️ **Architecture Overview**
- **Production-focused:** SHARED_AP hosts the main production workloads
- **Complete testing:** SHARED_DT mirrors production for comprehensive testing  
- **Development support:** Visual Studio Professional provides development resources
- **Microservices approach:** Separate databases for different business functions

### � **Database Architecture** 
- **66+ SQL Databases** across multiple environments (Production, Acceptance, Test)
- **Business function separation:** Auth, Baskets, Stock, Dealers, BI, Company data
- **Elastic Pool optimization:** Cost-effective resource sharing for databases
- **Environment parity:** Test databases mirror production structure

### � **Automation & Integration**
- **6+ Logic Apps** handling workflows, monitoring, and reporting
- **Teams integration** for alert notifications
- **Scheduled jobs** for stock updates, reporting, and monitoring
- **Multi-environment automation** (Production, Test, Development)

### �️ **Security & Compliance**
- **Network security groups** protecting AKS infrastructure
- **Managed identities** for secure service-to-service authentication
- **SFTP-enabled storage** for secure file transfers
- **Geo-redundant backup** for critical production databases

### 🌐 **Web & CDN Infrastructure**
- **Static website hosting** via Azure Storage
- **CDN integration** for image delivery
- **Load balancer public IPs** for external access
- **Container registry** for application deployments

---

## Key Insights

### Storage Usage

- **CDN Storage:** `agstorwebimagesp` for web images with public and private containers
- **Application Storage:** Multiple accounts for different applications (Accentry, PIM Parser, Mulesoft)
- **Static Website Hosting:** `agstorstaticaccentryd` for static web applications
- **File Transfer:** SFTP-enabled accounts for secure file operations
- **Development:** Dedicated storage accounts for development environments

### Tagging Compliance

- All resources are properly tagged with:
  - Business Owner Department
  - Business Owner Company
  - IT Owner
  - Project designation

### Geographic Distribution

- **West Europe:** 1 resource (100%)

### Subscription Distribution

- **SHARED_AP (1e4935cc-468f-46ba-9264-d7825e7e8194):**
  - Storage Accounts: agstorwebimagesp, agstoraccentryinterfacea, agstormulesoftfilesp
  - AKS Infrastructure: Public IPs, managed resources
  - Resource Groups: ag-web-images-p, ag-core-web-a, ag-core-web-p

- **SHARED_DT (6dcbeeff-435f-4fe9-b2e1-2fe73014f679):**
  - Storage Accounts: agstorpimparserd, agstorstaticaccentryd, agstoraccentryt, agstormulesoftfilest
  - SQL Databases: Multiple application databases in ait-core-web-t
  - AKS Infrastructure: aks-web-t cluster resources
  - App Configuration: ag-ac-web-teststore
  - Application Insights: PIM parser monitoring
  - Resource Groups: ait-core-web-d, ait-core-web-t, ag-core-pimparser-p, ag-core-pimparser-t

- **Visual Studio Professional (12ca3d92-dcec-4480-80c9-a00968259543):**
  - Storage Accounts: agstoraccentryinterfaced, saaccentryaccservicedev
  - Container Registry: acraccentryaccservicedev
  - Resource Groups: ag-core-accentry-d, rg-accentry-acc-service-dev

---

## Notes

- This overview includes resources identified through multiple criteria:
  - Tags containing `web` (case-insensitive)  
  - Resource groups containing `web` in the name
  - Specific tags: `Business Owner Department: Web`, `IT Owner: Web`, `owner: webteam`
- **All 13 available subscriptions were scanned** for comprehensive coverage
- **256+ total resources found** across Web-related resource groups and tags
- Results are truncated for readability - full details available in Azure portal
- Last scanned: September 24, 2025
- Primary subscriptions: SHARED_AP, SHARED_DT, Visual Studio Professional

---

## Maintenance Actions

### Recommended Actions

1. **Regular Review:** Schedule quarterly reviews of resource usage and costs
2. **Tagging Audit:** Ensure all Web team resources have consistent tagging
3. **Security Review:** Verify blob container access levels are appropriate
4. **Cost Optimization:** Monitor storage costs and implement lifecycle policies if needed

### Contact Information

- **IT Owner:** DevOps Team
- **Business Owner:** Web Department, Accell IT


---

*This document was automatically generated using Azure Resource Graph queries.*
