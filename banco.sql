-- 1. 20250423232245-create-table-denuncia.js
CREATE TABLE denuncia (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    titulo VARCHAR(50) NOT NULL,
    descricao VARCHAR(500) NOT NULL,
    dataPublicacao DATE NOT NULL,
    status INTEGER DEFAULT 0, -- Será alterado posteriormente para VARCHAR
    cep VARCHAR(30), -- Será alterado posteriormente para NOT NULL
    cidade VARCHAR(30), -- Será alterado posteriormente para NOT NULL
    bairro VARCHAR(30), -- Será alterado posteriormente para NOT NULL
    rua VARCHAR(30), -- Será alterado posteriormente para NOT NULL
    numero VARCHAR(30),
    complemento VARCHAR(30),
    pontuacao DECIMAL(5, 2) NOT NULL,
    id_usuario INTEGER NOT NULL -- Foreign Key será definida posteriormente
);

-- 2. 20250429135537-create-table-grupo-categoria.js
CREATE TABLE grupo_categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    icone VARCHAR(50) NOT NULL
);

-- 3. 20250507223335-create-table-usuario.js
CREATE TABLE usuario (
    id_usuario INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, -- Será renomeado para 'id'
    nome_usuario VARCHAR(50) NOT NULL, -- Será renomeado para 'nome'
    telefone VARCHAR(14), -- Será removido
    email VARCHAR(40) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE, -- Será removido
    endereco JSON, -- Será removido
    nivel INTEGER NOT NULL DEFAULT 0, -- Será removido
    verified BOOLEAN NOT NULL DEFAULT FALSE
);

-- 4. 20250524164653-create-table-imagem-denuncia.js
CREATE TABLE imagem_denuncia (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    id_denuncia INTEGER NOT NULL,
    FOREIGN KEY (id_denuncia) REFERENCES denuncia(id) ON DELETE CASCADE
);

-- ######################################################################
-- # FASE 2: ALTERAÇÕES INICIAIS EM TABELAS EXISTENTES
-- ######################################################################

-- 5. 20250925202854-alter-table-usuario-endereco.js
-- Remove a coluna 'endereco' e adiciona campos detalhados
ALTER TABLE usuario DROP COLUMN endereco;
ALTER TABLE usuario ADD COLUMN rua VARCHAR(255);
ALTER TABLE usuario ADD COLUMN numero VARCHAR(5);
ALTER TABLE usuario ADD COLUMN bairro VARCHAR(100);
ALTER TABLE usuario ADD COLUMN cidade VARCHAR(100);
ALTER TABLE usuario ADD COLUMN complemento VARCHAR(20);
ALTER TABLE usuario ADD COLUMN cep CHAR(9);

-- 6. 20250928141810-alter-table-usuario-id-nome.js
-- Renomeia colunas para o padrão final 'id' e 'nome'
ALTER TABLE usuario RENAME COLUMN id_usuario TO id;
ALTER TABLE usuario RENAME COLUMN nome_usuario TO nome;

-- ######################################################################
-- # FASE 3: CRIAÇÃO DE TABELAS DEPOIS DAS ALTERAÇÕES
-- ######################################################################

-- 7. 20251014222954-create-table-denuncia-feedback.js
CREATE TABLE "denuncia-feedback" (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    data_publicacao DATE NOT NULL,
    descricao VARCHAR(2048) NOT NULL,
    fk_denuncia INTEGER NOT NULL,
    FOREIGN KEY (fk_denuncia) REFERENCES denuncia(id) ON DELETE CASCADE
);

-- 8. 20251018175640-create-table-comentario.js
CREATE TABLE comentarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    descricao VARCHAR(500) NOT NULL,
    dataPublicacao DATE NOT NULL,
    fk_denuncia INTEGER NOT NULL,
    fk_usuario INTEGER NOT NULL,
    FOREIGN KEY (fk_denuncia) REFERENCES denuncia(id) ON DELETE CASCADE,
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id) ON DELETE CASCADE
);

-- 9. 20251018221424-create-table-categoria.js
CREATE TABLE categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    id_grupo INTEGER NOT NULL,
    FOREIGN KEY (id_grupo) REFERENCES grupo_categoria(id) ON DELETE CASCADE
);

-- 10. 20251018221450-create-table-categoria-denuncia.js
CREATE TABLE categoria_denuncia (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    id_categoria INTEGER NOT NULL,
    id_denuncia INTEGER NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id) ON DELETE CASCADE,
    FOREIGN KEY (id_denuncia) REFERENCES denuncia(id) ON DELETE CASCADE
);

