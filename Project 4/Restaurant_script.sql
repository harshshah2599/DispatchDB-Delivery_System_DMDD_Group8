set serveroutput on

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '1234567890',TO_TIMESTAMP('2022-03-22 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-22 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Qdoba');

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '2345678901',TO_TIMESTAMP('2022-03-23 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-23 21:00:00', 'YYYY-MM-DD HH24:MI:SS'),'KFC');

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '3456789012',TO_TIMESTAMP('2022-03-24 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-24 21:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Burger King');

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '4567890123',TO_TIMESTAMP('2022-03-25 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-25 22:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Olive Garden');

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '5678901234',TO_TIMESTAMP('2022-03-26 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-26 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Guapos');

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '6789012345',TO_TIMESTAMP('2022-03-27 13:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-27 22:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Boston Burger Company');

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '7890123456',TO_TIMESTAMP('2022-03-28 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-28 22:00:00', 'YYYY-MM-DD HH24:MI:SS'),'McDonald?s');

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '8901234567',TO_TIMESTAMP('2022-03-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-29 23:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Chick-fil-A');

execute restaurant_manager.upsert_restaurant_details(appadmin.RESTAURANT_SEQUENCE.nextval, '9012345678',TO_TIMESTAMP('2022-03-30 16:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2022-03-30 22:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Popeyes');

-----------------------------------------------------------------------
set serveroutput on;
SET SERVEROUTPUT ON;

execute restaurant_manager.upsert_branch_details('Burger King',appadmin.branch_id_seq.nextval,'123 Main St','Suite 101','New York','NY','10001');
execute restaurant_manager.upsert_branch_details('Guapos',appadmin.branch_id_seq.nextval,'456 First Ave','','Los Angeles','CA','90001');
execute restaurant_manager.upsert_branch_details('Burger King',appadmin.branch_id_seq.nextval,'789 Second St','Unit 5','Chicago','IL','60601');
execute restaurant_manager.upsert_branch_details('Burger King',appadmin.branch_id_seq.nextval,'789 Second St','Unit 5','Chicago','IL','60601');
EXECUTE restaurant_manager.upsert_branch_details('Popeyes', appadmin.branch_id_seq.nextval, '10 Third St','','Houston','TX','77001');

EXECUTE restaurant_manager.upsert_branch_details('Olive Garden', appadmin.branch_id_seq.nextval, '333 Seventh St','','Chicago','IL','60601');
EXECUTE restaurant_manager.upsert_branch_details('KFC', appadmin.branch_id_seq.nextval, '444 Eighth St','Floor 3','Houston','TX','77001');
EXECUTE restaurant_manager.upsert_branch_details('Boston Burger Company', appadmin.branch_id_seq.nextval, '999 Ninth St','','Miami','FL','33101');

EXECUTE restaurant_manager.upsert_branch_details('Boston Burger Company',appadmin.branch_id_seq.nextval,'555 Fourth St', 'Floor 12','Miami','FL','33101');
EXECUTE restaurant_manager.upsert_branch_details('Guapos',appadmin.branch_id_seq.nextval,'111 Fifth Ave', '','New York','NY','10001');
EXECUTE restaurant_manager.upsert_branch_details('KFC',appadmin.branch_id_seq.nextval,'222 Sixth Ave', '','Los Angeles','CA','90001');
---------------------------------------------------------------------------------------------
EXECUTE restaurant_manager.upsert_menu_type(7000,1003,'Lunch');
EXECUTE restaurant_manager.upsert_menu_type(7001,1009,'Dinner');
EXECUTE restaurant_manager.upsert_menu_type(7002,'1002','Breakfast');
EXECUTE restaurant_manager.upsert_menu_type(7003,'1006','Brunch');
EXECUTE restaurant_manager.upsert_menu_type(7004,'1006','Dessert');
EXECUTE restaurant_manager.upsert_menu_type(7005,'1009','Appetizers');
EXECUTE restaurant_manager.upsert_menu_type(7006,'1003','Drinks');
EXECUTE restaurant_manager.upsert_menu_type(7007,'1005','Seafood');
EXECUTE restaurant_manager.upsert_menu_type(7008,'1005','Vegetarian');
EXECUTE restaurant_manager.upsert_menu_type(7009,'1002','Italian');
--------------------------------------------------------------------------------------------
execute restaurant_manager.upsert_items(appadmin.items_seq.nextval,7000,'Spaghetti Carbonara',10.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7004, 'Spaghetti Carbonara', 10.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7008, 'Chicken Parmesan', 12.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7007, 'Filet Mignon', 24.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7001, 'Salmon with Asparagus', 18.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7003, 'Pancakes with Syrup', 7.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7004, 'Eggs Benedict', 8.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7003, 'Key Lime Pie', 5.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7005, 'Chocolate Cake', 6.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7006, 'Ice Cream Sundae', 4.99);
EXECUTE restaurant_manager.upsert_items(appadmin.items_seq.nextval, 7001, 'Banana Split', 6.99);

---------------------------------------------------------------------------------------------------------
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'SUMMER2',20,50,10,'Get 20% off on orders above 50. Maximum discount of 10');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'WINTER30',30,10,20,'Get 30% off on orders above 100. Maximum discount of 20');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'SPRING10',10,30,5,'Get 10% off on orders above 30. Maximum discount of 5');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'FALL25',25,75,15,'Get 25% off on orders above 75. Maximum discount of 15');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'JULY4',15,40,8,'Get 15% off on orders above 40. Maximum discount of 8');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'LABOR20',20,60,12,'Get 20% off on orders above 12. Maximum discount of 12');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'MEMORIAL15',20,50,10,'Get 20% off on orders above 10. Maximum discount of 10');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'CYBERMON25',25,10,20,'Get 25% off on orders above 20. Maximum discount of 10');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'BLACKFRI30',30,50,10,'Get 30% off on orders above 10. Maximum discount of 10');
EXECUTE restaurant_manager.upsert_coupon(appadmin.coupons_seq.nextval,'NEWYEAR20',20,50,10,'Get 20% off on orders above 10. Maximum discount of 10');


--------------------------------------------------------------------------------------------------------------
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10000,1000);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10001,1003);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10005,1005);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10007,1006);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10004,1000);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10005,1009);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10004,1007);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10003,1004);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10006,1002);
execute restaurant_manager.upsert_restaurant_coupon_relation(appadmin.RESTAURANT_COUPON_RELATION_SEQUENCE.nextval,10003,1001);

commit;

--select * from appadmin.restaurant;
--select * from appadmin.branch_address;
--select * from appadmin.menu;
--select * from appadmin.items;
--select * from appadmin.coupons;
--select * from appadmin.restaurant_coupon_relation;



execute restaurant_manager.update_delivery_status(8003,'prepared');
commit;