-- ============================================
-- PROJETO: Sistema de Análise de Grupos de Consórcio
-- AUTOR: Júlio Paixão
-- DATA: Outubro 2025
-- ============================================

-- ============================================
-- DESCRIÇÃO DO MÓDULO
-- ============================================
-- Este arquivo contém a inserção de 48 registros de grupos de consórcio,
-- distribuídos entre três categorias de bens (Automóveis, Motocicletas e Imóveis)
-- e organizados por períodos de formação (2022, 2023, 2024-2025).
--
-- Os dados simulam cenários realistas do mercado de consórcios, incluindo:
-- - Grupos novos recém-formados
-- - Grupos em andamento com histórico
--
-- DISTRIBUIÇÃO DOS DADOS:
-- Total: 48 grupos
--   • Automóveis: 18 grupos (6 valores × 3 prazos: 40, 60, 80 meses)
--   • Motocicletas: 12 grupos (4 valores × 3 prazos: 20, 30, 40 meses)
--   • Imóveis: 18 grupos (6 valores × 3 prazos: 120, 180, 240 meses)
--
-- PERIODICIDADE:
--   • 2022 (Grupos Antigos): 13 registros (27%)
--   • 2023 (Grupos em Andamento): 16 registros (33%)
--   • 2024-2025 (Grupos Novos): 19 registros (40%)
-- ============================================

-- ============================================
-- REGRAS DE CÁLCULO APLICADAS
-- ============================================
-- 1. REAJUSTE ANUAL (15% ao ano, conforme índices de mercado):
--    - Grupos 2024-2025: Valor original (sem reajuste)
--    - Grupos 2023: Valor original × 1,15 (um reajuste de 15%)
--    - Grupos 2022: Valor original × 1,3225 (dois reajustes: 1,15²)
--
-- 2. VALORES BASE (antes dos reajustes):
--    Automóveis: R$ 50k, 70k, 90k, 110k, 130k, 160k
--    Motocicletas: R$ 15k, 20k, 25k, 35k
--    Imóveis: R$ 200k, 300k, 400k, 500k, 650k, 800k
--
-- 3. TAXAS DE ADMINISTRAÇÃO (baseadas em pesquisa de mercado out/2025):
--    - Automóveis: 9,5% a 12% (média de mercado: 10-11%)
--    - Motocicletas: 9% a 11,5% (média de mercado: 9-10%)
--    - Imóveis: 15% a 20% (média de mercado: 16-18%)
--
-- 4. FUNDO DE RESERVA:
--    - Automóveis e Motocicletas: 2%
--    - Imóveis: 3%
--
-- 5. VALOR DA PARCELA:
--    Calculado automaticamente pela coluna STORED
--    Fórmula: valor_credito / prazo_meses
--    Nota: Taxas serão aplicadas no Power BI
-- ============================================

-- ============================================
-- ESTRUTURA DOS CÓDIGOS
-- ============================================
-- Formato: [Tipo][Sequencial]-[Prazo]M
-- 
-- Onde:
--   [Tipo] = A (Automóvel), M (Motocicleta), I (Imóvel)
--   [Sequencial] = Número sequencial de 001 a 999
--   [Prazo] = Prazo em meses (20, 30, 40, 60, 80, 120, 180, 240)
--   M = Sufixo fixo indicando "meses"
--
-- Exemplos:
--   A001-40M  = Automóvel, grupo 001, prazo 40 meses
--   M010-30M  = Motocicleta, grupo 010, prazo 30 meses
--   I014-240M = Imóvel, grupo 014, prazo 240 meses
-- ============================================

-- ============================================
-- PREPARAÇÃO DO AMBIENTE
-- ============================================
-- Seleciona o banco de dados
USE db_grupos_consorcios;

-- Resetando AUTO_INCREMENT após correção do arquivo 01
-- Garante que a numeração dos IDs reinicie do 1
-- Necessário devido ao ajuste do tamanho da coluna codigo_grupo
TRUNCATE TABLE grupos; 

