WITH table_1 AS(SELECT
	date_trunc('month', order_purchase_timestamp::DATE) AS MONTH,
	sum(oopd.payment_value) AS gmv, count(DISTINCT ood.order_id) AS cnt_order
FROM
	olist_orders_dataset ood
JOIN olist_order_payments_dataset oopd ON
	ood.order_id = oopd.order_id
GROUP BY
	date_trunc('month', order_purchase_timestamp::DATE)
	ORDER BY date_trunc('month', order_purchase_timestamp::DATE) ASC),
table_2 AS (
	SELECT
		t1."month"::DATE AS MONTH,
		t1.gmv,
		LAG(gmv) OVER() AS last_month_gmv,
		t1.cnt_order
	FROM
		table_1 t1
)
SELECT
	t2.MONTH,
	t2.gmv,
	ROUND(((t2.gmv - last_month_gmv) / last_month_gmv * 100)::NUMERIC, 2) AS percent_at_last_month,
	t2.cnt_order
FROM
	table_2 t2