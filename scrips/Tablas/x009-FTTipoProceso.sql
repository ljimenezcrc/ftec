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
from minisif_ft..FTTipoProceso

go
