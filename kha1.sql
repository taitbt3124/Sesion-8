create database session8;
create schema kha1;

CREATE TABLE kha1.ORDER_DETAIL(
    ID SERIAL PRIMARY KEY ,
    ORDER_ID INT,
    PRODUCT_NAME VARCHAR(100),
    QUANTITY INT,
    UNIT_PRICE NUMERIC
);

INSERT INTO kha1.ORDER_DETAIL (ORDER_ID, PRODUCT_NAME, QUANTITY, UNIT_PRICE)
values
    (1, 'Sản phẩm 1', 3, 10000),
    (2, 'Sản phẩm 2', 5, 50000),
    (3, 'Sản phẩm 3', 8, 10000),
    (1, 'Sản phẩm 4', 1, 60000),
    (2, 'Sản phẩm 5', 5, 10000),
    (3, 'Sản phẩm 6', 3, 10000);



CREATE OR REPLACE PROCEDURE kha1.calculate_order_total( IN order_id_input INT, OUT total NUMERIC)
language plpgsql
AS
    $$
    BEGIN
        select sum(unit_price * quantity) into total from kha1.ORDER_DETAIL where order_id = order_id_input;
    END;
    $$;
 do
 $$
    declare total numeric;
    begin
        call kha1.calculate_order_total(1,total);
        raise notice 'Tổng đơn hàng bạn chọn là: %', total;
    end;
 $$;
 CALL kha1.calculate_order_total(2, NULL);


