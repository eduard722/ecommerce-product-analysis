WITH table_1 AS(SELECT
		customer_unique_id,
		'2018-10-17'::DATE - max(ood.order_purchase_timestamp::DATE) AS recency_days,
		count(DISTINCT ood.order_id) AS frequency,
		round(sum(oopd.payment_value::NUMERIC), 2) AS monetary,
		CASE
			WHEN '2018-10-17'::DATE - max(ood.order_purchase_timestamp::DATE) <= 142 THEN '5'
		WHEN '2018-10-17'::DATE - max(ood.order_purchase_timestamp::DATE) <= 227 THEN '4'
		WHEN '2018-10-17'::DATE - max(ood.order_purchase_timestamp::DATE) <= 318 THEN '3'
		WHEN '2018-10-17'::DATE - max(ood.order_purchase_timestamp::DATE) <= 433 THEN '2'
		ELSE '1'
	END AS r_score,
	CASE
		WHEN count(DISTINCT ood.order_id) = 1 THEN '1'
		WHEN count(DISTINCT ood.order_id) = 2 THEN '2'
		WHEN count(DISTINCT ood.order_id) = 3 THEN '3'
		WHEN count(DISTINCT ood.order_id) BETWEEN 4 AND 5 THEN '4'
		ELSE '5'
	END AS f_score,
		CASE
			WHEN round(sum(oopd.payment_value::NUMERIC), 2) <= 55.37 THEN '1'
		WHEN round(sum(oopd.payment_value::NUMERIC), 2) <= 87.56 THEN '2'
		WHEN round(sum(oopd.payment_value::NUMERIC), 2) <= 133.21 THEN '3'
		WHEN round(sum(oopd.payment_value::NUMERIC), 2) <= 209.604 THEN '4'
		ELSE '5'
	END AS m_score
FROM
			olist_customers_dataset ocd
JOIN olist_orders_dataset ood ON
			ood.customer_id = ocd.customer_id
JOIN olist_order_payments_dataset oopd ON
			ood.order_id = oopd.order_id
GROUP BY
			customer_unique_id),
table_2 AS(
SELECT
	t1.customer_unique_id,
	t1.r_score,
	t1.f_score,
	t1.m_score,
	t1.r_score::text ||
	t1.f_score::text ||
	t1.m_score:: text AS rfm_segment
FROM
	table_1 t1),
table_3 AS (
	SELECT
		t2.rfm_segment,
		count(*) AS cnt_cust,
		CASE
			WHEN t2.r_score::int >= 4
				AND t2.m_score::int >= 4 
 THEN 'VIP'
				WHEN t2.r_score::int >= 3
				AND t2.m_score::int >= 3 
 THEN 'LOYAL'
				WHEN t2.r_score::int >= 2
				AND f_score::int >= 3
 THEN 'AT_RISK'
				WHEN t2.r_score::int >= 2
				AND f_score::int >= 2
 THEN 'LOST'
				ELSE 'REGULAR'
			END AS casess
		FROM
			table_2 t2
		GROUP BY
			t2.rfm_segment ,
			casess
		ORDER BY
			cnt_cust DESC
)
SELECT
	t3.casess,
	sum(t3.cnt_cust) AS cnt_customer
FROM
	table_3 t3
GROUP BY
	t3.casess
	ORDER BY cnt_customer desc