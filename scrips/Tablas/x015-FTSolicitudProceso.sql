SET IDENTITY_INSERT ftec..FTSolicitudProceso ON
go

insert into ftec..FTSolicitudProceso 
(SPid
,SPdocumento
,SPfechafactura
,SPfechavence
,SPfechaarribo
,TPid
,FPid
,LPid
,Mcodigo
,Bid
,SPfecha
,SPfechaReg
,Usucodigo
,SPestado
,SPacta
,Ecodigo
,SNcodigo
,Ret_Ecodigo
,Rcodigo
,SPctacliente
,SPfechaTrans
,SPobservacion)
select 
SPid
,SPdocumento
,SPfechafactura
,SPfechavence
,SPfechaarribo
,TPid
,FPid
,LPid
,Mcodigo
,Bid
,SPfecha
,SPfechaReg
,Usucodigo
,SPestado
,SPacta
,Ecodigo
,SNcodigo
,Ret_Ecodigo
,Rcodigo
,SPctacliente
,SPfechaTrans
,SPobservacion

from minisif_ft..FTSolicitudProceso

go
