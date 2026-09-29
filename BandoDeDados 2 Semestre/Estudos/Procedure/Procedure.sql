A diferença principal:
VIEW: você consulta com SELECT;
FUNCTION: recebe um valor e retorna um resultado;
PROCEDURE: recebe parâmetros e pode retornar uma tabela de resultados usando SELECT.
Exercício 5 — Procedure sp_relatorio_cliente
1. Identificando o que foi pedido
Pedido
O que usar
Criar uma procedure
CREATE PROCEDURE
Receber o ID do cliente
IN p_customer_id INT
Nome completo
CONCAT(first_name, ' ', last_name)
Quantidade de aluguéis
COUNT(*)
Valor total pago
SUM(amount)
Primeiro aluguel
MIN(rental_date)
Último aluguel
MAX(rental_date)
Executar a procedure
CALL
As tabelas utilizadas serão:
customer: nome do cliente;
rental: informações dos aluguéis;
payment: valores pagos.
2. Código completo
SQL
DELIMITER //

CREATE PROCEDURE sp_relatorio_cliente(IN p_customer_id INT)
BEGIN
    SELECT
        CONCAT(c.first_name, ' ', c.last_name) AS nome_completo,

        (
            SELECT COUNT(*)
            FROM rental AS r
            WHERE r.customer_id = c.customer_id
        ) AS quantidade_alugueis,

        (
            SELECT COALESCE(SUM(p.amount), 0.00)
            FROM payment AS p
            WHERE p.customer_id = c.customer_id
        ) AS valor_total_pago,

        (
            SELECT MIN(r.rental_date)
            FROM rental AS r
            WHERE r.customer_id = c.customer_id
        ) AS data_primeiro_aluguel,

        (
            SELECT MAX(r.rental_date)
            FROM rental AS r
            WHERE r.customer_id = c.customer_id
        ) AS data_ultimo_aluguel

    FROM customer AS c
    WHERE c.customer_id = p_customer_id;
END //

DELIMITER ;
3. Como executar a procedure
Para gerar o relatório do cliente de ID 1:
SQL
CALL sp_relatorio_cliente(1);
O resultado será parecido com:
nome_completo
quantidade_alugueis
valor_total_pago
data_primeiro_aluguel
data_ultimo_aluguel
Mary Smith
32
118.68
2005-05-24
2005-08-23
Os valores exatos dependem dos dados do seu banco.
4. Explicando o código
Parâmetro de entrada
SQL
IN p_customer_id INT
Significa que a procedure recebe um valor chamado p_customer_id, que será um número inteiro.
Por exemplo:
SQL
CALL sp_relatorio_cliente(1);
Nesse caso, o valor 1 será usado como ID do cliente.
Nome completo
SQL
CONCAT(c.first_name, ' ', c.last_name) AS nome_completo
Junta o nome e o sobrenome.
Por exemplo:
text
Mary + Smith = Mary Smith
Quantidade de aluguéis
SQL
SELECT COUNT(*)
FROM rental AS r
WHERE r.customer_id = c.customer_id
Conta quantos registros existem na tabela rental para aquele cliente.
Valor total pago
SQL
SELECT COALESCE(SUM(p.amount), 0.00)
FROM payment AS p
WHERE p.customer_id = c.customer_id
SUM(p.amount) soma todos os pagamentos;
COALESCE(..., 0.00) retorna 0.00 caso o cliente não tenha pagamentos.
Primeiro aluguel
SQL
MIN(r.rental_date)
MIN encontra a menor data, ou seja, a data mais antiga.
Último aluguel
SQL
MAX(r.rental_date)
MAX encontra a maior data, ou seja, a data mais recente.
5. Por que o código usa subconsultas?
Seria possível fazer tudo com JOIN, mas existe um problema: um cliente pode ter vários aluguéis e vários pagamentos. Se juntarmos as duas tabelas diretamente, os registros podem se multiplicar e os valores ficarem incorretos.
Por exemplo:
3 aluguéis;
4 pagamentos.
Um JOIN direto poderia gerar 12 combinações e contar ou somar valores repetidos.
As subconsultas evitam esse problema, pois calculam separadamente:
a quantidade de aluguéis;
o total de pagamentos;
a primeira data;
a última data.
6. Se a procedure já existir
Antes de recriá-la, você pode executar:
SQL
DROP PROCEDURE IF EXISTS sp_relatorio_cliente;
Depois, execute novamente o código de criação.
7. Código para entregar
SQL
DELIMITER //

CREATE PROCEDURE sp_relatorio_cliente(IN p_customer_id INT)
BEGIN
    SELECT
        CONCAT(c.first_name, ' ', c.last_name) AS nome_completo,
        (
            SELECT COUNT(*)
            FROM rental AS r
            WHERE r.customer_id = c.customer_id
        ) AS quantidade_alugueis,
        (
            SELECT COALESCE(SUM(p.amount), 0.00)
            FROM payment AS p
            WHERE p.customer_id = c.customer_id
        ) AS valor_total_pago,
        (
            SELECT MIN(r.rental_date)
            FROM rental AS r
            WHERE r.customer_id = c.customer_id
        ) AS data_primeiro_aluguel,
        (
            SELECT MAX(r.rental_date)
            FROM rental AS r
            WHERE r.customer_id = c.customer_id
        ) AS data_ultimo_aluguel
    FROM customer AS c
    WHERE c.customer_id = p_customer_id;
END //

DELIMITER ;
Para executar:
SQL
CALL sp_relatorio_cliente(1);
8. Padrão para memorizar
Uma procedure geralmente segue esta estrutura:
SQL
DELIMITER //

CREATE PROCEDURE nome_da_procedure(IN parametro TIPO)
BEGIN
    SELECT colunas
    FROM tabela
    WHERE coluna = parametro;
END //

DELIMITER ;
A principal diferença para uma function é:
SQL
-- Function
SELECT nome_da_funcao(1);

-- Procedure
CALL nome_da_procedure(1);
Portanto, para esse exercício, pense:
Procedure recebe o ID, executa um SELECT e devolve o relatório daquele cliente.
