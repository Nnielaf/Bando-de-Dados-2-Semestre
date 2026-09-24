CREATE VIEW vw_clientes_ativos AS
SELECT 
    CONCAT(cl.nome, ' ', cl.sobrenome) AS nome_completo,
    cl.email,
    ci.nome AS cidade,
    p.nome AS pais
FROM 
    clientes cl
JOIN 
    enderecos e ON cl.endereco_id = e.endereco_id
JOIN 
    cidades ci ON e.cidade_id = ci.cidade_id
JOIN 
    paises p ON ci.pais_id = p.pais_id
WHERE 
    cl.active = 1;
