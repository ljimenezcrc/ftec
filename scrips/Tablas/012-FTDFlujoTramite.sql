/*==============================================================*/
/* Table: FTDFlujoTramite                                       */
/*==============================================================*/
create table FTDFlujoTramite (
   FTDid                numeric(18)                    identity,
   FTid                 numeric(18)                    null,
   TAid                 numeric(18)                    null,
   constraint PK_FTDFLUJOTRAMITE primary key (FTDid)
)
go

alter table FTDFlujoTramite
   add constraint FK_FTDFLUJO_REFERENCE_FTFLUJOT foreign key (FTid)
      references FTFlujoTramite (FTid)
go

alter table FTDFlujoTramite
   add constraint FK_FTDFLUJO_REFERENCE_FTTIPOAU foreign key (TAid)
      references FTTipoAutorizador (TAid)
go