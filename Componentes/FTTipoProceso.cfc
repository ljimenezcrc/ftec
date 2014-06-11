<cfcomponent name="FTTipoProceso"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipos Proceso       --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TPcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select TPid, TPcodigo, TPdescripcion, Ecodigo
				from <cf_dbdatabase table="FTTipoProceso" datasource="ftec">
				where TPcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.TPcodigo#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>
    
	<!--- *************************** --->
	<!--- Alta Tipos Proceso  	--->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TTid" 			required="false" 	type="any">
        <cfargument name="TPcodigo" 		required="true" 	type="string">
    	<cfargument name="TPdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTTipoProceso" datasource="ftec">(	  Ecodigo
                								, TTid			
                                                , TPcodigo
                                                , TPdescripcion
                                                )
                                        values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                        		<cfif isdefined('Arguments.TTid')>
                                                	, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.TTid#" 		voidnull>
                                                <cfelse>
                                                	,null
                                                </cfif>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TPcodigo#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TPdescripcion#" 	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TPid, TPcodigo, TPdescripcion, Ecodigo
					from <cf_dbdatabase table="FTTipoProceso" datasource="ftec">
                    where TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>

    <!--- ********************* --->
	<!--- Baja Tipos Proceso  --->
	<!--- ********************* --->
    <cffunction access="public" name="Baja">
		<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TPcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTTipoProceso" datasource="ftec">
                where Ecodigo = #Session.Ecodigo#
                	and TPcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.TPcodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    
    <!--- *************************** --->
	<!--- Cambio Tipos Proceso --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TPid" 			required="true" 	type="numeric">
        <cfargument name="TTid" 			required="false" 	type="any">
        <cfargument name="TPcodigo" 		required="true" 	type="string">
    	<cfargument name="TPdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTTipoProceso" datasource="ftec"> set
                		<cfif isdefined('Arguments.TTid')>
                            TTid			=  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.TTid#" 		voidnull>
                        <cfelse>
                        	TTid			= null
                        </cfif>
                        , TPcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TPcodigo#" 		voidnull>
                        , TPdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TPdescripcion#" 	voidnull>
                where TPid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TPid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TPid, TPcodigo, TPdescripcion, Ecodigo
					from <cf_dbdatabase table="FTTipoProceso" datasource="ftec">
                    where TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TPid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>