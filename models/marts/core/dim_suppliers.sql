-- Dimension table for suppliers with product metrics and performance indicators
WITH supplier_base AS (
    SELECT * FROM {{ ref('stg_suppliers') }}
),

supplier_metrics AS (
    SELECT 
        s.supplier_id,
        COUNT(DISTINCT p.product_id) as total_products,
        COUNT(DISTINCT p.category) as product_categories_count,
        AVG(p.retail_price) as avg_product_price,
        AVG(p.margin_percent) as avg_margin_percent,
        MIN(p.retail_price) as min_product_price,
        MAX(p.retail_price) as max_product_price,
        SUM(COALESCE(oi.quantity, 0)) as total_quantity_sold,
        SUM(COALESCE(oi.line_total, 0)) as total_revenue_generated
    FROM {{ ref('stg_suppliers') }} s
    LEFT JOIN {{ ref('stg_products') }} p ON s.supplier_id = p.supplier_id
    LEFT JOIN {{ ref('stg_order_items') }} oi ON p.product_id = oi.product_id
    GROUP BY s.supplier_id
),

supplier_product_categories AS (
    SELECT 
        s.supplier_id,
        LISTAGG(DISTINCT p.category, ', ') as product_categories_list
    FROM {{ ref('stg_suppliers') }} s
    LEFT JOIN {{ ref('stg_products') }} p ON s.supplier_id = p.supplier_id
    WHERE p.category IS NOT NULL
    GROUP BY s.supplier_id
)

SELECT 
    sb.supplier_id,
    sb.supplier_name,
    sb.contact_person,
    sb.email,
    sb.phone,
    sb.address,
    sb.city,
    sb.state,
    sb.zip_code,
    sb.updated_at,
    
    -- Product portfolio metrics
    COALESCE(sm.total_products, 0) as total_products,
    COALESCE(sm.product_categories_count, 0) as product_categories_count,
    COALESCE(sm.avg_product_price, 0) as avg_product_price,
    COALESCE(sm.avg_margin_percent, 0) as avg_margin_percent,
    COALESCE(sm.min_product_price, 0) as min_product_price,
    COALESCE(sm.max_product_price, 0) as max_product_price,
    COALESCE(sm.total_quantity_sold, 0) as total_quantity_sold,
    COALESCE(sm.total_revenue_generated, 0) as total_revenue_generated,
    
    -- Product categories served
    COALESCE(spc.product_categories_list, 'No Products') as product_categories_list,
    
    -- Geographic classification
    CASE 
        WHEN sb.state IN ('CA', 'WA', 'OR', 'NV', 'AZ') THEN 'West'
        WHEN sb.state IN ('TX', 'OK', 'AR', 'LA', 'NM') THEN 'Southwest'
        WHEN sb.state IN ('IL', 'IN', 'MI', 'OH', 'WI') THEN 'Midwest'
        WHEN sb.state IN ('NY', 'NJ', 'PA', 'CT', 'MA', 'ME', 'NH', 'VT', 'RI') THEN 'Northeast'
        WHEN sb.state IN ('FL', 'GA', 'SC', 'NC', 'VA', 'TN', 'KY', 'WV', 'MD', 'DE', 'DC') THEN 'Southeast'
        ELSE 'Other'
    END as region,
    
    -- Supplier tier based on portfolio size and performance
    CASE 
        WHEN COALESCE(sm.total_products, 0) = 0 THEN 'No Active Products'
        WHEN sm.total_products >= 10 AND sm.total_revenue_generated >= 100000 THEN 'Strategic Partner'
        WHEN sm.total_products >= 5 AND sm.total_revenue_generated >= 50000 THEN 'Key Supplier'
        WHEN sm.total_products >= 2 THEN 'Standard Supplier'
        ELSE 'Minor Supplier'
    END as supplier_tier,
    
    -- Price positioning
    CASE 
        WHEN COALESCE(sm.avg_product_price, 0) = 0 THEN 'No Products'
        WHEN sm.avg_product_price < 50 THEN 'Budget Supplier'
        WHEN sm.avg_product_price < 200 THEN 'Mid-Range Supplier'
        WHEN sm.avg_product_price < 500 THEN 'Premium Supplier'
        ELSE 'Luxury Supplier'
    END as price_tier,
    
    -- Margin performance
    CASE 
        WHEN COALESCE(sm.avg_margin_percent, 0) = 0 THEN 'No Data'
        WHEN sm.avg_margin_percent >= 40 THEN 'High Margin'
        WHEN sm.avg_margin_percent >= 25 THEN 'Good Margin'
        WHEN sm.avg_margin_percent >= 15 THEN 'Average Margin'
        ELSE 'Low Margin'
    END as margin_category,
    
    -- Portfolio diversity
    CASE 
        WHEN COALESCE(sm.product_categories_count, 0) = 0 THEN 'No Products'
        WHEN sm.product_categories_count = 1 THEN 'Specialist'
        WHEN sm.product_categories_count <= 3 THEN 'Focused'
        ELSE 'Diversified'
    END as portfolio_diversity,
    
    -- Performance status based on sales
    CASE 
        WHEN COALESCE(sm.total_quantity_sold, 0) = 0 THEN 'No Sales'
        WHEN sm.total_quantity_sold >= 100 THEN 'High Volume'
        WHEN sm.total_quantity_sold >= 50 THEN 'Medium Volume'
        ELSE 'Low Volume'
    END as sales_performance

FROM supplier_base sb
LEFT JOIN supplier_metrics sm ON sb.supplier_id = sm.supplier_id
LEFT JOIN supplier_product_categories spc ON sb.supplier_id = spc.supplier_id