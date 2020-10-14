--Criando Database Transporte
CREATE DATABASE db_transport
    WITH OWNER 'postgres'
    ENCODING 'UTF8';

--Criando Schema Company
CREATE SCHEMA IF NOT EXISTS company;

--Tabela Tipos de Usuários
CREATE TABLE IF NOT EXISTS company.tb_type_user(
    id          bigserial    constraint pk_id_type_user          primary key,
    name        varchar(50)  constraint nn_type_user_name        not null,
    description varchar(200) constraint nn_type_user_description not null,
    CONSTRAINT  unique_type_user_name UNIQUE (name)
);

INSERT INTO company.tb_type_user (id,name,description) VALUES
(1,'DIRETOR',         'Diretor'),
(2,'GERENTE',         'Gerente'),
(3,'ENTREGADOR',      'Entregador de Encomendas'),
(4,'SUPORTE',         'Suporte ao Cliente'),
(5,'ADMINISTRATIVO',  'Administrativo da Empresa (RH, Financeiro, etc.)'),
(6,'CLIENTE',         'Cliente');

--Tabela de Usuários
CREATE TABLE IF NOT EXISTS company.tb_user(
    id           bigserial    constraint pk_id_user          primary key,
    id_type_user integer      constraint nn_user_type        not null,
    name         varchar(100) constraint nn_user_name        not null,
    doc_type     varchar(10)  constraint nn_user_doc_type    not null,
    doc_number   varchar(100) constraint nn_user_doc_number  not null,
    adress       varchar(100) constraint nn_user_adress      not null,
    city         varchar(30)  constraint nn_user_city        not null,
    state        char(02)     constraint nn_user_state       not null,
    ts_created   timestamp    constraint nn_user_ts_created  NOT NULL DEFAULT now(),
    active       boolean      DEFAULT    true,
    CONSTRAINT   unique_user_document UNIQUE     (doc_type,doc_number),
    CONSTRAINT   fk_user_type_id      FOREIGN KEY(id_type_user) REFERENCES company.tb_type_user(id) ON DELETE CASCADE
);

INSERT INTO company.tb_user (name,id_type_user,doc_type,doc_number,adress,city,state) VALUES
('Gabriel',  1, 'RG',   '1236549',     'Rua Quinze, n10',          'Uberlândia',   'MG'),
('Henrique', 2, 'CPF',  '0435489003',  'Av. Segismundo n9876',     'Santos',       'SP'),
('Márcio',   3, 'CNH',  '654987',      'Rua Palmares, n789',       'Rio Branco',   'AC'),
('Lucas',    4, 'RG',   '987878',      'Rua dos Pires, n888',      'São Paulo',    'SP'),
('Rodrigo',  5, 'RG',   '4564564',     'Av. 11 de Maio, n10',      'Araguari',     'MG'),
('Gustavo',  1, 'CPF',  '6959150604',  'Rua Pedro Pereira, n558',  'São Gotardo',  'MG'),
('João',     3, 'CPF',  '5985223507',  'Av. Rondon, n1654',        'Araxá',        'MG'),
('Jorge',    3, 'RG',   '8547889997',  'Av. Peixes, n1654',        'Paracatu',     'MG'),
('Pedro',    3, 'CPF',  '1020304050',  'Av. César, n1654',         'Indianópolis', 'MG'),
('César',    6, 'CNH',  '4002892200',  'BR 040, n1654',            'Guarujá',      'SP'),
('Herik',    6, 'CNH',  '9991143468',  'Av. João, n1654',          'Salvador',     'BA'),
('Lucimar',  6, 'CPF',  '1598169987',  'Rua. Pedro, n1654',        'Uberaba',      'MG'),
('Gabriela', 6, 'RG',   '1298655478',  'Av. Gabriel, n1654',       'Ouro Preto',   'MG'),
('Gláucia',  6, 'RG',   '6658999999',  'Av. Sem Nome, n1654',      'Curitiba',     'PR'),
('Sabrina',  6, 'CPF',  '5564456350',  'Praça dos Manos, n1654',   'Brasília',     'DF');

--Tabela de Produto
CREATE TABLE IF NOT EXISTS company.tb_product(
    id          bigserial     constraint pk_id_product          primary key,
    code        varchar(10)   constraint nn_product_code        not null,
    name        varchar(200)  constraint nn_product_name        not null,
    value       numeric(12,2) constraint nn_product_value       not null,
    ts_created  timestamp     constraint nn_product_ts_created  NOT NULL DEFAULT now(),
    active      boolean       DEFAULT    true,
  	CONSTRAINT  chk_product_value   CHECk   (value >= 0),
    CONSTRAINT  unique_product_code UNIQUE  (code)
);