-- 11. 20251028230755-create-table-registro.js
CREATE TABLE registro (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    data_publicacao DATE NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    statusAnterior VARCHAR(50) NOT NULL,
    statusPosterior VARCHAR(50) NOT NULL,
    id_denuncia INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL,
    FOREIGN KEY (id_denuncia) REFERENCES denuncia(id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
);

-- 12. 20251028230756-create-table-imagem-registro.js
CREATE TABLE imagem_registro (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    id_registro INTEGER NOT NULL,
    FOREIGN KEY (id_registro) REFERENCES registro(id) ON DELETE CASCADE
);

-- ######################################################################
-- # FASE 4: REESTRUTURAÇÃO DO USUÁRIO E CRIAÇÃO DE TABELAS DE PERFIL
-- ######################################################################

-- 13. 20251102031854-alter-table-usuario.js
-- Adiciona a coluna 'tipo' e remove campos de endereço/documento
ALTER TABLE usuario ADD COLUMN tipo VARCHAR(30) NOT NULL DEFAULT 'cidadao';
ALTER TABLE usuario DROP COLUMN telefone;
ALTER TABLE usuario DROP COLUMN cpf;
ALTER TABLE usuario DROP COLUMN cep;
ALTER TABLE usuario DROP COLUMN cidade;
ALTER TABLE usuario DROP COLUMN bairro;
ALTER TABLE usuario DROP COLUMN rua;
ALTER TABLE usuario DROP COLUMN numero;
ALTER TABLE usuario DROP COLUMN complemento;
ALTER TABLE usuario DROP COLUMN nivel;

-- 14. 20251103015624-create-table-cidadao.js
CREATE TABLE cidadao (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    id_usuario INTEGER NOT NULL,
    cep CHAR(8),
    cidade VARCHAR(50),
    bairro VARCHAR(50),
    rua VARCHAR(100),
    numero VARCHAR(15),
    complemento VARCHAR(50),
    cpf CHAR(11),
    telefone CHAR(11),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
);

-- 15. 20251104004626-create-table-visita.js
CREATE TABLE visita (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    motivo VARCHAR(150) NOT NULL,
    data_inicio DATE NOT NULL,
    data_final DATE NOT NULL,
    id_registro INTEGER NOT NULL,
    FOREIGN KEY (id_registro) REFERENCES registro(id) ON DELETE CASCADE
);

-- 16. 20251106002405-create-table-funcionarios.js
CREATE TABLE funcionario (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    id_usuario INTEGER NOT NULL,
    nivel VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
    -- Colunas de CPF, telefone e id_prefeitura serão adicionadas na próxima etapa
);

-- 17. 20251108113834-create-table-prefeitura.js
CREATE TABLE prefeitura (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nome_oficial VARCHAR(100) NOT NULL,
    email_institucional VARCHAR(100) NOT NULL UNIQUE,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    codigo_ibge CHAR(7) NOT NULL UNIQUE,
    logo VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    cep CHAR(8),
    cidade VARCHAR(50),
    bairro VARCHAR(50),
    rua VARCHAR(100),
    numero VARCHAR(15),
    complemento VARCHAR(50)
);

-- 18. 20251108113835-alter-table-funcionario-id-prefeitura-cpf-telefone.js
-- Adiciona CPF, telefone e Foreign Key para 'prefeitura'
ALTER TABLE funcionario ADD COLUMN cpf VARCHAR(11) NOT NULL;
ALTER TABLE funcionario ADD COLUMN telefone VARCHAR(11);
ALTER TABLE funcionario ADD COLUMN id_prefeitura INTEGER NOT NULL;
ALTER TABLE funcionario ADD FOREIGN KEY (id_prefeitura) REFERENCES prefeitura(id) ON DELETE CASCADE;

-- 19. 20251118005417-create-table-interface-feedback.js
CREATE TABLE "interface-feedback" (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    data_publicacao DATE NOT NULL,
    descricao VARCHAR(2048) NOT NULL,
    tela VARCHAR(255) NOT NULL
);

ALTER TABLE denuncia DROP COLUMN status;
ALTER TABLE denuncia ADD COLUMN status VARCHAR(50) NOT NULL DEFAULT 'aberto';

ALTER TABLE denuncia CHANGE COLUMN cep cep VARCHAR(30) NOT NULL;
ALTER TABLE denuncia CHANGE COLUMN bairro bairro VARCHAR(30) NOT NULL;
ALTER TABLE denuncia CHANGE COLUMN rua rua VARCHAR(30) NOT NULL;
ALTER TABLE denuncia CHANGE COLUMN cidade cidade VARCHAR(30) NOT NULL;