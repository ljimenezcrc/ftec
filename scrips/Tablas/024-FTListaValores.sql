create table FTListaValores (
   DVid                 numeric                        not null,
   DVLcodigo            char(10)                       not null,
   DVLdescripcion       varchar(40)                    null,
   BMUsucodigo          numeric                        null,
   ts_rversion          timestamp                      null,
   constraint FTListaValores_PK primary key (DVid, DVLcodigo)
)
go

alter table FTListaValores
   add constraint FTListaValores_FK01 foreign key (DVid)
      references FTDatosVariables (DVid)
go
