-- ============================================
-- PROJETO: Sistema de Análise de Grupos de Consórcio
-- AUTOR: Júlio Paixão
-- DATA: Outubro 2025
-- ============================================

-- ============================================
-- DESCRIÇÃO DO PROJETO
-- ============================================
-- Este sistema foi desenvolvido para simular e analisar grupos de consórcio
-- de automóveis, motocicletas e imóveis, com o objetivo de criar propostas
-- comerciais interativas através do Power BI.
--
-- O projeto replica a experiência profissional adquirida como vendedor de
-- consórcio, estruturando dados realistas de grupos com diferentes valores,
-- prazos e taxas de administração.
--
-- OBJETIVO PRINCIPAL:
-- Criar uma base de dados que servirá como fonte para um dashboard interativo
-- no Power BI, permitindo simulações e geração de propostas comerciais
-- personalizadas para clientes.
--
-- ESCOPO:
-- - 48 grupos de consórcio distribuídos entre 3 categorias
-- - Grupos com diferentes prazos e valores de crédito
-- - Dados históricos de 2022 a 2025 com reajustes anuais aplicados
-- - Cálculo automático de parcelas
-- ============================================

-- ============================================
-- SEÇÃO 1: CRIAÇÃO DO BANCO DE DADOS
-- ============================================
-- Cria o banco de dados caso não exista, evitando erros em execuções múltiplas.
-- Configurações de charset UTF8MB4 garantem compatibilidade total com caracteres
-- especiais, acentuação em português e emojis.
--
-- CHARSET: utf8mb4 - suporta todos os caracteres Unicode (4 bytes)
-- COLLATE: utf8mb4_0900_ai_ci
--   - 0900: versão mais recente das regras Unicode
--   - ai (accent insensitive): buscas não diferenciam acentos
--   - ci (case insensitive): buscas não diferenciam maiúsculas/minúsculas
-- ============================================

CREATE DATABASE IF NOT EXISTS db_grupos_consorcios
DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_0900_ai_ci;

-- Seleciona o banco de dados para uso
USE db_grupos_consorcios;

-- ============================================
-- SEÇÃO 2: CRIAÇÃO DA TABELA GRUPOS
-- ============================================
-- Tabela principal que armazena informações sobre grupos de consórcio.
-- Cada registro representa um grupo único com combinação específica de
-- valor de crédito e prazo.
--
-- REGRAS DE NEGÓCIO APLICADAS:
-- 1. Cada grupo possui um código único identificador
-- 2. Valores de crédito e taxas não podem ser negativos
-- 3. Taxas de administração e fundo de reserva limitadas a 100%
-- 4. Valor da parcela é calculado automaticamente (coluna STORED)
-- 5. Reajustes anuais de 15% aplicados manualmente nos dados históricos
--
-- CÁLCULO DA PARCELA:
-- valor_parcela = valor_credito / prazo_meses
-- Nota: Taxas serão aplicadas posteriormente no Power BI via Power Query
-- ============================================

