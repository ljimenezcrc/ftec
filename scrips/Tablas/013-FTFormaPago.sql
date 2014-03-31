/*==============================================================*/
/* Table: FTFormaPago                                           */
/*==============================================================*/
create table FTFormaPago (
   FPid                 numeric(18)                    identity,
   FPcodigo             varchar(10)                    null,
   FPdescripcion        varchar(50)                    null,
   Ecodigo              int                            not null,
   constraint PK_FTFORMAPAGO primary key (FPid)
)
go