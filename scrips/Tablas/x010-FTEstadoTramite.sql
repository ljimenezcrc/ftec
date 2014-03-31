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
from minisif..FTEstadoTramite

go

select *
from FTEstadoTramite

select * 
from ftec..FTEstadoTramite

go

sp_help FTEstadoTramite