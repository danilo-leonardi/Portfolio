use ControlBase

INSERT INTO ItensComprados (IdItensComprados, IdCompras, IdProdutos, QtdeCompradas, PrecoUniCompra)
VALUES (1, 1, 1, 2, 10.99),
       (2, 1, 2, 1, 5.50),
       (3, 2, 3, 3, 8.75),
       (4, 2, 4, 2, 12.50),
       (5, 3, 5, 5, 20.00);

	select*from ItensComprados

create View vw_ItensComprados
as
select IC.IdItensComprados, cr.IdCompras, p.IdProdutos, IC.QtdeCompradas, IC.PrecoUniCompra
from ItensComprados IC
right join Compras cr on IC.Idcompras = cr.Idcompras
right join produtos p on IC.Idprodutos = p.Idprodutos;
select*from vw_ItensComprados


