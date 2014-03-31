<cfcomponent name="FTEstadoTramite"  output="true">
	<!--- *************************** --->
	<!--- Lee  Estado de Tramite      --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="ETcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select ETid, ETcodigo, ETdescripcion, Ecodigo
				from FTEstadoTramite
				where ETcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.ETcodigo#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>
    
	<!--- *************************** --->
	<!--- Alta Estado de Tramite 	--->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="ETcodigo" 		required="true" 	type="string">
    	<cfargument name="ETdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into FTEstadoTramite(	  Ecodigo
                                                , ETcodigo
                                                , ETdescripcion
                                                )
                                        values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ETcodigo#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ETdescripcion#" 	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select ETid, ETcodigo, ETdescripcion, Ecodigo
					from FTEstadoTramite
                    where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <!--- ********************* --->
	<!--- Baja Estado Tramite --->
	<!--- ********************* --->
    <cffunction access="public" name="Baja">
		<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="ETcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from FTEstadoTramite
                where Ecodigo = #Session.Ecodigo#
                	and ETcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.ETcodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Estado de Tramite --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="ETid" 			required="true" 	type="numeric">
        <cfargument name="ETcodigo" 		required="true" 	type="string">
    	<cfargument name="ETdescripcion" 	required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update FTEstadoTramite set
	                     ETcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ETcodigo#" 		voidnull>
                        , ETdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ETdescripcion#" 	voidnull>
                where ETid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.ETid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select ETid, ETcodigo, ETdescripcion, Ecodigo
					from FTEstadoTramite
                    where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>