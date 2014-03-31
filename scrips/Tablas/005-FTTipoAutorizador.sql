/*==============================================================*/
/* Table: FTTipoAutorizador                                     */
/*==============================================================*/
create table FTTipoAutorizador (
   TAid                 numeric(18)                    identity,
   TAcodigo             varchar(10)                    not null,
   TAdescripcion        varchar(50)                    not null,
   TAmontomin           money                          not null,
   TAmontomax           money                          not null,
   Ecodigo              int                            null,
   Usucodigo            numeric(18)                    null,
   constraint PK_FTTIPOAUTORIZADOR primary key (TAid)
)
go