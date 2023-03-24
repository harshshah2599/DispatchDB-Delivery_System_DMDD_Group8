---------------------------------------------------------------------------------------------------------
-- EXECUTE FROM APP ADMIN --
---------------------------------------------------------------------------------------------------------

set serveroutput on
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select 'RESTAURANT' table_name from dual union all
             select 'MENU' table_name from dual union all
             select 'ITEMS' table_name from dual union all
             select 'CUSTOMER' table_name from dual union all
             select 'ORDERS' table_name from dual union all
             select 'DELIVERY_BOY' table_name from dual union all
             select 'BRANCH_ADDRESS' table_name from dual union all
             select 'ORDERED_ITEMS' table_name from dual union all
             select 'PAYMENT_TYPE' table_name from dual union all
             select 'COUPONS' table_name from dual union all
             select 'RESTAURANT_COUPON_RELATION' table_name from dual              
   )
   loop
   dbms_output.put_line('....Drop table '||i.table_name);
   begin
       select 'Y' into v_table_exists
       from USER_TABLES
       where TABLE_NAME=i.table_name;

       --dbms_output.put_line('drop table '||i.table_name|| ' CASCADE CONSTRAINTS');
       v_sql := 'drop table '||i.table_name|| ' CASCADE CONSTRAINTS';
       --dbms_output.put_line('drop table '||i.table_name|| ' CASCADE CONSTRAINTS');
       execute immediate v_sql;
       dbms_output.put_line('........Table '||i.table_name||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........Table already dropped');
   end;
   end loop;
   dbms_output.put_line('Schema cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;

/


create table restaurant (
  restaurant_id number(8),
  name varchar(45) not null,
  phone_number varchar(12) not null,
  opening_time timestamp,
  closing_time timestamp,
  primary key(restaurant_id)   
);

create table menu (
  menu_id number(8),
  restaurant_id number(8) not null,
  menu_type varchar(45) not null,
  constraint fk_menu
  foreign key(restaurant_id) references restaurant(restaurant_id) 
  on delete CASCADE
);

ALTER TABLE menu 
ADD CONSTRAINT pk_menu PRIMARY KEY (menu_id);

create table items (
  item_id number(8),
  menu_id number(8) not null,
  item_name varchar(30) not null,
  cost number(4,2) not null, 
  primary key (item_id),
  constraint fk_items 
  foreign key(menu_id) references menu(menu_id)
  on delete CASCADE
);

CREATE TABLE branch_address(
branch_id number(8),
restaurant_id number(8) NOT NULL,
addressLine_1 varchar(30) NOT NULL,
addressLine_2 varchar(30),
city varchar(15) NOT NULL,
state varchar(15) NOT NULL,
zipcode number(5) NOT NULL,
PRIMARY KEY(branch_id),
CONSTRAINT fk_branchAddress
FOREIGN KEY(restaurant_id) REFERENCES restaurant(restaurant_id)
on delete cascade
);


create table customer (
  customer_id number(8),
  first_name varchar(45) not null,
  last_name varchar(45) not null,
  phone_number varchar(12) not null,
  email_id varchar(45),
  primary key(customer_id)
 );


create table delivery_boy (
  delivery_boy_id number(8),
  first_name varchar(45) not null,
  last_name varchar(45) not null,
  phone_number varchar(12) not null,
  vehicle_number varchar(10) not null,
  primary key(delivery_boy_id)
 );

CREATE TABLE coupons(
promo_code_id number(8) ,
promo_code varchar(20) NOT NULL,
offer_percentage number(2),
minimum_order number(2) NOT NULL,
maximum_discount number(8),
details varchar(500) NOT NULL,
PRIMARY KEY(promo_code_id)
);


CREATE TABLE restaurant_coupon_relation(
offer_id number(8),
restaurant_id number(8) NOT NULL,
promo_code_id number(8) NOT NULL,
PRIMARY KEY(offer_id),
FOREIGN KEY(promo_code_id) REFERENCES coupons(promo_code_id) on delete cascade,
FOREIGN KEY(restaurant_id) REFERENCES restaurant(restaurant_id) on delete cascade
);

CREATE TABLE payment_type(
payment_type_id number(8),
payment_type varchar(40) NOT NULL,
payment_date date NOT NULL,
PRIMARY KEY(payment_type_id)
);

create table orders (
  order_id number(8),
  restaurant_id number(8) not null,
  customer_id number(8) not null,
  offer_id number(8) not null,
  delivery_boy_id number(8) not null,
  payment_type_id number(8) not null,
  status varchar(40) not null,
  tax number(3,2) not null,
  delivery_charge number(3,2) not null,
  addressLine_1 varchar(30) not null,
  addressLine_2 varchar(30),
  city varchar(15),
  state varchar(15),
  zipcode number(5),
  primary key(order_id),
  foreign key(restaurant_id) references restaurant(restaurant_id) on delete cascade,
  foreign key(customer_id) references customer(customer_id) on delete cascade,
  foreign key(offer_id) references restaurant_coupon_relation(offer_id) on delete cascade,
  foreign key(delivery_boy_id) references delivery_boy(delivery_boy_id) on delete cascade,
  foreign key(payment_type_id) references payment_type(payment_type_id) on delete cascade
  
);


CREATE TABLE ordered_items(
oi_id number(8),
order_id number(8) NOT NULL,
item_id number(8) NOT NULL,
quantity number(3) NOT NULL,
PRIMARY KEY(oi_id),
FOREIGN KEY(order_id) REFERENCES orders(order_id) on delete cascade,
FOREIGN KEY(item_id) REFERENCES items(item_id) on delete cascade
);

alter table coupons
modify (details varchar2(1000));

commit;

---------------------------------------------------------------------------------------------------------
-- EXECUTE FROM RESTAURANT MANAGER --
---------------------------------------------------------------------------------------------------------


INSERT INTO appadmin.restaurant (restaurant_id, name, phone_number, opening_time, closing_time)
SELECT 12345678, 'Qdoba','123-456-7890', TO_TIMESTAMP('2022-03-22 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-22 20:00:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 12345678) UNION ALL
SELECT 23456789, 'KFC', '234-567-8901', TO_TIMESTAMP('2022-03-23 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-23 21:00:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 23456789) UNION ALL
SELECT 34567890, 'Burger King', '345-678-9012', TO_TIMESTAMP('2022-03-24 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-24 21:00:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 34567890) UNION ALL
SELECT 45678901, 'Olive Garden', '456-789-0123', TO_TIMESTAMP('2022-03-25 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-25 22:00:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 45678901) UNION ALL
SELECT 56789012, 'Guapos', '567-890-1234', TO_TIMESTAMP('2022-03-26 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-26 20:00:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 56789012) UNION ALL
SELECT 67890123, 'Boston Burger Company', '678-901-2345', TO_TIMESTAMP('2022-03-27 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-27 22:00:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 67890123) UNION ALL
SELECT 78901234, 'McDonald’s', '789-012-3456', TO_TIMESTAMP('2022-03-28 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-28 22:00:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 78901234) UNION ALL
SELECT 89012345, 'Chick-fil-A', '890-123-4567', TO_TIMESTAMP('2022-03-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-29 23:00:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 89012345) UNION ALL
SELECT 90123456, 'Popeyes', '901-234-5678', TO_TIMESTAMP('2022-03-30 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-03-30 22:00','YYYY-MM-DD HH24:MI:SS') fROM dual where not exists(select * from appadmin.restaurant where restaurant_id = 90123456);


INSERT INTO appadmin.menu (menu_id, restaurant_id, menu_type) 
    select 12345678, 12345678, 'Lunch' from dual where not exists (select * from appadmin.menu where menu_id = 12345678) union all
    select 23456789, 23456789, 'Dinner' from dual where not exists (select * from appadmin.menu where menu_id = 23456789) union all
    select 34567890, 34567890, 'Breakfast' from dual where not exists (select * from appadmin.menu where menu_id = 34567890) union all
    select 45678901, 45678901, 'Brunch' from dual where not exists (select * from appadmin.menu where menu_id = 45678901) union all
    select 56789012, 56789012, 'Dessert' from dual where not exists (select * from appadmin.menu where menu_id = 56789012) union all
    select 67890123, 67890123, 'Appetizers' from dual where not exists (select * from appadmin.menu where menu_id = 67890123) union all
    select 78901234, 78901234, 'Drinks' from dual where not exists (select * from appadmin.menu where menu_id = 78901234) union all
    select 89012345, 89012345, 'Seafood' from dual where not exists (select * from appadmin.menu where menu_id = 89012345) union all
    select 90123456, 90123456, 'Vegetarian' from dual where not exists (select * from appadmin.menu where menu_id = 90123456) union all
    select 11111111, 12345678, 'Italian' from dual where not exists (select * from appadmin.menu where menu_id = 11111111);
    

INSERT INTO appadmin.items (item_id, menu_id, item_name, cost)
    select 12345678, 12345678, 'Spaghetti Carbonara', 10.99 from dual where not exists(select * from appadmin.items where item_id = 12345678) union all
    select 23456789, 12345678, 'Chicken Parmesan', 12.99 from dual where not exists(select * from appadmin.items where item_id = 23456789) union all
    select 34567890, 23456789, 'Filet Mignon', 24.99 from dual where not exists(select * from appadmin.items where item_id = 34567890) union all
    select 45678901, 23456789, 'Salmon with Asparagus', 18.99 from dual where not exists(select * from appadmin.items where item_id = 45678901) union all
    select 56789012, 34567890, 'Pancakes with Syrup', 7.99 from dual where not exists(select * from appadmin.items where item_id = 56789012) union all
    select 67890123, 34567890, 'Eggs Benedict', 8.99 from dual where not exists(select * from appadmin.items where item_id = 67890123) union all
    select 78901234, 45678901, 'Key Lime Pie', 5.99 from dual where not exists(select * from appadmin.items where item_id = 78901234) union all
    select 89012345, 45678901, 'Chocolate Cake', 6.99 from dual where not exists(select * from appadmin.items where item_id = 89012345) union all
    select 90123456, 56789012, 'Ice Cream Sundae', 4.99 from dual where not exists(select * from appadmin.items where item_id = 90123456) union all
    select 11111111, 56789012, 'Banana Split', 6.99  from dual where not exists(select * from appadmin.items where item_id = 11111111);
    

INSERT INTO appadmin.branch_address (branch_id, restaurant_id, addressLine_1, addressLine_2, city, state, zipcode)
    select 1, 12345678, '123 Main St', 'Suite 101', 'New York', 'NY', 10001 from dual where not exists (select * from appadmin.branch_address where branch_id = 1) union all
    select 2, 23456789, '456 First Ave', '', 'Los Angeles', 'CA', 90001 from dual where not exists (select * from appadmin.branch_address where branch_id = 2) union all
    select 3, 34567890, '789 Second St', 'Unit 5', 'Chicago', 'IL', 60601 from dual where not exists (select * from appadmin.branch_address where branch_id = 3) union all
    select 4, 45678901, '10 Third St', '', 'Houston', 'TX', 77001 from dual where not exists (select * from appadmin.branch_address where branch_id = 4) union all
    select 5, 56789012, '555 Fourth St', 'Floor 12', 'Miami', 'FL', 33101 from dual where not exists (select * from appadmin.branch_address where branch_id = 5) union all
    select 6, 67890123, '111 Fifth Ave', '', 'New York', 'NY', 10001 from dual where not exists (select * from appadmin.branch_address where branch_id = 6) union all
    select 7, 78901234, '222 Sixth Ave', '', 'Los Angeles', 'CA', 90001 from dual where not exists (select * from appadmin.branch_address where branch_id = 7) union all
    select 8, 89012345, '333 Seventh St', 'Suite 10', 'Chicago', 'IL', 60601 from dual where not exists (select * from appadmin.branch_address where branch_id = 8) union all
    select 9, 90123456, '444 Eighth St', 'Floor 3', 'Houston', 'TX', 77001 from dual where not exists (select * from appadmin.branch_address where branch_id = 9) union all
    select 10, 12345678, '999 Ninth St', '', 'Miami', 'FL', 33101 from dual where not exists (select * from appadmin.branch_address where branch_id = 10);


INSERT INTO appadmin.coupons (promo_code_id, promo_code, offer_percentage, minimum_order, maximum_discount, details)
SELECT 1001, 'SUMMER20', 20, 50, 10, 'Get 20% off on orders above 50. Maximum discount of 10' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1001) UNION ALL
SELECT 1002, 'WINTER30', 30, 10, 20, 'Get 30% off on orders above 100. Maximum discount of 20' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1002) UNION ALL
SELECT 1003, 'SPRING10', 10, 30, 5, 'Get 10% off on orders above 30. Maximum discount of 5' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1003) UNION ALL
SELECT 1004, 'FALL25', 25, 75, 15, 'Get 25% off on orders above 75. Maximum discount of 15' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1004) UNION ALL
SELECT 1005, 'JULY4', 15, 40, 8, 'Get 15% off on orders above 40. Maximum discount of 8.' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1005) UNION ALL
SELECT 1006, 'LABOR20', 20, 60, 12, 'Get 20% off on orders above 60. Maximum discount of 12.' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1006) UNION ALL
SELECT 1007, 'MEMORIAL15', 15, 35, 7, 'Get 15% off on orders above 35. Maximum discount of 7.' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1007) UNION ALL
SELECT 1008, 'CYBERMON25', 25, 10, 20, 'Get 25% off on orders above 100. Maximum discount of 20.' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1008) UNION ALL
SELECT 1009, 'BLACKFRI30', 30, 50, 30, 'Get 30% off on orders above 150. Maximum discount of 30.' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1009) UNION ALL
SELECT 1010, 'NEWYEAR20', 20, 50, 10, 'Get 20% off on orders above 50. Maximum discount of 10.' FROM dual where not exists (select * from appadmin.coupons where promo_code_id = 1010);
  
    
INSERT INTO appadmin.restaurant_coupon_relation ( offer_id,promo_code_id, restaurant_id )

    select 1, 1001, 12345678 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=1) union all
    select 2, 1002, 23456789 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id = 2) union all
    select 3, 1003, 34567890 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=3) union all
    select 4, 1004, 45678901 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=4) union all
    select 5, 1005, 56789012 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=5) union all
    select 6, 1006, 67890123 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=6) union all
    select 7, 1007, 78901234 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=7) union all
    select 8, 1008, 89012345 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=8)union all
    select 9, 1009, 90123456 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=9) union all
    select 10, 1010, 12345678 from dual where not exists(select * from appadmin.restaurant_coupon_relation where offer_id=10);

