
/*==============================================================*/
/* Table: FTCostoAdmin                                          */
/*==============================================================*/
create table FTCostoAdmin (
   CAid                 numeric(18)                    identity,
   CAcodigo             varchar(10)                    not null,
   CAdescripcion        varchar(50)                    not null,
   CAporcentaje         numeric(5,2)                   not null,
   Ecodigo              int                            null,
   CAobligatorio        int                            null,
   Usucodigo            numeric(18)                    null,
   constraint PK_FTCOSTOADMIN primary key (CAid)
)
go