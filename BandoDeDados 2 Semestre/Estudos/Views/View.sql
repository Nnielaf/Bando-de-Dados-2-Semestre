1. Identificando o que o exercício pede
O exercício pede
O que usar
Criar uma VIEW
CREATE VIEW
Nome da VIEW
vw_clientes_ativos
Nome completo
CONCAT(first_name, ' ', last_name)
E-mail
email
Cidade
Tabelas customer, address e city
País
Tabelas city e country
Apenas contas ativas
WHERE active = 1
Ordenar por país e nome
ORDER BY
No banco Sakila, os dados ficam nestas tabelas:
customer: nome, e-mail e situação da conta;
address: endereço e cidade do cliente;
city: nome da cidade e seu país;
country: nome do país.
Por isso, será necessário utilizar alguns JOIN.
2. Criando a VIEW
SQL
CREATE VIEW vw_clientes_ativos AS
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS nome_completo,
    c.email AS email,
    ci.city AS cidade,
    co.country AS pais
FROM customer AS c
JOIN address AS a
    ON c.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
JOIN country AS co
    ON ci.country_id = co.country_id
WHERE c.active = 1;
O que esse código faz?
Ele cria uma VIEW chamada vw_clientes_ativos contendo:
o nome e sobrenome juntos;
o e-mail;
a cidade;
o país;
mas somente dos clientes cujo valor de active seja 1.
3. Consultando a VIEW com ordenação
Depois de criar a VIEW, execute:
SQL
SELECT *
FROM vw_clientes_ativos
ORDER BY pais, nome_completo;
Esse comando mostra os clientes:
em ordem alfabética por país;
e, dentro de cada país, em ordem alfabética pelo nome.
4. Explicação das partes principais
Nome completo
SQL
CONCAT(c.first_name, ' ', c.last_name) AS nome_completo
A função CONCAT junta textos.
Por exemplo:
text
first_name: Mary
last_name: Smith
Resultado:
text
Mary Smith
O ' ' representa o espaço entre o nome e o sobrenome.
Filtro de clientes ativos
SQL
WHERE c.active = 1
No banco Sakila:
active = 1 significa cliente ativo;
active = 0 significa cliente inativo.
Relacionando as tabelas
O caminho dos dados é:
text
customer → address → city → country
Os JOINs fazem essas relações:
SQL
JOIN address AS a
    ON c.address_id = a.address_id
Liga o cliente ao endereço.
SQL
JOIN city AS ci
    ON a.city_id = ci.city_id
Liga o endereço à cidade.
SQL
JOIN country AS co
    ON ci.country_id = co.country_id
Liga a cidade ao país.
Ordenação
SQL
ORDER BY pais, nome_completo;
Ordena primeiro por pais e depois por nome_completo.
Como os dois campos estão em ordem crescente por padrão, também poderia ser escrito assim:
SQL
ORDER BY pais ASC, nome_completo ASC;
5. Código completo para entregar
SQL
CREATE VIEW vw_clientes_ativos AS
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS nome_completo,
    c.email AS email,
    ci.city AS cidade,
    co.country AS pais
FROM customer AS c
INNER JOIN address AS a
    ON c.address_id = a.address_id
INNER JOIN city AS ci
    ON a.city_id = ci.city_id
INNER JOIN country AS co
    ON ci.country_id = co.country_id
WHERE c.active = 1;
Depois:
SQL
SELECT *
FROM vw_clientes_ativos
ORDER BY pais, nome_completo;
6. Se a VIEW já existir
Se você executar novamente e aparecer um erro dizendo que a VIEW já existe, execute antes:
SQL
DROP VIEW IF EXISTS vw_clientes_ativos;
Depois execute novamente o comando de criação.
7. O padrão para memorizar
Os dois exercícios seguem praticamente a mesma estrutura:
SQL
CREATE VIEW nome_da_view AS
SELECT colunas
FROM tabela_principal
JOIN outras_tabelas
    ON condição_de_relacionamento
WHERE condição_do_filtro;
Depois, para usar a VIEW:
SQL
SELECT *
FROM nome_da_view
ORDER BY coluna1, coluna2;
No primeiro exercício:
SQL
WHERE c.name = 'Action'
No segundo:
SQL
WHERE c.active = 1
Ou seja:
VIEW: salva uma consulta;
JOIN: junta informações de tabelas diferentes;
WHERE: filtra os resultados;
ORDER BY: organiza os resultados.
