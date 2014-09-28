<cfcomponent name="FTPContratacion"  output="true">
<!---    
PCid				<!--- Id de la  Tabla --->

Cid 				<!---tipo de Contrato--->
,PCTidentificacion 	<!---tipo Identificacion oferente F=fisica, J=juridica--->
,PCIdentificacion 	<!---Identificacion oferente--->
,PCNombre			<!---Nombre Oferente cuando es fisico / Nombre Empresa es Juridico--->
,PCApellido1		<!--- apellido1 del oferente fisico / Razon Social es Jurico --->
,PCApellido2		<!--- Apellido2 oferente --->
,PCSexo				<!--- F=Femenino, M=Masculino--->
,PCEstadoCivil		<!--- Estado Civil del  oferente  1=soltero, 2=casado, 3=divorciado, 4=union libre, 5=separado --->
,PCFechaN			<!--- Fecha Nacimiento oferente--->
,PCEstado 			<!--- Estado del Contrato P=Proceso edicion, T= en tramite, A=Aprobado, R=Rechazado,F=Finiquito del contrato(Cancelado)--->
,PCEnumero			<!--- Numero del contrato se asigna una ves aprobado --->
,PCEPeriodo			<!--- Año aprobacion contrato se asigna una ves aprobado --->

,PCFechaC			<!--- Fecha Contrato --->
,PCFechaA			<!--- Fecha Aprobado Contrato --->
,PCFechaF			<!--- Fecha Finiquito Contrato --->

,PCUsucodigoC		<!--- Usuario creo Contrato --->
,PCUsucodigoA		<!--- Usuario que apruebo Contrato --->
,PCUsucodigoF		<!--- Usuario que Finiquito/cancelo Contrato --->

--->




	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
