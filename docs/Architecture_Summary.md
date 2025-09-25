# Azure Landing Zone PoC - Architecture Summary

## Two-Layer Infrastructure Approach

### 🏗️ **PROJECT RESOURCES (Shared Infrastructure)**

**Purpose:** Foundational components shared across multiple applications

#### Core Shared Components:
1. **SQL Server Infrastructure**
   - `dev-accentry-poc-sqlsrv-001` - Shared SQL Server (private endpoint only)
   - `dev-accentry-poc-sqlpool-001` - Shared Elastic Pool (50+ databases capacity)

2. **Storage Infrastructure**
   - `devaccentrypocst001` - Shared Storage Account (private endpoint only)
   - `devaccentrypocsftp001` - Shared SFTP Storage (private endpoint only)

3. **Container Infrastructure**
   - `devaccentrypocacr001` - Shared Container Registry (private endpoint only)
   - `dev-accentry-poc-aks-001` - Shared AKS Cluster (3 nodes, ONLY public component)

4. **Security & Networking**
   - `dev-accentry-poc-vnet-001` - Shared VNet with private endpoint subnets
   - `dev-accentry-poc-kv-001` - Shared Key Vault (private endpoint only)
   - `dev-accentry-poc-mi-shared-001` - Shared Managed Identity
   - Private DNS zones for all Azure services

---

### 📱 **APPLICATION RESOURCES (App-Specific)**

**Purpose:** Application-specific components using shared infrastructure

#### PoC Web Application Components:
1. **Application Databases** (in shared SQL Server)
   - `dev-accentry-poc-sqldb-auth-001` - Authentication database
   - `dev-accentry-poc-sqldb-products-001` - Product catalog database
   - `dev-accentry-poc-sqldb-logging-001` - Application logging database

2. **Application Storage** (in shared Storage Account)
   - `poc-app-assets` - Static application assets container
   - `poc-user-uploads` - User content container
   - `poc-app-logs` - Application logs container
   - `poc-backups` - Backup files container

3. **Container Workloads** (in shared AKS)
   - **Namespace:** `poc-webapp` (isolated namespace)
   - **Frontend:** 2 replicas web UI deployment
   - **Backend API:** 2 replicas API service deployment
   - **Ingress:** Routes from shared Load Balancer
   - **Images:** Stored in shared ACR with `poc/` prefix

---

## 🔒 **Security Architecture**

### Zero Trust Approach:
- **NO public access** to SQL Server, Storage, Key Vault, Container Registry
- **ALL communication** via private endpoints within VNet
- **ONLY AKS Load Balancer** has public internet access
- **Application isolation** via Kubernetes namespaces
- **Shared managed identity** with proper RBAC scoping

### Network Segmentation:
- **AKS Subnet** (10.0.1.0/24) - Container workloads
- **Data Subnet** (10.0.2.0/24) - Private endpoints
- **PE Subnet** (10.0.3.0/24) - Additional private endpoints
- **Management Subnet** (10.0.4.0/24) - Management services

---

## 🚀 **Deployment Strategy**

### Layer 1: Project Infrastructure
1. Foundation (VNet, NSGs, DNS, Identities)
2. Shared Data Services (SQL Server, Storage, Key Vault)
3. Shared Container Platform (AKS, ACR)
4. Shared Monitoring (Log Analytics, App Insights)

### Layer 2: Application Deployment
1. Application Data (databases, storage containers, secrets)
2. Application Containers (build, push, deploy to AKS namespace)
3. Application Configuration (ingress, monitoring, connections)
4. End-to-End Validation

---

## 💰 **Cost Structure**

**Shared Infrastructure:** ~€350-420/month
- SQL Server + Elastic Pool: €150-200
- AKS Cluster (3 nodes): €180-225
- Storage + Private Endpoints: €40-50
- Networking + Monitoring: €40-50

**Per Application:** ~€10-20/month additional
- Additional databases (small, in shared pool)
- Additional storage containers
- Additional AKS namespace resources
- Application-specific monitoring

---

## 🎯 **Benefits of This Approach**

1. **Cost Efficiency:** Shared infrastructure reduces per-application costs
2. **Scalability:** Easy to add new applications using same infrastructure
3. **Security:** Consistent security posture across all applications
4. **Management:** Centralized infrastructure management
5. **Isolation:** Applications isolated via namespaces and RBAC
6. **Standards:** Consistent naming and tagging across all resources

---

*This architecture supports multiple applications while maintaining security, cost-effectiveness, and operational simplicity.*