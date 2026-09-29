Neste exercício:
Quando um novo pagamento for inserido em payment, a trigger deverá copiar algumas informações para log_pagamento.
Exercício 6 — Trigger tr_log_pagamento
1. Identificando o que foi pedido
Pedido
O que usar
Criar tabela de log
CREATE TABLE
Registrar ID do pagamento
NEW.payment_id
Registrar ID do cliente
NEW.customer_id
Registrar valor pago
NEW.amount
Registrar data e hora atual
NOW()
Executar depois da inserção
AFTER INSERT
Criar trigger
CREATE TRIGGER
A palavra NEW representa os valores do novo registro que acabou de ser inserido.
2. Criando a tabela log_pagamento
SQL
CREATE TABLE log_pagamento (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    customer_id INT,
    valor DECIMAL(5,2),
    data_log DATETIME
);
O que significa cada coluna?
SQL
id_log INT AUTO_INCREMENT PRIMARY KEY
Cria um identificador próprio para cada registro do log.
SQL
payment_id INT
Armazena o ID do pagamento realizado.
SQL
customer_id INT
Armazena o ID do cliente que fez o pagamento.
SQL
valor DECIMAL(5,2)
Armazena o valor pago com duas casas decimais.
SQL
data_log DATETIME
Armazena a data e a hora em que o log foi criado.
3. Criando a trigger
SQL
DELIMITER //

CREATE TRIGGER tr_log_pagamento
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    INSERT INTO log_pagamento (
        payment_id,
        customer_id,
        valor,
        data_log
    )
    VALUES (
        NEW.payment_id,
        NEW.customer_id,
        NEW.amount,
        NOW()
    );
END //

DELIMITER ;
O que esse código faz?
SQL
AFTER INSERT ON payment
Significa:
Execute a trigger depois que um novo pagamento for inserido na tabela payment.
SQL
FOR EACH ROW
Significa:
Execute uma vez para cada pagamento inserido.
SQL
NEW.payment_id
Pega o ID do pagamento recém-inserido.
SQL
NEW.customer_id
Pega o ID do cliente do novo pagamento.
SQL
NEW.amount
Pega o valor pago.
SQL
NOW()
Pega a data e a hora atuais do servidor.
4. Código completo para criar a tabela e a trigger
SQL
CREATE TABLE log_pagamento (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    customer_id INT,
    valor DECIMAL(5,2),
    data_log DATETIME
);
SQL
DELIMITER //

CREATE TRIGGER tr_log_pagamento
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    INSERT INTO log_pagamento (
        payment_id,
        customer_id,
        valor,
        data_log
    )
    VALUES (
        NEW.payment_id,
        NEW.customer_id,
        NEW.amount,
        NOW()
    );
END //

DELIMITER ;
5. Testando a trigger
Agora faça uma inserção na tabela payment:
SQL
INSERT INTO payment (
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date
)
VALUES (
    1,
    1,
    1,
    9.99,
    NOW()
);
Nesse exemplo:
customer_id = 1: cliente que realizou o pagamento;
staff_id = 1: funcionário responsável;
rental_id = 1: aluguel relacionado;
amount = 9.99: valor pago;
NOW(): data e hora atuais.
O payment_id não foi informado porque normalmente ele é preenchido automaticamente pelo banco.
6. Verificando se a trigger funcionou
Depois do INSERT, consulte a tabela de log:
SQL
SELECT *
FROM log_pagamento;
Você deverá encontrar um registro parecido com:
id_log
payment_id
customer_id
valor
data_log
1
16100
1
9.99
2026-09-29 12:00:00
O payment_id e a data podem ser diferentes no seu banco.
Também é possível consultar apenas o último registro:
SQL
SELECT *
FROM log_pagamento
ORDER BY id_log DESC
LIMIT 1;
7. Se a tabela ou a trigger já existirem
Se você precisar executar o exercício novamente, primeiro remova a trigger e a tabela:
SQL
DROP TRIGGER IF EXISTS tr_log_pagamento;
SQL
DROP TABLE IF EXISTS log_pagamento;
Depois execute novamente os comandos de criação.
A ordem é importante:
remover a trigger;
remover a tabela;
criar a tabela;
criar a trigger;
inserir um pagamento;
consultar o log.
8. O padrão para memorizar
Uma trigger de inserção geralmente segue este formato:
SQL
DELIMITER //

CREATE TRIGGER nome_da_trigger
AFTER INSERT ON tabela
FOR EACH ROW
BEGIN
    INSERT INTO tabela_de_log (colunas)
    VALUES (NEW.coluna1, NEW.coluna2);
END //

DELIMITER ;
Para entender este exercício:
AFTER INSERT: depois de inserir;
ON payment: na tabela payment;
NEW: dados do novo registro;
INSERT INTO log_pagamento: grava o histórico;
NOW(): registra data e hora atuais.
A ideia principal é:
A trigger observa uma ação e executa outra automaticamente.
Neste caso:
text
Novo pagamento em payment
              ↓
Trigger é ativada
              ↓
Registro criado em log_pagamento
