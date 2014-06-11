
/*==============================================================*/
/* Table: FTDSolicitudProceso                                   */
/*==============================================================*/
create table FTDSolicitudProceso (
   SPid                 numeric(18)                    null,
   Vid                  numeric(18)                    null,
   Cid                  numeric                        null,
   Ecodigo              int                            null,
   Icodigo              char(5)                        null,
   DSPid                numeric(18)                    identity,
   CFcuenta             numeric                        null,
   Ccuenta              numeric                        null,
   DSPdocumento         varchar(25)                    null,
   DSPdescripcion       varchar(255)                   null,
   DSPobjeto            varchar(60)                    null,
   DSPmonto             money                          null,
   DScambiopaso         int                            null,
   DSPimpuesto          money                          null,
   DSPmontototal        money                          null,
   constraint PK_FTDSOLICITUDPROCESO primary key (DSPid)
)

go

alter table FTDSolicitudProceso
   add constraint FK_FTDSOLIC_REFERENCE_FTSOLICI foreign key (SPid)
      references FTSolicitudProceso (SPid)
go

alter table FTDSolicitudProceso
   add constraint FK_FTDSOLIC_REFERENCE_FTVICERR foreign key (Vid)
      references FTVicerrectoria (Vid)
go

/*
alter table FTDSolicitudProceso
   add constraint FK_FTDSOLIC_REFERENCE_CONCEPTO foreign key (Cid)
      references Conceptos
go

alter table FTDSolicitudProceso
   add constraint FK_FTDSOLIC_REFERENCE_IMPUESTO foreign key (Ecodigo, Icodigo)
      references Impuestos (, )
go

alter table FTDSolicitudProceso
   add constraint FK_FTDSOLIC_REFERENCE_CFINANCI foreign key (CFcuenta)
      references CFinanciera
go

alter table FTDSolicitudProceso
   add constraint FK_FTDSOLIC_REFERENCE_CCONTABL foreign key (Ccuenta)
      references CContables
go*/