<cfcomponent hint="Componente para el manejo de contratos">
	<!---Funcion para recuperar toda la información de los contratos--->
	<cffunction name="get" returntype="query" hint="Funcion para recuperar toda la información de los contratos">
		<cfargument name="Cid" 		type="numeric" required="no">
		<cfargument name="conexion" type="string"  required="no" default="ftec">			
				
		<cfquery name="rssql" datasource="#Arguments.conexion#">
			select Cid,TCid,TTid,Cdescripcion,Cestado,Ecodigo,Usucodigo
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
		<cfargument name="Cid" 		type="numeric" 	required="yes">
		<cfargument name="conexion" type="string"   required="no" default="ftec">
	
		<cfquery name="rssql" datasource="#Arguments.conexion#">
			select Sid, Cid, STexto, SOrden,Cpermisos, Ecodigo, Usucodigo,NombreSeccion
			 from FTSecciones
			where 1 = 1
			  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
		</cfquery>
		<cfreturn rssql>
	</cffunction>
	<!---Funcion para Eliminar los contratos--->
	<cffunction name="Delete" hint="Funcion para Eliminar los contratos">
		<cfargument name="Cid" 		type="numeric" 	required="yes">
		<cfargument name="conexion" type="string"  required="no" default="ftec">
		
		<cfquery name="rssql" datasource="#Arguments.conexion#">
			Delete from FTSecciones
			where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
		</cfquery>	
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
		<cfargument name="TTid" 		type="numeric" 	required="no" default="-1">
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
					TTid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TTid#" null="#Arguments.TTid EQ -1#">,
					Cdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cdescripcion#">,
					Cestado 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cestado#">,
					Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					Usucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				where Cid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
			</cfquery>	
			<cfreturn Arguments.Cid>
		<cfelse>
			<cfquery name="rssql" datasource="#Arguments.Conexion#">
				insert into FTContratos (TCid,TTid,Cdescripcion,Cestado,Ecodigo,Usucodigo) 
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TCid#" null="#Arguments.TCid EQ -1#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TTid#" null="#Arguments.TTid EQ -1#">,
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
		<cfargument name="Sid" 				type="numeric" 	required="no">
		<cfargument name="Cid" 				type="numeric" 	required="no">
		<cfargument name="STexto" 			type="string" 	required="no" default="DOBLE CLICK PARA EDITAR">
		<cfargument name="SOrden" 			type="numeric" 	required="no" default="1">
		<cfargument name="Cpermisos" 		type="string" 	required="no" default="M">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="Usucodigo" 		type="numeric" 	required="no">
		<cfargument name="conexion" 		type="string"  	required="no" default="ftec" hint="Nombre del Datasource">
		<cfargument name="NombreSeccion" 	type="string" 	required="no" default="">
		
		<cfif isdefined('session.Ecodigo') and not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif isdefined('session.Usucodigo') and not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
		<cfif NOT LEN(TRIM(Arguments.STexto))>
			<cfset Arguments.STexto = "DOBLE CLICK PARA EDITAR">
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
					STexto        = <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#Arguments.STexto#">,
					Cpermisos     = <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.Cpermisos#">,
					Ecodigo   	  = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">, 
					Usucodigo 	  = <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#">,
					NombreSeccion = <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.NombreSeccion#">
				  where   Sid = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.Sid#">
			</cfquery>
			<cfset LvarSid =  Arguments.Sid>
		<cfelse>
			<cfquery name="rssql" datasource="#Arguments.Conexion#">
				insert into FTSecciones (Cid, STexto, SOrden, Cpermisos, Ecodigo, Usucodigo,NombreSeccion)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Cid#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#Arguments.STexto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.SOrden#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.Cpermisos#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.NombreSeccion#">
				)
				<cf_dbidentity1 datasource="#Arguments.Conexion#">
			</cfquery>
				<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rssql" returnVariable="LvarSid"> 
			
		</cfif>
		<cfset SetDatosVariable(LvarSid,Arguments.STexto)>
		<cfreturn LvarSid>
	</cffunction>
	
	<cffunction name="SetDatosVariable" access="public" hint="Funcion que recupera los datos variables de las secciones">
		<cfargument name="Sid" 			type="numeric" 	required="no" hint="Id de la seccion del contrato">
		<cfargument name='STexto' 	    type='string' 	required="yes">
		<cfargument name="TVariables" 	type="numeric" 	required="no" default="1" hint="Tipo de Variable: 1 = dato variable">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Usucodigo" 	type="numeric" 	required="no">
		<cfargument name="conexion" 	type="string"  required="no" default="ftec" hint="Nombre del DataSource">
		
		<cfif isdefined('session.Ecodigo') and not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif isdefined('session.Usucodigo') and not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
			
		<cfset texto          = Arguments.STexto>
		<cfset cont           = 1>
     	<cfset variblesNuevas = ArrayNew(1)>
       	<cfset ch             =''>
       	<cfset variable       ="" >
     	<cfset inicia         = false>
		
        <cfloop from="0" to="#LEN(texto)-1#" index="i">
       		<cfset ch = texto.charAt(i)>
			<cfif ch eq '##' AND inicia EQ false>
            	<cfset variable="">
            	<cfset inicia = true> 
            <cfelseif inicia EQ true AND  ch NEQ '##'>
             	<cfset variable = variable & ch>
            <cfelseif inicia EQ true AND  ch EQ '##'>
            	<cfset variblesNuevas [cont]= variable>

				<!--- inserta nuevas varibles en el orden que aparecen --->
				<cfquery datasource="#Arguments.conexion#" name="rsInserto">
					INSERT INTO FTSeccionesD (Sid,TVariables,Variable,SDReport,Ecodigo,Usucodigo,SDorden) 
					SELECT 
							<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Sid#"> ,
							<cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   			value="#Arguments.TVariables#">,
							<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  	value="#variable#">,
							<cf_jdbcQuery_param cfsqltype="cf_sql_numeric"				value="1">,
							<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Ecodigo#">,
							<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Usucodigo#">,
							<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#cont#"> 
					 from dual
					 where (select Count(1) 
							 from FTSeccionesD 
							where Sid      = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Sid#">
							  and Variable = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100"  	value="#variable#">) = 0
				</cfquery>


				<!--- Actauliza el orden de las demas variables --->
				<cfquery datasource="#Arguments.conexion#" name="rsInserto">
					update FTSeccionesD set SDorden = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#cont#">
					<!---select Sid,TVariables,Variable,SDReport,Ecodigo,Usucodigo,SDorden 
					from FTSeccionesD--->
					where (select Count(1) 
							 from FTSeccionesD a 
							where a.Sid      = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Sid#">
								and a.Sid = FTSeccionesD.Sid
								and a.Variable = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100"  	value="#variable#">
								and a.Variable = FTSeccionesD.Variable) = 1
						and  FTSeccionesD.Variable = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100"  	value="#variable#">
						and FTSeccionesD.Sid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Sid#">
				</cfquery>

				<cfset cont = cont+1 >
                <cfset variable="" >
                <cfset inicia = false>
            </cfif>
       </cfloop>

    
		<cfquery datasource="#Arguments.conexion#">
	   		delete from FTPDContratacion
			where SDid in (select SDid 
							from FTSeccionesD
						where Sid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Sid#">
						  and Variable not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(variblesNuevas)#" list="yes">)
						  )			 
	   </cfquery>
	   
	   <cfquery datasource="#Arguments.conexion#">
	   		delete from FTSeccionesD
			where Sid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Sid#">
			  and Variable not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(variblesNuevas)#" list="yes">)			 
	   </cfquery>
	   
	</cffunction>
	<cffunction name="updateDatosVariable" access="remote" returntype="string" output="false" returnformat="JSON">
		<cfargument name="SDid" 	  type="numeric" required="yes">
		<cfargument name="TVariables" type="numeric" default="1">
		<cfargument name="DVid" 	  type="numeric" default="-1">				
		<cfargument name="conexion"    type="string"  required="no" default="ftec" hint="Nombre del DataSource">
		
		<cfquery datasource="#Arguments.conexion#" name="rsInserto">
			update FTSeccionesD
			 set TVariables = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TVariables#">,
			     DVid 	    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DVid#" null="#Arguments.DVid EQ -1#">
			where SDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SDid#">
		</cfquery>	
		<cfreturn 'OK'>
	</cffunction>
	
	<!---Funcion que retorna todas las variables de las secciones--->
	<cffunction name="getFTSeccionesD" returntype="query" hint="Funcion que retorna todas las variables de las secciones">
		<cfargument name="Cid" 			type="numeric" 	required="no" hint="Id del contrato">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Usucodigo" 	type="numeric" 	required="no">
		<cfargument name="conexion" 	type="string"   required="no" default="ftec">
		
		<cfif isdefined('session.Ecodigo') and not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif isdefined('session.Usucodigo') and not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
		
		<cfquery name="rsFTSeccionesD" datasource="#Arguments.Conexion#">
			select a.SDid,a.Sid,a.TVariables,a.Variable,a.DVid,a.SDReport,a.Ecodigo,a.Usucodigo , b.NombreSeccion, a.SDorden
   			from FTSeccionesD a
				inner join FTSecciones b
					on b.Sid = a.Sid
			where 1 = 1
			<cfif isdefined('Arguments.Cid')>
				and b.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
			</cfif>
			Order by a.Sid, a.SDorden
		</cfquery>
		<cfreturn rsFTSeccionesD>
	</cffunction>
</cfcomponent>