<cfcomponent name="FTTipoAutorizador"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TAcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select TAid, TAcodigo, TAdescripcion, TAmontomin, TAmontomax, Ecodigo
				from FTTipoAutorizador
				where TAcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.TAcodigo#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>
    
    
	<!--- *************************** --->
	<!--- Alta Tipos de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TAcodigo" 		required="true" 	type="string">
    	<cfargument name="TAdescripcion" 	required="true" 	type="string">
        <cfargument name="TAmontomin" 		required="true" 	type="numeric" default="0.00">
        <cfargument name="TAmontomax" 		required="true" 	type="numeric" default="0.00">
        <cfargument name="Usucodigo" 		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into FTTipoAutorizador(	  Ecodigo
                                                , TAcodigo
                                                , TAdescripcion
                                                , TAmontomin
                                                , TAmontomax
                                                , Usucodigo
                                                )
                                        values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TAcodigo#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TAdescripcion#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.TAmontomin#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.TAmontomax#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#"  		voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TAid, TAcodigo, TAdescripcion, TAmontomin, TAmontomax, Ecodigo
                    from FTTipoAutorizador
                    where TAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <!--- ********************* --->
	<!--- Baja tipo Autorizador --->
	<!--- ********************* --->
    <cffunction access="public" name="Baja">
		<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TAcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from FTTipoAutorizador
                where Ecodigo = #Session.Ecodigo#
                	and TAcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.TAcodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Tipos de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TAid" 			required="true" 	type="numeric">
        <cfargument name="TAcodigo" 		required="true" 	type="string">
    	<cfargument name="TAdescripcion" 	required="true" 	type="string">
        <cfargument name="TAmontomin" 		required="true" 	type="numeric" default="0.00">
        <cfargument name="TAmontomax" 		required="true" 	type="numeric" default="0.00">
        <cfargument name="Usucodigo" 		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update FTTipoAutorizador set
	                     TAcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TAcodigo#" 		voidnull>
                        , TAdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.TAdescripcion#" 	voidnull>
                        , TAmontomin	= <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.TAmontomin#" 		voidnull>
                        , TAmontomax	= <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.TAmontomax#" 		voidnull>
                        , Usucodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#"  		voidnull>
                where TAid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TAid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TAid, TAcodigo, TAdescripcion, TAmontomin, TAmontomax, Ecodigo
                    from FTTipoAutorizador
                    where TAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>