CREATE OR REPLACE PACKAGE restaurant_manager AS 

    PROCEDURE upsert_restaurant_details (
    p_restaurant_id IN NUMBER,
    p_phone_number IN VARCHAR2,
    p_opening_time IN TIMESTAMP,
    p_closing_time IN TIMESTAMP,
    p_name IN VARCHAR2
  );
  
    PROCEDURE upsert_branch_details (
    p_restaurant_name IN VARCHAR2,
    p_branch_id IN NUMBER,
    p_addressline_1 IN VARCHAR2,
    p_addressline_2 IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zipcode IN VARCHAR2
  );
  
    PROCEDURE upsert_items (
    i_item_id IN NUMBER,
    i_menu_id IN NUMBER,
    i_item_name IN VARCHAR2,
    i_item_cost IN NUMBER
  );
  
    PROCEDURE upsert_menu_type(
    p_menu_id IN NUMBER,
    p_restaurant_id IN NUMBER,
    p_menu_type IN VARCHAR
  );
  
   PROCEDURE upsert_coupon (
    p_pc_id IN NUMBER,
    p_pc IN VARCHAR,
    p_offer_percent IN NUMBER,
    p_min_order IN NUMBER,
    p_max_disc IN NUMBER,
    p_det IN VARCHAR
  );
  
   PROCEDURE upsert_restaurant_coupon_relation(
   p_offer_id IN NUMBER,
   p_promo_code_id IN NUMBER,
   p_restaurant_id IN NUMBER
  );
  
  PROCEDURE UPDATE_DELIVERY_STATUS (
        order_id_in IN NUMBER,
        status_in IN VARCHAR2
    );
END restaurant_manager;
/

CREATE OR REPLACE PACKAGE BODY restaurant_manager AS 

   PROCEDURE upsert_restaurant_details (
    p_restaurant_id IN NUMBER,
    p_phone_number IN VARCHAR2,
    p_opening_time IN TIMESTAMP,
    p_closing_time IN TIMESTAMP,
    p_name IN VARCHAR2
  ) IS
    restaurant_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO restaurant_count
    FROM appadmin.restaurant
    WHERE name = p_name;

    IF restaurant_count > 0 THEN
      UPDATE appadmin.restaurant
      SET phone_number = p_phone_number,
          opening_time = p_opening_time,
          closing_time = p_closing_time,
          name = p_name
      WHERE restaurant_id = p_restaurant_id;
    ELSE
      INSERT INTO appadmin.restaurant (restaurant_id, phone_number, opening_time, closing_time, name)
      VALUES (p_restaurant_id, p_phone_number, p_opening_time, p_closing_time, p_name);
    END IF;
  END upsert_restaurant_details;
  
    PROCEDURE upsert_branch_details (
    p_restaurant_name IN VARCHAR2,
    p_branch_id IN NUMBER,
    p_addressline_1 IN VARCHAR2,
    p_addressline_2 IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zipcode IN VARCHAR2
  ) IS
    v_restaurant_id NUMBER;
    v_branch_count NUMBER;
  BEGIN
    SELECT restaurant_id INTO v_restaurant_id
    FROM appadmin.restaurant
    WHERE name = p_restaurant_name;

    SELECT COUNT(*) INTO v_branch_count
    FROM appadmin.branch_address
    WHERE branch_id = p_branch_id;

    IF v_branch_count > 0 THEN
      UPDATE appadmin.branch_address
      SET addressLine_1 = p_addressline_1,
          addressLine_2 = p_addressline_2,
          city = p_city,
          state = p_state,
          zipcode = p_zipcode
      WHERE branch_id = p_branch_id;
    ELSE
      INSERT INTO appadmin.branch_address (branch_id, restaurant_id, addressLine_1, addressLine_2, city, state, zipcode)
      VALUES (p_branch_id, v_restaurant_id, p_addressline_1, p_addressline_2, p_city, p_state, p_zipcode);
    END IF;
  END upsert_branch_details;
  
    PROCEDURE upsert_items (
    i_item_id IN NUMBER,
    i_menu_id IN NUMBER,
    i_item_name IN VARCHAR2,
    i_item_cost IN NUMBER
  ) IS 
    exist_cnt NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO exist_cnt FROM appadmin.items WHERE item_id = i_item_id;
    IF exist_cnt > 0 THEN
      UPDATE appadmin.items
      SET menu_id = i_menu_id,
          item_name = i_item_name,
          cost = i_item_cost
      WHERE item_id = i_item_id;
    ELSE
      INSERT INTO appadmin.items (item_id, menu_id, item_name, cost)
      VALUES (i_item_id, i_menu_id, i_item_name, i_item_cost);
    END IF;
  END upsert_items;
  
    PROCEDURE upsert_menu_type(
    p_menu_id IN NUMBER,
    p_restaurant_id IN NUMBER,
    p_menu_type IN VARCHAR
) AS
    v_menu_exists NUMBER(1);
