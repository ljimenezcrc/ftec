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