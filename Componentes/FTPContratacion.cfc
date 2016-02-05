<cfcomponent name="FTPContratacion"  output="true">
<!---    
PCid				<!--- Id de la  Tabla --->
,Vid                <!--- Id de Proycto --->
,Cid 				<!---tipo de Contrato--->
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
        <cfargument name="PCid" 			required="false" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select a.Cid 					<!---tipo de Contrato--->
                    ,a.Vid                <!--- Id de Proycto --->
					,a.PCTidentificacion 	<!---tipo Identificacion oferente F=fisica, J=juridica--->
					,a.PCIdentificacion 	<!---Identificacion oferente--->
					,a.PCNombre			<!---Nombre Oferente cuando es fisico / Nombre Empresa es Juridico--->
					,a.PCApellido1		<!--- apellido1 del oferente fisico / Razon Social es Jurico --->
					,a.PCApellido2		<!--- Apellido2 oferente --->
					,a.PCSexo				<!--- F=Femenino, M=Masculino--->
					,a.PCEstadoCivil		<!--- Estado Civil del  oferente  1=soltero, 2=casado, 3=divorciado, 4=union libre, 5=separado --->
					<!---,a.PCFechaN			 Fecha Nacimiento oferente--->
					,a.PCEstado 			<!--- Estado del Contrato P=Proceso edicion, T= en tramite, A=Aprobado, R=Rechazado,F=Finiquito del contrato(Cancelado)--->
					,a.PCEnumero			<!--- Numero del contrato se asigna una ves aprobado --->
					,a.PCEPeriodo			<!--- Año aprobacion contrato se asigna una ves aprobado --->
					
					,a.PCFechaC			<!--- Fecha Contrato --->
					,a.PCFechaA			<!--- Fecha Aprobado Contrato --->
					,a.PCFechaF			<!--- Fecha Finiquito Contrato --->
					
					,a.PCUsucodigoC		<!--- Usuario creo Contrato --->
					,a.PCUsucodigoA		<!--- Usuario que apruebo Contrato --->
					,a.PCUsucodigoF		<!--- Usuario que Finiquito/cancelo Contrato --->
                    ,b.TTid				<!---tipo de tramite--->
				from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a
                left join <cf_dbdatabase table="FTContratos" datasource="ftec"> b
                	on b.Cid = a.Cid
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
	<!--- Alta y Cambio Contratacion  --->
	<!--- *************************** --->

    
    
	<cffunction access="public" name="set" returntype="numeric"  hint="Funcion para Insertar o Actualizar contratos">
        <cfargument name="PCid" 				required="false" 	type="numeric">
        <cfargument name="Vid"                  required="true"     type="any">
        <cfargument name="Cid" 					required="true" 	type="numeric">
    	<cfargument name="PCTidentificacion" 	required="true" 	type="string">
        <cfargument name="PCIdentificacion" 	required="true" 	type="string">
        <cfargument name="PCNombre" 			required="true" 	type="string">
        <cfargument name="PCApellido1" 			required="true" 	type="string">
        <cfargument name="PCApellido2" 			required="false" 	type="string">
        <cfargument name="PCSexo" 				required="true" 	type="string">
        <cfargument name="PCEstadoCivil" 		required="true" 	type="string">
        <!--- <cfargument name="PCFechaN" 			required="false" 	type="string"> --->
        <cfargument name="PCFechaA"           required="false"    type="string">
        <cfargument name="PCFechaF"           required="false"    type="string">
        <cfargument name="PCUsucodigoC" 		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 				required="false" 	type="boolean" 	default="false">     
		<cfargument name="Conexion" 			required="false" 	type="string" 	default="ftec">  

 
        
        <cftransaction>   
            <cfif isdefined('Arguments.PCid')>
             <cfquery name="rsInsert" datasource="#Arguments.Conexion#" result="res">
            	update FTPContratacion set
                    Cid 				= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Cid#">
                    ,Vid                = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Arguments.Vid#" voidnull>
                    ,PCTidentificacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCTidentificacion#" 	voidnull>
                    ,PCIdentificacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCIdentificacion#" 	voidnull>
                    ,PCNombre			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCNombre#" 			voidnull>
                    ,PCApellido1		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCApellido1#" 		voidnull>
                    ,PCApellido2		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCApellido2#" 		voidnull>
                    ,PCSexo				= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCSexo#" 				voidnull>
                    ,PCEstadoCivil		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.PCEstadoCivil#" 		voidnull>
                    <!--- ,PCFechaN			= <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.PCFechaN#" 		voidnull>--->
                    ,PCFechaA         = <cf_jdbcquery_param cfsqltype="cf_sql_date"       value="#Arguments.PCFechaA#"        voidnull>
                    ,PCFechaF         = <cf_jdbcquery_param cfsqltype="cf_sql_date"       value="#Arguments.PCFechaF#"        voidnull>
                    ,PCUsucodigoC		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">
              where PCid = #Arguments.PCid#
            </cfquery>
            <cfset Lvar_Iid = Arguments.PCid>
             
            <cfelse>
                <cfquery name="rsInsert" datasource="#Arguments.Conexion#" result="res">
                    insert into FTPContratacion (	  
                            Cid 				<!---tipo de Contrato--->
                            ,Vid                <!--- Id Proyecto --->
                            ,PCTidentificacion 	<!--- tipo Identificacion oferente F=fisica, J=juridica--->
                            ,PCIdentificacion 	<!--- Identificacion oferente--->
                            ,PCNombre			<!--- Nombre Oferente cuando es fisico / Nombre Empresa es Juridico--->
                            ,PCApellido1		<!--- apellido1 del oferente fisico / Razon Social es Jurico --->
                            ,PCApellido2		<!--- Apellido2 oferente --->
                            ,PCSexo				<!--- F=Femenino, M=Masculino--->
                            ,PCEstadoCivil		<!--- Estado Civil del  oferente  1=soltero, 2=casado, 3=divorciado, 4=union libre, 5=separado --->
                            <!---,PCFechaN			 Fecha Nacimiento oferente--->
                            ,PCFechaA           <!---Fecha Aprobado--->
                            ,PCFechaF           <!--- Fecha Firmas--->
                            ,PCEstado 			<!--- Estado del Contrato P=Proceso edicion, T= en tramite, A=Aprobado, R=Rechazado,F=Finiquito del contrato(Cancelado)--->
                            ,PCEnumero			<!--- Numero del contrato se asigna una ves aprobado --->
                            ,PCEPeriodo			<!--- Año aprobacion contrato se asigna una ves aprobado --->
                            ,PCUsucodigoC		<!--- Usuario creo Contrato --->
                            )
                    values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Cid#">
                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Arguments.Vid#" voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCTidentificacion#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCIdentificacion#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCNombre#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCApellido1#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCApellido2#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.PCSexo#" 		voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.PCEstadoCivil#" 		voidnull>
                            <!---, <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.PCFechaN#" 		voidnull>--->
                            , <cf_jdbcquery_param cfsqltype="cf_sql_date"       value="#Arguments.PCFechaA#"        voidnull>
                            , <cf_jdbcquery_param cfsqltype="cf_sql_date"       value="#Arguments.PCFechaF#"        voidnull>
                            
                            , 'P' <!---Proceso--->
                            , -1
                            , year(getdate())
                            , <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">
                            )
                    <cf_dbidentity1 datasource="#Arguments.Conexion#" verificar_transaccion="false">
                </cfquery>
                <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsert" verificar_transaccion="false"> 
                
                <cfset Lvar_Iid = rsInsert.Identity>

                <cfif Arguments.Debug>
                    <cfquery name="rsDebug" datasource="#Arguments.Conexion#">
                        select *
                        from FTPContratacion
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
    
    <cffunction access="public" name="delete">
        <cfargument name="PCid" 			required="true" 	type="numeric">
        <cftransaction>   
			 <cfquery datasource="ftec">
                delete from FTPDContratacion
                where PCid= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#" voidnull>
            </cfquery>	
            <cfquery datasource="ftec">
                delete from FTPContratacion
                where PCid= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <cffunction access="public" name="setComentario">
        <cfargument name="PCid" 			required="true" 	type="numeric">
        <cfargument name="comentarios"		required="true" 	type="any">
        
        <cftransaction>   
        	 <cfquery datasource="ftec" name="rsExiste">
                select * from FTPContratacionObserv
                where PCid= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#" voidnull>
            </cfquery>
            
            <cfif isdefined('rsExiste') and rsExiste.RecordCount GT 0>
                <cfquery datasource="ftec">
                    update FTPContratacionObserv set 
                    FTPCOcomentario = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.comentarios#" voidnull> 
                    where PCid= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#" voidnull>
                </cfquery>	
            <cfelse>
                <cfquery datasource="ftec">
                    insert into FTPContratacionObserv (PCid,FTPCOcomentario) values
                    (<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#" voidnull>,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.comentarios#" voidnull> )
                </cfquery>	
            </cfif>
		
        </cftransaction>
        <cfreturn>
	</cffunction>
</cfcomponent>