USE CATALOG dbt_demo;
USE SCHEMA bronze;

-- Clear existing data (optional)
TRUNCATE TABLE customers;
TRUNCATE TABLE employees;
TRUNCATE TABLE stores;
TRUNCATE TABLE suppliers;
TRUNCATE TABLE products;
TRUNCATE TABLE orders;
TRUNCATE TABLE order_items;
TRUNCATE TABLE dates;

-- Insert Customers (20 records)
INSERT INTO customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '555-0101', '123 Main St', 'New York', 'NY', '10001', current_timestamp()),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '555-0102', '456 Oak Ave', 'Los Angeles', 'CA', '90001', current_timestamp()),
(3, 'Bob', 'Johnson', 'bob.j@email.com', '555-0103', '789 Pine Rd', 'Chicago', 'IL', '60601', current_timestamp()),
(4, 'Alice', 'Williams', 'alice.w@email.com', '555-0104', '321 Elm St', 'Houston', 'TX', '77001', current_timestamp()),
(5, 'Charlie', 'Brown', 'charlie.b@email.com', '555-0105', '654 Maple Dr', 'Phoenix', 'AZ', '85001', current_timestamp()),
(6, 'Diana', 'Davis', 'diana.d@email.com', '555-0106', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', current_timestamp()),
(7, 'Edward', 'Miller', 'edward.m@email.com', '555-0107', '147 Birch Blvd', 'San Antonio', 'TX', '78201', current_timestamp()),
(8, 'Fiona', 'Wilson', 'fiona.w@email.com', '555-0108', '258 Spruce Way', 'San Diego', 'CA', '92101', current_timestamp()),
(9, 'George', 'Moore', 'george.m@email.com', '555-0109', '369 Ash Ave', 'Dallas', 'TX', '75201', current_timestamp()),
(10, 'Helen', 'Taylor', 'helen.t@email.com', '555-0110', '741 Willow St', 'San Jose', 'CA', '95101', current_timestamp()),
(11, 'Ian', 'Anderson', 'ian.a@email.com', '555-0111', '852 Poplar Rd', 'Austin', 'TX', '78701', current_timestamp()),
(12, 'Julia', 'Thomas', 'julia.t@email.com', '555-0112', '963 Sycamore Ln', 'Jacksonville', 'FL', '32201', current_timestamp()),
(13, 'Kevin', 'Jackson', 'kevin.j@email.com', '555-0113', '159 Hickory Dr', 'San Francisco', 'CA', '94101', current_timestamp()),
(14, 'Laura', 'White', 'laura.w@email.com', '555-0114', '357 Chestnut St', 'Columbus', 'OH', '43201', current_timestamp()),
(15, 'Michael', 'Harris', 'michael.h@email.com', '555-0115', '486 Beech Ave', 'Charlotte', 'NC', '28201', current_timestamp()),
(16, 'Nancy', 'Martin', 'nancy.m@email.com', '555-0116', '624 Dogwood Ln', 'Indianapolis', 'IN', '46201', current_timestamp()),
(17, 'Oliver', 'Thompson', 'oliver.t@email.com', '555-0117', '738 Magnolia Blvd', 'Seattle', 'WA', '98101', current_timestamp()),
(18, 'Patricia', 'Garcia', 'patricia.g@email.com', '555-0118', '842 Cherry St', 'Denver', 'CO', '80201', current_timestamp()),
(19, 'Quinn', 'Martinez', 'quinn.m@email.com', '555-0119', '951 Apple Way', 'Boston', 'MA', '02101', current_timestamp()),
(20, 'Rachel', 'Robinson', 'rachel.r@email.com', '555-0120', '753 Pear Dr', 'Nashville', 'TN', '37201', current_timestamp());

-- Insert Employees (20 records)
INSERT INTO employees VALUES
(1, 'Mike', 'Wilson', 'mike.w@company.com', 'Store Manager', '2020-01-15', NULL, '321 Elm St', 'New York', 'NY', '10002', current_timestamp()),
(2, 'Sarah', 'Davis', 'sarah.d@company.com', 'Sales Associate', '2021-03-20', 1, '654 Maple Dr', 'New York', 'NY', '10003', current_timestamp()),
(3, 'Tom', 'Lee', 'tom.l@company.com', 'Assistant Manager', '2020-06-10', 1, '987 Oak Ave', 'Los Angeles', 'CA', '90002', current_timestamp()),
(4, 'Emma', 'Chen', 'emma.c@company.com', 'Sales Associate', '2021-11-05', 3, '123 Pine St', 'Los Angeles', 'CA', '90003', current_timestamp()),
(5, 'James', 'Taylor', 'james.t@company.com', 'Store Manager', '2019-08-22', NULL, '456 Cedar Ln', 'Chicago', 'IL', '60602', current_timestamp()),
(6, 'Lisa', 'Anderson', 'lisa.a@company.com', 'Sales Associate', '2022-01-18', 5, '789 Birch Rd', 'Chicago', 'IL', '60603', current_timestamp()),
(7, 'Robert', 'Johnson', 'robert.j@company.com', 'Warehouse Manager', '2020-04-12', NULL, '147 Spruce Way', 'Houston', 'TX', '77002', current_timestamp()),
(8, 'Maria', 'Garcia', 'maria.g@company.com', 'Inventory Specialist', '2021-07-30', 7, '258 Ash Blvd', 'Houston', 'TX', '77003', current_timestamp()),
(9, 'David', 'Brown', 'david.b@company.com', 'Regional Manager', '2018-12-01', NULL, '369 Willow St', 'Phoenix', 'AZ', '85002', current_timestamp()),
(10, 'Jennifer', 'Miller', 'jennifer.m@company.com', 'HR Manager', '2019-05-15', 9, '741 Poplar Ave', 'Phoenix', 'AZ', '85003', current_timestamp()),
(11, 'William', 'Jones', 'william.j@company.com', 'Sales Associate', '2022-03-25', 1, '852 Sycamore Dr', 'New York', 'NY', '10004', current_timestamp()),
(12, 'Amanda', 'White', 'amanda.w@company.com', 'Customer Service', '2021-09-10', 3, '963 Hickory Ln', 'Los Angeles', 'CA', '90004', current_timestamp()),
(13, 'Richard', 'Harris', 'richard.h@company.com', 'IT Specialist', '2020-11-20', 9, '159 Chestnut Blvd', 'Chicago', 'IL', '60604', current_timestamp()),
(14, 'Susan', 'Martin', 'susan.m@company.com', 'Marketing Manager', '2019-02-28', 9, '357 Beech St', 'Houston', 'TX', '77004', current_timestamp()),
(15, 'Joseph', 'Thompson', 'joseph.t@company.com', 'Finance Manager', '2018-07-14', 9, '486 Dogwood Ave', 'Phoenix', 'AZ', '85004', current_timestamp()),
(16, 'Karen', 'Moore', 'karen.m@company.com', 'Sales Associate', '2022-05-08', 5, '624 Magnolia Way', 'Chicago', 'IL', '60605', current_timestamp()),
(17, 'Christopher', 'Taylor', 'chris.t@company.com', 'Security Manager', '2020-09-03', 9, '738 Cherry Dr', 'New York', 'NY', '10005', current_timestamp()),
(18, 'Michelle', 'Walker', 'michelle.w@company.com', 'Training Coordinator', '2021-12-12', 10, '842 Apple Ln', 'Los Angeles', 'CA', '90005', current_timestamp()),
(19, 'Daniel', 'Hall', 'daniel.h@company.com', 'Sales Associate', '2022-08-17', 1, '951 Pear Blvd', 'Houston', 'TX', '77005', current_timestamp()),
(20, 'Ashley', 'Young', 'ashley.y@company.com', 'Operations Manager', '2019-10-25', 9, '753 Plum St', 'Phoenix', 'AZ', '85005', current_timestamp());

-- Insert Stores (10 records - realistic for a retail chain)
INSERT INTO stores VALUES
(1, 'Downtown Store', '100 Commerce St', 'New York', 'NY', '10001', 'downtown@store.com', '555-1000', current_timestamp()),
(2, 'Uptown Store', '200 Fashion Ave', 'New York', 'NY', '10002', 'uptown@store.com', '555-2000', current_timestamp()),
(3, 'LA Central', '300 Sunset Blvd', 'Los Angeles', 'CA', '90001', 'lacentral@store.com', '555-3000', current_timestamp()),
(4, 'LA Beach', '400 Ocean Dr', 'Los Angeles', 'CA', '90002', 'labeach@store.com', '555-4000', current_timestamp()),
(5, 'Chicago Loop', '500 Michigan Ave', 'Chicago', 'IL', '60601', 'chicagoloop@store.com', '555-5000', current_timestamp()),
(6, 'Houston Galleria', '600 Post Oak Blvd', 'Houston', 'TX', '77001', 'houstongalleria@store.com', '555-6000', current_timestamp()),
(7, 'Phoenix Central', '700 Camelback Rd', 'Phoenix', 'AZ', '85001', 'phoenixcentral@store.com', '555-7000', current_timestamp()),
(8, 'Online Store', '999 Web Plaza', 'Seattle', 'WA', '98101', 'online@store.com', '555-9999', current_timestamp()),
(9, 'Warehouse East', '800 Industrial Way', 'Newark', 'NJ', '07101', 'warehouseeast@store.com', '555-8000', current_timestamp()),
(10, 'Warehouse West', '900 Logistics Blvd', 'Ontario', 'CA', '91761', 'warehousewest@store.com', '555-9000', current_timestamp());

-- Insert Suppliers (15 records)
INSERT INTO suppliers VALUES
(1, 'TechSupply Co', 'Tom Anderson', 'tom@techsupply.com', '555-5001', '500 Tech Blvd', 'San Jose', 'CA', '95001', current_timestamp()),
(2, 'Fashion Wholesale', 'Lisa Chen', 'lisa@fashionwholesale.com', '555-5002', '600 Style St', 'Los Angeles', 'CA', '90002', current_timestamp()),
(3, 'Electronics Direct', 'John Smith', 'john@electronicsdirect.com', '555-5003', '700 Circuit Ave', 'Austin', 'TX', '78701', current_timestamp()),
(4, 'Clothing Express', 'Mary Johnson', 'mary@clothingexpress.com', '555-5004', '800 Fabric Ln', 'New York', 'NY', '10010', current_timestamp()),
(5, 'Home Goods Plus', 'Robert Brown', 'robert@homegoodsplus.com', '555-5005', '900 Comfort Rd', 'Chicago', 'IL', '60610', current_timestamp()),
(6, 'Sports Equipment Pro', 'Sarah Davis', 'sarah@sportsequipro.com', '555-5006', '100 Athletic Way', 'Denver', 'CO', '80201', current_timestamp()),
(7, 'Book Publishers Inc', 'Michael Wilson', 'michael@bookpublishers.com', '555-5007', '200 Literature Blvd', 'Boston', 'MA', '02110', current_timestamp()),
(8, 'Toy Factory Direct', 'Jennifer Lee', 'jennifer@toyfactory.com', '555-5008', '300 Fun St', 'Minneapolis', 'MN', '55401', current_timestamp()),
(9, 'Beauty Supply Co', 'Amanda Garcia', 'amanda@beautysupply.com', '555-5009', '400 Glamour Ave', 'Miami', 'FL', '33101', current_timestamp()),
(10, 'Office Supplies Ltd', 'David Martinez', 'david@officesupplies.com', '555-5010', '500 Business Park', 'Atlanta', 'GA', '30301', current_timestamp()),
(11, 'Outdoor Gear Wholesale', 'Chris Thompson', 'chris@outdoorgear.com', '555-5011', '600 Adventure Rd', 'Seattle', 'WA', '98110', current_timestamp()),
(12, 'Kitchen Supplies Pro', 'Patricia White', 'patricia@kitchensupplies.com', '555-5012', '700 Culinary Way', 'Portland', 'OR', '97201', current_timestamp()),
(13, 'Pet Supplies Direct', 'James Harris', 'james@petsupplies.com', '555-5013', '800 Animal Ln', 'San Diego', 'CA', '92101', current_timestamp()),
(14, 'Music Instruments Co', 'Linda Clark', 'linda@musicinstruments.com', '555-5014', '900 Melody St', 'Nashville', 'TN', '37201', current_timestamp()),
(15, 'Garden Supplies Inc', 'Richard Lewis', 'richard@gardensupplies.com', '555-5015', '1000 Green Thumb Blvd', 'Sacramento', 'CA', '95814', current_timestamp());

-- Insert Products (30 records)
INSERT INTO products VALUES
(1, 'Laptop Pro 15', 'Electronics', 1299.99, 899.99, 1, current_timestamp()),
(2, 'Wireless Mouse', 'Electronics', 29.99, 15.99, 1, current_timestamp()),
(3, 'USB-C Hub', 'Electronics', 49.99, 25.99, 3, current_timestamp()),
(4, 'Mechanical Keyboard', 'Electronics', 149.99, 89.99, 3, current_timestamp()),
(5, '27" Monitor', 'Electronics', 399.99, 249.99, 1, current_timestamp()),
(6, 'Designer T-Shirt', 'Clothing', 49.99, 25.99, 2, current_timestamp()),
(7, 'Premium Jeans', 'Clothing', 89.99, 45.99, 2, current_timestamp()),
(8, 'Running Shoes', 'Clothing', 129.99, 69.99, 4, current_timestamp()),
(9, 'Winter Jacket', 'Clothing', 199.99, 99.99, 4, current_timestamp()),
(10, 'Baseball Cap', 'Clothing', 24.99, 12.99, 4, current_timestamp()),
(11, 'Coffee Maker', 'Home', 79.99, 39.99, 5, current_timestamp()),
(12, 'Blender Pro', 'Home', 99.99, 49.99, 12, current_timestamp()),
(13, 'Vacuum Cleaner', 'Home', 249.99, 149.99, 5, current_timestamp()),
(14, 'Air Purifier', 'Home', 199.99, 119.99, 5, current_timestamp()),
(15, 'Smart Thermostat', 'Home', 179.99, 99.99, 3, current_timestamp()),
(16, 'Yoga Mat', 'Sports', 39.99, 19.99, 6, current_timestamp()),
(17, 'Dumbbell Set', 'Sports', 149.99, 89.99, 6, current_timestamp()),
(18, 'Tennis Racket', 'Sports', 199.99, 119.99, 6, current_timestamp()),
(19, 'Basketball', 'Sports', 29.99, 14.99, 6, current_timestamp()),
(20, 'Fitness Tracker', 'Electronics', 99.99, 59.99, 1, current_timestamp()),
(21, 'Best Seller Novel', 'Books', 24.99, 14.99, 7, current_timestamp()),
(22, 'Cookbook Deluxe', 'Books', 34.99, 19.99, 7, current_timestamp()),
(23, 'Children Picture Book', 'Books', 14.99, 8.99, 7, current_timestamp()),
(24, 'Building Blocks Set', 'Toys', 49.99, 29.99, 8, current_timestamp()),
(25, 'Remote Control Car', 'Toys', 79.99, 44.99, 8, current_timestamp()),
(26, 'Face Cream Premium', 'Beauty', 59.99, 34.99, 9, current_timestamp()),
(27, 'Shampoo Professional', 'Beauty', 29.99, 16.99, 9, current_timestamp()),
(28, 'Office Chair Ergonomic', 'Office', 399.99, 249.99, 10, current_timestamp()),
(29, 'Desk Lamp LED', 'Office', 49.99, 24.99, 10, current_timestamp()),
(30, 'Camping Tent 4-Person', 'Outdoor', 299.99, 179.99, 11, current_timestamp());

-- Insert Orders (30 records for January 2024)
INSERT INTO orders VALUES
(1, '2024-01-02', 1, 2, 1, 'completed', current_timestamp()),
(2, '2024-01-02', 2, 4, 3, 'completed', current_timestamp()),
(3, '2024-01-03', 3, 2, 1, 'completed', current_timestamp()),
(4, '2024-01-04', 4, 6, 5, 'completed', current_timestamp()),
(5, '2024-01-05', 5, 2, 1, 'completed', current_timestamp()),
(6, '2024-01-06', 6, 4, 3, 'processing', current_timestamp()),
(7, '2024-01-07', 7, 6, 5, 'completed', current_timestamp()),
(8, '2024-01-08', 8, 2, 1, 'completed', current_timestamp()),
(9, '2024-01-09', 9, 4, 3, 'completed', current_timestamp()),
(10, '2024-01-10', 10, 6, 5, 'completed', current_timestamp()),
(11, '2024-01-11', 11, 11, 2, 'completed', current_timestamp()),
(12, '2024-01-12', 12, 12, 4, 'completed', current_timestamp()),
(13, '2024-01-13', 13, 2, 1, 'processing', current_timestamp()),
(14, '2024-01-14', 14, 4, 3, 'completed', current_timestamp()),
(15, '2024-01-15', 15, 6, 5, 'completed', current_timestamp()),
(16, '2024-01-16', 16, 11, 2, 'completed', current_timestamp()),
(17, '2024-01-17', 17, 12, 4, 'cancelled', current_timestamp()),
(18, '2024-01-18', 18, 2, 1, 'completed', current_timestamp()),
(19, '2024-01-19', 19, 4, 3, 'completed', current_timestamp()),
(20, '2024-01-20', 20, 6, 5, 'completed', current_timestamp()),
(21, '2024-01-21', 1, 11, 2, 'completed', current_timestamp()),
(22, '2024-01-22', 3, 12, 4, 'processing', current_timestamp()),
(23, '2024-01-23', 5, 2, 1, 'completed', current_timestamp()),
(24, '2024-01-24', 7, 4, 3, 'completed', current_timestamp()),
(25, '2024-01-25', 9, 6, 5, 'completed', current_timestamp()),
(26, '2024-01-26', 11, 11, 8, 'completed', current_timestamp()),
(27, '2024-01-27', 13, 12, 8, 'processing', current_timestamp()),
(28, '2024-01-28', 15, 2, 1, 'completed', current_timestamp()),
(29, '2024-01-29', 17, 4, 3, 'completed', current_timestamp()),
(30, '2024-01-30', 19, 6, 5, 'completed', current_timestamp());

-- Insert Order Items (50+ records)
INSERT INTO order_items VALUES
(1, 1, 1, 1, 1299.99, current_timestamp()),
(2, 1, 2, 2, 29.99, current_timestamp()),
(3, 2, 6, 3, 49.99, current_timestamp()),
(4, 2, 7, 1, 89.99, current_timestamp()),
(5, 3, 11, 1, 79.99, current_timestamp()),
(6, 4, 16, 2, 39.99, current_timestamp()),
(7, 5, 3, 1, 49.99, current_timestamp()),
(8, 5, 4, 1, 149.99, current_timestamp()),
(9, 6, 8, 1, 129.99, current_timestamp()),
(10, 7, 13, 1, 249.99, current_timestamp()),
(11, 8, 21, 2, 24.99, current_timestamp()),
(12, 9, 26, 1, 59.99, current_timestamp()),
(13, 10, 28, 1, 399.99, current_timestamp()),
(14, 11, 5, 1, 399.99, current_timestamp()),
(15, 11, 20, 1, 99.99, current_timestamp()),
(16, 12, 9, 1, 199.99, current_timestamp()),
(17, 13, 24, 2, 49.99, current_timestamp()),
(18, 14, 12, 1, 99.99, current_timestamp()),
(19, 15, 30, 1, 299.99, current_timestamp()),
(20, 16, 10, 3, 24.99, current_timestamp()),
(21, 17, 15, 1, 179.99, current_timestamp()),
(22, 18, 22, 1, 34.99, current_timestamp()),
(23, 19, 27, 2, 29.99, current_timestamp()),
(24, 20, 29, 1, 49.99, current_timestamp()),
(25, 21, 1, 1, 1299.99, current_timestamp()),
(26, 21, 3, 2, 49.99, current_timestamp()),
(27, 22, 7, 2, 89.99, current_timestamp()),
(28, 23, 14, 1, 199.99, current_timestamp()),
(29, 24, 17, 1, 149.99, current_timestamp()),
(30, 24, 18, 1, 199.99, current_timestamp()),
(31, 25, 19, 3, 29.99, current_timestamp()),
(32, 26, 2, 5, 29.99, current_timestamp()),
(33, 26, 4, 2, 149.99, current_timestamp()),
(34, 27, 6, 4, 49.99, current_timestamp()),
(35, 28, 11, 2, 79.99, current_timestamp()),
(36, 28, 12, 1, 99.99, current_timestamp()),
(37, 29, 23, 5, 14.99, current_timestamp()),
(38, 30, 25, 1, 79.99, current_timestamp()),
(39, 30, 16, 2, 39.99, current_timestamp()),
(40, 1, 5, 1, 399.99, current_timestamp()),
(41, 3, 13, 1, 249.99, current_timestamp()),
(42, 5, 20, 2, 99.99, current_timestamp()),
(43, 7, 26, 1, 59.99, current_timestamp()),
(44, 9, 8, 1, 129.99, current_timestamp()),
(45, 11, 28, 1, 399.99, current_timestamp()),
(46, 13, 30, 1, 299.99, current_timestamp()),
(47, 15, 21, 3, 24.99, current_timestamp()),
(48, 17, 9, 1, 199.99, current_timestamp()),
(49, 19, 15, 1, 179.99, current_timestamp()),
(50, 21, 2, 3, 29.99, current_timestamp());

-- Insert Dates for January 2024
INSERT INTO dates VALUES
('2024-01-01', 'Mon', 'January', '2024', 1, 'Monday', 1, current_timestamp()),
('2024-01-02', 'Tue', 'January', '2024', 1, 'Tuesday', 1, current_timestamp()),
('2024-01-03', 'Wed', 'January', '2024', 1, 'Wednesday', 1, current_timestamp()),
('2024-01-04', 'Thu', 'January', '2024', 1, 'Thursday', 1, current_timestamp()),
('2024-01-05', 'Fri', 'January', '2024', 1, 'Friday', 1, current_timestamp()),
('2024-01-06', 'Sat', 'January', '2024', 1, 'Saturday', 1, current_timestamp()),
('2024-01-07', 'Sun', 'January', '2024', 1, 'Sunday', 1, current_timestamp()),
('2024-01-08', 'Mon', 'January', '2024', 1, 'Monday', 2, current_timestamp()),
('2024-01-09', 'Tue', 'January', '2024', 1, 'Tuesday', 2, current_timestamp()),
('2024-01-10', 'Wed', 'January', '2024', 1, 'Wednesday', 2, current_timestamp()),
('2024-01-11', 'Thu', 'January', '2024', 1, 'Thursday', 2, current_timestamp()),
('2024-01-12', 'Fri', 'January', '2024', 1, 'Friday', 2, current_timestamp()),
('2024-01-13', 'Sat', 'January', '2024', 1, 'Saturday', 2, current_timestamp()),
('2024-01-14', 'Sun', 'January', '2024', 1, 'Sunday', 2, current_timestamp()),
('2024-01-15', 'Mon', 'January', '2024', 1, 'Monday', 3, current_timestamp()),
('2024-01-16', 'Tue', 'January', '2024', 1, 'Tuesday', 3, current_timestamp()),
('2024-01-17', 'Wed', 'January', '2024', 1, 'Wednesday', 3, current_timestamp()),
('2024-01-18', 'Thu', 'January', '2024', 1, 'Thursday', 3, current_timestamp()),
('2024-01-19', 'Fri', 'January', '2024', 1, 'Friday', 3, current_timestamp()),
('2024-01-20', 'Sat', 'January', '2024', 1, 'Saturday', 3, current_timestamp()),
('2024-01-21', 'Sun', 'January', '2024', 1, 'Sunday', 3, current_timestamp()),
('2024-01-22', 'Mon', 'January', '2024', 1, 'Monday', 4, current_timestamp()),
('2024-01-23', 'Tue', 'January', '2024', 1, 'Tuesday', 4, current_timestamp()),
('2024-01-24', 'Wed', 'January', '2024', 1, 'Wednesday', 4, current_timestamp()),
('2024-01-25', 'Thu', 'January', '2024', 1, 'Thursday', 4, current_timestamp()),
('2024-01-26', 'Fri', 'January', '2024', 1, 'Friday', 4, current_timestamp()),
('2024-01-27', 'Sat', 'January', '2024', 1, 'Saturday', 4, current_timestamp()),
('2024-01-28', 'Sun', 'January', '2024', 1, 'Sunday', 4, current_timestamp()),
('2024-01-29', 'Mon', 'January', '2024', 1, 'Monday', 5, current_timestamp()),
('2024-01-30', 'Tue', 'January', '2024', 1, 'Tuesday', 5, current_timestamp()),
('2024-01-31', 'Wed', 'January', '2024', 1, 'Wednesday', 5, current_timestamp());

-- Verify counts
SELECT 'customers' as table_name, COUNT(*) as record_count FROM customers
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'stores', COUNT(*) FROM stores
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'dates', COUNT(*) FROM dates;