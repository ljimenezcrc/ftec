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
                        ,'F' as PCTIdentificacion
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


    <!---Genera la consulta con datos en blanco para poder hacer el ingreso.--->
    <cffunction name="NDF" access="public" returntype="query">
        <cfargument name="Identificacion" type="string" required="yes">
 
            <cfquery name="rs" datasource="#session.dsn#">
                select
                    <!---DEidentificacion as PCIdentificacion
                    ,'F' as PCTIdentificacion
                    ,DEsexo as PCSexo
                    ,DEnombre as PCNombre
                    ,DEapellido1 as PCApellido1
                    ,DEapellido2 as PCApellido2
                    ,DEcivil as PCEstadoCivil <!---1=soltero, 2=casado, 3=divorciado, 4=union libre, 5=separado--->


                    
                    <cfif isdefined('form.Cid') and len(form.Cid)>
                         #form.Cid# as Cid
                    <cfelse>
                         -1 as Cid
                    </cfif>
                    <cfif isdefined('form.PCid') and len(form.PCid)>
                        ,#form.PCid# as PCid
                    <cfelse>
                        , -1 as PCid
                    </cfif>
                    <cfif isdefined('form.Vid') and len(form.Vid)>
                        ,#form.Vid# as Vid
                    <cfelse>
                        , -1 as Vid
                    </cfif>
                    <cfif isdefined('form.TCid') and len(form.TCid)>
                         ,#form.TCid# as TCid
                    <cfelse>
                         ,-1 as TCid
                    </cfif>

                    <cfif isdefined('form.Cdescripcion') and len(form.Cdescripcion)>
                         ,'#form.Cdescripcion#' as Cdescripcion
                    <cfelse>
                         ,NULL as Cdescripcion
                    </cfif>
                    --->

                    <cfif isdefined('form.PCTidentificacion') and len(form.PCTidentificacion)>
                         '#form.PCTidentificacion#' as PCTidentificacion
                    <cfelse>
                         NULL as PCTidentificacion
                    </cfif>
                     
                    <cfif isdefined('form.PCIdentificacion') and len(form.PCIdentificacion)>
                       ,'#form.PCIdentificacion#' as PCIdentificacion 
                    <cfelse>
                        ,null as PCIdentificacion 
                    </cfif> 
                    ,null as PCSexo
                    ,null as PCEstadoCivil
                    ,null as PCnombre
                    ,null as PCapellido1
                    ,null as PCapellido2
                from dual
            </cfquery>
        <cfreturn rs>
    </cffunction>

</cfcomponent>


