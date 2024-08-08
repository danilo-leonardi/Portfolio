create database ControlBase
use ControlBase

create table Clientes(
             IdClientes int primary key not null,
			 Nome varchar(30) not null,
			 Endereço varchar(30) not null,
			 Telefone char(15) not null,
			 Email varchar(30)
)
create table Vendas(
             IdVendas Int primary key not null,
			 IdClientes int references Clientes(IdClientes),
			 DataVenda date not null,
			 TipoPagamento varchar(30),
			 NumNFV char(30)
)
create table Produtos(
             IdProdutos int primary key not null,
			 NomeProduto varchar(30) not null,
			 QtdeEstoque int not null,
			 PrecoVenda money not null
)
create table ItensVendidos(
             IdItensVendidos int primary key not null,
			 IdVendas int references Vendas(IdVendas),
			 IdProdutos int references Produtos(IdProdutos),
			 QtdeVendida int not null,
			 PrecoIni money not null
)
create table Fornecedor(
             IdFornecedor int primary key not null,
			 Nome varchar(30) not null,
			 Endereço varchar(30) not null,
			 Telefone char(15) not null,
			 Email varchar(30)
)
create table Compras(
             IdCompras int primary key not null,
			 IdFornecedor int references Fornecedor(IdFornecedor),
			 DataCompra date not null,
			 DataPagamento date not null,
			 DataVencimento date not null,
			 QtdeComprada int not null,
			 NumNFC char(30)
)
create table ItensComprados(
             IdItensComprados int primary key not null,
			 IdCompras int references Compras(IdCompras),
			 IdProdutos int references Produtos(IdProdutos),
			 QtdeCompradas int not null,
			 PrecoUniCompra money not null
)
