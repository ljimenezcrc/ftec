SET IDENTITY_INSERT ftec..FTFlujoTramite ON
go

insert into ftec..FTFlujoTramite 
(FTid
,ETid
,TTid
,FTpasoactual
,FTpasoaprueba
,FTpasorechaza
,FTautoriza)
select 
FTid
,ETid
,TTid
,FTpasoactual
,FTpasoaprueba
,FTpasorechaza
,FTautoriza
from minisif_ft..FTFlujoTramite

go
