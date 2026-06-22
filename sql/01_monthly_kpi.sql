WITH table_1 AS (
	SELECT
		sum(oopd.payment_value) AS pay_value,
		date_trunc('month', order_purchase_timestamp::DATE) AS MONTH,
		LAG(sum(oopd.payment_value)) OVER() AS last_month,
		count(DISTINCT ood.order_id) AS cnt_order,
		avg(oopd.payment_value) AS mean_pay
	FROM
		olist_order_payments_dataset oopd
	JOIN olist_orders_dataset ood ON
		oopd.order_id = ood.order_id
	WHERE
		order_status = 'delivered'
	GROUP BY
		date_trunc('month', order_purchase_timestamp::DATE)
)
		SELECT
			t1."month"::DATE,
	t1.pay_value,
	round(((t1.pay_value - t1.last_month) / NULLIF(t1.last_month, 0) * 100)::NUMERIC, 2) AS percent_last_month,
	t1.cnt_order,
	round(t1.mean_pay::NUMERIC, 2) AS mean_payy
FROM
			table_1 t1
ORDER BY
			t1."month" ASC