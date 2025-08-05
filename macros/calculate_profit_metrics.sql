{% macro calculate_profit_metrics(date_column, quantity_column, retail_price_column, supplier_price_column) %}
    -- Total Revenue
    SUM({{ quantity_column }} * {{ retail_price_column }}) AS total_revenue,
    
    -- Total Cost  
    SUM({{ quantity_column }} * {{ supplier_price_column }}) AS total_cost,
    
    -- Total Profit
    SUM({{ quantity_column }} * ({{ retail_price_column }} - {{ supplier_price_column }})) AS total_profit,
    
    -- Profit Margin %
    ROUND(
        (SUM({{ quantity_column }} * ({{ retail_price_column }} - {{ supplier_price_column }})) / 
         NULLIF(SUM({{ quantity_column }} * {{ retail_price_column }}), 0)) * 100, 
    2) AS profit_margin_pct

{% endmacro %}