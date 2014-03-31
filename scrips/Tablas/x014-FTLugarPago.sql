SET IDENTITY_INSERT ftec..FTLugarPago ON
go

insert into ftec..FTLugarPago 
(LPid
,LPcodigo
,LPdescripcion
,Ecodigo)
select 
LPid
,LPcodigo
,LPdescripcion
,Ecodigo
from minisif..FTLugarPago

go

select *
from FTLugarPago

select * 
from ftec..FTLugarPago

go

sp_help FTLugarPago