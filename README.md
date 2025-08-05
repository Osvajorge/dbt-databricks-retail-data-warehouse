# dbt Demo Project

This project demonstrates a dbt (data build tool) implementation for a data analytics pipeline, showcasing best practices for data modeling, transformation, and documentation. It follows a multi-layered architecture (Bronze, Silver, Gold) to ensure data quality, consistency, and usability for various analytical purposes.

## Project Structure

The project is organized into the following key directories:

- `analyses/`: Contains SQL files for ad-hoc analyses and reporting that are not part of the core data models.
- `dbt-venv/`: A Python virtual environment for dbt and its dependencies.
- `macros/`: Houses reusable SQL code snippets (macros) to promote DRY (Don't Repeat Yourself) principles and maintain consistency across models.
- `models/`: The core of the dbt project, containing all data models organized into logical layers:
    - `models/marts/`: Represents the **Gold Layer**, containing highly transformed, aggregated, and business-ready data models optimized for reporting and analytical consumption.
        - `models/marts/core/`: Core business metrics and facts.
        - `models/marts/finance/`: Financial-specific aggregated data.
    - `models/staging/`: Represents the **Silver Layer**, containing cleaned, standardized, and lightly transformed data from the raw sources. This layer focuses on data quality and consistency.
    - `models/sources.yml`: Defines the raw data sources (Bronze Layer) ingested into the pipeline.
- `seeds/`: Stores static CSV files that are loaded directly into the data warehouse. These are typically small, unchanging lookup tables.
- `snapshots/`: (If applicable) Contains dbt snapshots for tracking changes in mutable source tables over time.
- `tests/`: Custom data tests to ensure data quality and integrity at various stages of the pipeline.

## Data Layers Explained

This project adheres to a medallion architecture, categorizing data into three distinct layers:

1.  **Bronze Layer (Raw Data)**:
    -   **Location**: Defined in `models/sources.yml`.
    -   **Purpose**: This layer represents the raw, untransformed data ingested directly from source systems. Tables in this schema are typically exact replicas of the source data, with minimal or no transformations applied.
    -   **Characteristics**: Data is immutable, preserving the original state. It serves as the foundation for all subsequent data transformations and ensures data lineage back to the original source.
    -   **Examples**: `bronze.customers`, `bronze.orders`, `bronze.products`.

2.  **Silver Layer (Staging/Cleaned Data)**:
    -   **Location**: Models within the `models/staging/` directory.
    -   **Purpose**: This layer contains cleaned, standardized, and lightly transformed data from the raw sources. It focuses on improving data quality and consistency.
    -   **Characteristics**: Data types are cast correctly, basic cleaning (e.g., handling nulls, removing duplicates) is performed, and columns are renamed for clarity. This layer prepares data for more complex transformations.
    -   **Examples**: `stg_customers`, `stg_orders`, `stg_products`.

3.  **Gold Layer (Marts/Business-Ready Data)**:
    -   **Location**: Models within the `models/marts/` directory.
    -   **Purpose**: This layer provides highly transformed, aggregated, and business-ready data models optimized for reporting, analytical consumption, and business intelligence tools.
    -   **Characteristics**: Data is denormalized, aggregated, and structured to meet specific business requirements. It's designed for fast querying and direct use by end-users and applications.
    -   **Examples**: `fct_orders`, `customer_revenue`, `fct_customer_segmentation`, `fct_store_performance`.

## Setup and Installation

To set up and run this dbt project, follow these steps:

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-repo/dbt-demo.git
    cd dbt-demo
    ```

2.  **Create and activate a Python virtual environment**:
    ```bash
    python3 -m venv dbt-venv
    source dbt-venv/bin/activate
    ```

3.  **Install dbt and its dependencies**:
    ```bash
    pip install -r requirements.txt # Assuming you have a requirements.txt
    # Or, if you don't have requirements.txt, install dbt-databricks (or your specific adapter)
    pip install dbt-databricks
    ```

4.  **Configure your `profiles.yml`**:
    dbt connects to your data warehouse using connection profiles. You'll need to configure your `profiles.yml` file (typically located in `~/.dbt/profiles.yml` or in the project root if specified in `dbt_project.yml`). An example `profiles.yml` might look like this for Databricks:

    ```yaml
    dbt_demo:
      target: dev
      outputs:
        dev:
          type: databricks
          host: <your_databricks_host>
          http_path: <your_databricks_http_path>
          token: "{{ env_var('DATABRICKS_TOKEN') }}" # Use environment variable for security
          schema: dbt_demo_dev
          catalog: dbt_demo
          threads: 4
    ```
    **Note**: Ensure you set the `DATABRICKS_TOKEN` environment variable or use another secure method for credentials.

## Running dbt Commands

Once set up, you can run various dbt commands:

-   **Check dbt connectivity**:
    ```bash
    dbt debug
    ```

-   **Compile SQL models without running them**:
    ```bash
    dbt compile
    ```

-   **Run all models**:
    ```bash
    dbt run
    ```

-   **Run specific models**:
    ```bash
    dbt run --select stg_customers
    dbt run --select fct_orders+ # Run a model and its downstream dependencies
    ```

-   **Test all models**:
    ```bash
    dbt test
    ```

-   **Generate documentation**:
    ```bash
    dbt docs generate
    ```

-   **Serve documentation locally**:
    ```bash
    dbt docs serve
    ```
    (This will open a local web server where you can browse the documentation.)

-   **Seed data**:
    ```bash
    dbt seed
    ```

## Documentation

Comprehensive documentation for all models, sources, analyses, macros, and tests is generated using `dbt docs generate`. This documentation provides detailed descriptions of each data asset, including column definitions, data types, and applied tests, ensuring a clear understanding of the data pipeline.

To view the documentation, run `dbt docs generate` followed by `dbt docs serve`.

## Contributing

Contributions are welcome! Please follow standard Git practices: fork the repository, create a new branch for your features or bug fixes, and submit a pull request. Ensure your code adheres to the project's coding standards and includes relevant tests and documentation updates.
