
CREATE TABLE log_pagamento (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    customer_id INT,
    valor DECIMAL(10,2),
    data_log DATETIME
);
DELIMITER $$
CREATE TRIGGER tr_log_pagamento
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    INSERT INTO log_pagamento (payment_id, customer_id, valor, data_log)
    VALUES (NEW.payment_id, NEW.customer_id, NEW.amount, NOW());
END$$
DELIMITER ;

INSERT INTO payment (payment_id, customer_id, staff_id, rental_id, amount, payment_date)
VALUES (9999, 5, 1, 1, 29.90, NOW());

SELECT * FROM log_pagamento;
