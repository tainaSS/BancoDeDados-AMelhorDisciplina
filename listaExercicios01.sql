USE aula_db_exemplos;

SELECT titulo FROM livros;

SELECT nome
FROM autores
WHERE nascimento < '1900-01-01';

SELECT livros.titulo, autores.nome
FROM livros
INNER JOIN autores ON livros.autor_id = autores.id
WHERE nome = 'J.K. Rowling';

SELECT alunos.nome, matriculas.curso
FROM alunos
INNER JOIN matriculas ON alunos.id = matriculas.aluno_id
WHERE curso = 'Engenharia de Software';

SELECT produto, SUM(receita) AS receita_total
FROM vendas
GROUP BY produto;

SELECT autores.nome, COUNT(autor_id) AS livros_n
FROM autores
INNER JOIN livros ON autores.id = livros.autor_id
GROUP BY autores.nome;

SELECT matriculas.curso, COUNT(alunos.id) AS alunos_matriculados
FROM matriculas
INNER JOIN alunos ON matriculas.aluno_id = alunos.id
GROUP BY matriculas.curso;

SELECT produto, AVG(receita) AS receita_media
FROM vendas
GROUP BY produto;

