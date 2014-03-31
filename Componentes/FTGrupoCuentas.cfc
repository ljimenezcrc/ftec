<cfcomponent name="FTGrupoCuentas"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Tramite        --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="GCcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select GCid, Iid, GCcodigo, GCdescripcion
				from <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec">
				where GCcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.GCcodigo#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>

	<!--- *************************** --->
	<!--- Alta Indicador			  --->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
        <cfargument name="Iid" 			required="false" 	type="numeric">
        <cfargument name="GCcodigo" 		required="false" 	type="string">
        <cfargument name="GCdescripcion"	required="false"	type="string">
        
        <cfargument name="Debug" 		required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec">( Iid
                                        , GCcodigo
                                        , GCdescripcion	
                                        )
                                values(	  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Iid#"				voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.GCcodigo#" 		voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.GCdescripcion#" 	voidnull>
                                        )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select GCid, Iid, GCcodigo, GCdescripcion
                        from <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec">
                    where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <!--- ********************* --->
	<!--- Baja Indicador 		--->
	<!--- ********************* --->
    <cffunction access="public" name="Baja">
        <cfargument name="GCid" 			required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec">
                where GCid = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.GCid#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- **************************--->
	<!--- Cambio Indicador			--->
	<!--- **************************--->
   
	<cffunction access="public" name="Cambio">
        <cfargument name="GCid" 		required="true" 	type="numeric">
       	<cfargument name="Iid" 			required="false" 	type="numeric">
        <cfargument name="GCcodigo" 	required="false" 	type="string">
        <cfargument name="GCdescripcion" 	required="false" 	type="string">

        <cfargument name="Debug" 		required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec"> set
	                     GCcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.GCcodigo#"		voidnull>
                        ,GCdescripcion	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.GCdescripcion#" 	voidnull>
                where GCid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"				value="#Arguments.GCid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select GCid, Iid, GCcodigo, GCdescripcion
                        from <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec">
					from <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec">
                    where GCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GCid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
    
</cfcomponent>