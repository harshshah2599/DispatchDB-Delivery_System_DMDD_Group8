

---------------------------------------------------------------------------------------------------------
-- EXECUTE THESE VIEWS FROM RESTAURANT MANAGER --
---------------------------------------------------------------------------------------------------------

--select * from top_5_items;
CREATE OR REPLACE VIEW top_5_items AS
SELECT i.item_name, SUM(oi.quantity) AS total_ordered
FROM appAdmin.items i
INNER JOIN appAdmin.menu m ON i.menu_id = m.menu_id
INNER JOIN appAdmin.restaurant r ON m.restaurant_id = r.restaurant_id
INNER JOIN appAdmin.ordered_items oi ON i.item_id = oi.item_id
WHERE r.restaurant_id = 12345678
GROUP BY i.item_name
ORDER BY total_ordered DESC
FETCH FIRST 5 ROWS ONLY;


--select * from top_10_customers;
CREATE OR REPLACE VIEW top_10_customers AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS total_orders
FROM appAdmin.orders o
JOIN appAdmin.customer c ON o.customer_id = c.customer_id
WHERE o.restaurant_id = 12345678
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC
FETCH FIRST 10 ROWS ONLY;


--select * from top_delivery_boy_view
CREATE OR REPLACE VIEW top_delivery_boy_view AS
SELECT delivery_boy_id, COUNT(*) as total_orders_delivered
FROM appAdmin.orders
WHERE status = 'Delivered'
GROUP BY delivery_boy_id
ORDER BY total_orders_delivered DESC
FETCH FIRST 1 ROWS ONLY;

--showing this view for a particular restaurant

-- shows coupons for a particular restuarant
CREATE OR REPLACE VIEW restaurant_coupons AS
SELECT c.promo_code_id, c.promo_code, c.offer_percentage, c.minimum_order, c.maximum_discount, c.details
FROM appAdmin.coupons c
JOIN appadmin.restaurant_coupon_relation rcr ON c.promo_code_id = rcr.promo_code_id
WHERE rcr.restaurant_id = 12345678;


-- delivery_details_view
CREATE OR REPLACE VIEW delivery_details_view AS
SELECT o.order_id, o.addressLine_1 || ', ' || o.addressLine_2 || ', ' || o.city || ', ' || o.state || ', ' || o.zipcode as delivery_address, 
       db.first_name || ' ' || db.last_name AS delivery_boy_name, db.phone_number AS delivery_boy_phone,
       r.name AS restaurant_name, ra.addressLine_1 || ', ' || ra.addressLine_2 || ', ' || ra.city || ', ' || ra.state || ' ' || ra.zipcode AS restaurant_address
FROM APPADMIN.ORDERS o
JOIN APPADMIN.DELIVERY_BOY db ON o.delivery_boy_id = db.delivery_boy_id
JOIN APPADMIN.RESTAURANT r ON o.restaurant_id = r.restaurant_id
JOIN APPADMIN.BRANCH_ADDRESS ra ON ra.restaurant_id = r.restaurant_id;

commit;



---------------------------------------------------------------------------------------------------------
-- EXECUTE THESE VIEWS FROM CUSTOMER --
---------------------------------------------------------------------------------------------------------

--select * from top_10_restaurants_location
CREATE OR REPLACE VIEW top_10_restaurants_location AS
SELECT ba.city, ba.state, r.restaurant_id, r.name, COUNT(o.order_id) AS num_orders
FROM appAdmin.restaurant r
JOIN appAdmin.branch_address ba ON r.restaurant_id = ba.restaurant_id
JOIN appAdmin.orders o ON r.restaurant_id = o.restaurant_id
GROUP BY ba.city, ba.state, r.restaurant_id, r.name
ORDER BY COUNT(o.order_id) DESC
FETCH FIRST 10 ROWS ONLY;


--select * from menu_items
CREATE OR REPLACE VIEW menu_items AS
SELECT m.menu_type, i.item_name, i.cost
FROM appAdmin.ITEMS i
JOIN appAdmin.MENU m ON i.menu_id = m.menu_id;


CREATE OR REPLACE VIEW order_details AS
SELECT o.order_id, o.status, o.tax, o.delivery_charge, 
o.addressLine_1 || ', ' || o.addressLine_2 || ', ' || o.city || ', ' || o.state || ', ' || o.zipcode as delivery_address,
p.payment_type, p.payment_date,
r.name, r.phone_number, r.opening_time, r.closing_time,
b.addressLine_1 || ', ' || b.addressLine_2 || ', ' || b.city || ', ' || b.state || ', ' || b.zipcode as restaurant_address,
d.first_name || ' ' || d.last_name as delivery_boy_name, d.phone_number as delivery_boy_phone_number, d.vehicle_number,
c.first_name || ' ' || c.last_name as customer_name, c.phone_number as customer_phone_number, c.email_id,
i.item_name, i.cost, oi.quantity
FROM appAdmin.ORDERS o
JOIN appAdmin.PAYMENT_TYPE p ON o.payment_type_id = p.payment_type_id
JOIN appAdmin.RESTAURANT r ON o.restaurant_id = r.restaurant_id
JOIN appAdmin.BRANCH_ADDRESS b ON b.restaurant_id = r.restaurant_id
JOIN appAdmin.DELIVERY_BOY d ON o.delivery_boy_id = d.delivery_boy_id
JOIN appAdmin.CUSTOMER c ON o.customer_id = c.customer_id
JOIN appAdmin.ORDERED_ITEMS oi ON o.order_id = oi.order_id
JOIN appAdmin.ITEMS i ON oi.item_id = i.item_id;

commit;