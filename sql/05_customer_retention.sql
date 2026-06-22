WITH table_1 AS(SELECT
	ocd.customer_unique_id,
	count(ood.order_id) AS cnt_order,
	CASE
		WHEN count(ood.order_id) = 1 THEN 'Cust_1_order'
		ELSE 'Cust_2+_order'
	END AS cases
FROM
		olist_customers_dataset ocd
JOIN olist_orders_dataset ood ON
		ocd.customer_id = ood.customer_id
JOIN olist_order_payments_dataset oopd ON
		ood.order_id = oopd.order_id
GROUP BY
		ocd.customer_unique_id),
table_2 AS(
SELECT
	count(DISTINCT t1.customer_unique_id) AS CNT_CUSTOMER,
	t1.cases AS cohort
FROM
	table_1 t1
GROUP BY
	t1.cases)
SELECT
	t2.cnt_customer,
	t2.cohort,
	round(t2.cnt_customer * 100 / sum(t2.cnt_customer) over(),2)
FROM
	table_2 t2