INSERT INTO company.tb_product (code,name,value) VALUES
('400289', 'Playstation 5',   4999.99),
('654875', 'Xbox Series X',   3599.99),
('987777', 'Nintendo Switch', 2889.26),
('547789', 'Tv 50 SAMSUNG',   1987.69),
('321654', 'Cadeira Gamer',   3524.00),
('123654', 'Ventilador Arno', 1999.99);

--Criando Tabela de Veículos
CREATE TABLE IF NOT EXISTS company.tb_vehicle(
    id          bigserial   constraint  pk_id_vehicle         primary key,
    code        varchar(20) constraint  nn_vehicle_code       not null,
    name        varchar(50) constraint  nn_vehicle_name       not null,
    ts_created  timestamp   constraint  nn_vehicle_ts_created NOT NULL DEFAULT NOW(),
    active      boolean     DEFAULT     true,
    CONSTRAINT  unique_vehicle_code UNIQUE (code)
);

INSERT INTO company.tb_vehicle (code,name) VALUES
('HHW3305', 'VW Saveiro'),
('UJW2602', 'FIAT Doblô'),
('BRA0S17', 'FIAT Fiorino'),
('ABC1B34', 'FIAT Fiorino'),
('ACD8B99', 'Caminhão Scania');

--Criando Tabela de Status de Entrega
CREATE TABLE IF NOT EXISTS company.tb_delivery_status(
    id          bigserial       constraint pk_id_delivery_status            primary key,
    name        varchar(20)     constraint nn_delivery_status_name          NOT NULL,
    description varchar(100)    constraint nn_delivery_status_description   NOT NULL,
    CONSTRAINT  unique_delivery_status_name UNIQUE (name)
);

INSERT INTO company.tb_delivery_status (name,description) VALUES
('A CAMINHO',               'Pedido a Caminho do Centro de Distribuição'),
('EM ROTA DE ENTREGA',      'Pedido Saiu para Entrega ao Destinatário'),
('ENTREGUE',                'Pedido Entregue'),
('CANCELADO',               'Pedido foi Cancelado');

--Tabela de log de Pedidos
CREATE TABLE IF NOT EXISTS company.tb_delivery(
    id                  bigserial       constraint pk_id_delivery               primary key,
    id_vehicle          integer,
    id_user_employee    integer,
    id_user_client      integer,
    id_product          integer,
    amount_product      integer         constraint nn_delivery_amount_product   NOT NULL,
    value_delivery      numeric(12,2)   constraint nn_delivery_value_delivery   NOT NULL,
    id_delivery_status  integer,
    ts_created          timestamp       constraint nn_delivery_ts_created        NOT NULL DEFAULT now(),
    CONSTRAINT          chk_delivery_amount_product     CHECK       (amount_product >= 0),
    CONSTRAINT          chk_delivery_value              CHECK       (value_delivery >= 0),
    CONSTRAINT          fk_delivery_id_vehicle          FOREIGN KEY (id_vehicle)         REFERENCES company.tb_vehicle(id)          ON DELETE CASCADE,
    CONSTRAINT          fk_delivery_id_user_employee    FOREIGN KEY (id_user_employee)   REFERENCES company.tb_user(id)             ON DELETE CASCADE,
    CONSTRAINT          fk_delivery_id_user_client      FOREIGN KEY (id_user_client)     REFERENCES company.tb_user(id)             ON DELETE CASCADE,
    CONSTRAINT          fk_delivery_id_product          FOREIGN KEY (id_product)         REFERENCES company.tb_product(id)          ON DELETE CASCADE,
    CONSTRAINT          fk_delivery_id_delivery_status  FOREIGN KEY (id_delivery_status) REFERENCES company.tb_delivery_status(id)  ON DELETE CASCADE
);

--Function para ajudar no Insert
CREATE OR REPLACE FUNCTION company.fn_random_vehicle()
RETURNS INTEGER 
LANGUAGE plpgsql AS
$$
	BEGIN
		return (select id from company.tb_vehicle where active ORDER BY RANDOM() limit 1);
	end;
$$;

CREATE OR REPLACE FUNCTION company.fn_random_user_id_by_type(type_user_fn character varying)
RETURNS INTEGER 
LANGUAGE plpgsql AS
$$
	BEGIN
		return (select id from company.tb_user where id_type_user = (select id from company.tb_type_user where name = type_user_fn) and active ORDER BY RANDOM() limit 1);
	end;
