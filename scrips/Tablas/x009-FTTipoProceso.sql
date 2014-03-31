SET IDENTITY_INSERT ftec..FTTipoProceso ON
go

insert into ftec..FTTipoProceso 
(TPid
,TPcodigo
,TPdescripcion
,Ecodigo
,TTid)
select 
TPid
,TPcodigo
,TPdescripcion
,Ecodigo
,TTid
from minisif..FTTipoProceso

go

select *
from FTTipoProceso

select * 
from ftec..FTTipoProceso

go

sp_help FTTipoProceso