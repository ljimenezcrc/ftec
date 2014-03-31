
/*==============================================================*/
/* Table: FTCostoProyectoD                                      */
/*==============================================================*/
create table FTCostoProyectoD (
   CPDid                numeric(18)                    identity,
   CPid                 numeric(18)                    null,
   Vid                  numeric(18)                    null,
   CPDporcentaje        numeric(5,2)                   null,
   constraint PK_FTCOSTOPROYECTOD primary key (CPDid)
)
go

alter table FTCostoProyectoD
   add constraint FK_FTCOSTOP_REFERENCE_FTCOSTOP foreign key (CPid)
      references FTCostoProyecto (CPid)
go

alter table FTCostoProyectoD
   add constraint FK_FTCOSTOP_REFERENCE_FTVICERR foreign key (Vid)
      references FTVicerrectoria (Vid)
go
