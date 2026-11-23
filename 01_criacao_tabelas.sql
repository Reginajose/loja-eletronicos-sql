-- =====================================================================
-- CRIAÇÃO DAS TABELAS - banco loja_eletronicos
-- Ordem: entidades independentes -> dependentes -> associativa
-- =====================================================================
CREATE DATABASE IF NOT EXISTS loja_eletronicos
  CHARACTER SET utf8mb4;

USE loja_eletronicos;

-- Entidade independente
CREATE TABLE Cidade (
    ID_Cidade   INT PRIMARY KEY AUTO_INCREMENT,
    UF          CHAR(2) NOT NULL,
    Nome_cidade VARCHAR(80) NOT NULL
);

-- Entidade independente
CREATE TABLE Produto (
    ID_Produto INT PRIMARY KEY AUTO_INCREMENT,
    Modelo     VARCHAR(100) NOT NULL,
    Preco      DECIMAL(10,2) NOT NULL
);

-- Depende de Cidade
CREATE TABLE Cliente (
    ID_cliente   INT PRIMARY KEY AUTO_INCREMENT,
    Nome_Cliente VARCHAR(100) NOT NULL,
    CPF          VARCHAR(14)  NOT NULL UNIQUE,
    Email        VARCHAR(100) NOT NULL,
    Rua          VARCHAR(100),
    Numero       VARCHAR(10),
    CEP          VARCHAR(9),
    Bairro       VARCHAR(60),
    ID_Cidade    INT NOT NULL,
    FOREIGN KEY (ID_Cidade) REFERENCES Cidade(ID_Cidade)
);

-- Depende de Cliente
CREATE TABLE Telefone_Cliente (
    ID_Telefone INT PRIMARY KEY AUTO_INCREMENT,
    Numero      VARCHAR(15) NOT NULL,
    ID_Cliente  INT NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_cliente)
);

-- Depende de Cliente
CREATE TABLE Pedido (
    ID_Pedido   INT PRIMARY KEY AUTO_INCREMENT,
    ID_cliente  INT NOT NULL,
    Status      VARCHAR(30) NOT NULL,
    Data        DATE NOT NULL,
    Quantidade  INT NOT NULL,
    Preco_final DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_cliente) REFERENCES Cliente(ID_cliente)
);

-- Tabela associativa: depende de Pedido e Produto (PK composta)
CREATE TABLE Item_Pedido (
    ID_Pedido      INT,
    ID_Produto     INT,
    Quantidade     INT NOT NULL,
    Preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ID_Pedido, ID_Produto),
    FOREIGN KEY (ID_Pedido)  REFERENCES Pedido(ID_Pedido),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);
