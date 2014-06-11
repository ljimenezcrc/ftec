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
from minisif_ft..FTTipoAutorizador

go
