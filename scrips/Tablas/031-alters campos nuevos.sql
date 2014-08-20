--alter crea campos nuevos generados pos creaccion de la tabla

alter table FTHistoriaTramite add PCid numeric(18) null
go
alter table FTHistoriaTramite add HTObservacion varchar(1024) null
go

alter table FTHistoriaTramite
   add constraint FK_FTHISTOR_REFERENCE_FTPCONTR foreign key (PCid)
      references FTPContratacion (PCid)
go
