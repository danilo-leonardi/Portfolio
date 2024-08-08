use ControlBase

INSERT INTO Vendas (IdVendas, IdClientes, DataVenda, TipoPagamento, NumNFV)
VALUES (1, 2, '2023-05-01', 'Credito', 'NFV-123456'),
	   (2, 4, '2023-05-02', 'Debito', 'NFV-654321'),
	   (3, 1, '2023-05-03', 'Credito', 'NFV-987654'),
	   (4, 3, '2023-05-04', 'Debito', 'NFV-321654'),
	   (5, 5, '2023-05-05', 'Credito', 'NFV-555888');

	select*from Vendas

create view vw_VendasClientes
as
select v.IdVendas, c.IdClientes, v.DataVenda, v.TipoPagamento, v.NumNFV
FROM vendas v
Right join clientes c on v.IdClientes = c.IdClientes;
select*from vw_VendasClientes

  