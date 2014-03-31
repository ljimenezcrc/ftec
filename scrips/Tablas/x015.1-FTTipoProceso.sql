SET IDENTITY_INSERT ftec..FTTipoProceso ON
go

insert into ftec..FTSolicitudProceso 
(TPid
,TPcodigo
,TPdescripcion
,Ecodigo
,TTid
,SPid)
select 
TPid
,TPcodigo
,TPdescripcion
,Ecodigo
,TTid
,SPid

from minisif..FTTipoProceso

go

select *
from FTTipoProceso

select * 
from ftec..FTTipoProceso

go

sp_help FTTipoProceso