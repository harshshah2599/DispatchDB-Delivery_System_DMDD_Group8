CREATE OR REPLACE PACKAGE customer_mgmt AS

  PROCEDURE create_order(
    p_email IN VARCHAR2,
    p_rest_name IN VARCHAR2,
    p_addr_line1 IN VARCHAR2,
    p_addr_line2 IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zipcode IN NUMBER,
    p_payment_type IN VARCHAR2,
    p_offer_id IN NUMBER,
    o_order_id OUT NUMBER
  );
  
  PROCEDURE add_ordered_items (
p_rest_name VARCHAR,
p_order_id NUMBER,
p_item_name VARCHAR2,
p_qty NUMBER
);
  
  PROCEDURE upsert_customer_details (
    p_customer_first_name IN VARCHAR2,
    p_customer_last_name IN VARCHAR2,
    p_customer_phone_Number IN VARCHAR2,
    p_customer_email IN VARCHAR2  
);



FUNCTION fnCalculateOrderTotalAmount(f_orderId IN NUMBER, f_offer_id NUMBER, f_tax NUMBER, f_delivery_charge NUMBER)
RETURN NUMBER;

END customer_mgmt;

/

CREATE OR REPLACE PACKAGE BODY customer_mgmt AS

PROCEDURE create_order(
    p_email IN VARCHAR2,
    p_rest_name IN VARCHAR2,
    p_addr_line1 IN VARCHAR2,
    p_addr_line2 IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zipcode IN NUMBER,
    p_payment_type IN VARCHAR2,
    p_offer_id IN NUMBER,
    o_order_id OUT NUMBER
) IS
v_cust_id number;
v_restid number;
v_branch_id number;
v_payment_type_id number;
t_cnt number := 0;
v_orderid number;
v_itemid number;
t_qty number;
v_delboy_id number;

BEGIN
select customer_id into v_cust_id from appadmin.customer where email_id = p_email;
select restaurant_id into v_restid from appadmin.restaurant where name = p_rest_name;


INSERT INTO appadmin.payment_type (payment_type_id, payment_type, payment_date)
VALUES (appadmin.payment_type_seq.NEXTVAL,p_payment_type,SYSDATE);

select payment_type_id into v_payment_type_id from appadmin.payment_type where payment_type = p_payment_type and payment_date = sysdate;

SELECT d.delivery_boy_id into v_delboy_id
FROM appadmin.delivery_boy d
WHERE d.delivery_boy_id NOT IN (
  SELECT o.delivery_boy_id
  FROM appadmin.orders o
  WHERE o.status IN ('Out for Delivery','Processing') 
) FETCH FIRST 1 ROW ONLY;

INSERT INTO appAdmin.orders (restaurant_id, customer_id, offer_id, delivery_boy_id, payment_type_id, status, tax, delivery_charge, addressLine_1, addressLine_2, city, state, zipcode)
VALUES (v_restid, v_cust_id, p_offer_id, v_delboy_id, v_payment_type_id, 'Pending', 2.50, 5.00, p_addr_line1, p_addr_line2, p_city, p_state, p_zipcode);

select order_id INTO o_order_id from appadmin.orders where customer_id = v_cust_id and restaurant_id = v_restid;
  
END create_order;

PROCEDURE add_ordered_items (
p_rest_name VARCHAR,
p_order_id NUMBER,
p_item_name VARCHAR2,
p_qty NUMBER
) IS
p_item_id NUMBER;
p_restid NUMBER;
BEGIN
select restaurant_id into p_restid from appadmin.restaurant where name = p_rest_name;

select item_id into p_item_id from appadmin.items i
join appadmin.menu m on m.menu_id = i.menu_id
join appadmin.restaurant r on r.restaurant_id = m.restaurant_id
where r.restaurant_id = p_restid and i.item_name = p_item_name; 

INSERT INTO appadmin.ordered_items VALUES (appadmin.ordered_items_seq.nextval, p_order_id, p_item_id, p_qty);

END add_ordered_items;

PROCEDURE upsert_customer_details (
    p_customer_first_name IN VARCHAR2,
    p_customer_last_name IN VARCHAR2,
    p_customer_phone_Number IN VARCHAR2,
    p_customer_email IN VARCHAR2  
)
IS
    p_customer_count NUMBER;
    p_customer_id NUMBER;
BEGIN
    

    -- Check if the customer already exists
    
    SELECT COUNT(*) INTO p_customer_count
    FROM appadmin.customer
    WHERE email_id = p_customer_email;
    
    -- If the customer exists, update their details
    IF p_customer_count > 0 THEN
        select customer_id into p_customer_id from appadmin.customer where email_id = p_customer_email;
        UPDATE appadmin.customer
        SET first_name = p_customer_first_name,
            last_name = p_customer_last_name,
            phone_number = p_customer_phone_Number,
            email_id = p_customer_email
        WHERE customer_id = p_customer_id;
    -- If the customer doesn't exist, insert a new row with the specified details
    ELSE
        INSERT INTO appadmin.customer (customer_id,first_name, last_name, phone_number, email_id)
        VALUES (appadmin.customers_seq.NEXTVAL,p_customer_first_name, p_customer_last_name, p_customer_phone_Number, p_customer_email);
    END IF;
END upsert_customer_details;

FUNCTION fnCalculateOrderTotalAmount(f_orderId IN NUMBER, f_offer_id NUMBER, f_tax NUMBER, f_delivery_charge NUMBER)
RETURN NUMBER
IS
    orderTotalAmount DECIMAL(10,2);
    min_order NUMBER;
    max_disc NUMBER;
BEGIN
    SELECT SUM(i.COST * oi.QUANTITY) INTO orderTotalAmount
    FROM appadmin.ORDERED_ITEMS oi
    JOIN appadmin.ITEMS i ON oi.ITEM_ID = i.ITEM_ID
    WHERE oi.ORDER_ID = f_orderId;
    
    select c.minimum_order into min_order from appadmin.coupons c
    JOIN appadmin.restaurant_coupon_relation rcr ON c.promo_code_id = rcr.promo_code_id
    where rcr.offer_id = f_offer_id;
    
    
    IF orderTotalAmount IS NULL THEN
        orderTotalAmount := 0.00;
    ELSIF orderTotalAmount > min_order THEN
        select c.maximum_discount into max_disc from appadmin.coupons c
        JOIN appadmin.restaurant_coupon_relation rcr ON c.promo_code_id = rcr.promo_code_id
        where rcr.offer_id = f_offer_id;
        orderTotalAmount := (orderTotalAmount - max_disc) + f_tax + f_delivery_charge;
    ELSE
        orderTotalAmount := orderTotalAmount + f_tax + f_delivery_charge;
    END IF;
    
    RETURN orderTotalAmount;
END fnCalculateOrderTotalAmount;



END customer_mgmt;
/

commit;