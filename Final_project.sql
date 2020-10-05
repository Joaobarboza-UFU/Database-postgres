--Cliente, Produto, FuncionÃ¡rios, VeÃ­culos, Entregas, Cargos
--Cliente, Produto, VeÃ­culo, Cargos, FuncinÃ¡rios, Entregas
--Criando Empresa
CREATE DATABASE transport
    WITH OWNER 'postgres'
    ENCODING 'UTF8';

--Criando Schema Company
CREATE SCHEMA IF NOT EXISTS company;

--Tabela Tipos de UsuÃ¡rios
CREATE TABLE IF NOT EXISTS company.type_user(
    id          bigserial    constraint pk_id_type_user          primary key,
    name        varchar(50)  constraint nn_type_user_name        not null,
    description varchar(200) constraint nn_type_user_description not null,
    CONSTRAINT  unique_type_user_name UNIQUE (name)
);

INSERT INTO company.type_user (id,name,description) VALUES
(1,'DIRETOR',         'Diretor'),
(2,'GERENTE',         'Gerente'),
(3,'ENTREGADOR',      'Entregador de Encomendas'),
(4,'SUPORTE',         'Suporte ao Cliente'),
(5,'ADMINISTRATIVO',  'Administrativo da Empresa (RH, Financeiro, etc.)'),
(6,'CLIENTE',         'Cliente');


--Tabela de UsuÃ¡rios
CREATE TABLE IF NOT EXISTS company.user(
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
    CONSTRAINT   fk_user_type_id      FOREIGN KEY(id_type_user) REFERENCES company.type_user(id) ON DELETE CASCADE
);

INSERT INTO company.user (name,id_type_user,doc_type,doc_number,adress,city,state) VALUES
('Gabriel',  1, 'RG',   '1236549',     'Rua Quinze, n10',          'UberlÃ¢ndia',   'MG'),
('Henrique', 2, 'CPF',  '0435489003',  'Av. Segismundo n9876',     'Santos',       'SP'),
('MÃ¡rcio',   3, 'CNH',  '654987',      'Rua Palmares, n789',       'Rio Branco',   'AC'),
('Lucas',    4, 'RG',   '987878',      'Rua dos Pires, n888',      'SÃ£o Paulo',    'SP'),
('Rodrigo',  5, 'RG',   '4564564',     'Av. 11 de Maio, n10',      'Araguari',     'MG'),
('Gustavo',  6, 'CPF',  '6959150604',  'Rua Pedro Pereira, n558',  'SÃ£o Gotardo',  'MG'),
('JoÃ£o',     3, 'CPF',  '5985223507',  'Av. Rondon, n1654',        'AraxÃ¡',        'MG'),
('Jorge',    3, 'RG',   '8547889997',  'Av. Peixes, n1654',        'Paracatu',     'MG'),
('Pedro',    3, 'CPF',  '1020304050',  'Av. CÃ©sar, n1654',         'IndianÃ³polis', 'MG'),
('CÃ©sar',    6, 'CNH',  '4002892200',  'BR 040, n1654',            'GuarujÃ¡',      'SP'),
('Herik',    6, 'CNH',  '9991143468',  'Av. JoÃ£o, n1654',          'Salvador',     'BA'),
('Lucimar',  6, 'CPF',  '1598169987',  'Rua. Pedro, n1654',        'Uberaba',      'MG'),
('Gabriela', 6, 'RG',   '1298655478',  'Av. Gabriel, n1654',       'Ouro Preto',   'MG'),
('GlÃ¡ucia',  6, 'RG',   '6658999999',  'Av. Sem Nome, n1654',      'Curitiba',     'PR'),
('Sabrina',  6, 'CPF',  '5564456350',  'PraÃ§a dos Manos, n1654',   'BrasÃ­lia',     'DF');

--Tabela de Produto
CREATE TABLE IF NOT EXISTS company.product(
    id          bigserial     constraint pk_id_product          primary key,
    code        varchar(10)   constraint nn_product_code        not null,
    name        varchar(200)  constraint nn_product_name        not null,
    value       numeric(12,2) constraint nn_product_value       not null,
    ts_created  timestamp     constraint nn_product_ts_created  NOT NULL DEFAULT now(),
    active      boolean       DEFAULT    true,
  	CONSTRAINT  chk_product_value   CHECk   (value >= 0),
    CONSTRAINT  unique_product_code UNIQUE  (code)
);

INSERT INTO company.product (code,name,value) VALUES
('400289', 'Playstation 5',   4999.99),
('654875', 'Xbox Series X',   3599.99),
('987777', 'Nintendo Switch', 2889.26),
('547789', 'Tv 50 SAMSUNG',   1987.69),
('321654', 'Cadeira Gamer',   3524.00),
('123654', 'Ventilador Arno', 1999.99);

