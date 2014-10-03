USE ftec
go
CREATE TABLE dbo.RegistroCivilPadronElectoral
(
    cedula          varchar(9)  COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    codelec         varchar(6)  COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    sexo            varchar(1)  COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    fechacaduc      varchar(8)  COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    junta           varchar(5)  COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    nombre          varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    primerApellido  varchar(26) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    segundoApellido varchar(26) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
go
IF OBJECT_ID('dbo.RegistroCivilPadronElectoral') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.RegistroCivilPadronElectoral >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.RegistroCivilPadronElectoral >>>'
go



--
-- TABLE INSERT STATEMENTS
--
INSERT INTO dbo.RegistroCivilPadronElectoral ( cedula, codelec, sexo, fechacaduc, junta, nombre, primerApellido, segundoApellido ) 
		 VALUES ( '108650795', '', 'M', '', '0530', 'Luis Enrique', 'Jimenez', 'Sancho' ) 
go
INSERT INTO dbo.RegistroCivilPadronElectoral ( cedula, codelec, sexo, fechacaduc, junta, nombre, primerApellido, segundoApellido ) 
		 VALUES ( '602680818', '', 'F', '', '0530', 'Veronica', 'Salas', 'Salas' ) 
go
