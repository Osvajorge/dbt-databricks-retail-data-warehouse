-- Dimension table for products with category information and metrics
WITH product_base AS (
    SELECT * FROM {{ ref('stg_products') }}
),

product_categories AS (
    SELECT * FROM {{ ref('product_categories') }}
),

suppliers AS (
    SELECT * FROM {{ ref('stg_suppliers') }}
),

product_metrics AS (
    SELECT 
        p.product_id,
        COUNT(DISTINCT oi.order_id) as total_orders,
        SUM(oi.quantity) as total_quantity_sold,
        SUM(oi.line_total) as total_revenue,
        AVG(oi.quantity) as avg_quantity_per_order,
        MAX(o.order_date) as last_order_date
    FROM {{ ref('stg_products') }} p
    LEFT JOIN {{ ref('stg_order_items') }} oi ON p.product_id = oi.product_id
    LEFT JOIN {{ ref('stg_orders') }} o ON oi.order_id = o.order_id
    WHERE o.status_desc = 'Completed' OR o.status_desc IS NULL
    GROUP BY p.product_id
)

SELECT 
    pb.product_id,
    pb.product_name,
    pb.category,
    pb.retail_price,
    pb.supplier_price,
    pb.margin_amount,
    pb.margin_percent,
    pb.supplier_id,
    pb.updated_at,
    
    -- Supplier information
    s.supplier_name,
    s.contact_person as supplier_contact,
    s.city as supplier_city,
    s.state as supplier_state,
    
    -- Category enrichment
    COALESCE(pc.category_group, 'Uncategorized') as category_group,
    COALESCE(pc.margin_target, 0.30) as target_margin_percent,
    
    -- Performance metrics
    COALESCE(pm.total_orders, 0) as total_orders,
    COALESCE(pm.total_quantity_sold, 0) as total_quantity_sold,
    COALESCE(pm.total_revenue, 0) as total_revenue,
    COALESCE(pm.avg_quantity_per_order, 0) as avg_quantity_per_order,
    pm.last_order_date,
    
    -- Calculated fields
    CASE 
        WHEN pm.total_quantity_sold IS NULL THEN 'Never Sold'
        WHEN pm.total_quantity_sold = 0 THEN 'Never Sold'
        WHEN pm.last_order_date >= DATEADD(DAY, -30, CURRENT_DATE()) THEN 'Active'
        WHEN pm.last_order_date >= DATEADD(DAY, -90, CURRENT_DATE()) THEN 'Slow Moving'
        ELSE 'Inactive'
    END as product_status,
    
    -- Price tier classification
    CASE 
        WHEN pb.retail_price < 25 THEN 'Budget'
        WHEN pb.retail_price < 100 THEN 'Standard'
        WHEN pb.retail_price < 500 THEN 'Premium'
        ELSE 'Luxury'
    END as price_tier,
    
    -- Margin performance vs target
    CASE 
        WHEN pc.margin_target IS NULL THEN 'No Target'
        WHEN (pb.margin_percent / 100) >= pc.margin_target THEN 'Above Target'
        WHEN (pb.margin_percent / 100) >= (pc.margin_target * 0.9) THEN 'Near Target'
        ELSE 'Below Target'
    END as margin_performance

FROM product_base pb
LEFT JOIN suppliers s ON pb.supplier_id = s.supplier_id
LEFT JOIN product_categories pc ON pb.category = pc.category
LEFT JOIN product_metrics pm ON pb.product_id = pm.product_id