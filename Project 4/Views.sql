CREATE OR REPLACE VIEW restaurant_coupons AS
SELECT r.name,rcr.offer_id,rcr.restaurant_id,c.promo_code_id, c.promo_code, c.offer_percentage, c.minimum_order, c.maximum_discount, c.details
FROM appadmin.coupons c
JOIN appadmin.restaurant_coupon_relation rcr ON c.promo_code_id = rcr.promo_code_id
JOIN appadmin.restaurant r ON r.restaurant_id = rcr.restaurant_id;

CREATE OR REPLACE VIEW menu_items AS
SELECT r.name,m.menu_type, i.item_name, i.cost
FROM appAdmin.ITEMS i
JOIN appAdmin.MENU m ON i.menu_id = m.menu_id
JOIN appadmin.restaurant r ON r.restaurant_id = m.restaurant_id;


--------------------------------------------------------
--  DDL for View ORDER_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "APPADMIN"."ORDER_DETAILS" ("ORDER_ID", "STATUS", "CUSTOMER_NAME", "CUSTOMER_PHONE_NUMBER", "EMAIL_ID", "RESTAURANT_NAME", "REST_PHONE_NUMBER", "DELIVERY_ADDRESS", "DELIVERY_BOY_NAME", "DELIVERY_BOY_PHONE_NUMBER", "VEHICLE_NUMBER", "PAYMENT_TYPE", "PAYMENT_DATE", "ITEM_NAME", "COST", "QUANTITY", "TAX", "DELIVERY_CHARGE", "TOTAL_AMOUNT") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT distinct o.order_id, o.status,
c.first_name || ' ' || c.last_name as customer_name, c.phone_number as customer_acphone_number, c.email_id,
r.name as restaurant_name, r.phone_number as rest_phone_number,
o.addressLine_1 || ', ' || o.addressLine_2 || ', ' || o.city || ', ' || o.state || ', ' || o.zipcode as delivery_address,
d.first_name || ' ' || d.last_name as delivery_boy_name, d.phone_number as delivery_boy_phone_number, d.vehicle_number,
p.payment_type, p.payment_date,
i.item_name, i.cost, oi.quantity,
o.tax, o.delivery_charge,
fnCalculateOrderTotalAmount(o.order_id,rcr.offer_id,o.tax,o.delivery_charge) as total_amount
FROM appAdmin.ORDERS o
LEFT JOIN appAdmin.PAYMENT_TYPE p ON o.payment_type_id = p.payment_type_id
LEFT JOIN appAdmin.RESTAURANT r ON o.restaurant_id = r.restaurant_id
LEFT JOIN appAdmin.BRANCH_ADDRESS b ON b.restaurant_id = r.restaurant_id
LEFT JOIN appAdmin.DELIVERY_BOY d ON o.delivery_boy_id = d.delivery_boy_id
LEFT JOIN appAdmin.CUSTOMER c ON o.customer_id = c.customer_id
LEFT JOIN appAdmin.ORDERED_ITEMS oi ON o.order_id = oi.order_id
LEFT JOIN appAdmin.ITEMS i ON oi.item_id = i.item_id
LEFT JOIN appAdmin.restaurant_coupon_relation rcr on r.restaurant_id = rcr.restaurant_id
;

CREATE OR REPLACE VIEW "APPADMIN"."DELIVERY_DETAILS_VIEW" ("ORDER_ID", "DELIVERY_ADDRESS", "DELIVERY_BOY_NAME", "DELIVERY_BOY_PHONE", "RESTAURANT_NAME", "RESTAURANT_ADDRESS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT o.order_id, o.addressLine_1 || ', ' || o.addressLine_2 || ', ' || o.city || ', ' || o.state || ', ' || o.zipcode as delivery_address, 
       db.first_name || ' ' || db.last_name AS delivery_boy_name, db.phone_number AS delivery_boy_phone,
       r.name AS restaurant_name, ra.addressLine_1 || ', ' || ra.addressLine_2 || ', ' || ra.city || ', ' || ra.state || ' ' || ra.zipcode AS restaurant_address
FROM APPADMIN.ORDERS o
JOIN APPADMIN.DELIVERY_BOY db ON o.delivery_boy_id = db.delivery_boy_id
JOIN APPADMIN.RESTAURANT r ON o.restaurant_id = r.restaurant_id
JOIN APPADMIN.BRANCH_ADDRESS ra ON ra.restaurant_id = r.restaurant_id
;


