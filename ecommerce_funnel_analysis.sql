/*
E-commerce Conversion & Revenue Lifecycle Analysis
Skills used: CTEs, Conditional Aggregation, Time-Series Analysis (TIMESTAMPDIFF), 
Financial Safeguards (COALESCE, NULLIF), Unit Economics (AOV, RPV)
*/

-- Initial data check

SELECT * FROM user_events;

-- DEFINE SALES FUNNEL AND DIFFRERENT STAGES

WITH funnel_stages AS (
	SELECT 
		COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END) AS stage_1_views,
		COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END) AS stage_5_purchase
 FROM user_events
 
 WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
 )
 SELECT * FROM funnel_stages;
 
 -- CONVERSION RATE THROUGH THE FUNNEL
 
 WITH funnel_stages AS (
	SELECT 
		COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END) AS stage_1_views,
		COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END) AS stage_5_purchase
 FROM user_events
 
 WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
 )
 
SELECT 
stage_1_views,

stage_2_cart,
ROUND(stage_2_cart *100/stage_1_views) As view_to_cart_rate,

stage_3_checkout,
ROUND(stage_3_checkout *100/stage_2_cart) As cart_to_checkout_rate,

stage_4_payment,
ROUND(stage_4_payment *100/stage_3_checkout) As checkout_to_payment_rate,

stage_5_purchase,
ROUND(stage_5_purchase *100/stage_4_payment) As payment_to_purchase_rate,

ROUND(stage_5_purchase *100/stage_1_views) As overall_conversion_rate
 
 FROM funnel_stages;
 
 -- funnel by source
 
WITH source_funnel AS (
SELECT traffic_source,
		COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END) AS views,
		COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END) AS cart,
        COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END) AS purchase
FROM user_events
WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
GROUP BY traffic_source
)
SELECT traffic_source,
views,
purchase,
ROUND(cart *100/views) As cart_conversion_rate,
ROUND(purchase *100/views) As cart_conversion_rate,
ROUND(purchase *100/cart) As cart_to_purchase_conversion_rate

FROM source_funnel
ORDER BY purchase DESC;

-- Time to conversion analysis

WITH user_journey AS (
SELECT user_id,
		MIN(CASE WHEN event_type ='page_view' THEN event_date END) AS view_time,
		MIN( CASE WHEN event_type ='add_to_cart' THEN event_date END) AS cart_time,
        MIN( CASE WHEN event_type ='purchase' THEN event_date END) AS purchase_time
FROM user_events
WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
GROUP BY user_id
HAVING purchase_time IS NOT NULL
)
SELECT 
	COUNT(*) AS converted_users,
	ROUND(AVG(TIMESTAMPDIFF(MINUTE,view_time,cart_time)),2) AS avg_view_to_cart_minutes,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE,cart_time,purchase_time)),2) AS avg_cart_to_purchase_minutes,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE,view_time,purchase_time)),2) AS avg_total_journey_minutes
 FROM user_journey;


-- revenue funnel analysis
WITH funnel_revenue AS (
SELECT 
		COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END) AS total_visitors,
        COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END) AS total_buyers,
		COALESCE(SUM(CASE WHEN event_type ='purchase' THEN amount END),0) AS total_revenue,
		COUNT(CASE WHEN event_type ='purchase' THEN 1 END) AS total_orders

FROM user_events
WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
)
SELECT
total_visitors,
total_buyers,
total_orders,
total_revenue,
total_revenue/NULLIF(total_orders,0) AS avg_order_value,
total_revenue/NULLIF(total_buyers,0) AS revenue_per_buyer,
total_revenue/NULLIF(total_visitors,0) AS revenue_per_visitor
FROM funnel_revenue
