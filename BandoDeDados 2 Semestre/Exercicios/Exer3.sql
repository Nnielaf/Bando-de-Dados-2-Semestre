DELIMITER $$

CREATE FUNCTION fn_total_alugueis_cliente(p_cliente_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT;

    
    SELECT COUNT(*) 
    INTO v_total
    FROM alugueis
    WHERE cliente_id = p_cliente_id;

 
    RETURN v_total;
END$$

DELIMITER ;
