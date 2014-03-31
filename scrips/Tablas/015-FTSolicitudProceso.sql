/*==============================================================*/
/* Table: FTSolicitudProceso                                    */
/*==============================================================*/
create table FTSolicitudProceso (
   SPid                 numeric(18)                    identity,
   SPdocumento          varchar(25)                    not null,
   SPfechafactura       datetime                       not null,
   SPfechavence         datetime                       not null,
   SPfechaarribo        datetime                       not null,
   TPid                 numeric(18)                    not null,
   FPid                 numeric(18)                    null,
   LPid                 numeric(18)                    null,
   Mcodigo              numeric(8)                     null,
   Bid                  numeric                        null,
   SPfecha              datetime                       null,
   SPfechaReg           datetime                       null,
   Usucodigo            numeric(18)                    null,
   SPestado             int                            not null,
   SPacta               varchar(25)                    null,
   Ecodigo              int                            null,
   SNcodigo             int                            null,
   Ret_Ecodigo          int                            null,
   Rcodigo              char(2)                        null,
   SPctacliente         varchar(20)                    null,
   SPfechaTrans         datetime                       null,
   SPobservacion        varchar(2000)                  null,
   constraint PK_FTSOLICITUDPROCESO primary key (SPid)
)
go

alter table FTSolicitudProceso
   add constraint FK_FTSOLICI_REFERENCE_FTTIPOPR foreign key (TPid)
      references FTTipoProceso (TPid)
go

alter table FTSolicitudProceso
   add constraint FK_FTSOLICI_REFERENCE_FTFORMAP foreign key (FPid)
      references FTFormaPago (FPid)
go

alter table FTSolicitudProceso
   add constraint FK_FTSOLICI_REFERENCE_FTLUGARP foreign key (LPid)
      references FTLugarPago (LPid)
go
/*
alter table FTSolicitudProceso
   add constraint FK_FTSOLICI_REFERENCE_MONEDAS foreign key (Mcodigo)
      references Monedas
go

alter table FTSolicitudProceso
   add constraint FK_FTSOLICI_REFERENCE_BANCOS foreign key (Bid)
      references Bancos
go

alter table FTSolicitudProceso
   add constraint FK_FTSOLICI_REFERENCE_SNEGOCIO foreign key (Ecodigo, SNcodigo)
      references SNegocios 
go

alter table FTSolicitudProceso
   add constraint FK_FTSOLICI_REFERENCE_RETENCIO foreign key (Ret_Ecodigo, Rcodigo)
      references Retenciones
go
*/