DELIMITER $$

CREATE FUNCTION fn_valor_gasto_cliente(p_customer_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total_gasto DECIMAL(10,2);
    SELECT COALESCE(SUM(amount), 0.00)
    INTO v_total_gasto
    FROM payment
    WHERE customer_id = p_customer_id;
    RETURN v_total_gasto;
END$$

DELIMITER ;
