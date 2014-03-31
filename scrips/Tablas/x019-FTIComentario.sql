SET IDENTITY_INSERT ftec..FTIComentario ON
go

insert into ftec..FTIComentario 
(ICid
,Iid
,ICfecha
,ICcodigo
,ICcomentario
,ICperiodo)
select 
ICid
,Iid
,ICfecha
,ICcodigo
,ICcomentario
,ICperiodo
from minisif..FTIComentario

go

select *
from FTIComentario

select * 
from ftec..FTIComentario

go

sp_help FTIComentario