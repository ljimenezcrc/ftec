SET IDENTITY_INSERT ftec..FTCostoAdmin ON
go

insert into ftec..FTCostoAdmin 
(CAid
,CAcodigo
,CAdescripcion
,CAporcentaje
,Ecodigo
,CAobligatorio
,Usucodigo)
select 
CAid
,CAcodigo
,CAdescripcion
,CAporcentaje
,Ecodigo
,CAobligatorio
,Usucodigo
from minisif_ft..FTCostoAdmin

go

