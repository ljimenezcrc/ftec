create table FTContratos (
   Cid                  numeric                        identity,
   TCid                 numeric                        null,
   Cdescripcion         varchar(256)                   null,
   Cestado              char(1)                        null
         constraint CKC_CESTADO_FTCONTRA check (Cestado is null or (Cestado in ('A','I'))),
   Ecodigo              numeric(18)                    null,
   Usucodigo            numeric(18)                    null,
   constraint PK_FTCONTRATOS primary key (Cid)
)
go

alter table FTContratos
   add constraint Contratos_FK01 foreign key (TCid)
      references FTTipoContrato (TCid)
go