--Criando Tabela de VeÃ­culos
CREATE TABLE IF NOT EXISTS company.vehicle(
    id          bigserial   constraint  pk_id_vehicle         primary key,
    code        varchar(20) constraint  nn_vehicle_code       not null,
    name        varchar(50) constraint  nn_vehicle_name       not null,
    ts_created  timestamp   constraint  nn_vehicle_ts_created NOT NULL DEFAULT NOW(),
    active      boolean     DEFAULT     true,
    CONSTRAINT  unique_vehicle_code UNIQUE (code)
);

INSERT INTO company.vehicle (code,name) VALUES
('HHW3305', 'VW Saveiro'),
('UJW2602', 'FIAT DoblÃ´'),
('BRA0S17', 'FIAT Fiorino'),
('ABC1B34', 'FIAT Fiorino'),
('ACD8B99', 'CaminhÃ£o Scania');

--Criando Tabela de Status de Entrega
CREATE TABLE IF NOT EXISTS company.delivery_status(
    id          bigserial       constraint pk_id_delivery_status            primary key,
    name        varchar(20)     constraint nn_delivery_status_name          NOT NULL,
    description varchar(100)    constraint nn_delivery_status_description   NOT NULL,
    CONSTRAINT  unique_delivery_status_name UNIQUE (name)
);

INSERT INTO company.delivery_status (name,description) VALUES
('A CAMINHO',               'Pedido a Caminho do Centro de DistribuiÃ§Ã£o'),
('EM ROTA DE ENTREGA',      'Pedido Saiu para Entrega ao DestinatÃ¡rio'),
('ENTREGUE',                'Pedido Entregue'),
('CANCELADO',               'Pedido foi Cancelado');

--Tabela de log de Pedidos
CREATE TABLE IF NOT EXISTS company.delivery(
    id                  bigserial       constraint pk_id_delivery               primary key,
    id_vehicle          integer,
    id_user_employee    integer,
    id_user_client      integer,
    id_product          integer,
    amount_product      integer         constraint nn_delivery_amount_product   NOT NULL,
    value_delivery      numeric(12,2)   constraint nn_delivery_value_delivery   NOT NULL,
    id_delivery_status  integer,
    ts_created          timestamp       constraint nn_product_ts_created        NOT NULL DEFAULT now(),
    CONSTRAINT          fk_delivery_id_vehicle          FOREIGN KEY(id_vehicle)         REFERENCES company.vehicle(id)          ON DELETE CASCADE,
    CONSTRAINT          fk_delivery_id_user_employee    FOREIGN KEY(id_user_employee)   REFERENCES company.user(id)             ON DELETE CASCADE,
    CONSTRAINT          fk_delivery_id_user_client      FOREIGN KEY(id_user_client)     REFERENCES company.user(id)             ON DELETE CASCADE,
    CONSTRAINT          fk_delivery_id_product          FOREIGN KEY(id_product)         REFERENCES company.product(id)          ON DELETE CASCADE,
    CONSTRAINT          fk_delivery_id_delivery_status  FOREIGN KEY(id_delivery_status) REFERENCES company.delivery_status(id)  ON DELETE CASCADE
);

--Function para ajudar no Insert
CREATE OR REPLACE FUNCTION company.fn_random_vehicle()
RETURNS INTEGER 
LANGUAGE plpgsql AS
$$
	BEGIN
		return (select id from company.vehicle where active ORDER BY RANDOM() limit 1);
	end;
$$;

CREATE OR REPLACE FUNCTION company.fn_random_user_id_by_type(type_user_fn character varying)
RETURNS INTEGER 
LANGUAGE plpgsql AS
$$
	BEGIN
		return (select id from company.user where id_type_user = (select id from company.type_user where name = type_user_fn) and active ORDER BY RANDOM() limit 1);
	end;
$$;

CREATE OR REPLACE FUNCTION company.fn_random_product()
RETURNS INTEGER 
LANGUAGE plpgsql AS
$$
	BEGIN
		return (select id from company.product where active ORDER BY RANDOM() limit 1);
	end;
$$;

CREATE OR REPLACE FUNCTION company.fn_random_delivery_status()
RETURNS INTEGER 
LANGUAGE plpgsql AS
$$
	BEGIN
		return (select id from company.delivery_status ORDER BY RANDOM() limit 1);
	end;
$$;

INSERT INTO company.delivery(id_vehicle, id_user_employee, id_user_client, id_product, amount_product, value_delivery, id_delivery_status) VALUES
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
