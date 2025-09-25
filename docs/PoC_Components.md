# Azure Landing Zone Migration PoC - Component List

**Created on:** September 24, 2025  
**Purpose:** Define minimal viable c#### Virtual Network
- **Component:** `vnet-${local.name_prefix}-001`ponents fo#### Network Security Groups
- **Component:** `nsg-aks-${local.name_prefix}-001`Azure Landing Zone mig#### Public IP (AKS Load Balancer Only)
- **Component:** `pip-aks-lb-${local.name_prefix}-001`tion testing  
**Base#### Container Registry (Project-Level)
- **Component:** `acr${local.name_prefix}001` (50 char max: acrdevaccentrypoc001) on:** Web Team current infrastructure analysis  

---

## PoC Objectives#### Logic App (Simplified)
- **Component:** `la-monitoring-${local.name_prefix}-001`
This PoC will#### Key Vault (Project-Level)
- **Component:** `kv-${local.name_prefix}-001`alidate the Az#### Managed Identity (Project-Level)
- **Component:** `mi-shared-${local.name_prefix}-001`e Landing Zone setup by creating a simplified version of the Web team's current infrastructure. The goal is to test:
- Resource deployment patterns
- Networking and security configurations
- Database connectivity and performance
- Storage and CDN functionality
- Monitoring and logging capabilities
- Infrastructure as Code (Terraform) templates

---

## Terraform Configuration

### Default Locals Setup

```hcl
locals {
    # Common varibales to use in project
    env_name         = "dev"
    az_region        = "westeurope"
    project_name     = "accentry"
    application_name = "poc"

    # name_prefix which will use in resource naming convention
    name_prefix      = "${local.env_name}-${local.project_name}-${local.application_name}"

    # These tags are being used in all terraform resources and can be add more
    default_tags = {
        project_name        = "accentry"
        owner               = "web"
        environment         = local.env_name
        region              = local.az_region
        application_name    = local.application_name
        managed_by          = "terraform"
        created_date        = formatdate("YYYY-MM-DD", timestamp())
        # Required by Azure Policy
        "Application Name"   = local.application_name 
        # options: Critical, High, Medium, Low
        "Business Criticality" = "Low"        
    }
}
```

### Architecture Approach: Two-Layer Infrastructure

**Resource Separation:**
- **Project Resources:** Shared infrastructure (SQL Server, AKS Cluster, Storage Accounts, Container Registry)
- **Application Resources:** App-specific components (Databases, Container workloads, App configs)

**Security Design:**
- All Azure PaaS services configured with **private endpoints only**
- **AKS cluster** is the only component with public access (via Load Balancer/Ingress)
- Web application runs as **containerized workload in AKS**
- All internal communication through **private networking**

---

## PROJECT RESOURCES (shared project infrastructure)

*These are the foundational components that can be shared across multiple applications*

### 🗄️ **Project Resource: SQL Server Infrastructure**

#### SQL Server (Project-Level)
- **Component:** `sqlsrv-${local.name_prefix}`
- **Purpose:** **Shared SQL Server** to host databases for multiple applications
- **Configuration:**
  - Location: West Europe
  - Version: Latest supported
  - **Private endpoint only** - No public access
  - Firewall: Deny all public access
  - Admin authentication: Azure AD integration
  - Private DNS integration
  - VNet integration: data subnet
  - **Shared across all applications in the project**

#### Elastic Pool (Project-Level)
- **Component:** `sqlpool-${local.name_prefix}`
- **Purpose:** **Shared resource pool** for cost-effective database hosting
- **Configuration:**
  - Tier: Standard
  - Capacity: 50 DTU (expandable for multiple apps)
  - Max databases: 50 (can host multiple application databases)
  - **Shared resource for all project applications**

---

### 🗄️ **Project Resource: Storage Infrastructure**

#### Primary Storage Account (Project-Level)
- **Component:** `sa${local.name_prefix}` (24 char max: sadevaccentrypoc)
- **Purpose:** **Shared storage** for all applications in the project
- **Configuration:**
  - Type: StorageV2
  - Replication: LRS (Local for PoC)
  - Access Tier: Hot
  - **Private endpoint only** - No public access
  - **No public blob access**
  - Private DNS integration
  - VNet integration: data subnet
  - **Shared across all project applications**
  - Pre-configured containers for common use cases

#### SFTP Storage Account (Project-Level)
- **Component:** `sftp${local.name_prefix}` (24 char max: sftpdevaccentrypoc)
- **Purpose:** **Shared SFTP endpoint** for secure file transfers
- **Configuration:**
  - Type: StorageV2
  - Replication: LRS
  - **Private endpoint only** - No public access
  - SFTP enabled: Yes (via private endpoint)
  - Hierarchical namespace: Enabled
  - Access Tier: Cool
  - Private DNS integration
  - VNet integration: data subnet
  - **Shared resource for all applications requiring SFTP**