<!---        <cfargument name="TTcodigo" 		required="true" 	type="string">
--->        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select Cid 					<!---tipo de Contrato--->
					,PCTidentificacion 	<!---tipo Identificacion oferente F=fisica, J=juridica--->
					,PCIdentificacion 	<!---Identificacion oferente--->
					,PCNombre			<!---Nombre Oferente cuando es fisico / Nombre Empresa es Juridico--->
					,PCApellido1		<!--- apellido1 del oferente fisico / Razon Social es Jurico --->
					,PCApellido2		<!--- Apellido2 oferente --->
					,PCSexo				<!--- F=Femenino, M=Masculino--->
					,PCEstadoCivil		<!--- Estado Civil del  oferente  1=soltero, 2=casado, 3=divorciado, 4=union libre, 5=separado --->
					,PCFechaN			<!--- Fecha Nacimiento oferente--->
					,PCEstado 			<!--- Estado del Contrato P=Proceso edicion, T= en tramite, A=Aprobado, R=Rechazado,F=Finiquito del contrato(Cancelado)--->
					,PCEnumero			<!--- Numero del contrato se asigna una ves aprobado --->
					,PCEPeriodo			<!--- Año aprobacion contrato se asigna una ves aprobado --->
					
					,PCFechaC			<!--- Fecha Contrato --->
					,PCFechaA			<!--- Fecha Aprobado Contrato --->
					,PCFechaF			<!--- Fecha Finiquito Contrato --->
					
					,PCUsucodigoC		<!--- Usuario creo Contrato --->
					,PCUsucodigoA		<!--- Usuario que apruebo Contrato --->
					,PCUsucodigoF		<!--- Usuario que Finiquito/cancelo Contrato --->
				from <cf_dbdatabase table="FTPContratacion" datasource="ftec">
				where PCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>
    
	<!--- *************************** --->
	<!--- Alta Contratacion			--->
	<!--- *************************** --->

    
    
	<cffunction access="public" name="set" returntype="numeric"  hint="Funcion para Insertar o Actualizar contratos">
        <cfargument name="PCid" 				required="false" 	type="numeric">
        <cfargument name="Cid" 					required="true" 	type="numeric">
    	<cfargument name="PCTidentificacion" 	required="true" 	type="string">
        <cfargument name="PCIdentificacion" 	required="true" 	type="string">
        <cfargument name="PCNombre" 			required="true" 	type="string">
        <cfargument name="PCApellido1" 			required="true" 	type="string">
        <cfargument name="PCApellido2" 			required="false" 	type="string">
        <cfargument name="PCSexo" 				required="true" 	type="string">
        <cfargument name="PCEstadoCivil" 		required="true" 	type="string">
        <cfargument name="PCFechaN" 			required="true" 	type="string">
        <cfargument name="PCUsucodigoC" 		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 				required="false" 	type="boolean" 	default="false">     

        <cftransaction>   
            <cfif isdefined('Arguments.PCid')>
            	update <cf_dbdatabase table="FTPContratacion" datasource="ftec"> set
                    Cid 				= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Cid#">
                    ,PCTidentificacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCTidentificacion#" 	voidnull>
                    ,PCIdentificacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCIdentificacion#" 	voidnull>
                    ,PCNombre			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCNombre#" 			voidnull>
                    ,PCApellido1		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCApellido1#" 		voidnull>
                    ,PCApellido2		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCApellido2#" 		voidnull>
                    ,PCSexo				= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCSexo#" 				voidnull>
                    ,PCEstadoCivil		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCEstadoCivil#" 		voidnull>
                    <!---,PCFechaN			= --->
                    ,PCUsucodigoC		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">
              where PCid = Arguments.PCid
            <cfelse>
                <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                    insert into <cf_dbdatabase table="FTPContratacion" datasource="ftec">(	  
                            Cid 				<!---tipo de Contrato--->
                            ,PCTidentificacion 	<!---tipo Identificacion oferente F=fisica, J=juridica--->
                            ,PCIdentificacion 	<!---Identificacion oferente--->
                            ,PCNombre			<!---Nombre Oferente cuando es fisico / Nombre Empresa es Juridico--->
                            ,PCApellido1		<!--- apellido1 del oferente fisico / Razon Social es Jurico --->
                            ,PCApellido2		<!--- Apellido2 oferente --->
                            ,PCSexo				<!--- F=Femenino, M=Masculino--->
                            ,PCEstadoCivil		<!--- Estado Civil del  oferente  1=soltero, 2=casado, 3=divorciado, 4=union libre, 5=separado --->
                            ,PCFechaN			<!--- Fecha Nacimiento oferente--->
                            ,PCEstado 			<!--- Estado del Contrato P=Proceso edicion, T= en tramite, A=Aprobado, R=Rechazado,F=Finiquito del contrato(Cancelado)--->
                            ,PCEnumero			<!--- Numero del contrato se asigna una ves aprobado --->
                            ,PCEPeriodo			<!--- Año aprobacion contrato se asigna una ves aprobado --->
                            ,PCUsucodigoC		<!--- Usuario creo Contrato --->
                            )
                    values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Cid#">
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCTidentificacion#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCIdentificacion#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCNombre#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCApellido1#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCApellido2#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCSexo#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.PCEstadoCivil#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.PCFechaN#" 		voidnull>
                            
                            , 'P' <!---Proceso--->
                            , 1
                            , year(getdate())
                            , <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">
                            )
                    <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
                </cfquery>
                <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
                
                <cfset Lvar_Iid = rsInsert.Identity>
                
        
                <cfif Arguments.Debug>
                    <cfquery name="rsDebug" datasource="#Session.DSN#">
                        select *
                        from <cf_dbdatabase table="FTPContratacion" datasource="ftec">
                        where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                    </cfquery>
                    <cfdump var="#Arguments#">
                    <cfdump var="#rsDebug#">
                    <cfabort>
                </cfif>
        	</cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <!--- ********************* --->
	<!--- Baja tipo Tramite --->
	<!--- ********************* --->
    <cffunction access="public" name="Baja">
		<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TTcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTTipoTramite" datasource="ftec">
                where Ecodigo = #Session.Ecodigo#
                	and TTcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.TTcodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Tipos de Tramite --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TTid" 			required="true" 	type="numeric">
        <cfargument name="TTcodigo" 		required="true" 	type="string">
    	<cfargument name="TTdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTTipoTramite" datasource="ftec"> set
	                     TTcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TTcodigo#" 		voidnull>
                        , TTdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TTdescripcion#" 	voidnull>
                where TTid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TTid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TTid, TTcodigo, TTdescripcion, Ecodigo
					from <cf_dbdatabase table="FTTipoTramite" datasource="ftec">
                    where TTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TTid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>