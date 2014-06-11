SET IDENTITY_INSERT ftec..FTAutorizador ON
go

insert into ftec..FTAutorizador 
(Aid
,TAid
,Vid
,Usucodigo
,Afdesde
,Afhasta
,Ecodigo
,Ainactivo
,TAresponsable)
select 
Aid
,TAid
,Vid
,Usucodigo
,Afdesde
,Afhasta
,Ecodigo
,Ainactivo
,TAresponsable
from minisif_ft..FTAutorizador

go
