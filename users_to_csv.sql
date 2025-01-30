SELECT 
    u.nome AS user_name,
    u.prova_de_conhecimentos,
    u.avaliacao_curricular,
    u.nota_final,
    ub.Bolsa_id AS bolsa_id,
    GROUP_CONCAT(CONCAT(e.nome, ' - ', ue.escola_priority_id) ORDER BY ue.escola_priority_id SEPARATOR ', ') AS escola_info,
    ub.contrato_id,
    u.deficiencia
FROM 
    Users u
JOIN 
    userbolsas ub ON u.id = ub.user_id
JOIN 
    user_escola ue ON u.id = ue.user_id
JOIN 
    Escola e ON ue.escola_id = e.id
JOIN 
    Bolsa_Escola be ON be.bolsa_id = ub.Bolsa_id AND be.escola_id = e.id
GROUP BY 
    u.nome,  u.prova_de_conhecimentos,u.avaliacao_curricular, u.nota_final, ub.Bolsa_id, ub.contrato_id,u.deficiencia
ORDER BY 
    u.nome;

mysql -u root -p -e "
SELECT 
    u.nome AS user_name,
    u.prova_de_conhecimentos,
    u.avaliacao_curricular,
    u.nota_final,
    ub.Bolsa_id AS bolsa_id,
    GROUP_CONCAT(CONCAT(e.nome, ' - ', ue.escola_priority_id) ORDER BY ue.escola_priority_id SEPARATOR ', ') AS escola_info,
    ub.contrato_id,
    u.deficiencia
FROM 
    Users u
JOIN 
    userbolsas ub ON u.id = ub.user_id
JOIN 
    user_escola ue ON u.id = ue.user_id
JOIN 
    Escola e ON ue.escola_id = e.id
JOIN 
    Bolsa_Escola be ON be.bolsa_id = ub.Bolsa_id AND be.escola_id = e.id
GROUP BY 
    u.nome,  u.prova_de_conhecimentos, u.avaliacao_curricular, u.nota_final, ub.Bolsa_id, ub.contrato_id, u.deficiencia
ORDER BY 
    u.nome;"  bolsas_ilha > output.csv