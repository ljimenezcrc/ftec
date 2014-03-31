SET IDENTITY_INSERT ftec..FTCuentasIndicadores ON
go

insert into ftec..FTCuentasIndicadores 
(CIid
,Iid
,Cuenta
,NivelDet
,NivelTot
,MesInicio
,MesFinal)
select 
CIid
,Iid
,Cuenta
,NivelDet
,NivelTot
,MesInicio
,MesFinal
from minisif..FTCuentasIndicadores

go

select *
from FTCuentasIndicadores

select * 
from ftec..FTCuentasIndicadores

go

sp_help FTCuentasIndicadores