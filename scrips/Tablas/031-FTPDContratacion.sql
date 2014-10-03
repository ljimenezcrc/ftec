/*==============================================================*/
/* Table: FTPDContratacion                                      */
/*==============================================================*/
create table FTPDContratacion (
   PCid                 numeric                        not null,
   PCDid                numeric                        identity,
   SDid                 numeric                        not null,
   DVLcodigo            char(10)                       null,
   DVid                 numeric                        null,
   PCDValor             varchar(1024)                  null,
   constraint FTPDContratacion_PK primary key (PCDid),
   constraint FTPDContratacion_UK unique (PCid, SDid)
)
go

alter table FTPDContratacion
   add constraint FK_FTPDCONT_REFERENCE_FTPCONTR foreign key (PCid)
      references FTPContratacion (PCid)
go

alter table FTPDContratacion
   add constraint FK_FTPDCONT_REFERENCE_FTSECCIO foreign key (SDid)
      references FTSeccionesD (SDid)
go

alter table FTPDContratacion
   add constraint FK_FTPDCONT_REFERENCE_FTDATOSV foreign key (DVid)
      references FTDatosVariables (DVid)
go

alter table FTPDContratacion
   add constraint FK_FTPDCONT_REFERENCE_FTLISTAV foreign key (DVid, DVLcodigo)
      references FTListaValores (DVid, DVLcodigo)
go
