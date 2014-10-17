--alter crea campos nuevos generados pos creaccion de la tabla

alter table FTHistoriaTramite add PCid numeric(18) null
go
alter table FTHistoriaTramite add HTObservacion varchar(1024) null
go

alter table FTHistoriaTramite
   add constraint FK_FTHISTOR_REFERENCE_FTPCONTR foreign key (PCid)
      references FTPContratacion (PCid)
go

alter table FTPContratacion add PCEstadoCivil integer null
go
alter table FTPContratacion add  constraint CKC_PCESTADOCIVIL_FTPCONTR check (PCEstadoCivil is null or (PCEstadoCivil in (1,2,3,4,5)))


/*05:16 p.m. 07/10/2014*/

alter table FTContratos add  TTid numeric(18) null
go
alter table FTContratos
   add constraint FK_FTCONTRA_REFERENCE_FTTIPOTR foreign key (TTid)
      references FTTipoTramite (TTid)
go