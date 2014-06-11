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
from minisif_ft..FTLugarPago

go

 