-- ============================================
-- SEÇÃO 1: INSERÇÃO DOS DADOS
-- ============================================
-- Os dados estão ordenados cronologicamente por data_formacao,
-- do mais antigo (2022) ao mais recente (2025), facilitando
-- análises temporais e identificação de tendências no Power BI.
-- ============================================

INSERT INTO grupos(codigo_grupo, tipo_bem, valor_credito, prazo_meses, taxa_admin, fundo_reserva, data_formacao, status_grupo, qtd_cotas)
VALUES
-- 2022 (MAIS ANTIGOS)
('A014-40M', 'Automóvel', 119025.00, 40, 11.00, 2.00, '2022-01-20', 'Ativo', 245),
('M010-40M', 'Motocicleta', 26450.00, 40, 10.50, 2.00, '2022-02-20', 'Ativo', 135),
('I014-240M', 'Imóvel', 396750.00, 240, 17.50, 3.00, '2022-03-10', 'Ativo', 370),
('A015-60M', 'Automóvel', 145475.00, 60, 11.50, 2.00, '2022-04-18', 'Ativo', 265),
('M011-20M', 'Motocicleta', 33062.50, 20, 11.00, 2.00, '2022-06-15', 'Ativo', 130),
('I015-120M', 'Imóvel', 529000.00, 120, 18.50, 3.00, '2022-06-22', 'Ativo', 330),
('A016-80M', 'Automóvel', 171925.00, 80, 12.00, 2.00, '2022-07-12', 'Ativo', 285),
('I018-120M', 'Imóvel', 1058000.00, 120, 18.00, 3.00, '2022-08-05', 'Ativo', 350),
('I016-180M', 'Imóvel', 661250.00, 180, 19.50, 3.00, '2022-09-15', 'Ativo', 385),
('A017-40M', 'Automóvel', 211600.00, 40, 10.50, 2.00, '2022-10-05', 'Ativo', 310),
('M012-30M', 'Motocicleta', 46287.50, 30, 11.50, 2.00, '2022-11-08', 'Ativo', 150),
('I017-240M', 'Imóvel', 859625.00, 240, 20.00, 3.00, '2022-11-28', 'Ativo', 395),
('A018-80M', 'Automóvel', 92575.00, 80, 10.00, 2.00, '2022-12-15', 'Ativo', 235),

-- 2023 (EM ANDAMENTO)
('I008-120M', 'Imóvel', 345000.00, 120, 16.00, 3.00, '2023-01-15', 'Ativo', 310),
('A008-40M', 'Automóvel', 80500.00, 40, 10.50, 2.00, '2023-02-14', 'Ativo', 210),
('I012-180M', 'Imóvel', 920000.00, 180, 20.00, 3.00, '2023-02-28', 'Ativo', 410),
('M006-20M', 'Motocicleta', 23000.00, 20, 10.00, 2.00, '2023-03-18', 'Ativo', 125),
('A012-60M', 'Automóvel', 184000.00, 60, 12.00, 2.00, '2023-03-25', 'Ativo', 290),
('I009-180M', 'Imóvel', 460000.00, 180, 17.00, 3.00, '2023-04-20', 'Ativo', 360),
('A009-60M', 'Automóvel', 103500.00, 60, 11.00, 2.00, '2023-05-20', 'Ativo', 240),
('M007-30M', 'Motocicleta', 28750.00, 30, 10.50, 2.00, '2023-06-25', 'Ativo', 145),
('I010-240M', 'Imóvel', 575000.00, 240, 18.00, 3.00, '2023-07-08', 'Ativo', 340),
('A013-80M', 'Automóvel', 57500.00, 80, 9.50, 2.00, '2023-07-15', 'Ativo', 195),
('A010-80M', 'Automóvel', 126500.00, 80, 11.50, 2.00, '2023-08-10', 'Ativo', 270),
('M008-40M', 'Motocicleta', 40250.00, 40, 11.00, 2.00, '2023-09-10', 'Ativo', 155),
('I011-120M', 'Imóvel', 747500.00, 120, 19.00, 3.00, '2023-10-12', 'Ativo', 390),
('A011-40M', 'Automóvel', 149500.00, 40, 10.00, 2.00, '2023-11-08', 'Ativo', 230),
('I013-240M', 'Imóvel', 230000.00, 240, 15.50, 3.00, '2023-12-05', 'Ativo', 270),
('M009-40M', 'Motocicleta', 17250.00, 40, 9.50, 2.00, '2023-12-05', 'Ativo', 105),

