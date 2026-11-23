-- =====================================================================
-- CONSULTAS EXPLORATÓRIAS (SELECT) - banco loja_eletronicos
-- =====================================================================
USE loja_eletronicos;

-- ---------------------------------------------------------------------
-- CONSULTA 1: os 5 pedidos de maior valor (exceto cancelados), com o
-- cliente e a cidade de entrega.
-- JOIN: Pedido -> Cliente (FK ID_cliente) -> Cidade (FK ID_Cidade)
-- WHERE: ignora pedidos cancelados | ORDER BY: do maior valor ao menor
-- LIMIT: apenas os 5 primeiros
-- ---------------------------------------------------------------------
SELECT p.ID_Pedido,
       c.Nome_Cliente,
       ci.Nome_cidade,
       ci.UF,
       p.Data,
       p.Status,
       p.Preco_final
FROM Pedido p
INNER JOIN Cliente c  ON p.ID_cliente = c.ID_cliente
INNER JOIN Cidade  ci ON c.ID_Cidade  = ci.ID_Cidade
WHERE p.Status <> 'Cancelado'
ORDER BY p.Preco_final DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- CONSULTA 2: itens vendidos em pedidos já entregues, com o subtotal
-- de cada item (quantidade x preço unitário).
-- JOIN: Item_Pedido -> Pedido -> Cliente e Item_Pedido -> Produto
-- (percorre a tabela associativa do relacionamento N:N)
-- WHERE: somente pedidos com Status 'Entregue'
-- ORDER BY: maiores subtotais primeiro | LIMIT: 5 itens
-- ---------------------------------------------------------------------
SELECT p.ID_Pedido,
       c.Nome_Cliente,
       pr.Modelo,
       ip.Quantidade,
       ip.Preco_unitario,
       (ip.Quantidade * ip.Preco_unitario) AS Subtotal
FROM Item_Pedido ip
INNER JOIN Pedido  p  ON ip.ID_Pedido  = p.ID_Pedido
INNER JOIN Cliente c  ON p.ID_cliente  = c.ID_cliente
INNER JOIN Produto pr ON ip.ID_Produto = pr.ID_Produto
WHERE p.Status = 'Entregue'
ORDER BY Subtotal DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- CONSULTA 3: clientes de Curitiba e seus telefones de contato.
-- JOIN: Cliente -> Cidade e Cliente -> Telefone_Cliente
-- (atributo multivalorado: um cliente pode aparecer em mais de uma linha)
-- WHERE: filtra pela cidade | ORDER BY: nome do cliente (A-Z)
-- LIMIT: até 10 registros
-- ---------------------------------------------------------------------
SELECT c.Nome_Cliente,
       c.Email,
       c.Bairro,
       t.Numero AS Telefone
FROM Cliente c
INNER JOIN Cidade ci          ON c.ID_Cidade  = ci.ID_Cidade
INNER JOIN Telefone_Cliente t ON c.ID_cliente = t.ID_Cliente
WHERE ci.Nome_cidade = 'Curitiba'
ORDER BY c.Nome_Cliente ASC, t.Numero ASC
LIMIT 10;

-- ---------------------------------------------------------------------
-- CONSULTA 4: os 3 produtos mais vendidos (em unidades) e a receita
-- gerada por cada um, desconsiderando pedidos cancelados.
-- JOIN: Item_Pedido -> Produto e Item_Pedido -> Pedido
-- WHERE: exclui pedidos cancelados | GROUP BY: agrupa por produto
-- ORDER BY: mais unidades vendidas primeiro (desempate pelo modelo)
-- LIMIT: ranking dos 3 primeiros
-- ---------------------------------------------------------------------
SELECT pr.ID_Produto,
       pr.Modelo,
       SUM(ip.Quantidade)                    AS Unidades_Vendidas,
       SUM(ip.Quantidade * ip.Preco_unitario) AS Receita
FROM Item_Pedido ip
INNER JOIN Produto pr ON ip.ID_Produto = pr.ID_Produto
INNER JOIN Pedido  p  ON ip.ID_Pedido  = p.ID_Pedido
WHERE p.Status <> 'Cancelado'
GROUP BY pr.ID_Produto, pr.Modelo
ORDER BY Unidades_Vendidas DESC, pr.Modelo ASC
LIMIT 3;
