SET IDENTITY_INSERT ftec..FTCostoProyecto ON
go

insert into ftec..FTCostoProyecto 
(CPid
,Vid
,CAid
,CPporcentaje
,CPexoneracion
,CPfdesde
,CPfhasta
,CPdistribuido
,CPvalorcatalogo
,Usucodigo)
select 
CPid
,Vid
,CAid
,CPporcentaje
,CPexoneracion
,CPfdesde
,CPfhasta
,CPdistribuido
,CPvalorcatalogo
,Usucodigo
from minisif..FTCostoProyecto

go

select *
from FTCostoProyecto

select *
from ftec..FTCostoProyecto

go

sp_help FTCostoProyecto