/*==============================================================*/
/* Table: FTTipoTramite                                         */
/*==============================================================*/
create table FTTipoTramite (
   TTid                 numeric(18)                    identity,
   TTcodigo             varchar(10)                    null,
   TTdescripcion        varchar(50)                    null,
   Ecodigo              int                            null,
   constraint PK_FTTIPOTRAMITE primary key (TTid)
)
go