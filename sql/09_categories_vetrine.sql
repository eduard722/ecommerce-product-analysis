WITH table_1 AS (
	SELECT
		opd.product_category_name,
		round(sum(oopd.payment_value)::NUMERIC, 2) AS gmv,
		count(DISTINCT oopd.order_id) AS cnt_order,
		round(avg(oord.review_score), 2) AS avg_review,
		ROUND((sum(oopd.payment_value) / sum(sum(oopd.payment_value)) OVER() * 100)::NUMERIC, 2) AS fraction_gmv
	FROM
		olist_products_dataset opd
	JOIN olist_order_items_dataset ooid ON
		ooid.product_id = opd.product_id
	JOIN olist_order_payments_dataset oopd ON
		ooid.order_id = oopd.order_id
	JOIN olist_order_reviews_dataset oord ON
		oopd.order_id = oord.order_id
	GROUP BY
		opd.product_category_name
)
SELECT
	t1.product_category_name,
	t1.gmv,
	t1.cnt_order,
	t1.avg_review,
	t1.fraction_gmv
FROM
	table_1 t1