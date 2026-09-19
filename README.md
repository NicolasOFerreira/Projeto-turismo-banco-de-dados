# Projeto-turismo-banco-de-dados
Repositório dedicado ao projeto bimestral da matéria laboratório de banco de dados.

# Sistema de Gestão de Turismo - Banco de Dados

Projeto de modelagem e implementação de um banco de dados relacional para gerenciar uma rede de turismo, contemplando usuários, guias, pontos turísticos, hospedagens e reservas.

## Tecnologias
* MySQL Server 8.0
* Visual Studio Code (extensão Database Client)
* SQL (DDL e DML)

## Estrutura do Banco (db_turismo)

O banco é composto por 11 tabelas:
* tb_usuario e tb_usuario_telefone: Cadastro de usuários e contatos
* tb_turista e tb_guia: Especializações de perfil
* tb_guia_idioma: Idiomas falados pelos guias
* tb_ponto_turistico e tb_passeio_guiado: Atrações e roteiros
* tb_hospedagem e tb_quarto: Estabelecimentos e acomodações
* tb_reserva_hospedagem e tb_avaliacao_hospedagem: Reservas e avaliações

## Arquivos do Repositório
* BD_turismo.sql: Script completo com DDL, DML e consultas SELECT.
* Documentacao_Turismo.pdf: Documento com DER, mapeamento lógico e contextualização.

## Como Executar

1. Certifique-se de ter o MySQL 8.0 em execução na porta 3306.
2. Abra a pasta do projeto no VS Code.
3. Conecte a extensão Database Client ao MySQL local (localhost / usuário root).
4. Abra o arquivo BD_turismo.sql e execute o script para criar e povoar o banco.