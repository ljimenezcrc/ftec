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
from minisif_ft..FTCuentasIndicadores

go
 