commit;
    




---------------------------------------------------------------------------------------------------------
-- EXECUTE FROM DELIVERY BOY --
---------------------------------------------------------------------------------------------------------

select * from appadmin.delivery_boy;
INSERT INTO appadmin.delivery_boy (delivery_boy_id, first_name, last_name, phone_number, vehicle_number)
    select 1001, 'John', 'Doe', '111-555-1234', 'ABC123' from dual where not exists (select * from appadmin.delivery_boy where delivery_boy_id = 1001) union all
    select 1002, 'Jane', 'Doe', '123-555-5678', 'DEF456' from dual where not exists (select * from appadmin.delivery_boy where delivery_boy_id = 1002) union all
    select 1003, 'Bob', 'Smith', '122-555-9012', 'GHI789' from dual where not exists(select * from appadmin.delivery_boy where  delivery_boy_id = 1003) union all
    select 1004, 'Alice', 'Johnson', '111-555-3456', 'JKL012' from dual where not exists(select * from appadmin.delivery_boy where delivery_boy_id = 1004) union all
    select 1005, 'Jim', 'Davis', '111-555-7890', 'MNO345' from dual where not exists(select * from appadmin.delivery_boy where delivery_boy_id = 1005) union all
    select 1006, 'Sara', 'Lee', '222-555-2345', 'PQR678' from dual where not exists(select * from appadmin.delivery_boy where delivery_boy_id = 1006) union all
    select 1007, 'Tom', 'Johnson', '345-555-6789', 'STU901' from dual where not exists(select * from appadmin.delivery_boy where delivery_boy_id = 1007) union all
    select 1008, 'Emily', 'Williams', '342-555-0123', 'VWX234' from dual where not exists(select * from appadmin.delivery_boy where delivery_boy_id = 1008) union all
    select 1009, 'Mike', 'Brown', '222-555-4567', 'YZA567' from dual where not exists(select * from appadmin.delivery_boy where delivery_boy_id = 1009) union all
    select 1010, 'Lisa', 'Taylor', '678-555-8901', 'BCD890' from dual where not exists(select * from appadmin.delivery_boy where delivery_boy_id = 1010);
    
