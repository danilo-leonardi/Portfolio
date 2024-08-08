use ControlBase

INSERT INTO Fornecedor (IdFornecedor, Nome, Endereço, Telefone, Email)
VALUES (1, 'Fornecedor A', 'Rua X, 123', '(11)123456789', 'fornecedorA@example.com'),
	   (2, 'Fornecedor B', 'Avenida Y, 456', '(11)987654321', 'fornecedorB@example.com'),
	   (3, 'Fornecedor C', 'Rua Z, 789', '(11)555555555', 'fornecedorC@example.com'),
	   (4, 'Fornecedor D', 'Avenida W, 987', '(11)444444444', 'fornecedorD@example.com'),
	   (5, 'Fornecedor E', 'Rua V, 654', '(11)333333333', 'fornecedorE@example.com');

	select*from Fornecedor

create view vw_Fornecedor
as
select IdFornecedor, Nome, Endereço, Telefone, Email
from Fornecedor;
select*from vw_Fornecedor

update Fornecedor
set Nome = 'Carlos Alberto', 
    Endereço = 'Rua V, 857',
    Telefone = '(35)965587423',
    Email = 'carlao.fornece@gmail.com'
where IdFornecedor = 4  