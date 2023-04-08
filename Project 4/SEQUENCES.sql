---------------------------------------------------------------------------------------------------------
-- EXECUTE FROM APP ADMIN --
---------------------------------------------------------------------------------------------------------

-- SEQUENCES --


CREATE SEQUENCE restaurant_sequence START WITH 1000 INCREMENT BY 1 MAXVALUE 99999999 NOCACHE NOCYCLE;

create table restaurant (
  restaurant_id number(8) DEFAULT restaurant_sequence.NEXTVAL PRIMARY KEY,
  name varchar(45) not null,
  phone_number varchar(12) not null,
  opening_time timestamp,
  closing_time timestamp  
);

CREATE SEQUENCE menu_seq
  START WITH 7000
  INCREMENT BY 1
  MAXVALUE 99999999
  NOCACHE
  NOCYCLE;

create table menu (
  menu_id number(8) DEFAULT menu_seq.NEXTVAL,
  restaurant_id number(8) not null,
  menu_type varchar(45) not null,
  constraint fk_menu
  foreign key(restaurant_id) references restaurant(restaurant_id) 
  on delete CASCADE,
  primary key(menu_id)
);

CREATE SEQUENCE items_seq
  START WITH 3000
  INCREMENT BY 1
  MAXVALUE 99999999
  NOCACHE
  NOCYCLE;


CREATE TABLE items (
  item_id NUMBER(8) DEFAULT items_seq.NEXTVAL,
  menu_id NUMBER(8) NOT NULL,
  item_name VARCHAR(30) NOT NULL,
  cost NUMBER(4,2) NOT NULL, 
  PRIMARY KEY (item_id),
  CONSTRAINT fk_items 
    FOREIGN KEY(menu_id) REFERENCES menu(menu_id)
    ON DELETE CASCADE
);

CREATE SEQUENCE branch_id_seq
 START WITH     2000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
 CREATE TABLE branch_address(
branch_id number(8) default branch_id_seq.NEXTVAL,
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

CREATE SEQUENCE customers_seq
 START WITH     5000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
 create table customer (
  customer_id number(8) default customers_seq.nextval,
  first_name varchar(45) not null,
  last_name varchar(45) not null,
  phone_number varchar(12) not null,
  email_id varchar(45),
  primary key(customer_id)
 );
 
 CREATE SEQUENCE DELIVERY_BOY_SEQ START WITH 4000 INCREMENT BY 1 NOCACHE NOCYCLE;

create table delivery_boy (
  delivery_boy_id number(8) DEFAULT DELIVERY_BOY_SEQ.NEXTVAL PRIMARY KEY,
  first_name varchar(45) not null,
  last_name varchar(45) not null,
  phone_number varchar(12) not null,
  vehicle_number varchar(10) not null);
  
 CREATE SEQUENCE coupons_seq
  START WITH 10000
  INCREMENT BY 1
  MAXVALUE 99999999
  NOCACHE
  NOCYCLE;

CREATE TABLE coupons(
promo_code_id number(8) DEFAULT coupons_seq.NEXTVAL,
promo_code varchar(20) NOT NULL,
offer_percentage number(2),
minimum_order number(2) NOT NULL,
maximum_discount number(8),
details varchar(500) NOT NULL,
PRIMARY KEY(promo_code_id)
);

CREATE SEQUENCE restaurant_coupon_relation_sequence START WITH 9000 INCREMENT BY 1 MAXVALUE 99999999 NOCACHE NOCYCLE;
CREATE TABLE restaurant_coupon_relation(
offer_id number(8) DEFAULT restaurant_coupon_relation_sequence.NEXTVAL PRIMARY KEY,
restaurant_id number(8) NOT NULL,
promo_code_id number(8) NOT NULL,
FOREIGN KEY(promo_code_id) REFERENCES coupons(promo_code_id) on delete cascade,
FOREIGN KEY(restaurant_id) REFERENCES restaurant(restaurant_id) on delete cascade
);
 

CREATE SEQUENCE payment_type_seq
  START WITH 6000
  INCREMENT BY 1
  MAXVALUE 99999999
  NOCACHE
  NOCYCLE;

CREATE TABLE payment_type(
payment_type_id number(8) DEFAULT payment_type_seq.NEXTVAL PRIMARY KEY,
payment_type varchar(40) NOT NULL,
payment_date date NOT NULL
);

CREATE SEQUENCE orders_seq
  START WITH 8000
  INCREMENT BY 1
  MAXVALUE 99999999
  NOCACHE
  NOCYCLE;

create table orders (
  order_id number(8) DEFAULT orders_seq.NEXTVAL PRIMARY KEY,
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
  foreign key(restaurant_id) references restaurant(restaurant_id) on delete cascade,
  foreign key(customer_id) references customer(customer_id) on delete cascade,
  foreign key(offer_id) references restaurant_coupon_relation(offer_id) on delete cascade,
  foreign key(delivery_boy_id) references delivery_boy(delivery_boy_id) on delete cascade,
  foreign key(payment_type_id) references payment_type(payment_type_id) on delete cascade  
);

CREATE SEQUENCE ORDERED_ITEMS_SEQ START WITH 11000 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE TABLE ordered_items(
oi_id number(8) DEFAULT ORDERED_ITEMS_SEQ.NEXTVAL PRIMARY KEY,
order_id number(8) NOT NULL,
item_id number(8) NOT NULL,
quantity number(3) NOT NULL,
FOREIGN KEY(order_id) REFERENCES orders(order_id) on delete cascade,
FOREIGN KEY(item_id) REFERENCES items(item_id) on delete cascade
);


COMMIT;