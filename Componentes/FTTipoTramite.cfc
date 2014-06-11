<cfcomponent name="FTTipoTramite"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Tramite        --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TTcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select TTid, TTcodigo, TTdescripcion, Ecodigo
				from <cf_dbdatabase table="FTTipoTramite" datasource="ftec">
				where TTcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.TTcodigo#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>
    
	<!--- *************************** --->
	<!--- Alta Tipos de Tramite 	--->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TTcodigo" 		required="true" 	type="string">
    	<cfargument name="TTdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTTipoTramite" datasource="ftec">(	  Ecodigo
                                                , TTcodigo
                                                , TTdescripcion
                                                )
                                        values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TTcodigo#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TTdescripcion#" 	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TTid, TTcodigo, TTdescripcion, Ecodigo
					from <cf_dbdatabase table="FTTipoTramite" datasource="ftec">
                    where TTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
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