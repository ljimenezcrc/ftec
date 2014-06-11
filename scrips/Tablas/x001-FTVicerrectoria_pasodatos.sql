SET IDENTITY_INSERT ftec..FTVicerrectoria ON
go

insert into ftec..FTVicerrectoria 
(Vid
,Vcodigo
,Vdescripcion
,Vpadre
,Vctaingreso
,Vctagasto
,Vctasaldoinicial
,Vesproyecto
,Ecodigo
,Vfinicio
,Vffinal
,Vestado
,Mcodigo
,Vmonto
,Usucodigo
,CFid)
select 
Vid
,Vcodigo
,Vdescripcion
,Vpadre
,Vctaingreso
,Vctagasto
,Vctasaldoinicial
,Vesproyecto
,Ecodigo
,Vfinicio
,Vffinal
,Vestado
,Mcodigo
,Vmonto
,Usucodigo
,CFid from minisif_ft..FTVicerrectoria

go
