--EXECUTE FROM DATABASE ADMIN--
-----------------------------------

set SERVEROUTPUT on;
DECLARE
  user_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO user_exists FROM all_users WHERE username = 'APPADMIN';
  IF user_exists > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER APPADMIN CASCADE';
    DBMS_OUTPUT.PUT_LINE('User dropped successfully.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User does not exist.');
  END IF;
END;

/
create user appAdmin identified by SillyLittleBunny4000 DEFAULT TABLESPACE data_ts QUOTA UNLIMITED ON data_ts ; 
GRANT CONNECT, RESOURCE TO appAdmin with admin option; 
--GRANT CONNECT TO appAdmin;  
grant create view, create procedure, create sequence, CREATE USER, DROP USER to appAdmin with admin option;

/

set SERVEROUTPUT on;
DECLARE
  user_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO user_exists FROM all_users WHERE username = 'RESTAURANTMANAGER';
  IF user_exists > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER RESTAURANTMANAGER CASCADE';
    DBMS_OUTPUT.PUT_LINE('User dropped successfully.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User does not exist.');
  END IF;
END;

/

create user RESTAURANTMANAGER identified by SillyLittleBunny3000 DEFAULT TABLESPACE data_ts QUOTA UNLIMITED ON data_ts ; 

/

set SERVEROUTPUT on;
DECLARE
  user_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO user_exists FROM all_users WHERE username = 'DELIVERY_BOY';
  IF user_exists > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER DELIVERY_BOY CASCADE';
    DBMS_OUTPUT.PUT_LINE('User dropped successfully.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User does not exist.');
  END IF;
END;

/

create user DELIVERY_BOY identified by SillyLittleBunny3002 DEFAULT TABLESPACE data_ts QUOTA UNLIMITED ON data_ts ; 

/

set SERVEROUTPUT on;
DECLARE
  user_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO user_exists FROM all_users WHERE username = 'CUSTOMER';
  IF user_exists > 0 THEN
    EXECUTE IMMEDIATE 'DROP USER CUSTOMER CASCADE';
    DBMS_OUTPUT.PUT_LINE('User dropped successfully.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User does not exist.');
  END IF;
END;

/

create user CUSTOMER identified by SillyLittleBunny3001 DEFAULT TABLESPACE data_ts QUOTA UNLIMITED ON data_ts ; 

/

commit;



--EXECUTE AS APPADMIN--
-----------------------------------

GRANT CONNECT, RESOURCE TO CUSTOMER ;  
grant insert, select,update on orders to customer;
grant select,insert, update on customer to customer;
grant insert,select,update on ordered_items to customer;
grant insert,select,update on payment_type to customer;
grant select on branch_address to customer;
grant select on menu to customer;
grant select on items to customer;
grant select on delivery_boy to customer;
grant select on restaurant to customer;

GRANT CONNECT, RESOURCE TO DELIVERY_BOY ; 
grant select,update on delivery_boy to DELIVERY_BOY;
grant select on customer to DELIVERY_BOY;
grant select on ordered_items to DELIVERY_BOY;
grant select on branch_address to DELIVERY_BOY;
grant select on ordered_items to DELIVERY_BOY;
grant select on orders to DELIVERY_BOY;
grant select on restaurant to DELIVERY_BOY;
grant create view to DELIVERY_BOY;

GRANT CONNECT, RESOURCE TO RESTAURANTMANAGER ;  
grant insert, select,update on restaurant to RESTAURANTMANAGER;
grant insert, select,update on branch_address to RESTAURANTMANAGER;
grant insert,select,update on menu to RESTAURANTMANAGER;
grant insert, select,update on items to RESTAURANTMANAGER;
grant select on orders to RESTAURANTMANAGER;
grant insert, select,update on restaurant_coupon_relation to RESTAURANTMANAGER;
grant select on payment_type to RESTAURANTMANAGER;
grant insert, select,update on DELIVERY_BOY to RESTAURANTMANAGER;
grant insert, select,update on coupons to RESTAURANTMANAGER;


commit;

