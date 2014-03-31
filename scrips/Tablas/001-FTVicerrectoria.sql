/*==============================================================*/
/* Table: FTVicerrectoria                                       */
/*==============================================================*/
create table FTVicerrectoria (
   Vid                  numeric(18)                    identity,
   Vcodigo              varchar(10)                    not null,
   Vdescripcion         varchar(50)                    not null,
   Vpadre               numeric(18)                    null,
   CFid                 numeric                        null,
   Vctaingreso          varchar(30)                    null,
   Vctagasto            varchar(30)                    null,
   Vctasaldoinicial     varchar(30)                    null,
   Vesproyecto          int                            null,
   Ecodigo              int                            null,
   Vfinicio             datetime                       null,
   Vffinal              datetime                       null,
   Vestado              int                            null,
   Mcodigo              numeric(18)                    null,
   Vmonto               money                          null,
   Usucodigo            numeric(18)                    null,
   constraint PK_FTVICERRECTORIA primary key (Vid)
)
go

alter table FTVicerrectoria
   add constraint FK_FTVICERR_REFERENCE_FTVICERR foreign key (Vpadre)
      references FTVicerrectoria (Vid)
go
/*
alter table FTVicerrectoria
   add constraint FK_FTVICERR_REFERENCE_CFUNCION foreign key (CFid)
      references CFuncional
go
*/
