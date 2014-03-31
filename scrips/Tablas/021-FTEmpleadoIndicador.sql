/*==============================================================*/
/* Table: FTEmpleadoIndicador                                   */
/*==============================================================*/
create table FTEmpleadoIndicador (
   EIid                 numeric                        identity,
   DEid                 numeric                        null,
   CFid                 numeric                        null,
   EImes                int                            not null,
   EIperiodo            int                            not null,
   EInoaplica           int                            default 0 null
         constraint CKC_EINOAPLICA_FTEMPLEA check (EInoaplica is null or (EInoaplica in (0,1))),
   constraint PK_FTEMPLEADOINDICADOR primary key (EIid),
   constraint AK_KEY_2_FTEMPLEA unique (DEid, EImes, EIperiodo)
)
go
/*
 
alter table FTEmpleadoIndicador
   add constraint FK_FTEMPLEA_REFERENCE_DATOSEMP foreign key (DEid)
      references DatosEmpleado
go

alter table FTEmpleadoIndicador
   add constraint FK_FTEMPLEA_REFERENCE_CFUNCION foreign key (CFid)
      references CFuncional
go
*