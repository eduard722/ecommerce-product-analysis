WITH table_1 AS(SELECT
	oord.review_score,
	ood.order_estimated_delivery_date::DATE -
	ood.order_delivered_customer_date::DATE AS days
FROM
		olist_products_dataset opd
JOIN olist_order_items_dataset ooid ON
		ooid.product_id = opd.product_id
JOIN olist_order_reviews_dataset oord ON
	ooid.order_id = oord.order_id
JOIN olist_orders_dataset ood ON
	ood.order_id = oord.order_id),
table_2 AS(
SELECT
	t1.review_score AS review_score,
	t1.days,
	CASE
		WHEN t1.days < 0 THEN 'late'
		WHEN t1.days = 0 THEN 'on_time'
		ELSE 'early'
	END AS casee
FROM
	table_1 t1
ORDER BY
	review_score ASC)
SELECT
	round(avg(t2.review_score),2), t2.casee
FROM
	table_2 t2
	GROUP BY t2.casee