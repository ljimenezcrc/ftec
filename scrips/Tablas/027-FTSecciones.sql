create table FTSecciones (
   Cid                  numeric                        null,
   Sid                  numeric                        identity,
   STexto               text                           null,
   SOrden               numeric                        default 1 null,
   Ecodigo              numeric(18)                    null,
   Usucodigo            numeric(18)                    null,
   Cpermisos            char(1)                        default 'M' null
         constraint CKC_CPERMISOS_FTSECCIO check (Cpermisos is null or (Cpermisos in ('M','N','E'))),
   constraint PK_FTSECCIONES primary key (Sid)
)
go

alter table FTSecciones
   add constraint FK_FTSECCIO_REFERENCE_FTCONTRA foreign key (Cid)
      references FTContratos (Cid)
go