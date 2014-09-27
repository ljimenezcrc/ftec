*==============================================================*/
/* Table: FTPContratacion                                       */
/*==============================================================*/
create table FTPContratacion (
   Id_del_proceso_e_contratacion numeric                        identity,
   Cid                  numeric                        not null,
   PCTidentificacion    char(1)                        default 'F' not null
         constraint CKC_PCTIDENTIFICACION_FTPCONTR check (PCTidentificacion in ('F','J')),
   PCIdentificacion     varchar(30)                    not null,
   PCNombre              varchar(100)                  null,
   PCApellido1           varchar(80)                   null,
   PCApellido2           varchar(80)                   null,
   PCSexo                varchar(1)                    default 'M' null
         constraint CKC_PCSEXO_FTPCONTR check (PCSexo is null or (PCSexo in ('M','F'))),
   PCFechaN             date                           null,
   PCEstado             char(1)                        default 'P' not null
         constraint CKC_PCESTADO_FTPCONTR check (PCEstado in ('P','T','A','R','F')),
   PCEnumero            numeric(18)                    null,
   PCEPeriodo           numeric(18)                    null,
   PCFechaC             datetime                       default getdate() not null,
   PCFechaA             datetime                       null,
   PCFechaF             datetime                       null,
   PCUsucodigoC         numeric                        null,
   PCUsucodigoA         numeric                        null,
   PCUsucodigoF         numeric                        null,
   PCEstadoCivil        char(1)                        default 'S' null
         constraint CKC_PCESTADOCIVIL_FTPCONTR check (PCEstadoCivil is null or (PCEstadoCivil in ('C','S','D','V'))),
   constraint PK_FTPCONTRATACION primary key (Id_del_proceso_e_contratacion)
)
go

alter table FTPContratacion
   add constraint FK_FTPCONTR_REFERENCE_FTCONTRA foreign key (Cid)
      references FTContratos (Cid)
go

