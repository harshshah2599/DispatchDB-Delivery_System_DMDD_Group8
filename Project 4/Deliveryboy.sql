CREATE OR REPLACE PACKAGE pkg_Deliveryboy_mgmt AS

    PROCEDURE upsert_delivery_boy_details (
        p_delivery_boy_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_phone_number IN VARCHAR2,
        p_vehicle_number IN VARCHAR2
    );

    PROCEDURE UPDATE_DELIVERY_STATUS (
        order_id_in IN NUMBER,
        status_in IN VARCHAR2
    );

END pkg_Deliveryboy_mgmt;
/



CREATE OR REPLACE PACKAGE BODY pkg_Deliveryboy_mgmt AS

    -- Upsert delivery boy details

    PROCEDURE upsert_delivery_boy_details (
        p_delivery_boy_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_phone_number IN VARCHAR2,
        p_vehicle_number IN VARCHAR2
    )
    IS
        exist_cnt NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO exist_cnt FROM appadmin.delivery_boy WHERE delivery_boy_id = p_delivery_boy_id;
        IF exist_cnt > 0 THEN
            UPDATE appadmin.delivery_boy SET
                first_name = p_first_name,
                last_name = p_last_name,
                phone_number = p_phone_number,
                vehicle_number = p_vehicle_number
            WHERE delivery_boy_id = p_delivery_boy_id;
        ELSE
            INSERT INTO appadmin.delivery_boy(delivery_boy_id, first_name, last_name, phone_number, vehicle_number)
            VALUES (p_delivery_boy_id, p_first_name, p_last_name, p_phone_number, p_vehicle_number);
        END IF;
    END upsert_delivery_boy_details;

    -- Update delivery status

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

END pkg_Deliveryboy_mgmt;
/



execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'John', 'Doe', '1115551234', 'ABC123');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Jane', 'Doe', '1235555678', 'DEF456');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Bob', 'Smith', '1225559012', 'GHI789');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Alice', 'Johnson', '1115553456', 'JKL012');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Jim', 'Davis', '1115557890', 'MNO345');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Sara', 'Lee', '2225552345', 'PQR678');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Tom', 'Johnson', '3455556789', 'STU901');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Emily', 'Williams', '3425550123', 'VWX234');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Mike', 'Brown', '2225554567', 'YZA567');
execute pkg_Deliveryboy_mgmt.upsert_delivery_boy_details(appadmin.delivery_boy_seq.nextval,'Lisa', 'Taylor', '6785558901', 'BCD890');

--select * from appadmin.delivery_boy;
commit;

execute pkg_Deliveryboy_mgmt.update_delivery_status(8003,'out of delivery');
--select * from appadmin.orders;

--grant select, update, insert on pkg_Deliveryboy_mgmt to restaurantmanager;