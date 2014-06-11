SET IDENTITY_INSERT ftec..FTEstadoTramite ON
go

insert into ftec..FTEstadoTramite 
(ETid
,ETcodigo
,ETdescripcion
,Ecodigo)
select 
ETid
,ETcodigo
,ETdescripcion
,Ecodigo
from minisif_ft..FTEstadoTramite

go

