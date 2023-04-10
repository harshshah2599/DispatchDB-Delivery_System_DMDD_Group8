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