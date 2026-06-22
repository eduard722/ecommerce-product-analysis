SELECT
	opd.product_category_name,
	round(sum(ooid.price)::NUMERIC , 2) AS gmv,
	count(oord.review_id) AS cnt_review,
	round(avg(oord.review_score), 2) AS review_score
FROM
		olist_products_dataset opd
JOIN olist_order_items_dataset ooid ON
		ooid.product_id = opd.product_id
JOIN olist_order_reviews_dataset oord ON
	ooid.order_id = oord.order_id
GROUP BY
		opd.product_category_name
HAVING
	count(oord.review_id) >= 500
ORDER BY
	review_score ASC,
	gmv DESC