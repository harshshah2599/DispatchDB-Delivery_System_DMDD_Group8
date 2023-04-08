---------------------------------------------------------------------------------------------------------
-- EXECUTE FROM APP ADMIN --
---------------------------------------------------------------------------------------------------------

-- STORED PROCEDURES --


CREATE OR REPLACE PROCEDURE upsert_delivery_boy_details (
    p_delivery_boy_id IN NUMBER,
    p_first_name IN VARCHAR,
    p_last_name IN VARCHAR,
    p_phone_number IN VARCHAR,
    p_vehicle_number IN VARCHAR
)
IS 
exist_cnt number := 0;
BEGIN
    SELECT count(*) into exist_cnt FROM delivery_boy WHERE delivery_boy_id = p_delivery_boy_id;
    IF exist_cnt > 0 THEN
        UPDATE delivery_boy SET
            delivery_boy.first_name = p_first_name,
            delivery_boy.last_name = p_last_name,
            delivery_boy.phone_number = p_phone_number,
            delivery_boy.vehicle_number = p_vehicle_number
        WHERE delivery_boy_id = p_delivery_boy_id;
    ELSE
        INSERT INTO delivery_boy(delivery_boy_id, first_name, last_name, phone_number, vehicle_number)
        VALUES (p_delivery_boy_id, p_first_name, p_last_name, p_phone_number, p_vehicle_number);
    END IF;
END;
/

commit;


CREATE OR REPLACE PROCEDURE upsert_restaurant_details (
     p_restaurant_id in NUMBER,
     p_phone_number in VARCHAR,
     p_opening_time in TIMESTAMP,
     p_closing_time in TIMESTAMP,
     p_name in VARCHAR
)
IS
    restaurant_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO restaurant_count
    FROM restaurant
    WHERE restaurant_id = p_restaurant_id;
    
    IF restaurant_count > 0 THEN
        UPDATE restaurant SET
            phone_number = p_phone_number,
            opening_time = p_opening_time,
            closing_time = p_closing_time,
            name = p_name
        WHERE restaurant_id = p_restaurant_id;
    ELSE
        INSERT INTO restaurant (restaurant_id, phone_number, opening_time, closing_time, name)
        VALUES (p_restaurant_id, p_phone_number, p_opening_time, p_closing_time, p_name);
    END IF;
END;

/
commit;


CREATE OR REPLACE PROCEDURE upsert_customer_details (
    p_customer_id IN NUMBER,
    p_customer_first_name IN VARCHAR2,
    p_customer_last_name IN VARCHAR2,
    p_customer_phone_Number IN VARCHAR2,
    p_customer_email IN VARCHAR2  
)
IS
    customer_count NUMBER;
BEGIN
    -- Check if the customer already exists
    SELECT COUNT(*) INTO customer_count
    FROM customer
    WHERE customer_id = p_customer_id;
    
    -- If the customer exists, update their details
    IF customer_count > 0 THEN
        UPDATE customer
        SET first_name = p_customer_first_name,
            last_name = p_customer_last_name,
            phone_number = p_customer_phone_Number,
            email_id = p_customer_email
        WHERE customer_id = p_customer_id;
    -- If the customer doesn't exist, insert a new row with the specified details
    ELSE
        INSERT INTO customer (customer_id, first_name, last_name, phone_number, email_id)
        VALUES (p_customer_id, p_customer_first_name, p_customer_last_name, p_customer_phone_Number, p_customer_email);
    END IF;
END;

/
commit;



