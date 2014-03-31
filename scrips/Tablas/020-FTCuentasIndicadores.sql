create table FTCuentasIndicadores (
   CIid                 numeric                        identity,
   Iid                  numeric                        null,
   Cuenta               varchar(100)                   null,
   NivelDet             int                            null,
   NivelTot             int                            null,
   MesInicio            int                            null,
   MesFinal             int                            null,
   constraint PK_FTCUENTASINDICADORES primary key (CIid)
)
go

alter table FTCuentasIndicadores
   add constraint FK_FTCUENTA_REFERENCE_FTINDICA foreign key (Iid)
      references FTIndicador (Iid)
go