---

### 🌐 **Networking Infrastructure**

#### Virtual Network
- **Component:** `vnet-${local.name_prefix}`
- **Purpose:** Isolated network for PoC resources with private endpoint support
- **Configuration:**
  - Address space: 10.0.0.0/16
  - Subnets:
    - `subnet-aks-${local.name_prefix}` (10.0.1.0/24) - AKS cluster nodes
    - `subnet-data-${local.name_prefix}` (10.0.2.0/24) - Private endpoints (SQL, Storage)
    - `subnet-pe-${local.name_prefix}` (10.0.3.0/24) - Additional private endpoints
    - `subnet-mgmt-${local.name_prefix}` (10.0.4.0/24) - Management services
  - DNS Integration: Private DNS zones for Azure services

#### Network Security Groups
- **Component:** `nsg-aks-${local.name_prefix}`
- **Purpose:** Security rules for AKS subnet
- **Rules:**
  - Allow HTTP/HTTPS inbound from internet (Load Balancer only)
  - Allow outbound to private endpoint subnet
  - Allow AKS internal communication
  - Deny direct internet access from pods

- **Component:** `nsg-data-${local.name_prefix}-001`
- **Purpose:** Security rules for private endpoint subnet
- **Rules:**
  - Allow inbound from AKS subnet only
  - Allow private endpoint communication (port 443)
  - **Deny all internet access**
  - Allow Azure backbone communication

- **Component:** `nsg-pe-${local.name_prefix}-001`
- **Purpose:** Security rules for private endpoint subnet
- **Rules:**
  - Allow HTTPS from AKS subnet
  - Allow private DNS resolution
  - **Deny all public internet access**

#### Public IP (AKS Load Balancer Only)
- **Component:** `pip-aks-lb-${local.name_prefix}`
- **Purpose:** **ONLY** external access for AKS Load Balancer
- **Configuration:**
  - Type: Static
  - SKU: Standard
  - **Note:** This is the ONLY public-facing component

#### Private DNS Zones
- **Components:**
  - `privatelink.database.windows.net` - SQL Server private DNS
  - `privatelink.blob.core.windows.net` - Storage private DNS
  - `privatelink.vaultcore.azure.net` - Key Vault private DNS
- **Purpose:** DNS resolution for private endpoints
- **Configuration:**
  - Linked to VNet
  - Auto-registration disabled
  - Manual A records for private endpoints

---

### ☸️ **Container Infrastructure (Primary Compute)**

#### Container Registry
- **Component:** `acr${local.name_prefix}` (50 char max: acrdevaccentrypoc)
- **Purpose:** Container image storage for AKS workloads
- **Configuration:**
  - SKU: Basic
  - **Private endpoint only** - No public access
  - Admin user: Disabled (use managed identity)
  - Private DNS integration
  - VNet integration: data subnet
  - Vulnerability scanning: Enabled

#### AKS Cluster (Primary Web Platform)
- **Component:** `aks-${local.name_prefix}`
- **Purpose:** **Primary hosting platform** for web applications
- **Configuration:**
  - Node count: 2 (minimal HA setup)
  - VM Size: Standard_B4ms (4 vCPU, 16GB RAM)
  - **Network:** Azure CNI with VNet integration
  - **Load Balancer:** Standard (with public IP - ONLY public component)
  - **Ingress Controller:** NGINX or Application Gateway
  - **Identity:** System-assigned managed identity
  - **Container Runtime:** containerd
  - **Private cluster:** No (needs public access for web traffic)
  - **RBAC:** Azure AD integration
  - **Network Policy:** Azure or Calico
  - **Outbound connectivity:** Load Balancer (not NAT Gateway for PoC)

---

## APPLICATION RESOURCES (App-Specific)

*These are the application-specific components that use the shared project infrastructure*

### 📱 **PoC Web Application**

#### Application Databases
1. **sqldb-auth-${local.name_prefix}**
   - Purpose: Authentication system for PoC app
   - Elastic Pool: `sqlpool-${local.name_prefix}` (shared)
   - Initial size: Small
   - **Private access only** via shared SQL Server

2. **sqldb-products-${local.name_prefix}**
   - Purpose: Product catalog for PoC app
   - Elastic Pool: `sqlpool-${local.name_prefix}` (shared)
   - Initial size: Small
   - **Private access only** via shared SQL Server

