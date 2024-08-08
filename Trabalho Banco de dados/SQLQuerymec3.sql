use ControlBase

INSERT INTO ItensVendidos (IdItensVendidos, IdVendas, IdProdutos, QtdeVendida, PrecoIni)
VALUES (1, 1, 3, '2', 49.99),
	   (2, 2, 1, '1', 29.99),
	   (3, 2, 4, '3', 39.99),
	   (4, 3, 5, '2', 59.99),
	   (5, 4, 2, '1', 79.99);

	select*from ItensVendidos

	create View vw_ItensVendidos 
as 
select IV.IdItensVendidos, IV.IdVendas, IV.IdProdutos, IV.QtdeVendida, IV.PrecoIni
from ItensVendidos IV
right join vendas v on IV.Idvendas = v.Idvendas
right join produtos p on IV.Idprodutos= p.Idprodutos;
select*from vw_ItensVendidos

update ItensVendidos
 set QtdeVendida = '10'
 where IdItensVendidos = 5
