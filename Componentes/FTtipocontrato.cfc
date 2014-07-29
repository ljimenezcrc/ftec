<cfcomponent name="FTtipocontrato"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de contrato        --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TCcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select TCid, TCcodigo, TCdescripcion, Ecodigo
				from <cf_dbdatabase table="FTtipocontrato" datasource="ftec">
				where TCcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.TCcodigo#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>
    
	<!--- *************************** --->
	<!--- Alta Tipos de contrato 	--->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TCcodigo" 		required="true" 	type="string">
    	<cfargument name="TCdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTtipocontrato" datasource="ftec">(	  Ecodigo
                                                , TCcodigo
                                                , TCdescripcion
                                                )
                                        values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TCcodigo#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TCdescripcion#" 	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TCid, TCcodigo, TCdescripcion, Ecodigo
					from <cf_dbdatabase table="FTtipocontrato" datasource="ftec">
                    where TCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <!--- ********************* --->
	<!--- Baja tipo contrato --->
	<!--- ********************* --->
    <cffunction access="public" name="Baja">
		<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TCcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTtipocontrato" datasource="ftec">
                where Ecodigo = #Session.Ecodigo#
                	and TCcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.TCcodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Tipos de contrato --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TCid" 			required="true" 	type="numeric">
        <cfargument name="TCcodigo" 		required="true" 	type="string">
    	<cfargument name="TCdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTtipocontrato" datasource="ftec"> set
	                     TCcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TCcodigo#" 		voidnull>
                        , TCdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TCdescripcion#" 	voidnull>
                where TCid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TCid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TCid, TCcodigo, TCdescripcion, Ecodigo
					from <cf_dbdatabase table="FTtipocontrato" datasource="ftec">
                    where TCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TCid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>