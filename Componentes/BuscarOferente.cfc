<cfcomponent>
	<!---busca en el para el padron electoral--->
	<cffunction name="Padron" access="public" returntype="query">
		<cfargument name="Identificacion" type="string" required="yes">
			<cfquery name="rs" datasource="ftec">
                select cedula as PCIdentificacion
                		,'F' as PCTIdentificacion
                        ,sexo as PCSexo
                        ,nombre as PCNombre
                        ,primerApellido as PCApellido1
                        ,segundoApellido as PCApellido2 
                        ,'' as PCEstadoCivil   
                from RegistroCivilPadronElectoral
                where cedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Identificacion#">
            </cfquery>
		<cfreturn rs>
	</cffunction>

	<!---busca en el para Ultimo contrato aplicado--->
	<cffunction name="Contratos" access="public" returntype="query">
		<cfargument name="Identificacion" type="string" required="yes">
        <cfargument name="TipoIdentificacion" type="string" required="yes">
        
			<cfquery name="rs" datasource="ftec">
                select PCTidentificacion  <!---F=Fisica, J=Juridica--->
                        ,PCIdentificacion
                        ,PCNombre
                        ,PCApellido1
                        ,PCApellido2
                        ,PCSexo			<!---F=Femenino, M=Masculino--->
                        ,PCEstadoCivil 	<!---1=soltero, 2=casado, 3=divorciado, 4=union libre, 5=separado--->
                from FTPContratacion	
                where PCTidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoIdentificacion#">
	                and PCIdentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Identificacion#">
            </cfquery>
		<cfreturn rs>
	</cffunction>

	<!---Busca en el para Empleado--->
	<cffunction name="Empleado" access="public" returntype="query">
		<cfargument name="Identificacion" type="string" required="yes">
			<cfquery name="rs" datasource="#session.dsn#">
                select DEidentificacion as PCIdentificacion
                        ,DEsexo as PCSexo
                        ,DEnombre as PCNombre
                        ,DEapellido1 as PCApellido1
                        ,DEapellido2 as PCApellido2
                        ,DEcivil as PCEstadoCivil <!---1=soltero, 2=casado, 3=divorciado, 4=union libre, 5=separado--->
                from DatosEmpleado
                where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Identificacion#">
            </cfquery>
		<cfreturn rs>
	</cffunction>
</cfcomponent>


