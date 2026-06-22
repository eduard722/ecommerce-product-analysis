WITH table_1 AS (
	SELECT
		opd.product_category_name,
		sum(ooid.price) AS gmv,
		count(ooid.order_id) AS cnt_order
	FROM
		olist_products_dataset opd
	JOIN olist_order_items_dataset ooid ON
		ooid.product_id = opd.product_id
	GROUP BY
		opd.product_category_name
	ORDER BY
		gmv DESC
	LIMIT 10
)
SELECT
	*,
	round((gmv / t1.cnt_order)::NUMERIC, 2) AS price_one_order
FROM
	table_1 t1