-- 2024 (NOVOS)
('I001-120M', 'Imóvel', 200000.00, 120, 15.00, 3.00, '2024-01-20', 'Ativo', 250),
('M001-20M', 'Motocicleta', 15000.00, 20, 9.00, 2.00, '2024-02-10', 'Ativo', 100),
('A001-40M', 'Automóvel', 50000.00, 40, 10.00, 2.00, '2024-03-15', 'Ativo', 180),
('I002-180M', 'Imóvel', 300000.00, 180, 16.00, 3.00, '2024-04-15', 'Ativo', 300),
('M002-30M', 'Motocicleta', 20000.00, 30, 10.00, 2.00, '2024-05-22', 'Ativo', 120),
('A002-60M', 'Automóvel', 70000.00, 60, 10.50, 2.00, '2024-06-10', 'Ativo', 220),
('I003-240M', 'Imóvel', 400000.00, 240, 17.00, 3.00, '2024-07-10', 'Ativo', 350),
('M003-40M', 'Motocicleta', 25000.00, 40, 10.50, 2.00, '2024-08-15', 'Ativo', 140),
('A003-80M', 'Automóvel', 90000.00, 80, 11.00, 2.00, '2024-09-20', 'Ativo', 250),
('I004-120M', 'Imóvel', 500000.00, 120, 18.00, 3.00, '2024-10-25', 'Ativo', 320),

-- 2025 (MAIS RECENTES)
('A004-40M', 'Automóvel', 110000.00, 40, 9.50, 2.00, '2025-01-12', 'Ativo', 200),
('M004-20M', 'Motocicleta', 35000.00, 20, 9.50, 2.00, '2025-02-08', 'Ativo', 110),
('I005-180M', 'Imóvel', 650000.00, 180, 19.00, 3.00, '2025-03-12', 'Ativo', 380),
('A005-60M', 'Automóvel', 130000.00, 60, 11.50, 2.00, '2025-04-18', 'Ativo', 280),
('I006-240M', 'Imóvel', 800000.00, 240, 20.00, 3.00, '2025-06-18', 'Ativo', 400),
('A006-80M', 'Automóvel', 160000.00, 80, 12.00, 2.00, '2025-07-25', 'Ativo', 300),
('M005-30M', 'Motocicleta', 15000.00, 30, 9.00, 2.00, '2025-09-12', 'Ativo', 95),
('I007-180M', 'Imóvel', 200000.00, 180, 15.00, 3.00, '2025-09-22', 'Ativo', 260),
('A007-60M', 'Automóvel', 50000.00, 60, 10.00, 2.00, '2025-10-05', 'Ativo', 190);

-- ============================================
-- SEÇÃO 2: VERIFICAÇÃO DOS DADOS INSERIDOS
-- ============================================
-- Consulta todos os registros inseridos para validação e verificação.
-- Esta consulta permite confirmar que:
--   • Todos os 48 registros foram inseridos com sucesso
--   • Os valores estão corretos e dentro dos limites esperados
--   • As parcelas foram calculadas automaticamente
--   • Os códigos são únicos e seguem o padrão estabelecido
--   • As datas estão ordenadas cronologicamente
--
-- VALIDAÇÕES RECOMENDADAS:
--   1. Total de registros = 48 linhas
--   2. Valores de parcela com 2 casas decimais
--   3. Códigos únicos sem duplicação
--   4. Status = 'Ativo' para todos os grupos
--   5. Taxas dentro dos ranges definidos
-- ============================================

SELECT * FROM grupos;