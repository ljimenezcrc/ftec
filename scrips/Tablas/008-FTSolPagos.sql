/*==============================================================*/
/* Table: FTSolPagos                                            */
/*==============================================================*/
create table FTSolPagos (
   SPid                 numeric(18)                    identity,
   SPdoc                varchar(20)                    null,
   constraint PK_FTSOLPAGOS primary key (SPid)
)
go