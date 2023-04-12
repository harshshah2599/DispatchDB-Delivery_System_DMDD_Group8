SELECT c.customer_id, c.last_name, c.first_name, COUNT(distinct(o.order_id)) AS order_count
FROM orders o
inner JOIN customer c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.last_name, c.first_name
ORDER BY order_count DESC
FETCH FIRST 10 ROWS ONLY;

/

SELECT ba.city, ba.state, r.restaurant_id, r.name, COUNT(DISTINCT o.order_id) AS num_orders
FROM appAdmin.restaurant r
JOIN appAdmin.branch_address ba ON r.restaurant_id = ba.restaurant_id
JOIN appAdmin.orders o ON r.restaurant_id = o.restaurant_id
GROUP BY ba.city, ba.state, r.restaurant_id, r.name
ORDER BY COUNT(o.order_id) DESC
FETCH FIRST 10 ROWS ONLY;
/

SELECT i.item_name, SUM(oi.quantity) AS total_ordered
FROM appAdmin.items i
INNER JOIN appAdmin.menu m ON i.menu_id = m.menu_id
INNER JOIN appAdmin.restaurant r ON m.restaurant_id = r.restaurant_id
INNER JOIN appAdmin.ordered_items oi ON i.item_id = oi.item_id
WHERE r.restaurant_id = 1006
GROUP BY i.item_name
ORDER BY total_ordered DESC
FETCH FIRST 5 ROWS ONLY;

/

SELECT delivery_boy_id, COUNT(*) as total_orders_delivered
FROM appAdmin.orders
WHERE status = 'Delivered'
GROUP BY delivery_boy_id
ORDER BY total_orders_delivered DESC
FETCH FIRST 1 ROWS ONLY;

/

SELECT o.restaurant_id, sum(total_amount)  AS TOTAL_SALES FROM order_details od
join RESTAURANT r on od.restaurant_name = r.name
JOIN ORDERS o ON r.RESTAURANT_ID = o.RESTAURANT_ID
JOIN ORDERED_ITEMS oi on o.ORDER_ID = oi.ORDER_ID
GROUP BY o.restaurant_id;
