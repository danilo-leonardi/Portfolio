use ControlBase

INSERT INTO Compras (IdCompras,IdFornecedor, DataCompra,DataPagamento,DataVencimento,QtdeComprada,NumNFC)
VALUES(2, 2, '2023-05-16', '2023-05-16', '2023-06-16', 40, 'NFC-5598743'),
      (3, 3, '2023-07-25', '2023-07-25', '2023-08-25', 60, 'NFC-5545589'),
	  (4, 4, '2023-04-02', '2023-04-02', '2023-05-02', 45, 'NFC-5554923'),
	  (5, 5, '2023-11-30', '2023-11-30', '2023-12-30', 15, 'NFC-5145896'),
      (1, 1, '2023-09-22', '2023-09-22', '2023-10-22', 22, 'NFC-5897546');
	select*from Compras

create View vw_Compras 
as
select cr.IdCompras,f.IdFornecedor, cr.DataCompra,cr.DataPagamento,cr.DataVencimento,cr.NumNFC
from Compras cr
right join fornecedor f on cr.Idfornecedor = f.Idfornecedor;
select*from vw_Compras
