/*==============================================================*/
/* Table: FTEstadoTramite                                       */
/*==============================================================*/
create table FTEstadoTramite (
   ETid                 numeric(18)                    identity,
   ETcodigo             varchar(10)                    not null,
   ETdescripcion        varchar(50)                    not null,
   Ecodigo              int                            null,
   constraint PK_FTESTADOTRAMITE primary key (ETid)
)
go
