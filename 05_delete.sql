-- =====================================================================
-- EXCLUSÃO DE REGISTROS (DELETE) - banco loja_eletronicos
-- Regra 1: todo DELETE com WHERE na chave primária.
-- Regra 2: apagar primeiro as tabelas filhas (FK) e só depois as pais.
-- =====================================================================
USE loja_eletronicos;

-- ---------------------------------------------------------------------
-- TESTE DE INTEGRIDADE (deixe comentado): tentar apagar um cliente que
-- possui pedidos é rejeitado pelo banco (erro 1451: Cannot delete or
-- update a parent row: a foreign key constraint fails).
-- Por isso os pedidos precisam ser tratados antes do cliente.
-- ---------------------------------------------------------------------
-- DELETE FROM Cliente WHERE ID_cliente = 1;

-- =====================================================================
-- CENÁRIO A: limpeza de um pedido cancelado (pedido 8, status 'Cancelado')
-- Pedido é pai de Item_Pedido, então os itens saem primeiro.
-- =====================================================================

-- DELETE 1: remove o item do pedido cancelado (tabela filha).
-- Atinge 1 linha (PK composta: ID_Pedido + ID_Produto).
DELETE FROM Item_Pedido
WHERE ID_Pedido = 8 AND ID_Produto = 9;

-- DELETE 2: remove o pedido cancelado (agora sem itens vinculados).
-- O AND no status é uma trava extra: só apaga se ainda estiver cancelado.
-- Atinge 1 linha.
DELETE FROM Pedido
WHERE ID_Pedido = 8 AND Status = 'Cancelado';

-- =====================================================================
-- CENÁRIO B: exclusão de um registro simples e sem dependentes
-- =====================================================================

-- DELETE 3: a cliente 3 (Fernanda) deixou de usar o telefone fixo.
-- Telefone_Cliente é tabela filha e ninguém depende dela, então a
-- exclusão é direta. Atinge 1 linha.
DELETE FROM Telefone_Cliente
WHERE ID_Telefone = 5;

-- =====================================================================
-- CENÁRIO C: exclusão de um cliente (cliente 7, Patrícia Gomes)
-- O único pedido dela (pedido 8) foi apagado no cenário A, então ela
-- não tem mais pedidos. Ainda restam os telefones, que referenciam o
-- cliente e precisam sair antes.
-- =====================================================================

-- DELETE 4: remove os telefones do cliente 7 (filha de Cliente).
-- Atinge 1 linha.
DELETE FROM Telefone_Cliente
WHERE ID_Cliente = 7;

-- DELETE 5: remove o cliente 7 (sem pedidos nem telefones vinculados).
-- Atinge 1 linha.
DELETE FROM Cliente
WHERE ID_cliente = 7;

-- =====================================================================
-- CENÁRIO D: limpeza de registros base que ficaram sem uso
-- =====================================================================

-- DELETE 6: o Acer Aspire 5 (produto 9) só havia sido vendido no pedido
-- cancelado, então nenhum Item_Pedido o referencia mais e o produto
-- pode ser descontinuado. Atinge 1 linha.
DELETE FROM Produto
WHERE ID_Produto = 9;

-- DELETE 7: Porto Alegre (cidade 6) só tinha a cliente 7, já removida.
-- Cidade é tabela pai de Cliente; só pode sair porque nenhum cliente
-- a referencia mais. Atinge 1 linha.
DELETE FROM Cidade
WHERE ID_Cidade = 6;

-- ---------------------------------------------------------------------
-- VERIFICAÇÃO: contagem final de registros por tabela
-- ---------------------------------------------------------------------
SELECT 'Cidade' AS Tabela, COUNT(*) AS Registros FROM Cidade
UNION ALL SELECT 'Produto',          COUNT(*) FROM Produto
UNION ALL SELECT 'Cliente',          COUNT(*) FROM Cliente
UNION ALL SELECT 'Telefone_Cliente', COUNT(*) FROM Telefone_Cliente
UNION ALL SELECT 'Pedido',           COUNT(*) FROM Pedido
UNION ALL SELECT 'Item_Pedido',      COUNT(*) FROM Item_Pedido;
