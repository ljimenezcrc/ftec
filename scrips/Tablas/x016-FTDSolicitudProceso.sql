SET IDENTITY_INSERT ftec..FTDSolicitudProceso ON
go

insert into ftec..FTDSolicitudProceso 
(SPid
,Vid
,Cid
,Ecodigo
,Icodigo
,DSPid
,CFcuenta
,Ccuenta
,DSPdocumento
,DSPdescripcion
,DSPobjeto
,DSPmonto
,DScambiopaso
,DSPimpuesto)
select 
SPid
,Vid
,Cid
,Ecodigo
,Icodigo
,DSPid
,CFcuenta
,Ccuenta
,DSPdocumento
,DSPdescripcion
,DSPobjeto
,DSPmonto
,DScambiopaso
,DSPimpuesto

from minisif..FTDSolicitudProceso

go

select *
from FTDSolicitudProceso

select * 
from ftec..FTDSolicitudProceso

go

sp_help FTDSolicitudProceso