commit;



---------------------------------------------------------------------------------------------------------
-- EXECUTE FROM CUSTOMER --
---------------------------------------------------------------------------------------------------------


INSERT INTO appadmin.customer(customer_id, first_name, last_name, phone_number, email_id) 
    select 12345678, 'John', 'Doe', '123-456-7890', 'johndoe@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 12345678) union all
    select 23456789, 'Jane', 'Doe', '234-567-8901', 'janedoe@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 23456789) union all
    select 34567890, 'Bob', 'Smith', '345-678-9012', 'bobsmith@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 34567890) union all
    select 45678901, 'Alice', 'Jones', '456-789-0123', 'alicejones@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 45678901) union all
    select 56789012, 'Mike', 'Brown', '567-890-1234', 'mikebrown@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 56789012) union all
    select 67890123, 'Sarah', 'Lee', '678-901-2345', 'sarahlee@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 67890123) union all
    select 78901234, 'David', 'Garcia', '789-012-3456', 'davidgarcia@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 78901234) union all
    select 89012345, 'Julia', 'Kim', '890-123-4567', 'juliakim@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 89012345) union all
    select 90123456, 'Tom', 'Wilson', '901-234-5678', 'tomwilson@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 90123456) union all
    select 11111111, 'Emily', 'Davis', '111-111-1111', 'emilydavis@example.com' from dual where not exists (select * from appadmin.customer where customer_id = 11111111);


 
