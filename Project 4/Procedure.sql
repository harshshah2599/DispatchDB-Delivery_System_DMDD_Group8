--------------------------------------------------------
--  DDL for Procedure CANCELORDER
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE "APPADMIN"."CANCELORDER" (
  orderId IN ORDERS.ORDER_ID%TYPE
)
IS
  orderStatus ORDERS.STATUS%TYPE;
  current_user VARCHAR2(30) := USER;
BEGIN
  -- Get the status of the order
  
IF current_user = 'RESTAURANTMANAGER' OR current_user = 'CUSTOMER' THEN
  SELECT STATUS INTO orderStatus FROM ORDERS WHERE ORDER_ID = orderId;

  -- Cancel the order only if it's in Placed or Processing status
  IF orderStatus = 'Placed' OR orderStatus = 'Preparing' THEN
    -- Set the quantity to 0 for all ordered items
    UPDATE ORDERED_ITEMS SET QUANTITY = 0 WHERE ORDER_ID = orderId;

    -- Update the order status to Cancelled
    UPDATE ORDERS SET STATUS = 'Cancelled' WHERE ORDER_ID = orderId;

    DBMS_OUTPUT.PUT_LINE('Order ' || orderId || ' has been cancelled.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Order ' || orderId || ' cannot be cancelled as its status is ' || orderStatus || '.');
  END IF;
        
ELSE
            -- Display an error message if the current user is not authorized to update order status
    RAISE_APPLICATION_ERROR(-20002, 'User ' || current_user || ' is not authorized to update order status.');
END IF;
  
END;

/
