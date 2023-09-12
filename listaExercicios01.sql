USE aula_db_exemplos;

SELECT titulo FROM livros;

SELECT nome
FROM autores
WHERE nascimento < '1900-01-01';

SELECT livros.titulo, autores.nome
FROM livros
INNER JOIN autores ON livros.autor_id = autores.id
WHERE nome = 'J.K. Rowling';

