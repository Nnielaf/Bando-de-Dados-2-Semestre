DELIMITER $$

CREATE PROCEDURE sp_relatorio_cliente(IN p_customer_id INT)
BEGIN
    SELECT 
         CONCAT(c.first_name, ' ', c.last_name) AS nome_completo,
        
        fn_total_alugueis_cliente(p_customer_id) AS quantidade_alugueis,
        fn_valor_gasto_cliente(p_customer_id) AS valor_total_pago,
        MIN(r.rental_date) AS data_primeiro_aluguel
    FROM 
        customer c
    LEFT JOIN 
        rental r ON c.customer_id = r.customer_id
    WHERE 
        c.customer_id = p_customer_id
    GROUP BY 
        c.customer_id;
END$$

DELIMITER ;
