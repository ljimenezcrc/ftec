
/*==============================================================*/
/* Table: FTTipoProceso                                         */
/*==============================================================*/
create table FTTipoProceso (
   TPid                 numeric(18)                    identity,
   SPid                 numeric(18)                    null,
   TTid                 numeric(18)                    null,
   TPcodigo             varchar(10)                    null,
   TPdescripcion        varchar(50)                    null,
   Ecodigo              int                            null,
   constraint PK_FTTIPOPROCESO primary key (TPid)
)
go

alter table FTTipoProceso
   add constraint FK_FTTIPOPR_REFERENCE_FTSOLPAG foreign key (SPid)
      references FTSolPagos (SPid)
go

alter table FTTipoProceso
   add constraint FK_FTTIPOPR_REFERENCE_FTTIPOTR foreign key (TTid)
      references FTTipoTramite (TTid)
go

