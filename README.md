# Loja de Eletrônicos: Banco de Dados Relacional (MySQL)

Projeto acadêmico de implementação e manipulação de um banco de dados relacional com SQL (DDL e DML), aplicado a um mini-mundo de uma loja que vende **celulares e notebooks**.

**Autor(a):** [Seu nome]
**SGBD:** MySQL 8.0+ | **Ferramenta:** MySQL Workbench | **Schema:** `loja_eletronicos`

---

## 1. Descrição do mini-mundo

A loja vende celulares e notebooks para clientes cadastrados. O sistema registra:

- os **clientes**, com dados pessoais, endereço e cidade;
- os **telefones** de cada cliente (um cliente pode ter vários);
- os **produtos** do catálogo, com modelo e preço;
- os **pedidos** feitos pelos clientes, com data, status e valor total;
- os **itens de cada pedido**, já que um pedido pode ter vários produtos e um produto pode aparecer em vários pedidos.

### Premissas do sistema

- Um cliente pode fazer vários pedidos, e cada pedido pertence a um único cliente.
- Cada cliente mora em uma cidade, e uma cidade pode ter vários clientes.
- A relação entre pedidos e produtos é muitos-para-muitos, resolvida pela tabela associativa `Item_Pedido`.
- O preço do produto é copiado para `Item_Pedido.Preco_unitario` no momento da venda, para que alterações futuras de preço não modifiquem o histórico.
- O CPF do cliente é único.
- Os status de pedido usados na carga são: `Em processamento`, `Pago`, `Enviado`, `Entregue` e `Cancelado`.
- Todos os dados são **fictícios**.

---

## 2. Modelo lógico

| Tabela | Chave primária | Chaves estrangeiras | Descrição |
|---|---|---|---|
| `Cidade` | `ID_Cidade` | n/a | Cidades atendidas (UF e nome). |
| `Produto` | `ID_Produto` | n/a | Catálogo de celulares e notebooks. |
| `Cliente` | `ID_cliente` | `ID_Cidade` → `Cidade` | Dados pessoais e endereço. |
| `Telefone_Cliente` | `ID_Telefone` | `ID_Cliente` → `Cliente` | Telefones dos clientes. |
| `Pedido` | `ID_Pedido` | `ID_cliente` → `Cliente` | Pedidos realizados. |
| `Item_Pedido` | (`ID_Pedido`, `ID_Produto`) | `ID_Pedido` → `Pedido`, `ID_Produto` → `Produto` | Itens de cada pedido (N:N). |

### Relacionamentos

| Relacionamento | Cardinalidade |
|---|---|
| Cidade → Cliente | 1:N |
| Cliente → Telefone_Cliente | 1:N |
| Cliente → Pedido | 1:N |
| Pedido ↔ Produto (via `Item_Pedido`) | N:N |

### Observações de implementação

- Nomes de colunas foram padronizados sem hífen e sem acento (por exemplo, `Email` e `Numero`), para evitar o uso de crases no MySQL.
- Valores monetários usam `DECIMAL(10,2)` para evitar erros de arredondamento do `FLOAT`.

---

## 3. Pré-requisitos

- MySQL Server 8.0 ou superior, em execução na porta `3306`.
- MySQL Workbench (ou outro cliente SQL).
- Um usuário com permissão para criar bancos e tabelas (por exemplo, `root`).

### Configuração do ambiente

1. Instale o **MySQL Server** e o **MySQL Workbench** com o MySQL Installer (https://dev.mysql.com/downloads/installer/).
2. No Workbench, crie a conexão local:
   - **Hostname:** `127.0.0.1`
   - **Port:** `3306`
   - **Username:** `root`
3. Use **Test Connection** para validar e abra a conexão.
4. Crie o schema:

```sql
CREATE DATABASE IF NOT EXISTS loja_eletronicos
  CHARACTER SET utf8mb4;
```

---

## 4. Ordem de execução dos scripts

Execute os scripts **na ordem abaixo**, sempre na mesma conexão. Cada script começa com `USE loja_eletronicos;`.

| Ordem | Arquivo | Conteúdo |
|---|---|---|
| 1 | `01_criacao_tabelas.sql` | `CREATE TABLE` das 6 tabelas, das independentes para as dependentes. |
| 2 | `02_insert.sql` | Povoamento (`INSERT`), respeitando a hierarquia das chaves estrangeiras. |
| 3 | `03_select.sql` | 4 consultas com `JOIN`, `WHERE`, `ORDER BY` e `LIMIT`. |
| 4 | `04_update.sql` | 5 atualizações, todas com `WHERE` na chave primária. |
| 5 | `05_delete.sql` | 7 exclusões seguras, respeitando as dependências. |

### Por que essa ordem?

- **Criação e carga:** uma tabela com chave estrangeira só aceita registros cujo valor já existe na tabela de origem. A ordem é `Cidade` e `Produto` (independentes), depois `Cliente`, depois `Telefone_Cliente` e `Pedido`, e por último `Item_Pedido`.
- **Consultas antes de alterações:** os resultados dos `SELECT` correspondem aos dados originais da carga. Depois de `UPDATE` e `DELETE`, os resultados mudam.
- **Exclusão:** a ordem é inversa à da carga. Apaga-se primeiro a tabela filha (por exemplo, `Item_Pedido`) e só depois a tabela pai (`Pedido`, `Cliente`, `Cidade`).

### Como executar no Workbench

1. Abra o arquivo em uma aba de consulta (`File → Open SQL Script`).
2. Execute tudo com `Ctrl+Shift+Enter`, ou um comando por vez com `Ctrl+Enter`.
3. Confira no painel **Output** se todos os comandos terminaram com ✅.

---

## 5. Validação

### Contagem esperada após o povoamento (script 2)

| Tabela | Registros |
|---|---|
| `Cidade` | 6 |
| `Produto` | 10 |
| `Cliente` | 8 |
| `Telefone_Cliente` | 10 |
| `Pedido` | 11 |
| `Item_Pedido` | 15 |

### Contagem esperada após os `DELETE` (script 5)

| Tabela | Registros |
|---|---|
| `Cidade` | 5 |
| `Produto` | 9 |
| `Cliente` | 7 |
| `Telefone_Cliente` | 8 |
| `Pedido` | 10 |
| `Item_Pedido` | 14 |

---

## 6. Problemas comuns

| Erro | Causa | Solução |
|---|---|---|
| `1451 Cannot delete or update a parent row` | Tentativa de apagar um registro que ainda é referenciado por uma FK. | Apague antes os registros dependentes (tabelas filhas). |
| `1452 Cannot add or update a child row` | `INSERT` com FK que não existe na tabela pai. | Execute a carga na ordem correta. |
| `1062 Duplicate entry` | Script de carga executado mais de uma vez. | Reinicie o banco (veja abaixo). |
| `1175 You are using safe update mode` | `UPDATE` ou `DELETE` sem `WHERE` pela chave. | Use a chave primária no `WHERE`. |

### Reiniciar o banco do zero

```sql
DROP DATABASE IF EXISTS loja_eletronicos;
CREATE DATABASE loja_eletronicos CHARACTER SET utf8mb4;
```

Depois, execute novamente os scripts na ordem da seção 4.

---

## 7. Estrutura do repositório

```text
.
├── README.md
├── 01_criacao_tabelas.sql
├── 02_insert.sql
├── 03_select.sql
├── 04_update.sql
└── 05_delete.sql
```
