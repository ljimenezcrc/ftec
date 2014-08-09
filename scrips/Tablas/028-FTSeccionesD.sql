create table FTSeccionesD (
   SDid                 numeric                        identity,
   Sid                  numeric                        not null,
   TVariables           numeric                        default 1 not null
         constraint CKC_TVARIABLES_FTSECCIO check (TVariables in (1)),
   Variable             varchar(100)                   not null,
   DVid                 numeric                        null,
   SDReport             bit                            default 1 not null
         constraint CKC_SDREPORT_FTSECCIO check (SDReport in (0,1)),
   Ecodigo              numeric(18)                    null,
   Usucodigo            numeric(18)                    null,
   constraint FTSeccionesD_PK primary key (SDid)
)
go

alter table FTSeccionesD
   add constraint FTSeccionesD_FK01 foreign key (Sid)
      references FTSecciones (Sid)
go

alter table FTSeccionesD
   add constraint FTSeccionesD_FK02 foreign key (DVid)
      references FTDatosVariables (DVid)
go