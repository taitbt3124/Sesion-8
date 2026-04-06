CREATE SCHEMA IF NOT EXISTS exercise;

CREATE TABLE exercise.employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    job_level INT,
    salary NUMERIC
);

INSERT INTO exercise.employees (emp_name, job_level, salary)
VALUES 
    ('Nguyễn Văn A', 1, 1000),
    ('Trần Thị B', 2, 2000),
    ('Lê Văn C', 3, 3000),
    ('Phạm Văn D', 1, 1500);

CREATE OR REPLACE PROCEDURE exercise.adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_salary NUMERIC;
    v_level INT;
    v_ratio NUMERIC;
BEGIN
    SELECT salary, job_level INTO v_current_salary, v_level 
    FROM exercise.employees 
    WHERE emp_id = p_emp_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Nhân viên ID % không tồn tại', p_emp_id;
    END IF;

    IF v_level = 1 THEN
        v_ratio := 1.05;
    ELSEIF v_level = 2 THEN
        v_ratio := 1.10;
    ELSEIF v_level = 3 THEN
        v_ratio := 1.15;
    ELSE
        v_ratio := 1;
    END IF;

    p_new_salary := v_current_salary * v_ratio;

    UPDATE exercise.employees 
    SET salary = p_new_salary 
    WHERE emp_id = p_emp_id;
END;
$$;

DO $$
DECLARE 
    v_result NUMERIC;
BEGIN
    CALL exercise.adjust_salary(1, v_result);
    RAISE NOTICE 'Lương mới của nhân viên 1 là: %', v_result;
END $$;

CALL exercise.adjust_salary(2, NULL);

SELECT * FROM exercise.employees;
