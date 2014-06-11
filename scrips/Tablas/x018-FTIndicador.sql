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
from minisif_ft..FTIndicador

go
 