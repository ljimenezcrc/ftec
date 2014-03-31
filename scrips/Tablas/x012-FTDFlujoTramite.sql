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
from minisif..FTDFlujoTramite

go

select *
from FTDFlujoTramite

select * 
from ftec..FTDFlujoTramite

go

sp_help FTDFlujoTramite