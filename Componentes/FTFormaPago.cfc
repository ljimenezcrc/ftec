<cfcomponent name="FTFormaPago"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Tramite        --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="FPcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select FPid, FPcodigo, FPdescripcion, Ecodigo
				from <cf_dbdatabase table="FTFormaPago" datasource="ftec">
				where FPcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.FPcodigo#" voidnull>
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
        <cfargument name="FPcodigo" 		required="true" 	type="string">
    	<cfargument name="FPdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTFormaPago" datasource="ftec">(	  Ecodigo
                                                , FPcodigo
                                                , FPdescripcion
                                                )
                                        values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.FPcodigo#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.FPdescripcion#" 	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select FPid, FPcodigo, FPdescripcion, Ecodigo
					from <cf_dbdatabase table="FTFormaPago" datasource="ftec">
                    where FPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
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
        <cfargument name="FPcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTFormaPago" datasource="ftec">
                where Ecodigo = #Session.Ecodigo#
                	and FPcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.FPcodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Tipos de Tramite --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="FPid" 			required="true" 	type="numeric">
        <cfargument name="FPcodigo" 		required="true" 	type="string">
    	<cfargument name="FPdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTFormaPago" datasource="ftec"> set
	                     FPcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.FPcodigo#" 		voidnull>
                        , FPdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.FPdescripcion#" 	voidnull>
                where FPid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select FPid, FPcodigo, FPdescripcion, Ecodigo
					from <cf_dbdatabase table="FTFormaPago" datasource="ftec">
                    where FPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>