<cfcomponent name="FTCostosAdmin"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="CAcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			 select CAid, CAcodigo, CAdescripcion, CAporcentaje, CAobligatorio, Ecodigo
                from <cf_dbdatabase table="FTCostoAdmin" datasource="ftec">
				where CAcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.CAcodigo#" voidnull>
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
        <cfargument name="CAcodigo" 		required="true" 	type="string">
    	<cfargument name="CAdescripcion" 	required="true" 	type="string">
        <cfargument name="CAporcentaje"		required="true" 	type="numeric" default="0.00">
        <cfargument name="CAobligatorio"	required="true" 	type="numeric" default="0">
        <cfargument name="Usucodigo" 		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTCostoAdmin" datasource="ftec">(	  Ecodigo
                                                , CAcodigo
                                                , CAdescripcion
                                                , CAporcentaje
                                                , CAobligatorio
                                                , Usucodigo
                                                )
                                        values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.CAcodigo#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.CAdescripcion#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.CAporcentaje#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.CAobligatorio#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#"  		voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select CAid, CAcodigo, CAdescripcion, CAporcentaje, CAobligatorio, Ecodigo
                    from <cf_dbdatabase table="FTCostoAdmin" datasource="ftec">
                    where CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
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
        <cfargument name="CAcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTCostoAdmin" datasource="ftec">
                where Ecodigo = #Session.Ecodigo#
                	and CAcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.CAcodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Tipos de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="CAid" 			required="true" 	type="numeric">
        <cfargument name="CAcodigo" 		required="true" 	type="string">
    	<cfargument name="CAdescripcion" 	required="true" 	type="string">
        <cfargument name="CAporcentaje" 	required="true" 	type="numeric" default="0.00">
        <cfargument name="CAobligatorio" 	required="true" 	type="numeric" default="0">
        <cfargument name="Usucodigo" 		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTCostoAdmin" datasource="ftec"> set
	                     CAcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.CAcodigo#" 		voidnull>
                        , CAdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.CAdescripcion#" 	voidnull>
                        , CAporcentaje	= <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.CAporcentaje#" 		voidnull>
                        , CAobligatorio	= <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.CAobligatorio#" 		voidnull>
                        , Usucodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#"  		voidnull>
                where CAid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CAid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select CAid, CAcodigo, CAdescripcion, CAporcentaje, CAobligatorio, Ecodigo
                    from <cf_dbdatabase table="FTCostoAdmin" datasource="ftec">
                    where CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>