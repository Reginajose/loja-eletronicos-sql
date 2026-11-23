-- =====================================================================
-- ATUALIZAÇÃO DE REGISTROS (UPDATE) - banco loja_eletronicos
-- Regra: todo UPDATE com WHERE na chave primária, para atingir
-- somente os registros desejados.
-- =====================================================================
USE loja_eletronicos;

-- ---------------------------------------------------------------------
-- UPDATE 1: avanço do ciclo de vida de um pedido.
-- O pedido 4 estava 'Enviado' e foi entregue ao cliente.
-- Atinge 1 linha (WHERE na PK de Pedido).
-- ---------------------------------------------------------------------
UPDATE Pedido
SET Status = 'Entregue'
WHERE ID_Pedido = 4;

-- ---------------------------------------------------------------------
-- UPDATE 2: reajuste de preço de um produto (promoção).
-- O Galaxy S24 passa de R$ 3.899,00 para R$ 3.699,00.
-- Item_Pedido guarda o preço praticado na venda (Preco_unitario),
-- então o histórico dos pedidos antigos não é alterado.
-- Atinge 1 linha (WHERE na PK de Produto).
-- ---------------------------------------------------------------------
UPDATE Produto
SET Preco = 3699.00
WHERE ID_Produto = 2;

-- ---------------------------------------------------------------------
-- UPDATE 3: atualização cadastral de um cliente (e-mail e endereço).
-- Altera várias colunas do mesmo registro em um único comando.
-- Atinge 1 linha (WHERE na PK de Cliente).
-- ---------------------------------------------------------------------
UPDATE Cliente
SET Email  = 'fernanda.oliveira@novoemail.com',
    Rua    = 'Rua Marechal Deodoro',
    Numero = '512'
WHERE ID_cliente = 3;

-- ---------------------------------------------------------------------
-- UPDATE 4: mudança de cidade de um cliente (coluna que é FK).
-- O novo valor (ID_Cidade = 2) já existe na tabela Cidade, então a
-- integridade referencial é respeitada. Um ID inexistente seria
-- rejeitado pelo banco (erro de chave estrangeira).
-- Atinge 1 linha (WHERE na PK de Cliente).
-- ---------------------------------------------------------------------
UPDATE Cliente
SET ID_Cidade = 2,
    Bairro    = 'Centro'
WHERE ID_cliente = 8;

-- ---------------------------------------------------------------------
-- UPDATE 5: atualização de mais de um registro de forma controlada.
-- Os pedidos 6 e 11 (status 'Pago') foram despachados.
-- O IN lista exatamente os IDs afetados, sem filtro genérico.
-- Atinge 2 linhas.
-- ---------------------------------------------------------------------
UPDATE Pedido
SET Status = 'Enviado'
WHERE ID_Pedido IN (6, 11);

-- ---------------------------------------------------------------------
-- VERIFICAÇÃO: confere o resultado das atualizações
-- ---------------------------------------------------------------------
SELECT ID_Pedido, Status FROM Pedido WHERE ID_Pedido IN (4, 6, 11);
SELECT ID_Produto, Modelo, Preco FROM Produto WHERE ID_Produto = 2;
SELECT ID_cliente, Nome_Cliente, Email, Rua, Numero, Bairro, ID_Cidade
FROM Cliente WHERE ID_cliente IN (3, 8);
