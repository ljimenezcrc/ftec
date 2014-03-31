
/*==============================================================*/
/* Table: FTGrupoCuentas                                        */
/*==============================================================*/
create table FTGrupoCuentas (
   GCid                 numeric                        identity,
   Iid                  numeric                        null,
   GCcodigo             varchar(10)                    not null,
   GCdescripcion        varchar(100)                   not null,
   constraint PK_FTGRUPOCUENTAS primary key (GCid)
)
go

alter table FTGrupoCuentas
   add constraint FK_FTGRUPOC_REFERENCE_FTINDICA foreign key (Iid)
      references FTIndicador (Iid)
go

alter table FTCuentasIndicadores add  GCid numeric null 
go

alter table FTCuentasIndicadores
   add constraint FK_FTCUENTA_REFERENCE_FTGRUPOC foreign key (GCid)
      references FTGrupoCuentas (GCid)
go