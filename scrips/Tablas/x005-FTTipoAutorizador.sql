SET IDENTITY_INSERT ftec..FTTipoAutorizador ON
go

insert into ftec..FTTipoAutorizador 
(TAid
,TAcodigo
,TAdescripcion
,TAmontomin
,TAmontomax
,Ecodigo
,Usucodigo)
select 
TAid
,TAcodigo
,TAdescripcion
,TAmontomin
,TAmontomax
,Ecodigo
,Usucodigo
from minisif..FTTipoAutorizador

go

select *
from FTTipoAutorizador

select *
from ftec..FTTipoAutorizador

go

sp_help FTTipoAutorizador