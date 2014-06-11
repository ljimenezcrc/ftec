SET IDENTITY_INSERT ftec..FTTipoTramite ON
go

insert into ftec..FTTipoTramite 
(TTid
,TTcodigo
,TTdescripcion
,Ecodigo)
select 
TTid
,TTcodigo
,TTdescripcion
,Ecodigo
from minisif_ft..FTTipoTramite

go

