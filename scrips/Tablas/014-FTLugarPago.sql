/*==============================================================*/
/* Table: FTLugarPago                                           */
/*==============================================================*/
create table FTLugarPago (
   LPid                 numeric(18)                    identity,
   LPcodigo             varchar(10)                    null,
   LPdescripcion        varchar(50)                    null,
   Ecodigo              int                            not null,
   constraint PK_FTLUGARPAGO primary key (LPid)
)
go
