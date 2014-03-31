/*==============================================================
 Table FTIndicador                                           
==============================================================*/
create table FTIndicador (
   Iid                  numeric                        identity,
   Ecodigo              int                            not null,
   Icodigo              varchar(10)                    not null,
   Idescripcion         varchar(500)                   not null,
   Ifecha               datetime                       null,
   Iformacalculo        varchar(500)                   null,
   Iperiodicidad        varchar(500)                   null,
   Ifuente              varchar(500)                   null,
   Iresponsable         varchar(500)                   null,
   Iformapresenta       varchar(500)                   null,
   Iusos                varchar(500)                   null,
   Inivelagrega         varchar(500)                   null,
   Irotroproceso        varchar(500)                   null,
   Ivalormeta           varchar(500)                   null,
   Irangoacepta         varchar(500)                   null,
   Iobservacion         varchar(2040)                  null,
   constraint PK_FTINDICADOR primary key (Iid)
)
go
