
/*==============================================================*/
/* Table: FTAutorizador                                         */
/*==============================================================*/
create table FTAutorizador (
   Aid                  numeric(18)                    identity,
   TAid                 numeric(18)                    not null,
   Vid                  numeric(18)                    not null,
   Usucodigo            numeric(18)                    not null,
   Afdesde              datetime                       not null,
   Afhasta              datetime                       not null,
   Ecodigo              int                            null,
   Ainactivo            int                            null,
   TAresponsable        int                            null,
   constraint PK_FTAUTORIZADOR primary key nonclustered (Aid),
   constraint AK_KEY_1_FTAUTORI unique clustered (TAid, Vid, Usucodigo)
)
go

alter table FTAutorizador
   add constraint FK_FTAUTORI_REFERENCE_FTVICERR foreign key (Vid)
      references FTVicerrectoria (Vid)
go

alter table FTAutorizador
   add constraint FK_FTAUTORI_REFERENCE_FTTIPOAU foreign key (TAid)
      references FTTipoAutorizador (TAid)
go