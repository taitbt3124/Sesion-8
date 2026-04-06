CREATE SCHEMA IF NOT EXISTS gioi2;

CREATE TABLE gioi2.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC,
    discount_percent INT
);

INSERT INTO gioi2.products (name, price, discount_percent)
VALUES 
    ('iPhone 15', 20000000, 10),
    ('Samsung S23', 15000000, 60),
    ('Tai nghe Sony', 5000000, 20);

CREATE OR REPLACE PROCEDURE gioi2.calculate_discount(p_id INT, OUT p_final_price NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price NUMERIC;
    v_discount INT;
BEGIN
    SELECT price, discount_percent 
    INTO v_price, v_discount 
    FROM gioi2.products 
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Sản phẩm ID % không tồn tại', p_id;
    END IF;

    IF v_discount > 50 THEN
        v_discount := 50;
    END IF;

    p_final_price := v_price - (v_price * v_discount / 100);

    UPDATE gioi2.products 
    SET price = p_final_price 
    WHERE id = p_id;
END;
$$;

DO $$
DECLARE 
    p_final_price NUMERIC;
BEGIN
    CALL gioi2.calculate_discount(2, p_final_price);
    RAISE NOTICE 'Giá sau khi giảm: %', p_final_price;
END $$;

SELECT * FROM gioi2.products;
