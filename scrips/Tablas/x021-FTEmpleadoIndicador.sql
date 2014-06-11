SET IDENTITY_INSERT ftec..FTEmpleadoIndicador ON
go

insert into ftec..FTEmpleadoIndicador 
(EIid
,DEid
,CFid
,EImes
,EIperiodo
,EInoaplica)
select 
EIid
,DEid
,CFid
,EImes
,EIperiodo
,EInoaplica
from minisif_ft..FTEmpleadoIndicador

go
 