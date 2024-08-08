use ControlBase

INSERT INTO Clientes (IdClientes, Nome, Endereço, Telefone, Email)
VALUES (1, 'João Silva', 'Rua A, 123', '(11)123456789', 'joao.silva@example.com');
INSERT INTO Clientes (IdClientes, Nome, Endereço, Telefone, Email)
VALUES (2, 'Maria Souza', 'Avenida B, 456', '(11)987654321', 'maria.souza@example.com');
INSERT INTO Clientes (IdClientes, Nome, Endereço, Telefone, Email)
VALUES (3, 'Pedro Santos', 'Rua C, 789', '(11)555555555', 'pedro.santos@example.com');
INSERT INTO Clientes (IdClientes, Nome, Endereço, Telefone, Email)
VALUES (4, 'Ana Oliveira', 'Avenida D, 987', '(11)444444444', 'ana.oliveira@example.com');
INSERT INTO Clientes (IdClientes, Nome, Endereço, Telefone, Email)
VALUES (5, 'Lucas Pereira', 'Rua E, 654', '(11)333333333', 'lucas.pereira@example.com');

select*from Clientes

create View vw_Clientes
as
 select IdClientes, Nome, Endereço, Telefone, Email
FROM Clientes;
select*from vw_Clientes

update Clientes
set Nome = 'Larissa Juliana',
    Endereço = 'Rua D',
   	 Email = 'larissa.juliana@gmail.com'
where IdClientes = 3 

create index IDX_IdCliente
on Clientes (IdClientes)

-- Criar índice no campo "Nome" da tabela "Clientes"
CREATE INDEX idx_Nome_Clientes ON Clientes (Nome);

-- Exibir os resultados da tabela "Clientes"
SELECT * FROM Clientes;