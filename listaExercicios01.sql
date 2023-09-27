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

SELECT produto, SUM(receita) AS receita_total
FROM vendas
GROUP BY produto
HAVING receita_total > 10000;

SELECT autores.nome, COUNT(autor_id) AS livros
FROM autores
INNER JOIN livros ON autores.id = livros.autor_id
GROUP BY autores.nome
HAVING livros > 2;

SELECT autores.nome, livros.titulo
FROM autores
INNER JOIN livros ON autores.id = livros.autor_id;

SELECT autores.nome, matriculas.curso
FROM alunos
INNER JOIN matriculas ON alunos.id = matriculas.aluno_id;

SELECT autores.nome, livros.titulo
FROM autores
LEFT JOIN livros ON autores.id = livros.autor_id;

SELECT alunos.nome, matriculas.curso
FROM alunos
RIGHT JOIN matriculas ON alunos.id = matriculas.aluno_id;

SELECT alunos.nome, matriculas.curso
FROM alunos
INNER JOIN matriculas ON alunos.id = matriculas.aluno_id;

SELECT nome
FROM autores
WHERE id = (
	SELECT autor_id
    FROM livros
    GROUP BY autor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

SELECT produto, SUM(receita) AS vendas_totais
FROM vendas
GROUP BY produto
ORDER BY vendas_totais
LIMIT 1;

SELECT alunos.nome, COUNT(aluno_id) AS cursos
FROM alunos
INNER JOIN matriculas ON alunos.id = matriculas.aluno_id
GROUP BY alunos.nome;

SELECT produto, COUNT(*) AS venda_total
FROM vendas
GROUP BY produto
ORDER BY COUNT(*) DESC
LIMIT 1;

CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT Nome, Sobrenome FROM Autor;
END;

CREATE PROCEDURE sp_LivrosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo
    FROM Livro
    JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END;

CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoriaNome VARCHAR(100), OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total
    FROM Livro
    JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END;

CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoriaNome VARCHAR(100), OUT possuiLivros BOOLEAN)
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Livro
    JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
    
    IF total > 0 THEN
        SET possuiLivros = TRUE;
    ELSE
        SET possuiLivros = FALSE;
    END IF;
END;

CREATE PROCEDURE sp_LivrosAteAno(IN ano INT)
BEGIN
    SELECT Titulo
    FROM Livro
    WHERE Ano_Publicacao <= ano;
END;

CREATE PROCEDURE sp_TitulosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE titulo VARCHAR(255);
    DECLARE cur CURSOR FOR
        SELECT Livro.Titulo
        FROM Livro
        JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
        WHERE Categoria.Nome = categoriaNome;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO titulo;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT titulo;
    END LOOP;
    
    CLOSE cur;
END;

CREATE PROCEDURE sp_AdicionarLivro(IN tituloLivro VARCHAR(255), IN editoraID INT, IN anoPublicacao INT, IN numPaginas INT, IN categoriaID INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Erro: Não foi possível adicionar o livro.';
    END;
    
    START TRANSACTION;
    
    INSERT INTO Livro (Titulo, Editora_ID, Ano_Publicacao, Numero_Paginas, Categoria_ID)
    VALUES (tituloLivro, editoraID, anoPublicacao, numPaginas, categoriaID);
    
    COMMIT;
    SELECT 'Livro adicionado com sucesso.';
END;
