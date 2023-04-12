--p_customer_id ,p_customer_first_name ,p_customer_last_name ,p_customer_phone_Number ,p_customer_email
EXEC customer_mgmt.upsert_customer_details ('Aditi', 'Jajoo', '8888888810', 'aj@gmail.com');
EXEC customer_mgmt.upsert_customer_details ('Harsh', 'Shah', '8888888111', 'hs@gmail.com');
EXEC customer_mgmt.upsert_customer_details ('Rushabh', 'Ukani', '8888888555', 'ru@gmail.com');
EXEC customer_mgmt.upsert_customer_details ('Neha', 'Joisher', '8888888844', 'nj@gmail.com');
EXEC customer_mgmt.upsert_customer_details ('Mike', 'Brown', '5678901234', 'mikebrown@gmail.com');
EXEC customer_mgmt.upsert_customer_details ('Sarah', 'Lee', '6789012345', 'sarahlee@gmail.com');
EXEC customer_mgmt.upsert_customer_details ('David', 'Garcia', '7890123456', 'davidgarcia@gmail.com');
EXEC customer_mgmt.upsert_customer_details ('Tom', 'Wilson', '9012345678', 'tomwilson@gmail.com');
EXEC customer_mgmt.upsert_customer_details ('Emily', 'Davis', '1111111111', 'emilydavis@gmail.com');

-- wrong input
EXEC customer_mgmt.upsert_customer_details ('ABC', 'XYZ', '1111111122', 'emilydavisgmail.com');

EXEC customer_mgmt.upsert_customer_details ('Emily', 'Davis', '11111111', 'emilydavis@gmail.com');



--select * from appadmin.restaurant where city = '';

--restaurant_id = 1006;
-- Boston Burger Company
CREATE OR REPLACE VIEW menu_items AS
SELECT r.name,m.menu_type, i.item_name, i.cost
FROM appAdmin.ITEMS i
JOIN appAdmin.MENU m ON i.menu_id = m.menu_id
JOIN appadmin.restaurant r ON r.restaurant_id = m.restaurant_id;
--where m.restaurant_id = 1000;


--select * from menu_items where menu_items.name = '';

CREATE OR REPLACE VIEW restaurant_coupons AS
SELECT r.name,rcr.offer_id,rcr.restaurant_id,c.promo_code_id, c.promo_code, c.offer_percentage, c.minimum_order, c.maximum_discount, c.details
FROM appadmin.coupons c
JOIN appadmin.restaurant_coupon_relation rcr ON c.promo_code_id = rcr.promo_code_id
JOIN appadmin.restaurant r ON r.restaurant_id = rcr.restaurant_id;

--select * from restaurant_coupons where restaurant_coupons.name = '';


--declare
--    orderid NUMBER;
--BEGIN
--    -- p_email, p_rest_name, p_addr_line1, p_addr_line2 ,p_city ,p_state ,p_zipcode ,p_payment_type ,p_offer_id ,o_order_id
--    customer_mgmt.create_order ('nj@gmail.com','Popeyes','64 Smith Street','', 'Boston', 'MA', 02125, 'Cash', 9019, orderid);
--
--    -- rest_name, order_id, item_name, qty
--    customer_mgmt.add_ordered_items('Guapos', orderid, 'Filet Mignon', 2);
----    customer_mgmt.add_ordered_items('Guapos', orderid, 'Banana Split', 1);
----    customer_mgmt.add_ordered_items('Popeyes', orderid, 'Chocolate Cake', 1);
--END;

--select * from appadmin.orders;

    CREATE OR REPLACE VIEW order_details AS
    SELECT distinct o.order_id, o.status,
    c.first_name || ' ' || c.last_name as customer_name, c.phone_number as customer_phone_number, c.email_id,
    r.name as restaurant_name, r.phone_number as rest_phone_number,
    o.addressLine_1 || ', ' || o.addressLine_2 || ', ' || o.city || ', ' || o.state || ', ' || o.zipcode as delivery_address,
    d.first_name || ' ' || d.last_name as delivery_boy_name, d.phone_number as delivery_boy_phone_number, d.vehicle_number,
    p.payment_type, p.payment_date,
    i.item_name, i.cost, oi.quantity,
    o.tax, o.delivery_charge,
    customer_mgmt.fnCalculateOrderTotalAmount(o.order_id,rcr.offer_id,o.tax,o.delivery_charge) as total_amount
    FROM appAdmin.ORDERS o
    LEFT JOIN appAdmin.PAYMENT_TYPE p ON o.payment_type_id = p.payment_type_id
    LEFT JOIN appAdmin.RESTAURANT r ON o.restaurant_id = r.restaurant_id
    LEFT JOIN appAdmin.BRANCH_ADDRESS b ON b.restaurant_id = r.restaurant_id
    LEFT JOIN appAdmin.DELIVERY_BOY d ON o.delivery_boy_id = d.delivery_boy_id
    LEFT JOIN appAdmin.CUSTOMER c ON o.customer_id = c.customer_id
    LEFT JOIN appAdmin.ORDERED_ITEMS oi ON o.order_id = oi.order_id
    LEFT JOIN appAdmin.ITEMS i ON oi.item_id = i.item_id
    LEFT JOIN appAdmin.restaurant_coupon_relation rcr on r.restaurant_id = rcr.restaurant_id;
commit;
--select * from order_details where email_id = 'nj@gmail.com';