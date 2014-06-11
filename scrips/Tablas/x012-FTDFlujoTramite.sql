SET IDENTITY_INSERT ftec..FTDFlujoTramite ON
go

insert into ftec..FTDFlujoTramite 
(FTDid
,FTid
,TAid)
select 
FTDid
,FTid
,TAid
from minisif_ft..FTDFlujoTramite

go
 