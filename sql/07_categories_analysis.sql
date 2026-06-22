SELECT
	opd.product_category_name,
	round(sum(ooid.price::NUMERIC), 2) AS gmv,
	count(DISTINCT oopd.order_id) AS cnt_order,
	round(avg(oord.review_score::NUMERIC), 2) AS ratting
FROM
	olist_products_dataset opd
JOIN olist_order_items_dataset ooid ON
	ooid.product_id = opd.product_id
JOIN olist_order_payments_dataset oopd ON
	ooid.order_id = oopd.order_id
JOIN olist_order_reviews_dataset oord ON
	oord.order_id = oopd.order_id
GROUP BY
	opd.product_category_name
ORDER BY
	ratting ASC,
	gmv DESC