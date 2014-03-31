SET IDENTITY_INSERT ftec..FTFormaPago ON
go

insert into ftec..FTFormaPago 
(FPid
,FPcodigo
,FPdescripcion
,Ecodigo)
select 
FPid
,FPcodigo
,FPdescripcion
,Ecodigo
from minisif..FTFormaPago

go

select *
from FTFormaPago

select * 
from ftec..FTFormaPago

go

sp_help FTFormaPago