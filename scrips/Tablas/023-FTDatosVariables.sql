create table FTDatosVariables (
   DVid                 numeric                        identity,
   Ecodigo              integer                        null,
   DVetiqueta           varchar(40)                    not null,
   DVexplicacion        text                           null,
   DVtipoDato           char(1)                        not null
         constraint FTDatosVariables_CK check (DVtipoDato in ('C','N','L','F','H','K')),
   DVlongitud           int                            default 0 not null,
   DVdecimales          int                            default 0 not null,
   DVmascara            varchar(20)                    null,
   DVobligatorio        bit                            default 0 not null,
   BMUsucodigo          numeric                        null,
   ts_rversion          timestamp                      null,
   constraint FTDatosVariables_PK primary key (DVid)
)
go