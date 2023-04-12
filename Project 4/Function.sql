--------------------------------------------------------
--  DDL for Function FNCALCULATEORDERTOTALAMOUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "APPADMIN"."FNCALCULATEORDERTOTALAMOUNT" (f_orderId IN NUMBER, f_offer_id NUMBER, f_tax NUMBER, f_delivery_charge NUMBER)
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
END;

/