INSERT INTO appadmin.payment_type (payment_type_id, payment_type, payment_date)
  select 1, 'Credit Card', TO_DATE('2023-03-20', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 1) union all
  select 2, 'Debit Card', TO_DATE('2023-03-19', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 2) union all
  select 3, 'PayPal', TO_DATE('2023-03-21', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 3) union all
  select 4, 'Google Pay', TO_DATE('2023-03-18', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 4) union all
  select 5, 'Apple Pay', TO_DATE('2023-03-22', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 5) union all
  select 6, 'Apple Pay', TO_DATE('2023-03-20', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 6) union all
  select 7, 'Credit Card', TO_DATE('2023-03-21', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 7) union all
  select 8, 'Venmo', TO_DATE('2023-03-22', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 8) union all
  select 9, 'Zelle', TO_DATE('2023-03-19', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 9) union all
  select 10, 'Paypal', TO_DATE('2023-03-18', 'YYYY-MM-DD') from dual where not exists(select * from appadmin.payment_type where payment_type_id = 10);



INSERT INTO appadmin.orders (order_id, restaurant_id, customer_id, offer_id, delivery_boy_id, payment_type_id, status, tax, delivery_charge, addressLine_1, addressLine_2, city, state, zipcode)
    select 1, 12345678, 12345678, 1, 1001, 1, 'Pending', 2.50, 5.00, '123 Main St', 'Apt 2B', 'New York', 'NY', 10001 from dual where not exists (select * from appadmin.orders where order_id = 1) union all
    select 2, 23456789, 23456789, 2, 1002, 2, 'Delivered', 2.00, 4.50, '456 Elm St', 'Unit 3A', 'Boston', 'MA', 02115 from dual where not exists (select * from appadmin.orders where order_id = 2) union all
    select 3, 34567890, 34567890, 3, 1003, 3, 'Cancelled', 1.50, 4.00, '789 Oak St', 'Suite 5C', 'Chicago', 'IL', 60610 from dual where not exists (select * from appadmin.orders where order_id = 3) union all
    select 4, 45678901, 45678901, 4, 1004, 4, 'Delivered', 2.75, 6.50, '321 Pine St', 'Unit 1D', 'San Francisco', 'CA', 94102 from dual where not exists (select * from appadmin.orders where order_id = 4) union all
    select 5, 56789012, 56789012, 5, 1005, 5, 'Pending', 1.25, 3.00, '567 Maple St', 'Apt 4F', 'Los Angeles', 'CA', 90001 from dual where not exists (select * from appadmin.orders where order_id = 5) union all
    select 6, 67890123, 67890123, 6, 1006, 6, 'Delivered', 1.00, 2.50, '432 Oak St', 'Unit 2B', 'Seattle', 'WA', 98101 from dual where not exists (select * from appadmin.orders where order_id = 6) union all
    select 7, 78901234, 78901234, 7, 1007, 7, 'Pending', 2.00, 5.00, '876 Main St', 'Suite 3C', 'Austin', 'TX', 78701 from dual where not exists (select * from appadmin.orders where order_id = 7) union all
    select 8, 89012345, 89012345, 8, 1008, 8, 'Delivered', 1.50, 4.50, '654 Elm St', 'Apt 2A', 'Denver', 'CO', 80202 from dual where not exists (select * from appadmin.orders where order_id = 8) union all
    select 9, 90123456, 90123456, 9, 1009, 9, 'Cancelled', 1.75, 4.00, '987 Oak St', 'Unit 4D', 'Miami', 'FL', 33101 from dual where not exists (select * from appadmin.orders where order_id = 9) union all
    select 10, 12345678, 12345678, 10, 1010, 10, 'Pending', 1.00, 3.00, '543 Pine St', 'Apt 3E', 'Portland', 'OR', 97201 from dual where not exists (select * from appadmin.orders where order_id = 10);

    
    
