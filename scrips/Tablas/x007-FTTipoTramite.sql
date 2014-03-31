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
from minisif..FTTipoTramite

go

select *
from FTTipoTramite

select *
from ftec..FTTipoTramite

go

sp_help FTTipoTramite