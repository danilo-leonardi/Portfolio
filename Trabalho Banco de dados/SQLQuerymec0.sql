use ControlBase

INSERT INTO ItensComprados (IdItensComprados, IdCompras, IdProdutos, QtdeCompradas, PrecoUniCompra)
VALUES (1, 1, 1, 2, 10.99),
       (2, 1, 2, 1, 5.50),
       (3, 2, 3, 3, 8.75),
       (4, 2, 4, 2, 12.50),
       (5, 3, 5, 5, 20.00);

	select*from ItensComprados

create trigger TR_AtualizaEstoqueDeCompra
on ItensComprados
for insert
as
begin
	update Produtos
	set QtdeEstoque = QtdeEstoque + 
	(select QtdeCompradas
	from inserted
	)
	where idProdutos = (select idProdutos from inserted)
end