INSERT INTO appadmin.ordered_items (OI_id, order_id, item_id, quantity)
  select 1, 1, 12345678, 2 from dual where not exists (select * from appadmin.ordered_items where OI_id = 1) union all
  select 2, 2, 23456789, 1 from dual where not exists (select * from appadmin.ordered_items where OI_id = 2) union all
  select 3, 3, 34567890, 3 from dual where not exists (select * from appadmin.ordered_items where OI_id = 3)union all
  select 4, 4, 45678901, 2 from dual where not exists (select * from appadmin.ordered_items where OI_id = 4)union all
  select 5, 5, 56789012, 1 from dual where not exists (select * from appadmin.ordered_items where OI_id = 5)union all
  select 6, 6, 67890123, 2 from dual where not exists (select * from appadmin.ordered_items where OI_id = 6)union all
  select 7, 7, 78901234, 1 from dual where not exists (select * from appadmin.ordered_items where OI_id = 7)union all
  select 8, 8, 89012345, 2 from dual where not exists (select * from appadmin.ordered_items where OI_id = 8)union all
  select 9, 9, 90123456, 1 from dual where not exists (select * from appadmin.ordered_items where OI_id = 9)union all
  select 10, 10, 11111111, 3 from dual where not exists (select * from appadmin.ordered_items where OI_id = 10);

commit;