CREATE TABLE grupos(

	-- Identificador único auto-incremental
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    
    -- Código do grupo (ex: A001-40M, I005-180M)
    -- CHAR(8) comporta códigos com prazos de até 2 dígitos
    -- UNIQUE garante que não haja duplicação de códigos
    codigo_grupo CHAR(8) NOT NULL UNIQUE,
    
    -- Tipo de bem do consórcio (Automóvel, Motocicleta, Imóvel)
    tipo_bem VARCHAR(50) NOT NULL,
    
    -- Valor do crédito da carta de consórcio
    -- DECIMAL(10,2) suporta valores até R$ 99.999.999,99
    -- CHECK garante que não sejam inseridos valores negativos
    valor_credito DECIMAL(10, 2) NOT NULL CHECK(valor_credito >= 0),
    
	-- Prazo do grupo em meses
    -- SMALLINT UNSIGNED permite valores de 0 a 65.535
    prazo_meses SMALLINT UNSIGNED NOT NULL,
    
    -- Valor da parcela mensal (calculado automaticamente)
    -- STORED: o valor é calculado uma vez e armazenado fisicamente
    -- Fórmula: valor_credito dividido pelo prazo em meses
    valor_parcela DECIMAL(10, 2) AS (valor_credito / prazo_meses) STORED,
    
    -- Taxa de administração em percentual (ex: 10.50 = 10,5%)
    -- CHECK garante valores entre 0 e 100
    taxa_admin DECIMAL(5, 2) NOT NULL CHECK(taxa_admin >= 0 AND taxa_admin <= 100),
    
    -- Fundo de reserva em percentual (ex: 2.00 = 2%)
    -- Proteção contra inadimplência do grupo
    -- CHECK garante valores entre 0 e 100
    fundo_reserva DECIMAL(5, 2) NOT NULL CHECK(fundo_reserva >= 0 AND fundo_reserva <= 100),
    
    -- Data de formação/início do grupo
    data_formacao DATE NOT NULL,
    
    -- Status atual do grupo
    -- ENUM limita os valores possíveis a apenas 'Ativo' ou 'Encerrado'
    -- DEFAULT 'Ativo' para novos registros
    status_grupo ENUM('Ativo', 'Encerrado') DEFAULT 'Ativo',
    
    -- Quantidade de cotas/participantes no grupo
    -- SMALLINT UNSIGNED permite valores de 0 a 65.535
    qtd_cotas SMALLINT UNSIGNED NOT NULL
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================
-- OBSERVAÇÕES IMPORTANTES
-- ============================================
-- 1. ENGINE InnoDB: oferece suporte a transações ACID, integridade referencial
--    e melhor performance para operações de leitura/escrita
--
-- 2. Coluna valor_parcela STORED: calculada automaticamente na inserção/atualização
--    e armazenada fisicamente, otimizando consultas futuras
--
-- 3. Reajuste anual: grupos de 2023 têm valores × 1.15 (um reajuste)
--    grupos de 2022 têm valores × 1.3225 (dois reajustes de 15% compostos)
--
-- 4. Taxas realistas: baseadas em pesquisa de mercado realizada em out/2025
--    - Automóveis: 9% a 12%
--    - Motocicletas: 9% a 11.5%
--    - Imóveis: 15% a 20%
--
-- 5. Total de registros: 48 grupos distribuídos em:
--    - Automóveis: 18 grupos (6 valores × 3 prazos)
--    - Motocicletas: 12 grupos (4 valores × 3 prazos)
--    - Imóveis: 18 grupos (6 valores × 3 prazos)
-- ============================================

-- ============================================
-- SEÇÃO 3: AJUSTES E CORREÇÕES
-- ============================================
-- Esta seção contém alterações realizadas na estrutura da tabela após
-- a criação inicial, seja por correções de erros identificados ou por
-- ajustes de requisitos.
-- ============================================

-- ============================================
-- AJUSTE 3.1: Ampliação do tamanho do codigo_grupo
-- DATA: Outubro 2025
-- MOTIVO: Erro identificado durante inserção de dados
-- ============================================
-- PROBLEMA IDENTIFICADO:
-- Durante a primeira tentativa de inserção, ocorreu o erro:
-- "Error Code: 1406. Data too long for column 'codigo_grupo' at row 3"
--
-- CAUSA:
-- A coluna foi inicialmente definida como CHAR(8), porém alguns códigos
-- de grupos com prazos de 3 dígitos (ex: I014-240M) possuem 9 caracteres,
-- ultrapassando o limite estabelecido.
--
-- ANÁLISE:
-- Formato do código: [Tipo][Número]-[Prazo]M
-- Exemplos:
--   - A001-40M  = 8 caracteres (prazo com 2 dígitos) ✓
--   - M010-40M  = 8 caracteres (prazo com 2 dígitos) ✓
--   - I014-240M = 9 caracteres (prazo com 3 dígitos) ✗ ERRO!
--
-- SOLUÇÃO:
-- Alteração de CHAR(8) para CHAR(9) para comportar todos os formatos possíveis
-- de código, incluindo grupos com prazos de 120, 180 e 240 meses.
--
-- IMPACTO:
-- Após esta alteração, foi necessário resetar o AUTO_INCREMENT e reinserir
-- os dados para garantir a integridade das informações.
-- OBS: AUTO_INCREMENT resetado no arquivo 02_insercao_de_dados_grupos_consorcio.
-- ============================================

ALTER TABLE grupos
MODIFY COLUMN codigo_grupo CHAR(9) NOT NULL UNIQUE;

-- ============================================
-- OBSERVAÇÃO PÓS-ALTERAÇÃO:
-- O comando gerou um warning sobre índice duplicado (codigo_grupo_2),
-- mas isso não afeta o funcionamento. O UNIQUE está ativo e funcionando
-- corretamente. Este warning pode ser ignorado com segurança.
-- ============================================