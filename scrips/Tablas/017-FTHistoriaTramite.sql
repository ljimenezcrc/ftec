
/*==============================================================*/
/* Table: FTHistoriaTramite                                     */
/*==============================================================*/
create table FTHistoriaTramite (
   HTid                 numeric(18)                    identity,
   Usucodigo            numeric(18)                    null,
   HTfecha              datetime                       null,
   ETid                 numeric(18)                    null,
   TPid                 numeric(18)                    null,
   SPid                 numeric(18)                    null,
   DSPid                numeric(18)                    null,
   HTpasosigue          int                            null,
   HTcompleto           int                            null,
   constraint PK_FTHISTORIATRAMITE primary key (HTid)
)
go

alter table FTHistoriaTramite
   add constraint FK_FTHISTOR_REFERENCE_FTESTADO foreign key (ETid)
      references FTEstadoTramite (ETid)
go

alter table FTHistoriaTramite
   add constraint FK_FTHISTOR_REFERENCE_FTTIPOPR foreign key (TPid)
      references FTTipoProceso (TPid)
go

alter table FTHistoriaTramite
   add constraint FK_FTHISTOR_REFERENCE_FTSOLICI foreign key (SPid)
      references FTSolicitudProceso (SPid)
go

alter table FTHistoriaTramite
   add constraint FK_FTHISTOR_REFERENCE_FTDSOLIC foreign key (DSPid)
      references FTDSolicitudProceso (DSPid)
go