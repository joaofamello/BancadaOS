CREATE TYPE tipo_movimentacao AS ENUM ('ENTRADA', 'SAIDA');
CREATE TYPE cargo_usuario AS ENUM ('ADMIN', 'FUNCIONARIO');
CREATE TYPE forma_pagamento AS ENUM ('DINHEIRO', 'CREDITO', 'DEBITO', 'PIX');
CREATE TYPE status_venda AS ENUM ('PENDENTE', 'CONCLUIDA', 'CANCELADA');

CREATE TABLE usuario(
    id_usuario BIGSERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cargo cargo_usuario NOT NULL DEFAULT 'FUNCIONARIO'
);

CREATE TABLE categoria(
    id_categoria BIGSERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);


CREATE TABLE cliente(
    id_cliente BIGSERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255)
);

CREATE TABLE telefone(
    id_telefone BIGSERIAL PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    numero VARCHAR(20) NOT NULL,

    CONSTRAINT fk_cliente_telefone
    FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
);

CREATE TABLE produto(
    id_produto BIGSERIAL PRIMARY KEY,
    id_categoria BIGINT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    valor_compra DECIMAL(10,2) NOT NULL,
    valor_venda DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES categoria(id_categoria)
);

CREATE TABLE estoque(
    id_estoque BIGSERIAL PRIMARY KEY UNIQUE,
    id_produto BIGINT NOT NULL,
    quantidade BIGINT NOT NULL CHECK(quantidade >= 0),

    CONSTRAINT fk_produto_estoque
    FOREIGN KEY (id_produto)
    REFERENCES produto(id_produto)
);

CREATE TABLE movimentacao_estoque(
    id_movimentacao BIGSERIAL PRIMARY KEY,
    id_produto BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    tipo tipo_movimentacao NOT NULL,
    quantidade INT NOT NULL CHECK(quantidade > 0),
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    documento_referencia BIGINT,
    motivo TEXT NOT NULL,
    observacao TEXT,

    CONSTRAINT fk_usuario_movimentacao
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario),

    CONSTRAINT fk_produto_movimentacao
    FOREIGN KEY (id_produto)
    REFERENCES produto(id_produto)
);

CREATE TABLE venda(
    id_venda BIGSERIAL PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_cliente BIGINT,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    forma_pagamento forma_pagamento NOT NULL,
    status_venda status_venda NOT NULL,

    CONSTRAINT fk_usuario_venda
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario),

    CONSTRAINT fk_cliente_venda
    FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
);

CREATE TABLE item_venda(
    id_item BIGSERIAL PRIMARY KEY,
    id_venda BIGINT NOT NULL,
    id_produto BIGINT NOT NULL,
    quantidade BIGINT NOT NULL CHECK(quantidade > 0),
    valor_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_produto_item_venda
    FOREIGN KEY (id_produto)
    REFERENCES produto(id_produto),

    CONSTRAINT fk_venda
    FOREIGN KEY (id_venda)
    REFERENCES venda(id_venda)
);

CREATE INDEX idx_movimentacao_data ON movimentacao_estoque(data_movimentacao);
CREATE INDEX idx_movimentacao_produto ON movimentacao_estoque(id_produto);
CREATE INDEX idx_venda_data ON venda(data_venda);