$$;

CREATE OR REPLACE FUNCTION company.fn_random_product()
RETURNS INTEGER 
LANGUAGE plpgsql AS
$$
	BEGIN
		return (select id from company.tb_product where active ORDER BY RANDOM() limit 1);
	end;
$$;

CREATE OR REPLACE FUNCTION company.fn_random_delivery_status()
RETURNS INTEGER 
LANGUAGE plpgsql AS
$$
	BEGIN
		return (select id from company.tb_delivery_status ORDER BY RANDOM() limit 1);
	end;
$$;

INSERT INTO company.tb_delivery(id_vehicle, id_user_employee, id_user_client, id_product, amount_product, value_delivery, id_delivery_status) VALUES
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status()),
(company.fn_random_vehicle(), company.fn_random_user_id_by_type('ENTREGADOR'), company.fn_random_user_id_by_type('CLIENTE'), company.fn_random_product(), floor(random()*30)+1, (random()*1000)+1, company.fn_random_delivery_status());

--CREATE VIEWS
--Relatório de Pedidos
create or replace view company.vw_report_delivery as
select
	d.id as id_delivery,
    v.code as code_vehicle,
	v.name as vehicle,
	u1.name as deliveryman,
	u2.name as client,
	p.name as product,
	(p.value * d.amount_product) + d.value_delivery as vl_t_product,
	ds.name as status_delivery,
	to_char(d.ts_created,'DD/MM/YYYY') as data_delivery,
	to_char(d.ts_created,'HH:MI:SS') as horary_delivery
from
	company.tb_delivery d
	join company.tb_vehicle v on v.id = d.id_vehicle
	join company.tb_user u1 on u1.id = d.id_user_employee
	join company.tb_user u2 on u2.id = d.id_user_client
	join company.tb_product p on p.id = d.id_product
	join company.tb_delivery_status ds on ds.id = d.id_delivery_status;

--Quantidade de Pedidos por Estado
create or replace view company.vw_amount_delivery_by_state as
select
	u.state state,
	count(*) amount_delivery
from
	company.tb_delivery d
	join company.tb_user u on u.id = d.id_user_client
group by u.state;

--Quantidade de Pedidos por Status
create or replace view company.vw_amount_delivery_by_status as
select
	ds.name status,
	ds.description description,
	count(*) amount_delivery
from
	company.tb_delivery d
	join company.tb_delivery_status ds on ds.id = d.id_delivery_status
group by ds.name, ds.description;

--Trigger
CREATE TABLE IF NOT EXISTS company.tb_delivery_log(
    operation   		VARCHAR(20)     NOT NULL,
    user_name   		VARCHAR(100)    NOT NULL,
    ts_register 		TIMESTAMP   	NOT null,
    like company.tb_delivery
);

CREATE OR REPLACE FUNCTION company.fn_delivery_log()
RETURNS trigger AS
$$
    BEGIN
        IF(tg_op = 'DELETE') then
      		INSERT INTO company.tb_delivery_log 
              	SELECT 'DELETE', user, now(), OLD.*;
            RETURN OLD;
        ELSIF(tg_op = 'UPDATE') THEN
            INSERT INTO company.tb_delivery_log 
           		SELECT 'UPDATE', user, now(), NEW.*;
            RETURN NEW;
        ELSIF(tg_op = 'INSERT') then
            INSERT INTO company.tb_delivery_log
            	SELECT 'INSERT', user, now(), NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL;
    END
$$
LANGUAGE plpgsql;

CREATE TRIGGER tg_delivery_log
AFTER DELETE OR UPDATE OR INSERT company.tb_delivery
FOR EACH ROW EXECUTE PROCEDURE company.fn_delivery_log();

--Criando Usuários e Roles
--DBA
CREATE USER dba WITH SUPERUSER CONNECTION LIMIT 1 PASSWORD 'P4SSW0RD';

--ANALISTA
create group analyst;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA company to analyst;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA company TO analyst;
GRANT ALL ON SCHEMA company TO analyst;

--SISTEMA
create group system;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA company TO system;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA company TO system;
GRANT ALL ON SCHEMA company TO system;

--SUPORTE
create group suport;
GRANT select ON ALL TABLES IN SCHEMA company TO suport;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA company TO suport;
GRANT USAGE ON SCHEMA company TO suport;
