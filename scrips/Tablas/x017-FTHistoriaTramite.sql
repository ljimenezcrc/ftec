SET IDENTITY_INSERT ftec..FTHistoriaTramite ON
go

insert into ftec..FTHistoriaTramite 
(HTid
,Usucodigo
,HTfecha
,ETid
,TPid
,SPid
,DSPid
,HTpasosigue
,HTcompleto)
select 
HTid
,Usucodigo
,HTfecha
,ETid
,TPid
,SPid
,DSPid
,HTpasosigue
,HTcompleto
from minisif_ft..FTHistoriaTramite

go
 