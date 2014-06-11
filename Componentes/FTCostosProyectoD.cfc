<cfcomponent name="FTCostosProyectoD"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Autorizadores --->
	<!--- *************************** ---> 
	<cffunction access="public" name="Get" returntype="query">
        <cfargument name="CPid" 		required="true" 	type="numeric">
        <cfargument name="Vid" 			required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			 select CPDid, CPid, Vid, CPDporcentaje  
                from <cf_dbdatabase table="FTCostoProyectoD" datasource="ftec">
				where CPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CPid#" voidnull>
                    and Vid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Vid#" voidnull>
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
        <cfargument name="CPid"				required="true" 	type="numeric" default="0">
        <cfargument name="Vid"				required="true" 	type="numeric" default="0">
        <cfargument name="CPDporcentaje"	required="true" 	type="numeric" default="0.00">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTCostoProyectoD" datasource="ftec"> (	CPid
                                            	, Vid
                                            	, CPDporcentaje 
                                          	)
                                        values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CPid#" 			voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"value="#Arguments.Vid#" 			voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Arguments.CPDporcentaje#" 	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select CPDid, CPid, Vid, CPDporcentaje  
                    from <cf_dbdatabase table="FTCostoProyectoD" datasource="ftec">
                    where CPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
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
        <cfargument name="CPDid" 			required="true" 	type="numeric" default="0">
        <cfargument name="CPid" 			required="false" 	type="numeric" default="0">
        <cfargument name="Vid"				required="false" 	type="numeric" default="0">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTCostoProyectoD" datasource="ftec">
                where  CPDid 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CPDid#" voidnull> 
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    
    <!--- *************************** --->
	<!--- Cambio Tipos de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="CPDid" 			required="true" 	type="numeric">
        <cfargument name="CPid" 			required="true" 	type="numeric">
        <cfargument name="Vid"				required="true" 	type="numeric" default="0">
        <cfargument name="CPDporcentaje"	required="true" 	type="numeric" default="0.00">
        
        
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTCostoProyectoD" datasource="ftec"> set
                      CPid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CPid#" 		voidnull>
                    , Vid 	  			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vid#" 		voidnull>
                    , CPDporcentaje	   	= <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.CPDporcentaje#" 		voidnull>
                where CPDid=  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CPDid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select CPDid, CPid, Vid, CPDporcentaje  
                    from <cf_dbdatabase table="FTCostoProyectoD" datasource="ftec">
                    where CPDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CPDid#" voidnull> 
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>