
/*==============================================================*/
/* Table: FTFlujoTramite                                        */
/*==============================================================*/
create table FTFlujoTramite (
   FTid                 numeric(18)                    identity,
   ETid                 numeric(18)                    null,
   TTid                 numeric(18)                    null,
   FTpasoactual         int                            null,
   FTpasoaprueba        int                            null,
   FTpasorechaza        int                            null,
   FTautoriza           int                            null,
   constraint PK_FTFLUJOTRAMITE primary key (FTid)
)
go

alter table FTFlujoTramite
   add constraint FK_FTFLUJOT_REFERENCE_FTESTADO foreign key (ETid)
      references FTEstadoTramite (ETid)
go

alter table FTFlujoTramite
   add constraint FK_FTFLUJOT_REFERENCE_FTTIPOTR foreign key (TTid)
      references FTTipoTramite (TTid)
go