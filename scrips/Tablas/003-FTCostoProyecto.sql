
/*==============================================================*/
/* Table: FTCostoProyecto                                       */
/*==============================================================*/
create table FTCostoProyecto (
   CPid                 numeric(18)                    identity,
   Vid                  numeric(18)                    not null,
   CAid                 numeric(18)                    not null,
   CPporcentaje         numeric(5,2)                   not null,
   CPexoneracion        int                            null,
   CPfdesde             datetime                       null,
   CPfhasta             datetime                       null,
   CPdistribuido        int                            null,
   CPvalorcatalogo      int                            null,
   Usucodigo            numeric(18)                    null,
   constraint PK_FTCOSTOPROYECTO primary key (CPid)
)
go

alter table FTCostoProyecto
   add constraint FK_FTCOSTOP_REFERENCE_FTCOSTOA foreign key (CAid)
      references FTCostoAdmin (CAid)
go

alter table FTCostoProyecto
   add constraint FK_FTCOSTOP_REFERENCE_FTVICERR foreign key (Vid)
      references FTVicerrectoria (Vid)
go