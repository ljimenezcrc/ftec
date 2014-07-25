create table FTTipoContrato (
   TCid                 numeric                        identity,
   Ecodigo              numeric                        null,
   TCcodigo             varchar(40)                    not null,
   TCdescripcion        varchar(255)                   not null,
   Usucodigo            numeric(18)                    null,
   constraint PK_FTTIPOCONTRATO primary key (TCid),
   constraint FTTipoContrato_AK01 unique (Ecodigo, TCcodigo)
)
go