<<<<<<< HEAD

=======
>>>>>>> f4e2a3d943add023366541ed9028e29485f0ecf3
/*==============================================================*/
/* Table: FTPDContratacion                                      */
/*==============================================================*/
create table FTPDContratacion (
<<<<<<< HEAD
   PCid                 numeric                        null,
   PCDid                numeric                        identity,
   SDid                 numeric                        null,
   DVLcodigo            char(10)                       null,
   DVid                 numeric                        null,
   PCDValor             varchar(1024)                  null,
   constraint PK_FTPDCONTRATACION primary key (PCDid)
=======
   PCid                 numeric                        not null,
   PCDid                numeric                        identity,
   SDid                 numeric                        not null,
   DVLcodigo            char(10)                       null,
   DVid                 numeric                        null,
   PCDValor             varchar(1024)                  null,
   constraint FTPDContratacion_PK primary key (PCDid),
   constraint FTPDContratacion_UK unique (PCid, SDid)
>>>>>>> f4e2a3d943add023366541ed9028e29485f0ecf3
)
go

alter table FTPDContratacion
   add constraint FK_FTPDCONT_REFERENCE_FTPCONTR foreign key (PCid)
<<<<<<< HEAD
      references FTPContratacion (PCid)
=======
      references FTPContratacion (Id_del_proceso_e_contratacion)
>>>>>>> f4e2a3d943add023366541ed9028e29485f0ecf3
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
<<<<<<< HEAD
go
=======
go
>>>>>>> f4e2a3d943add023366541ed9028e29485f0ecf3
