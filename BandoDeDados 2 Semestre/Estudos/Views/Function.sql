. O que o exercício pede?
Pedido
O que usar
Criar uma função
CREATE FUNCTION
Receber o ID do cliente
Parâmetro INT
Somar os pagamentos
SUM(amount)
Buscar na tabela payment
FROM payment
Filtrar pelo cliente
WHERE customer_id = parâmetro
Retornar valor com duas casas
RETURNS DECIMAL(10,2)
2. Código completo
SQL
  
DELIMITER //

CREATE FUNCTION fn_valor_gasto_cliente(p_customer_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE total_gasto DECIMAL(10,2);

    SELECT COALESCE(SUM(amount), 0.00)
    INTO total_gasto
    FROM payment
    WHERE customer_id = p_customer_id;

    RETURN total_gasto;
END //

DELIMITER ;
3. Como testar a função
Para consultar o valor gasto pelo cliente 1:
SQL
SELECT fn_valor_gasto_cliente(1) AS valor_total_gasto;
4. Por que usamos COALESCE?
SQL
COALESCE(SUM(amount), 0.00)
Se o cliente ainda não tiver nenhum pagamento, SUM(amount) pode retornar NULL.
O COALESCE transforma esse NULL em 0.00.
Assim, em vez de aparecer:
text
NULL
aparece:
text
0.00
5. Consulta solicitada pelo exercício 4
Depois de criar a função, faça uma consulta para todos os clientes:
SQL
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS nome_completo,
    fn_valor_gasto_cliente(c.customer_id) AS valor_total_gasto
FROM customer AS c
ORDER BY nome_completo;
Essa consulta exibe:
ID do cliente;
nome completo;
valor total gasto.
Exemplo do resultado:
customer_id
nome_completo
valor_total_gasto
1
Mary Smith
118.68
2
Patricia Johnson
128.73
6. Código completo dos dois exercícios
SQL
DELIMITER //

CREATE FUNCTION fn_total_alugueis_cliente(p_customer_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_alugueis INT;

    SELECT COUNT(*)
    INTO total_alugueis
    FROM rental
    WHERE customer_id = p_customer_id;

    RETURN total_alugueis;
END //

DELIMITER ;
SQL
DELIMITER //

CREATE FUNCTION fn_valor_gasto_cliente(p_customer_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE total_gasto DECIMAL(10,2);

    SELECT COALESCE(SUM(amount), 0.00)
    INTO total_gasto
    FROM payment
    WHERE customer_id = p_customer_id;

    RETURN total_gasto;
END //

DELIMITER ;
Consulta do exercício 4:
SQL
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS nome_completo,
    fn_valor_gasto_cliente(c.customer_id) AS valor_total_gasto
FROM customer AS c
ORDER BY nome_completo;
7. Se as funções já existirem
Caso apareça um erro dizendo que a função já existe, execute antes:
SQL
DROP FUNCTION IF EXISTS fn_total_alugueis_cliente;
E, para a outra:
SQL
DROP FUNCTION IF EXISTS fn_valor_gasto_cliente;
Depois, execute novamente os comandos de criação.
8. O padrão para memorizar
Uma FUNCTION normalmente segue este modelo:
SQL
DELIMITER //

CREATE FUNCTION nome_da_funcao(parametro TIPO)
RETURNS TIPO_DO_RETORNO
READS SQL DATA
BEGIN
    DECLARE nome_da_variavel TIPO;

    SELECT calculo
    INTO nome_da_variavel
    FROM tabela
    WHERE condição;

    RETURN nome_da_variavel;
END //

DELIMITER ;
Para identificar o que usar:
pediu contar → use COUNT;
pediu somar → use SUM;
pediu resultado inteiro → RETURNS INT;
pediu valor monetário → RETURNS DECIMAL(10,2);
pediu para receber um ID → crie um parâmetro INT;
pediu para usar a função em uma consulta → chame a função dentro do SELECT.
A diferença essencial em relação às VIEWs é:
SQL
-- VIEW: consulta salva
SELECT * FROM vw_clientes_ativos;

-- FUNCTION: cálculo que recebe um valor
SELECT fn_total_alugueis_cliente(1);
