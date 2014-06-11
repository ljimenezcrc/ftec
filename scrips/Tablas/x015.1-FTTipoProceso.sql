SET IDENTITY_INSERT ftec..FTTipoProceso ON
go

insert into ftec..FTTipoProceso 
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

from minisif_ft..FTTipoProceso

go

 