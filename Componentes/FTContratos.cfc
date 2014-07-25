<cfcomponent hint="Componente para el manejo de contratos">
	<!---Funcion para recuperar toda la información de los contratos--->
	<cffunction name="get" returntype="query" hint="Funcion para recuperar toda la información de los contratos">
		<cfargument name="Cid" 		type="numeric" required="no">
		<cfargument name="conexion" type="string"  required="no" default="ftec">			
				
		<cfquery name="rssql" datasource="#Arguments.conexion#">
			select Cid,TCid,Cdescripcion,Cestado,Ecodigo,Usucodigo
			from FTContratos
			where 1 = 1
			<cfif isdefined('Arguments.Cid')>
				and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
			</cfif>
		</cfquery>
		<cfreturn rssql>
	</cffunction>
	<!---Funcion para la obtencion de los datos del tipo de contrato--->
	<cffunction name="getTipo" returntype="query" hint="Funcion para la obtencion de los datos del tipo de contrato">
	<cfargument name="conexion" type="string"  required="no" default="ftec">
			
		<cfquery name="rssql" datasource="#Arguments.conexion#">
			select TCid,Ecodigo,TCcodigo,TCdescripcion,Usucodigo
			from FTTipoContrato 
		</cfquery>
		<cfreturn rssql>
	</cffunction>	
	<!---Funcion para la obtencion las secciones del contrato--->
	<cffunction name="getSeccion" returntype="query" hint="Funcion para la obtencion las secciones del contrato">
	<cfargument name="conexion" type="string"  required="no" default="ftec">
	
		<cfquery name="rssql" datasource="#Arguments.conexion#">
			select Sid, Cid, STexto, SOrden,Cpermisos, Ecodigo, Usucodigo
			from FTSecciones
		</cfquery>
		<cfreturn rssql>
	</cffunction>
	<!---Funcion para Eliminar los contratos--->
	<cffunction name="Delete" hint="Funcion para Eliminar los contratos">
		<cfargument name="Cid" 		type="numeric" 	required="yes">
		<cfargument name="conexion" type="string"  required="no" default="ftec">
				
		<cfquery name="rssql" datasource="#Arguments.conexion#">
			Delete from FTContratos
			where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
		</cfquery>
		<cfreturn>
	</cffunction>
	<!---Funcion para Insertar o Actualizar contratos--->
	<cffunction name="set" returntype="numeric" hint="Funcion para Insertar o Actualizar contratos">
		<cfargument name="Cid"	 		type="numeric" 	required="no">
		<cfargument name="TCid" 		type="numeric" 	required="no" default="-1">
		<cfargument name="Cdescripcion" type="string" 	required="no" default="">
		<cfargument name="Cestado" 		type="string" 	required="no" default="I">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Usucodigo" 	type="numeric" 	required="no">
		<cfargument name="conexion" type="string"  required="no" default="ftec">
		
		<cfif isdefined('session.Ecodigo') and not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif isdefined('session.Usucodigo') and not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
	
		<cfif isdefined('Arguments.Cid')>
			<cfquery name="rssql" datasource="#Arguments.Conexion#">
				update FTContratos set 
					TCid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TCid#" null="#Arguments.TCid EQ -1#">,
					Cdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cdescripcion#">,
					Cestado 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cestado#">,
					Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					Usucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				where Cid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
			</cfquery>	
			<cfreturn Arguments.Cid>
		<cfelse>
			<cfquery name="rssql" datasource="#Arguments.Conexion#">
				insert into FTContratos (TCid,Cdescripcion,Cestado,Ecodigo,Usucodigo) 
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TCid#" null="#Arguments.TCid EQ -1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cestado#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				)
			<cf_dbidentity1 datasource="#Arguments.Conexion#">
            </cfquery>
            <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rssql" returnVariable="LvarCid"> 
            
			<cfreturn LvarCid>
		</cfif>
	</cffunction>
	<!---Funcion paa crear y Actualizar Secciones del contrato--->
	<cffunction name="SetSeccion" returntype="numeric" hint="Funcion paa crear y Actualizar Secciones del contrato">
		<cfargument name="Sid" 			type="numeric" 	required="no">
		<cfargument name="Cid" 			type="numeric" 	required="no">
		<cfargument name="STexto" 		type="string" 	required="no" default="NUEVA SECION DEL CONTRATO.<BR> DOBLE CLICK PARA EDITAR">
		<cfargument name="SOrden" 		type="numeric" 	required="no" default="1">
		<cfargument name="Cpermisos" 	type="string" 	required="no" default="M">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Usucodigo" 	type="numeric" 	required="no">
		<cfargument name="conexion" type="string"  required="no" default="ftec">
		
		<cfif isdefined('session.Ecodigo') and not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif isdefined('session.Usucodigo') and not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>

		<cfif isdefined('Arguments.Sid')>
			<cfquery name="rssql" datasource="#Arguments.Conexion#">
				update FTSecciones set 
				  <cfif isdefined('Arguments.Cid')>
				    Cid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Cid#">, 
				  </cfif>
				  <cfif isdefined('Arguments.SOrden')>
					SOrden    = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.SOrden#">, 	
				  </cfif>
					STexto    = <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#Arguments.STexto#">,
					Cpermisos = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cpermisos#">,
					Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">, 
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#">
				  where   Sid = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Sid#">
			</cfquery>
			<cfreturn Arguments.Sid>
		<cfelse>
			<cfquery name="rssql" datasource="#Arguments.Conexion#">
				insert into FTSecciones (Cid, STexto, SOrden, Cpermisos, Ecodigo, Usucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Cid#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#Arguments.STexto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.SOrden#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.Cpermisos#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#Arguments.Conexion#">
			</cfquery>
				<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rssql" returnVariable="LvarSid"> 
			<cfreturn LvarSid>
		</cfif>
	</cffunction>
</cfcomponent>