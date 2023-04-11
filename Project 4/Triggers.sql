-- trigger to validate phone number for customer table

CREATE OR REPLACE TRIGGER validate_phone_number
BEFORE INSERT OR UPDATE ON customer
FOR EACH ROW
DECLARE
  invalid_phone EXCEPTION;
BEGIN
  IF NOT REGEXP_LIKE(:new.phone_number, '^[0-9]{10}$') THEN
    RAISE invalid_phone;
  END IF;
EXCEPTION
  WHEN invalid_phone THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid phone number. Phone number must be a 10-digit number.');
END;
/
-- trigger to validate phone number for delivery boy table

CREATE OR REPLACE TRIGGER validate_phone_number_delboy
BEFORE INSERT OR UPDATE ON delivery_boy
FOR EACH ROW
DECLARE
  invalid_phone EXCEPTION;
BEGIN
  IF NOT REGEXP_LIKE(:new.phone_number, '^[0-9]{10}$') THEN
    RAISE invalid_phone;
  END IF;
EXCEPTION
  WHEN invalid_phone THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid phone number. Phone number must be a 10-digit number.');
END;
/
CREATE OR REPLACE TRIGGER validate_phone_number_rest
BEFORE INSERT OR UPDATE ON restaurant
FOR EACH ROW
DECLARE
  invalid_phone EXCEPTION;
BEGIN
  IF NOT REGEXP_LIKE(:new.phone_number, '^[0-9]{10}$') THEN
    RAISE invalid_phone;
  END IF;
EXCEPTION
  WHEN invalid_phone THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid phone number. Phone number must be a 10-digit number.');
END;
/

-- trigger to validate customer email

create or replace TRIGGER check_customer_email
BEFORE INSERT OR UPDATE ON customer
FOR EACH ROW
DECLARE
  email_regex VARCHAR2(100) := '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
BEGIN
  IF :NEW.email_id IS NOT NULL AND NOT REGEXP_LIKE(:NEW.email_id, email_regex) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid email format');
  END IF;
END;
/

create or replace TRIGGER check_closing_time
BEFORE INSERT ON ORDERS
FOR EACH ROW
DECLARE 
    restaurant_closing_time_hour NUMBER;
    restaurant_closing_time_minute NUMBER;
BEGIN
    SELECT extract(hour from CLOSING_TIME) INTO restaurant_closing_time_hour FROM RESTAURANT WHERE RESTAURANT_ID = :NEW.RESTAURANT_ID;
    SELECT extract(minute from CLOSING_TIME) INTO restaurant_closing_time_minute FROM RESTAURANT WHERE RESTAURANT_ID = :NEW.RESTAURANT_ID;

    IF extract(hour from SYSTIMESTAMP) > (restaurant_closing_time_hour+4) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Order cannot be created past restaurant closing time');
    ELSIF extract(hour from SYSTIMESTAMP) = restaurant_closing_time_hour AND extract(minute from SYSTIMESTAMP) > restaurant_closing_time_minute THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Order cannot be created past restaurant closing time');
    END IF;
END;
/
commit;