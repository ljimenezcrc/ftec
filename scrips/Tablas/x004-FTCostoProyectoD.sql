SET IDENTITY_INSERT ftec..FTCostoProyectoD ON
go

insert into ftec..FTCostoProyectoD 
(CPDid
,CPid
,Vid
,CPDporcentaje)
select 
CPDid
,CPid
,Vid
,CPDporcentaje
from minisif_ft..FTCostoProyectoD

go