3. **sqldb-logging-${local.name_prefix}**
   - Purpose: Application logging for PoC app
   - Elastic Pool: `sqlpool-${local.name_prefix}` (shared)
   - Initial size: Small
   - **Private access only** via shared SQL Server

#### Application Storage Containers
- **Storage Account:** Uses shared `sa${local.name_prefix}`
- **App-Specific Containers:**
  - `poc-app-assets` - Static application assets
  - `poc-user-uploads` - User uploaded content
  - `poc-app-logs` - Application-specific logs
  - `poc-backups` - Application backup files

#### Container Workloads in AKS
- **Namespace:** `poc-webapp` (isolated within shared AKS)
- **Components:**
  - **Frontend Deployment:** 2 replicas of web UI
  - **Backend API Deployment:** 2 replicas of API service
  - **Service:** ClusterIP for internal communication
  - **Ingress:** Routes traffic from shared Load Balancer
  - **Container Images:** Stored in shared ACR with `poc/` prefix
  - **Configuration:**
    - Uses shared managed identity
    - Connects to shared SQL Server via private endpoint
    - Accesses shared storage via private endpoint
    - Secrets from shared Key Vault

---

### 🔗 **Integration & Automation**

#### Logic App (Simplified)
- **Component:** `la-monitoring-${local.name_prefix}`
- **Purpose:** Basic workflow automation testing with private access
- **Configuration:**
  - **Type:** Standard (required for VNet integration)
  - **VNet Integration:** Connected to management subnet
  - **Private endpoint access** to SQL and Storage
  - Trigger: Recurrence (daily)
  - Action: Database health check via private endpoint
  - Notification: Email or Teams webhook
  - **No public internet access**

---

### 🔑 **Security & Identity**

#### Key Vault (Project-Level)
- **Component:** `kv-${local.name_prefix}`
- **Purpose:** **Shared secrets management** for all project applications
- **Configuration:**
  - **Private endpoint only** - No public access
  - Firewall: Deny all public access
  - Private DNS integration
  - VNet integration: data subnet
  - **Shared secrets:**
    - SQL Server connection strings (private endpoint URLs)
    - Storage account connection strings (private endpoint URLs)
    - Container registry credentials
    - Shared certificates and API keys
  - **Application-specific secrets** organized by namespaces
  - RBAC access policies for shared managed identity

#### Managed Identity (Project-Level)
- **Component:** `mi-shared-${local.name_prefix}`
- **Purpose:** **Shared identity** for all applications in the project
- **Configuration:**
  - User-assigned identity
  - **Federated credentials** for multiple AKS service accounts
  - **Project-wide access policies:**
    - Key Vault: Get/List secrets (all namespaces)
    - SQL Server: SQL DB Contributor (shared server)
    - Storage Account: Blob Data Contributor (shared storage)
    - Container Registry: AcrPull (shared registry)
  - **Application isolation** through Kubernetes RBAC and namespaces

---

## Resource Naming Convention

### Pattern (Using Terraform Locals)
`{service}-${local.name_prefix}-{instance}`

**Expands to:** `{service}-dev-accentry-poc-{instance}`

### Examples
- `sqlsrv-dev-accentry-poc`
- `vnet-dev-accentry-poc` 
- `aks-dev-accentry-poc`
- `sadevaccentrypoc` (for storage accounts - no hyphens, 24 char max)
- `acrdevaccentrypoc` (for container registry - no hyphens)

### Resource Groups (Project-Level)
**Shared Infrastructure:**
- `rg-networking-${local.name_prefix}` - VNet, NSGs, Private DNS Zones
- `rg-data-${local.name_prefix}` - SQL Server, Storage Accounts, Private Endpoints
- `rg-compute-${local.name_prefix}` - AKS Cluster, Container Registry
- `rg-monitoring-${local.name_prefix}` - Log Analytics, Application Insights
- `rg-security-${local.name_prefix}` - Key Vault, Managed Identities

**Application-Specific:**
- Applications use shared resources but can have:
  - Application-specific databases (in shared SQL Server)
  - Application-specific storage containers (in shared Storage Account)
  - Application-specific namespaces (in shared AKS)
  - Application-specific secrets (in shared Key Vault)

---

## Deployment Sequence

### LAYER 1: PROJECT RESOURCES (Shared Infrastructure)

#### Phase 1: Foundation Infrastructure
1. Resource Groups (project-level)
2. Virtual Network and subnets
3. Network Security Groups
4. Private DNS Zones
5. Managed Identities (shared)

#### Phase 2: Shared Data Services
1. SQL Server (private endpoint only)
2. Elastic Pool (shared resource)
3. Storage Accounts (private endpoints only)
4. Key Vault (private endpoint only)
5. **Configure all private endpoints with DNS integration**

