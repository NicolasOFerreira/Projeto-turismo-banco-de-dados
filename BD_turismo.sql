
-- SISTEMA DE GESTÃO DE TURISMO
-- Banco de Dados Relacional - MySQL


CREATE DATABASE IF NOT EXISTS db_turismo;
USE db_turismo;


-- 1. CRIAÇÃO DAS TABELAS 



CREATE TABLE tb_usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    logradouro VARCHAR(120) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    tipo_usuario ENUM('TURISTA', 'GUIA') NOT NULL
) ENGINE=InnoDB;


CREATE TABLE tb_usuario_telefone (
    id_telefone INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    numero_telefone VARCHAR(20) NOT NULL,
    CONSTRAINT fk_telefone_usuario FOREIGN KEY (id_usuario) 
        REFERENCES tb_usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE tb_turista (
    id_usuario INT PRIMARY KEY,
    cpf CHAR(11) UNIQUE,
    passaporte VARCHAR(20),
    nacionalidade VARCHAR(40) DEFAULT 'Brasileira',
    CONSTRAINT fk_turista_usuario FOREIGN KEY (id_usuario) 
        REFERENCES tb_usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE tb_guia (
    id_usuario INT PRIMARY KEY,
    cadastur VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT fk_guia_usuario FOREIGN KEY (id_usuario) 
        REFERENCES tb_usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE tb_guia_idioma (
    id_guia_idioma INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario_guia INT NOT NULL,
    idioma VARCHAR(30) NOT NULL,
    CONSTRAINT fk_idioma_guia FOREIGN KEY (id_usuario_guia) 
        REFERENCES tb_guia(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE tb_hospedagem (
    id_hospedagem INT AUTO_INCREMENT PRIMARY KEY,
    nome_fantasia VARCHAR(100) NOT NULL,
    cnpj CHAR(14) NOT NULL UNIQUE,
    estrelas INT DEFAULT 3 CHECK (estrelas BETWEEN 1 AND 5)
) ENGINE=InnoDB;


CREATE TABLE tb_quarto (
    id_hospedagem INT NOT NULL,
    numero_quarto VARCHAR(10) NOT NULL,
    tipo_quarto VARCHAR(40) NOT NULL,
    capacidade INT NOT NULL CHECK (capacidade > 0),
    diaria_base DECIMAL(10,2) NOT NULL CHECK (diaria_base > 0),
    PRIMARY KEY (id_hospedagem, numero_quarto),
    CONSTRAINT fk_quarto_hospedagem FOREIGN KEY (id_hospedagem) 
        REFERENCES tb_hospedagem(id_hospedagem) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE tb_ponto_turistico (
    id_ponto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    cidade VARCHAR(60) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE tb_reserva_hospedagem (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_turista INT NOT NULL,
    id_hospedagem INT NOT NULL,
    numero_quarto VARCHAR(10) NOT NULL,
    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL CHECK (valor_total >= 0),
    status_reserva ENUM('PENDENTE', 'CONFIRMADA', 'CANCELADA', 'CONCLUIDA') DEFAULT 'PENDENTE',
    CONSTRAINT fk_reserva_turista FOREIGN KEY (id_turista) 
        REFERENCES tb_turista(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reserva_quarto FOREIGN KEY (id_hospedagem, numero_quarto) 
        REFERENCES tb_quarto(id_hospedagem, numero_quarto) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_datas CHECK (data_checkout > data_checkin)
) ENGINE=InnoDB;


CREATE TABLE tb_avaliacao_hospedagem (
    id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL UNIQUE,
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_avaliacao_reserva FOREIGN KEY (id_reserva) 
        REFERENCES tb_reserva_hospedagem(id_reserva) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE tb_passeio_guiado (
    id_passeio INT AUTO_INCREMENT PRIMARY KEY,
    id_turista INT NOT NULL,
    id_guia INT NOT NULL,
    id_ponto INT NOT NULL,
    data_hora DATETIME NOT NULL,
    valor_contratado DECIMAL(10,2) NOT NULL CHECK (valor_contratado >= 0),
    status_passeio ENUM('AGENDADO', 'REALIZADO', 'CANCELADO') DEFAULT 'AGENDADO',
    CONSTRAINT fk_passeio_turista FOREIGN KEY (id_turista) 
        REFERENCES tb_turista(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_passeio_guia FOREIGN KEY (id_guia) 
        REFERENCES tb_guia(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_passeio_ponto FOREIGN KEY (id_ponto) 
        REFERENCES tb_ponto_turistico(id_ponto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;



-- 2. INSERÇÃO DE DADOS (DML)



INSERT INTO tb_usuario (nome, email, logradouro, numero, cidade, uf, cep, tipo_usuario) VALUES
('Lucas Silva', 'lucas@gmail.com', 'Av. Paulista', '1000', 'São Paulo', 'SP', '01310100', 'TURISTA'),
('Beatriz Souza', 'beatriz@gmail.com', 'Rua das Flores', '250', 'Rio de Janeiro', 'RJ', '22000000', 'TURISTA'),
('Roberto Alves', 'roberto.guia@gmail.com', 'Rua Do Comercio', '45', 'Salvador', 'BA', '40000000', 'GUIA'),
('Camila Rocha', 'camila.guia@gmail.com', 'Av. Beira Mar', '120', 'Florianópolis', 'SC', '88000000', 'GUIA');


INSERT INTO tb_usuario_telefone (id_usuario, numero_telefone) VALUES
(1, '(11) 98888-1111'),
(2, '(21) 97777-2222'),
(3, '(71) 99999-3333'),
(4, '(48) 99111-4444');


INSERT INTO tb_turista (id_usuario, cpf, passaporte, nacionalidade) VALUES
(1, '12345678901', 'BR112233', 'Brasileira'),
(2, '98765432100', 'BR445566', 'Brasileira');


INSERT INTO tb_guia (id_usuario, cadastur) VALUES
(3, 'CAD-11.222333.44-0'),
(4, 'CAD-55.666777.88-9');


INSERT INTO tb_guia_idioma (id_usuario_guia, idioma) VALUES
(3, 'Português'),
(3, 'Inglês'),
(4, 'Português'),
(4, 'Espanhol');


INSERT INTO tb_hospedagem (nome_fantasia, cnpj, estrelas) VALUES
('Grand Hotel Bahiamar', '11222333000199', 4),
('Pousada Beira Mar', '44555666000188', 3);


INSERT INTO tb_quarto (id_hospedagem, numero_quarto, tipo_quarto, capacidade, diaria_base) VALUES
(1, '101', 'Standard Casal', 2, 280.00),
(1, '201', 'Suíte Luxo', 3, 450.00),
(2, '05', 'Chalé Vista Mar', 2, 320.00);


INSERT INTO tb_ponto_turistico (nome, descricao, cidade) VALUES
('Pelourinho', 'Centro histórico com arquitetura colonial e atrações culturais.', 'Salvador'),
('Centro Histórico de Florianópolis', 'Área histórica com mercados, praças e museus.', 'Florianópolis');


INSERT INTO tb_reserva_hospedagem (id_turista, id_hospedagem, numero_quarto, data_checkin, data_checkout, valor_total, status_reserva) VALUES
(1, 1, '201', '2026-11-10', '2026-11-14', 1800.00, 'CONCLUIDA'),
(2, 2, '05', '2026-12-01', '2026-12-05', 1280.00, 'CONFIRMADA');


INSERT INTO tb_avaliacao_hospedagem (id_reserva, nota, comentario) VALUES
(1, 5, 'Quarto excelente, café da manhã completo e ótimo atendimento.');


INSERT INTO tb_passeio_guiado (id_turista, id_guia, id_ponto, data_hora, valor_contratado, status_passeio) VALUES
(1, 3, 1, '2026-11-11 09:00:00', 150.00, 'REALIZADO'),
(2, 4, 2, '2026-12-02 14:00:00', 200.00, 'AGENDADO');



-- 3. CONSULTAS E ATUALIZAÇÕES (DML)



UPDATE tb_reserva_hospedagem 
SET status_reserva = 'CONCLUIDA' 
WHERE id_reserva = 2;


UPDATE tb_quarto 
SET diaria_base = diaria_base * 1.05 
WHERE tipo_quarto LIKE '%Luxo%';


SELECT 
    u.nome AS Turista,
    h.nome_fantasia AS Hotel,
    q.numero_quarto AS Quarto,
    r.data_checkin,
    r.data_checkout,
    r.valor_total,
    a.nota,
    a.comentario
FROM tb_reserva_hospedagem r
JOIN tb_turista t ON r.id_turista = t.id_usuario
JOIN tb_usuario u ON t.id_usuario = u.id_usuario
JOIN tb_quarto q ON r.id_hospedagem = q.id_hospedagem AND r.numero_quarto = q.numero_quarto
JOIN tb_hospedagem h ON q.id_hospedagem = h.id_hospedagem
LEFT JOIN tb_avaliacao_hospedagem a ON r.id_reserva = a.id_reserva;


SELECT 
    p.id_passeio,
    u_turista.nome AS Turista,
    u_guia.nome AS Guia,
    g.cadastur,
    pt.nome AS Ponto_Turistico,
    p.data_hora,
    p.valor_contratado,
    p.status_passeio
FROM tb_passeio_guiado p
JOIN tb_usuario u_turista ON p.id_turista = u_turista.id_usuario
JOIN tb_guia g ON p.id_guia = g.id_usuario
JOIN tb_usuario u_guia ON g.id_usuario = u_guia.id_usuario
JOIN tb_ponto_turistico pt ON p.id_ponto = pt.id_ponto;


SELECT 
    h.nome_fantasia,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(r.valor_total) AS faturamento
FROM tb_hospedagem h
LEFT JOIN tb_reserva_hospedagem r ON h.id_hospedagem = r.id_hospedagem
GROUP BY h.id_hospedagem, h.nome_fantasia;