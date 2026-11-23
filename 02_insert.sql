-- =====================================================================
-- POVOAMENTO DO BANCO loja_eletronicos (loja de celulares e notebooks)
-- Ordem hierárquica: entidades independentes -> dependentes -> associativa
-- =====================================================================
USE loja_eletronicos;

-- ---------------------------------------------------------------------
-- 1) CIDADE (independente): referenciada por Cliente.ID_Cidade
-- ---------------------------------------------------------------------
INSERT INTO Cidade (ID_Cidade, UF, Nome_cidade) VALUES
(1, 'PR', 'Curitiba'),
(2, 'PR', 'São José dos Pinhais'),
(3, 'PR', 'Londrina'),
(4, 'SC', 'Florianópolis'),
(5, 'SP', 'São Paulo'),
(6, 'RS', 'Porto Alegre');

-- ---------------------------------------------------------------------
-- 2) PRODUTO (independente): catálogo de celulares e notebooks
-- ---------------------------------------------------------------------
INSERT INTO Produto (ID_Produto, Modelo, Preco) VALUES
(1,  'iPhone 15 128GB',            4599.00),
(2,  'Samsung Galaxy S24 256GB',   3899.00),
(3,  'Motorola Edge 50 Fusion',    2299.00),
(4,  'Xiaomi Redmi Note 13',       1399.00),
(5,  'Samsung Galaxy A55',         2199.00),
(6,  'Notebook Dell Inspiron 15',  3299.00),
(7,  'Notebook Lenovo IdeaPad 3',  2799.00),
(8,  'MacBook Air M2 256GB',       8499.00),
(9,  'Notebook Acer Aspire 5',     3199.00),
(10, 'Notebook ASUS Vivobook 15',  3099.00);

-- ---------------------------------------------------------------------
-- 3) CLIENTE (depende de Cidade): ID_Cidade deve existir no bloco 1
-- ---------------------------------------------------------------------
INSERT INTO Cliente (ID_cliente, Nome_Cliente, CPF, Email, Rua, Numero, CEP, Bairro, ID_Cidade) VALUES
(1, 'Mariana Souza',      '123.456.789-01', 'mariana.souza@email.com',    'Rua das Flores',        '120',  '80010-000', 'Centro',          1),
(2, 'Carlos Eduardo Lima','234.567.890-12', 'carlos.lima@email.com',      'Av. Sete de Setembro',  '850',  '80230-010', 'Batel',           1),
(3, 'Fernanda Oliveira',  '345.678.901-23', 'fernanda.oliveira@email.com','Rua XV de Novembro',    '45',   '83005-000', 'Centro',          2),
(4, 'Rafael Santos',      '456.789.012-34', 'rafael.santos@email.com',    'Rua Pernambuco',        '300',  '86020-120', 'Centro',          3),
(5, 'Juliana Pereira',    '567.890.123-45', 'juliana.pereira@email.com',  'Rua Felipe Schmidt',    '77',   '88010-001', 'Centro',          4),
(6, 'Bruno Almeida',      '678.901.234-56', 'bruno.almeida@email.com',    'Av. Paulista',          '1500', '01310-100', 'Bela Vista',      5),
(7, 'Patrícia Gomes',     '789.012.345-67', 'patricia.gomes@email.com',   'Rua dos Andradas',      '200',  '90020-007', 'Centro Histórico',6),
(8, 'Lucas Ferreira',     '890.123.456-78', 'lucas.ferreira@email.com',   'Rua Mateus Leme',       '410',  '80510-190', 'São Francisco',   1);

-- ---------------------------------------------------------------------
-- 4) TELEFONE_CLIENTE (depende de Cliente): atributo multivalorado,
--    por isso alguns clientes têm mais de um telefone
-- ---------------------------------------------------------------------
INSERT INTO Telefone_Cliente (ID_Telefone, Numero, ID_Cliente) VALUES
(1,  '(41) 99123-4567', 1),
(2,  '(41) 3322-1100',  1),
(3,  '(41) 98876-5432', 2),
(4,  '(41) 99765-4321', 3),
(5,  '(41) 3355-7788',  3),
(6,  '(43) 99654-3210', 4),
(7,  '(48) 99543-2109', 5),
(8,  '(11) 98432-1098', 6),
(9,  '(51) 99321-0987', 7),
(10, '(41) 99210-9876', 8);

-- ---------------------------------------------------------------------
-- 5) PEDIDO (depende de Cliente): Quantidade e Preco_final são os totais
--    calculados a partir dos itens inseridos no bloco 6
--    Status variados para permitir consultas por situação do pedido
-- ---------------------------------------------------------------------
INSERT INTO Pedido (ID_Pedido, ID_cliente, Status, Data, Quantidade, Preco_final) VALUES
(1,  1, 'Entregue',          '2026-09-05', 2, 5998.00),
(2,  2, 'Entregue',          '2026-09-12', 1, 8499.00),
(3,  3, 'Entregue',          '2026-09-20', 2, 4598.00),
(4,  4, 'Enviado',           '2026-10-03', 2, 4198.00),
(5,  5, 'Entregue',          '2026-10-10', 1, 3899.00),
(6,  6, 'Pago',              '2026-10-18', 2, 6298.00),
(7,  1, 'Em processamento',  '2026-11-02', 1, 2199.00),
(8,  7, 'Cancelado',         '2026-11-05', 1, 3199.00),
(9,  8, 'Entregue',          '2026-11-10', 3, 4197.00),
(10, 2, 'Enviado',           '2026-11-15', 3, 8997.00),
(11, 3, 'Pago',              '2026-11-18', 2, 5598.00);

-- ---------------------------------------------------------------------
-- 6) ITEM_PEDIDO (associativa N:N entre Pedido e Produto):
--    depende de Pedido e Produto, por isso é a última a ser povoada.
--    Preco_unitario guarda o preço praticado na venda (no pedido 6, o
--    ASUS Vivobook foi vendido com desconto: 2999.00 em vez de 3099.00)
-- ---------------------------------------------------------------------
INSERT INTO Item_Pedido (ID_Pedido, ID_Produto, Quantidade, Preco_unitario) VALUES
(1,  1,  1, 4599.00),
(1,  4,  1, 1399.00),
(2,  8,  1, 8499.00),
(3,  3,  2, 2299.00),
(4,  7,  1, 2799.00),
(4,  4,  1, 1399.00),
(5,  2,  1, 3899.00),
(6,  6,  1, 3299.00),
(6,  10, 1, 2999.00),
(7,  5,  1, 2199.00),
(8,  9,  1, 3199.00),
(9,  4,  3, 1399.00),
(10, 1,  1, 4599.00),
(10, 5,  2, 2199.00),
(11, 7,  2, 2799.00);

-- ---------------------------------------------------------------------
-- 7) VERIFICAÇÃO: conta os registros inseridos em cada tabela
-- ---------------------------------------------------------------------
SELECT 'Cidade' AS Tabela, COUNT(*) AS Registros FROM Cidade
UNION ALL SELECT 'Produto',          COUNT(*) FROM Produto
UNION ALL SELECT 'Cliente',          COUNT(*) FROM Cliente
UNION ALL SELECT 'Telefone_Cliente', COUNT(*) FROM Telefone_Cliente
UNION ALL SELECT 'Pedido',           COUNT(*) FROM Pedido
UNION ALL SELECT 'Item_Pedido',      COUNT(*) FROM Item_Pedido;