#### Phase 3: Shared Container Platform
1. Container Registry (private endpoint)
2. AKS Cluster (with public Load Balancer - ONLY public component)
3. Configure AKS managed identity access to all private resources
4. Set up AKS namespaces for application isolation

#### Phase 4: Shared Monitoring
1. Log Analytics Workspace
2. Application Insights
3. Diagnostic settings for all shared components
4. Container Insights for AKS

### LAYER 2: APPLICATION RESOURCES (App-Specific)

#### Phase 5: Application Data
1. Create application-specific databases in shared SQL Server
2. Create application-specific storage containers
3. Configure application-specific secrets in shared Key Vault

#### Phase 6: Application Deployment
1. Build and push application container images to shared ACR
2. Deploy application workloads to dedicated AKS namespace
3. Configure ingress routing for application
4. Logic App configuration (if needed)
5. Application-specific monitoring setup

#### Phase 7: End-to-End Validation
1. Test application access via shared AKS ingress
2. Verify application database connectivity (private endpoints)
3. Test application storage access (private endpoints)
4. Validate managed identity authentication for application
5. Application-specific functionality testing

---

## Success Criteria for PoC

### Functional Requirements
**Project Infrastructure:**
- [ ] **Shared AKS cluster accessible from internet** (ONLY public access point)
- [ ] **Shared SQL Server** accessible from AKS pods via private endpoints only
- [ ] **Shared Storage Accounts** accessible from AKS via private endpoints only
- [ ] **Shared Key Vault** accessible from AKS via private endpoints only
- [ ] **Shared Container Registry** functional for image deployment
- [ ] **Shared monitoring** (Log Analytics) capturing all workloads

**Application Layer:**
- [ ] Application databases created and accessible in shared SQL Server
- [ ] Application containers deployed to dedicated AKS namespace
- [ ] Application-specific storage containers functional
- [ ] Application secrets accessible from shared Key Vault
- [ ] Application routing working through shared ingress
- [ ] Logic App executing via private connectivity (if applicable)

### Security Requirements (CRITICAL)
**Project Infrastructure Security:**
- [ ] **No direct public access to shared SQL Server** (private endpoint only)
- [ ] **No direct public access to shared Storage Accounts** (private endpoint only)
- [ ] **No direct public access to shared Key Vault** (private endpoint only)
- [ ] **No direct public access to shared Container Registry** (private endpoint only)
- [ ] **Shared AKS is the ONLY component with public internet access**
- [ ] Network segmentation enforced (NSG rules)
- [ ] Shared managed identity authentication functional
- [ ] Private DNS resolution working for all private endpoints

**Application Security:**
- [ ] Application isolation through Kubernetes namespaces
- [ ] Application databases only accessible via shared private endpoints
- [ ] Application secrets properly scoped in shared Key Vault
- [ ] No application can bypass shared infrastructure security
- [ ] All application communication via private networks
- [ ] HTTPS/TLS enforced for all application communications

### Performance Requirements
- [ ] Database response times < 100ms for simple queries
- [ ] Storage account upload/download speed acceptable
- [ ] Application startup time < 30 seconds
- [ ] No resource throttling under light load

---

## Cost Estimation (Monthly)

| Component Category | Estimated Cost (EUR) | Notes |
|-------------------|---------------------|-------|
| SQL Infrastructure | €150-200 | Single server + elastic pool + 3 databases |
| Storage Accounts | €25-35 | 100GB storage + private endpoints |
| **AKS Cluster** | **€120-150** | **2 nodes Standard_B4ms (replaces App Service)** |
| Container Registry | €15-20 | Basic tier + private endpoint |
| **Private Endpoints** | **€15-25** | **~5 private endpoints @ €3-5 each** |
| Private DNS Zones | €2-5 | 3 private DNS zones |
| Networking | €10-15 | VNet, NSG, Public IP, Load Balancer |
| Key Vault | €2-5 | Secrets + private endpoint |
| Monitoring | €30-40 | Log Analytics + App Insights + Container Insights |
| **Total Estimated** | **€369-495** | **For complete private endpoint PoC environment** |

**Note:** Private endpoint architecture adds ~€30-40/month but provides production-grade security.

---

## Next Steps

1. **Review component list** with stakeholders
2. **Create Terraform modules** for each component
3. **Set up CI/CD pipeline** for Infrastructure as Code
4. **Deploy PoC environment** in designated subscription
5. **Test all functionality** against success criteria
6. **Document lessons learned** for full migration planning
7. **Create migration roadmap** based on PoC results

---

*This PoC represents approximately 15-20% of the full production infrastructure complexity while covering all major architectural patterns and integration points.*