BEGIN
    SELECT COUNT(*) INTO v_menu_exists
    FROM appadmin.MENU
    WHERE MENU_ID = p_menu_id AND RESTAURANT_ID = p_restaurant_id;
    
    IF v_menu_exists > 0 THEN
        UPDATE appadmin.MENU
        SET MENU_TYPE = p_menu_type
        WHERE MENU_ID = p_menu_id AND RESTAURANT_ID = p_restaurant_id;
    ELSE
        INSERT INTO appadmin.MENU (MENU_ID, RESTAURANT_ID, MENU_TYPE)
        VALUES (p_menu_id, p_restaurant_id, p_menu_type);
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Menu type updated successfully');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error updating menu type: ' || SQLERRM);
END;
 
PROCEDURE upsert_coupon (
    p_pc_id IN NUMBER,
    p_pc IN VARCHAR,
    p_offer_percent IN NUMBER,
    p_min_order IN NUMBER,
    p_max_disc IN NUMBER,
    p_det IN VARCHAR
  )
  IS 
    var_count NUMBER := 0;
  BEGIN 
    -- Check if the coupon already exists 
    SELECT COUNT(*) 
    INTO var_count 
    FROM appadmin.COUPONS 
    WHERE PROMO_CODE_ID = p_pc_id;
    
    IF var_count = 0 THEN 
      -- Coupon does not exist, insert new row 
      INSERT INTO appadmin.COUPONS (
        PROMO_CODE_ID, 
        PROMO_CODE, 
        OFFER_PERCENTAGE, 
        MINIMUM_ORDER, 
        MAXIMUM_DISCOUNT, 
        DETAILS
      ) VALUES (
        p_pc_id,
        p_pc,
        p_offer_percent,
        p_min_order,
        p_max_disc,
        p_det
      ); 
    ELSE 
      -- Coupon exists, update the row 
      UPDATE appadmin.COUPONS 
      SET 
        PROMO_CODE = p_pc, 
        OFFER_PERCENTAGE = p_offer_percent, 
        MINIMUM_ORDER = p_min_order, 
        MAXIMUM_DISCOUNT = p_max_disc, 
        DETAILS = p_det 
      WHERE PROMO_CODE_ID = p_pc_id; 
    END IF; 
  END upsert_coupon;  
  
    PROCEDURE upsert_restaurant_coupon_relation(
        p_offer_id IN NUMBER,
        p_promo_code_id IN NUMBER,
        p_restaurant_id IN NUMBER
    )
    AS
        v_count NUMBER;
    BEGIN
        -- Check if the record exists
        SELECT COUNT(*) INTO v_count 
        FROM appadmin.restaurant_coupon_relation 
        WHERE offer_id = p_offer_id 
        AND promo_code_id = p_promo_code_id 
        AND restaurant_id = p_restaurant_id;

        IF v_count = 0 THEN
            -- Insert the record if it doesn't exist
            INSERT INTO appadmin.restaurant_coupon_relation (
                offer_id, 
                promo_code_id, 
                restaurant_id
            ) VALUES (
                p_offer_id, 
                p_promo_code_id, 
                p_restaurant_id
            );
        ELSE
            -- Update the record if it already exists
            UPDATE appadmin.restaurant_coupon_relation 
            SET offer_id = p_offer_id 
            WHERE promo_code_id = p_promo_code_id 
            AND restaurant_id = p_restaurant_id;
        END IF;

      
    END upsert_restaurant_coupon_relation;
    
     PROCEDURE UPDATE_DELIVERY_STATUS (
        order_id_in IN NUMBER,
        status_in IN VARCHAR2
    )
    IS
        current_user VARCHAR2(30) := USER;
    BEGIN
        IF current_user = 'RESTAURANTMANAGER' THEN
            UPDATE appadmin.ORDERS
            SET STATUS = status_in
            WHERE ORDER_ID = order_id_in;
        ELSIF current_user = 'DELIVERY_BOY' THEN
            UPDATE appadmin.ORDERS
            SET STATUS = status_in
            WHERE ORDER_ID = order_id_in;
        ELSE
            -- Display an error message if the current user is not authorized to update order status
            RAISE_APPLICATION_ERROR(-20002, 'User ' || current_user || ' is not authorized to update order status.');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback the transaction and re-raise the exception
            ROLLBACK;
            RAISE;
    END UPDATE_DELIVERY_STATUS;
    
    
END restaurant_manager;
/

commit;
--------------------------------------------------------------------------
