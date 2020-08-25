
create database banco_2020_02

create schema filial

create table filial.Cliente(
    id integer,
    nome varchar(50),
	endereco varchar(50),
	cidade varchar(50),
	estado char(02),
	CPF varchar(11),
	RG varchar(11),
	dependente_01 varchar(40),
	telefone varchar(11),
	celular varchar(11)
	)
	
create table filial.Fornecedor(
	id integer,
	nome varchar(50),
	endereco varchar(02),
	CNPJ numeric(12),
	estado char(02),
	contato varchar(30)
)

create table filial.Cidade(
	id integer,
	descricao varchar(50),
	sigla varchar(02),
	populacao numeric(10,2),
	estado char(02)
)

create table filial.Produtos(
	id integer,
	descricao varchar(50),
	categoria varchar(20),
	preco_compra numeric(10,2),
	preco_custo numeric(10,2),
	estoque numeric(10,2)
)

create table filial.Regiao(
	id integer,
	descricao varchar(50),
	sigla varchar(02)
)

alter table filial.Cidade add column area_total numeric(10,2)

alter table filial.cliente add column dependente_02 varchar(40)

alter table filial.cliente drop column telefone
