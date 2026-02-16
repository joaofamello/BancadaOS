CREATE USER bancada_os WITH PASSWORD 'bancada';

CREATE TYPE tipo_movimentacao AS ENUM ('ENTRADA', 'SAIDA');
CREATE TYPE forma_pagamento AS ENUM ('DINHEIRO', 'CREDITO', 'DEBITO', 'PIX');
CREATE TYPE status_venda AS ENUM ('PENDENTE', 'CONCLUIDA', 'CANCELADA');
CREATE TYPE status_os AS ENUM ('ORCAMENTO', 'APROVADA', 'EM_ANDAMENTO', 'AGUARDANDO_PECA', 'CONCLUIDA', 'CANCELADA', 'ENTREGUE');

CREATE TABLE usuario(
    id_usuario BIGSERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE categoria(
    id_categoria BIGSERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE cliente(
    id_cliente BIGSERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE telefone(
    id_telefone BIGSERIAL PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    numero VARCHAR(20) NOT NULL,

    CONSTRAINT fk_cliente_telefone
    FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
    ON DELETE CASCADE
);

CREATE TABLE produto(
    id_produto BIGSERIAL PRIMARY KEY,
    id_categoria BIGINT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    valor_compra DECIMAL(10,2) NOT NULL,
    valor_venda DECIMAL(10,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES categoria(id_categoria)
);

CREATE TABLE estoque(
    id_estoque BIGSERIAL PRIMARY KEY,
    id_produto BIGINT NOT NULL UNIQUE,
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

CREATE TABLE aparelho(
    id_aparelho BIGSERIAL PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    tipo VARCHAR(255) NOT NULL,
    marca VARCHAR(255),
    modelo VARCHAR(255),
    numero_serie VARCHAR(255),
    senha_desbloqueio VARCHAR(255),
    observacao TEXT,

    CONSTRAINT fk_cliente_aparelho
    FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
);

CREATE TABLE tipo_servico(
    id_tipo_servico BIGSERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT
);

CREATE TABLE servico(
    id_servico BIGSERIAL PRIMARY KEY,
    id_tipo_servico BIGINT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    valor_base DECIMAL(10,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_tipo_servico
    FOREIGN KEY (id_tipo_servico)
    REFERENCES tipo_servico(id_tipo_servico)
);

CREATE TABLE ordem_servico(
    id_os BIGSERIAL PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    id_aparelho BIGINT NOT NULL,
    data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fechamento TIMESTAMP,
    problema_relato TEXT NOT NULL,
    laudo_tecnico TEXT,
    valor_total DECIMAL(10,2) NOT NULL,
    status_os status_os NOT NULL DEFAULT 'ORCAMENTO',

    CONSTRAINT fk_cliente_os
    FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente),

    CONSTRAINT fk_aparelho_os
    FOREIGN KEY (id_aparelho)
    REFERENCES aparelho(id_aparelho)
);

CREATE TABLE item_peca_os(
    id_item_peca BIGSERIAL PRIMARY KEY,
    id_os BIGINT NOT NULL,
    id_produto BIGINT NOT NULL,
    id_usuario BIGINT,
    quantidade BIGINT NOT NULL CHECK(quantidade > 0),
    valor_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_usuario_item_peca
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario),

    CONSTRAINT fk_os_item_peca
    FOREIGN KEY (id_os)
    REFERENCES ordem_servico(id_os),

    CONSTRAINT fk_produto_item_peca
    FOREIGN KEY (id_produto)
    REFERENCES produto(id_produto)
);

CREATE TABLE item_servico_os(
    id_item_servico BIGSERIAL PRIMARY KEY,
    id_os BIGINT NOT NULL,
    id_peca_os BIGINT,
    id_servico BIGINT NOT NULL,
    id_usuario BIGINT,
    valor_cobrado DECIMAL(10,2) NOT NULL,
    concluido BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_peca_os_item_servico
    FOREIGN KEY (id_peca_os)
    REFERENCES item_peca_os(id_item_peca),

    CONSTRAINT fk_usuario_item_servico
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario),

    CONSTRAINT fk_os_item_servico
    FOREIGN KEY (id_os)
    REFERENCES ordem_servico(id_os),

    CONSTRAINT fk_servico_item_servico
    FOREIGN KEY (id_servico)
    REFERENCES servico(id_servico)
);

CREATE INDEX idx_movimentacao_data ON movimentacao_estoque(data_movimentacao);
CREATE INDEX idx_movimentacao_produto ON movimentacao_estoque(id_produto);
CREATE INDEX idx_venda_data ON venda(data_venda);
CREATE INDEX idx_item_venda_venda ON item_venda(id_venda);
CREATE INDEX idx_item_servico_os ON item_servico_os(id_os);
CREATE INDEX idx_item_peca_os ON item_peca_os(id_os);
CREATE INDEX idx_cliente_nome ON cliente(nome);
CREATE INDEX idx_aparelho_serie ON aparelho(numero_serie);

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO bancada_os;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO bancada_os;