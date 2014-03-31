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
from minisif..FTFlujoTramite

go

select *
from FTFlujoTramite

select * 
from ftec..FTFlujoTramite

go

sp_help FTFlujoTramite