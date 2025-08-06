# 🛍️ dbt-Databricks Analytics - Retail Data Warehouse

[![dbt](https://img.shields.io/badge/dbt-1.7+-orange.svg)](https://docs.getdbt.com)
[![Databricks](https://img.shields.io/badge/Databricks-Compatible-red.svg)](https://databricks.com)

A comprehensive dbt demo project that implements a modern data warehouse for a retail company, following data modeling best practices and medallion architecture patterns.

## 📋 Table of Contents

- [🎯 Project Overview](#-project-overview)
- [🏗️ Architecture](#️-architecture)
- [📊 Data Model](#-data-model)
- [🚀 Setup & Installation](#-setup--installation)
- [📈 dbt Lineage](#-dbt-lineage)
- [🛠️ dbt Commands](#️-dbt-commands)
- [📖 Documentation](#-documentation)

## 🎯 Project Overview

This project demonstrates the implementation of a complete data warehouse for a retail company using dbt (data build tool). The project includes:

- **Medallion Architecture**: Bronze (Raw) → Silver (Staging) → Gold (Marts)
- **Dimensional Modeling**: Facts and dimensions for OLAP analysis
- **Data Quality Tests**: Automated data validations
- **Documentation**: Auto-generated and maintained
- **Business Analytics**: BI-ready insights

### 🎪 Use Cases Covered

- 📊 **Sales Analytics**: Performance metrics by store, product, and employee
- 👥 **Customer Segmentation**: Automated classification based on behavior
- 💰 **Profitability Analysis**: Margin and profitability analysis by dimensions
- 🎯 **Target Achievement**: Comparison against defined targets
- 📈 **Temporal Trends**: Seasonal and temporal pattern analysis

## 🏗️ Architecture

### Medallion Architecture Flow

```mermaid
graph TD
    subgraph Sources ["📥 Data Sources"]
        S1[Raw CSV Files]
        S2[Database Extracts] 
        S3[API Data]
    end
    
    subgraph Bronze ["🥉 Bronze Layer - Raw Data"]
        B1[(customers)]
        B2[(orders)]
        B3[(order_items)]
        B4[(products)]
        B5[(employees)]
        B6[(stores)]
        B7[(suppliers)]
        B8[(dates)]
    end
    
    subgraph Silver ["🥈 Silver Layer - Cleaned Data"]
        C1[stg_customers]
        C2[stg_orders]
        C3[stg_order_items]
        C4[stg_products]
        C5[stg_employees]
        C6[stg_stores]
        C7[stg_suppliers]
        C8[stg_dates]
    end
    
    subgraph Gold ["🥇 Gold Layer - Business Ready"]
        direction TB
        subgraph Dimensions ["📊 Dimensions"]
            D1[dim_customers]
            D2[dim_products] 
            D3[dim_employees]
            D4[dim_stores]
            D5[dim_suppliers]
            D6[dim_dates]
        end
        subgraph Facts ["📈 Facts"]
            F1[fct_orders]
            F2[fct_customer_segmentation]
            F3[fct_store_performance]
        end
    end
    
    Sources --> Bronze
    Bronze --> Silver
    Silver --> Gold
    
    classDef bronze fill:#cd853f,stroke:#8b4513,stroke-width:2px,color:#fff
    classDef silver fill:#c0c0c0,stroke:#696969,stroke-width:2px,color:#000
    classDef gold fill:#ffd700,stroke:#daa520,stroke-width:2px,color:#000
    classDef source fill:#98fb98,stroke:#228b22,stroke-width:2px,color:#000
    
    class B1,B2,B3,B4,B5,B6,B7,B8 bronze
    class C1,C2,C3,C4,C5,C6,C7,C8 silver  
    class D1,D2,D3,D4,D5,D6,F1,F2,F3 gold
    class S1,S2,S3 source
```

## 📊 Data Model

### Entity Relationship Diagram

Our data model follows a classic retail pattern with the following entities and relationships:

```mermaid
erDiagram
    SUPPLIERS {
        int supplier_id PK
        varchar supplier_name
        varchar contact_person
        varchar email
        varchar phone
        varchar address
        varchar city
        varchar state
        varchar zip_code
        timestamp updated_at
    }
    
    DATES {
        date date_id PK
        varchar day
        varchar month
        varchar year
        int quarter
        varchar day_of_week
        int week_of_year
        timestamp updated_at
    }
    
    STORES {
        int store_id PK
        varchar store_name
        varchar address
        varchar city
        varchar state
        varchar zip_code
        varchar email
        varchar phone
        timestamp updated_at
    }
    
    CUSTOMERS {
        int customer_id PK
        varchar first_name
        varchar last_name
        varchar email
        varchar phone
        varchar address
        varchar city
        varchar state
        varchar zip_code
        timestamp updated_at
    }
    
    EMPLOYEES {
        int employee_id PK
        varchar first_name
        varchar last_name
        varchar email
        varchar job_title
        date hire_date
        int manager_id FK
        varchar address
        varchar city
        varchar state
        varchar zip_code
        timestamp updated_at
    }
    
    PRODUCTS {
        int product_id PK
        varchar name
        varchar category
        decimal retail_price
        decimal supplier_price
        int supplier_id FK
        timestamp updated_at
    }
    
    ORDERS {
        int order_id PK
        date order_date
        int customer_id FK
        int employee_id FK
        int store_id FK
        varchar status
        timestamp updated_at
    }
    
    ORDER_ITEMS {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
        timestamp updated_at
    }

    %% Relationships
    SUPPLIERS ||--o{ PRODUCTS : supplies
    CUSTOMERS ||--o{ ORDERS : places
    EMPLOYEES ||--o{ ORDERS : processes
    EMPLOYEES ||--o{ EMPLOYEES : reports_to
    STORES ||--o{ ORDERS : receives
    DATES ||--o{ ORDERS : order_date
    ORDERS ||--o{ ORDER_ITEMS : contains
    PRODUCTS ||--o{ ORDER_ITEMS : included_in
```

### 🥇 Gold Layer (Marts)

#### Main Dimensions

| Dimension | Description | Key Attributes |
|-----------|-------------|-----------------|
| `dim_customers` | Customers with segmentation and metrics | segment, region, status, LTV |
| `dim_products` | Products with categories and performance | category, price tier, status |
| `dim_employees` | Employees with roles and performance | department, level, tenure |
| `dim_stores` | Stores with targets and classification | region, type, performance vs target |
| `dim_suppliers` | Suppliers with portfolio metrics | tier, diversity, performance |
| `dim_dates` | Complete calendar with attributes | season, holidays, fiscal periods |

#### Fact Tables

| Fact | Description | Key Metrics |
|-------|-------------|---------------------|
| `fct_orders` | Sales transactions | revenue, quantity, items |
| `fct_customer_segmentation` | Customer segmentation | segment, activity, classification |
| `fct_store_performance` | Store performance | revenue vs target, orders, customers |

## 📈 dbt Lineage

### Complete Data Flow

The following diagram shows the complete dbt lineage from bronze tables through to final marts:

> **Note**: After running `dbt docs generate && dbt docs serve`, you can explore the interactive lineage graph at `http://localhost:8080`

```mermaid
flowchart LR
    subgraph Bronze["🥉 Bronze Layer"]
        customers[customers]
        orders[orders]
        order_items[order_items]
        products[products]
        employees[employees]
        stores[stores]
        suppliers[suppliers]
        dates[dates]
    end
    
    subgraph Silver["🥈 Silver Layer"]
        stg_customers[stg_customers]
        stg_orders[stg_orders]
        stg_order_items[stg_order_items]
        stg_products[stg_products]
        stg_employees[stg_employees]
        stg_stores[stg_stores]
        stg_suppliers[stg_suppliers]
        stg_dates[stg_dates]
    end
    
    subgraph Gold["🥇 Gold Layer"]
        subgraph Core["Core Dimensions & Facts"]
            dim_customers[dim_customers]
            dim_products[dim_products]
            dim_employees[dim_employees]
            dim_stores[dim_stores]
            dim_suppliers[dim_suppliers]
            dim_dates[dim_dates]
            fct_orders[fct_orders]
        end
        
        subgraph Finance["Finance Marts"]
            fct_customer_segmentation[fct_customer_segmentation]
            fct_store_performance[fct_store_performance]
            fct_store_monthly_profit[fct_store_monthly_profit]
        end
    end
    
    subgraph Seeds["🌱 Seeds"]
        customer_segments[customer_segments]
        employee_roles[employee_roles]
        product_categories[product_categories]
        store_targets[store_targets]
        order_status_mapping[order_status_mapping]
    end
    
    %% Bronze to Silver
    customers --> stg_customers
    orders --> stg_orders
    order_items --> stg_order_items
    products --> stg_products
    employees --> stg_employees
    stores --> stg_stores
    suppliers --> stg_suppliers
    dates --> stg_dates
    
    %% Silver to Gold - Dimensions
    stg_customers --> dim_customers
    stg_products --> dim_products
    stg_employees --> dim_employees
    stg_stores --> dim_stores
    stg_suppliers --> dim_suppliers
    stg_dates --> dim_dates
    
    %% Silver to Gold - Facts
    stg_orders --> fct_orders
    stg_order_items --> fct_orders
    
    %% Seeds to Dimensions
    customer_segments --> dim_customers
    employee_roles --> dim_employees
    product_categories --> dim_products
    store_targets --> dim_stores
    order_status_mapping --> stg_orders
    
    %% Facts to Finance Marts
    fct_orders --> fct_customer_segmentation
    fct_orders --> fct_store_performance
    fct_orders --> fct_store_monthly_profit
    dim_customers --> fct_customer_segmentation
    dim_stores --> fct_store_performance
    customer_segments --> fct_customer_segmentation
    store_targets --> fct_store_performance
```

## 🚀 Setup & Installation

### Prerequisites

- Python 3.8+
- Databricks workspace
- Git

### 1. Repository Clone

```bash
git clone https://github.com/your-user/dbt-databricks-analytics.git
cd dbt-databricks-analytics
```

### 2. Virtual Environment Setup

```bash
python -m venv dbt-env
source dbt-env/bin/activate  # On Windows: dbt-env\Scripts\activate
pip install -r requirements.txt
```

### 3. Databricks Configuration

Create your `profiles.yml` file in `~/.dbt/`:

```yaml
dbt_demo:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: dbt_demo
      schema: dev_{{ env_var('USER') }}
      host: "{{ env_var('DATABRICKS_HOST') }}"
      http_path: "{{ env_var('DATABRICKS_HTTP_PATH') }}"
      token: "{{ env_var('DATABRICKS_TOKEN') }}"
      threads: 4
    
    prod:
      type: databricks
      catalog: dbt_demo
      schema: prod
      host: "{{ env_var('DATABRICKS_HOST') }}"
      http_path: "{{ env_var('DATABRICKS_HTTP_PATH') }}"
      token: "{{ env_var('DATABRICKS_TOKEN') }}"
      threads: 8
```

### 4. Environment Variables

```bash
export DATABRICKS_HOST="your-workspace-url"
export DATABRICKS_HTTP_PATH="/sql/1.0/warehouses/your-warehouse-id"
export DATABRICKS_TOKEN="your-access-token"
export USER=$(whoami)
```

### 5. Initial Setup

```bash
# 1. Run setup scripts in Databricks SQL Editor
# - Execute setup/catalog_setup.sql
# - Execute setup/seed_data.sql

# 2. Load seeds and run models
dbt seed
dbt run
dbt test

# 3. Generate documentation
dbt docs generate
dbt docs serve --port 8080
```

## 🛠️ dbt Commands

### Essential Commands

```bash
# Verify connection
dbt debug

# Install dependencies
dbt deps

# Load seeds (reference data)
dbt seed

# Run all models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve --port 8080
```

### Selective Commands

```bash
# Only staging
dbt run --select staging

# One model and its dependencies
dbt run --select +fct_orders

# Modified models
dbt run --select state:modified

# Full refresh (recreate tables)
dbt run --full-refresh
```

## 📖 Documentation

### Interactive Documentation

Access the full interactive documentation:

```bash
dbt docs generate
dbt docs serve --port 8080
```

Features include:
- **Entity Relationship Diagrams**: Visual representation of table relationships
- **Lineage Graphs**: Complete data flow visualization
- **Column Documentation**: Detailed descriptions and data types
- **Test Results**: Data quality validation status
- **Source Freshness**: Data freshness monitoring

### Databricks Integration

To visualize lineage in Databricks:

1. Go to **Data** → **Catalogs** → `dbt_demo`
2. Explore generated tables in `silver` and `gold` schemas
3. Use **Lineage** tab for dependency visualization
4. Leverage **Query Profile** for performance analysis

---
*Built with ❤️ using dbt and Databricks*
