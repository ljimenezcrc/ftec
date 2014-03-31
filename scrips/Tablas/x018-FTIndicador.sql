SET IDENTITY_INSERT ftec..FTIndicador ON
go

insert into ftec..FTIndicador 
(Iid
,Ecodigo
,Icodigo
,Idescripcion
,Ifecha
,Iformacalculo
,Iperiodicidad
,Ifuente
,Iresponsable
,Iformapresenta
,Iusos
,Inivelagrega
,Irotroproceso
,Ivalormeta
,Irangoacepta
,Iobservacion)
select 
Iid
,Ecodigo
,Icodigo
,Idescripcion
,Ifecha
,Iformacalculo
,Iperiodicidad
,Ifuente
,Iresponsable
,Iformapresenta
,Iusos
,Inivelagrega
,Irotroproceso
,Ivalormeta
,Irangoacepta
,Iobservacion
from minisif..FTIndicador

go

select *
from FTIndicador

select * 
from ftec..FTIndicador

go

sp_help FTIndicador