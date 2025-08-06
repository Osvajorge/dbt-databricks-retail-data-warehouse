-- Set up the catalog
USE CATALOG dbt_demo;

-- Create schemas for medallion architecture
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- Use bronze schema for source tables (raw data)
USE SCHEMA bronze;

-- Create all source tables without DEFAULT values
CREATE TABLE IF NOT EXISTS dates (
    date_id DATE NOT NULL,
    day VARCHAR(3),
    month VARCHAR(10),
    year VARCHAR(4),
    quarter INT,
    day_of_week VARCHAR(10),
    week_of_year INT,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(200),
    phone VARCHAR(50),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id INT NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(200),
    job_title VARCHAR(100),
    hire_date DATE,
    manager_id INT,
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stores (
    store_id INT NOT NULL,
    store_name VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    email VARCHAR(200),
    phone VARCHAR(50),
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INT NOT NULL,
    supplier_name VARCHAR(100),
    contact_person VARCHAR(100),
    email VARCHAR(200),
    phone VARCHAR(50),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT NOT NULL,
    name VARCHAR(100),
    category VARCHAR(100),
    retail_price DECIMAL(10,2),
    supplier_price DECIMAL(10,2),
    supplier_id INT,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT NOT NULL,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT NOT NULL,
    order_date DATE,
    customer_id INT,
    employee_id INT,
    store_id INT,
    status VARCHAR(50),
    updated_at TIMESTAMP
);

-- Verify tables were created successfully
SHOW TABLES IN bronze;