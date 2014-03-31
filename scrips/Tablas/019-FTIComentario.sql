/*==============================================================*/
/* Table: FTIComentario                                         */
/*==============================================================*/
create table FTIComentario (
   ICid                 numeric                        identity,
   Iid                  numeric                        null,
   ICfecha              datetime                       null,
   ICcodigo             varchar(10)                    null,
   ICcomentario         varchar(2040)                  null,
   ICperiodo            varchar(20)                    null,
   constraint PK_FTICOMENTARIO primary key (ICid)
)
go

alter table FTIComentario
   add constraint FK_FTICOMEN_REFERENCE_FTINDICA foreign key (Iid)
      references FTIndicador (Iid)
go
