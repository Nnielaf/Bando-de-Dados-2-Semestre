CREATE VIEW vw_filmes_acao AS
SELECT 
    f.filme_id AS id_do_filme,
    f.titulo,
    f.descricao,
    f.ano_lancamento,
    f.classificacao_indicativa
FROM 
    filmes f
JOIN 
    filmes_categorias fc ON f.filme_id = fc.filme_id
JOIN 
    categorias c ON fc.categoria_id = c.categoria_id
WHERE 
    c.nome = 'Action';
