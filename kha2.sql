create database session8;
create schema kha2;

create table kha2.inventory(
    product_id serial primary key ,
    product_name varchar(100),
    quantity int
);

insert into kha2.inventory (product_name, quantity)
values
    ('SP1', 1),
    ('SP2', 3),
    ('SP3', 5),
    ('SP4', 7),
    ('SP5', 9),
    ('SP6', 13);

create or replace procedure kha2.check_stock( IN p_id INT,IN p_qty INT)
    language plpgsql
as
    $$
    declare
        v_cur_quan int;
        v_name varchar(100);
    begin
        select i.quantity, i.product_name into v_cur_quan,v_name from kha2.inventory i where i.product_id = p_id;

        if not FOUND then
            raise exception 'Sản phẩm không có';
        end if;

        if v_cur_quan < p_qty then
            raise notice 'Sản phẩm với tên % có số lượng % không đủ để đặt hàng',v_name,p_qty;
        else
            raise exception 'Sản phẩm với tên % có số lượng % đủ để đặt hàng, số hàng tồn là %',v_name,p_qty,v_cur_quan ;
        end if;
    end;
    $$;

CALL kha2.check_stock(6,15);
