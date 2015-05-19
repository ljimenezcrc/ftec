<cfcomponent name="FTFlujoTramite"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipos Proceso       --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TTid" 			required="false" 	type="numeric">
        <cfargument name="ETid" 			required="false" 	type="numeric">
        <cfargument name="FTpasoactual" 	required="false" 	type="numeric">
        <cfargument name="FTpasoaprueba" 	required="false" 	type="numeric">
        <cfargument name="FTpasorechaza" 	required="false" 	type="numeric">
        <cfargument name="FTpasoVB" 		required="false" 	type="numeric">
        <cfargument name="FTautoriza" 		required="false" 	type="numeric"  default="0"> 
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">    


        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select FTid, TTid, ETid, FTpasoactual, FTpasoaprueba, FTpasorechaza,FTautoriza,FTpasoVB
				from <cf_dbdatabase table="FTFlujoTramite" datasource="ftec">
				where TTid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TTid#" voidnull>
                 	and ETid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ETid#" voidnull>
                 	and FTpasoactual	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FTpasoactual#" voidnull>
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
        <cfargument name="TTid" 			required="false" 	type="numeric">
        <cfargument name="ETid" 			required="false" 	type="numeric">
        <cfargument name="FTpasoactual" 	required="true" 	type="numeric">
        <cfargument name="FTpasoaprueba" 	required="false" 	type="any" default="0">
        <cfargument name="FTpasorechaza" 	required="false" 	type="any" default="0">
        <cfargument name="FTpasoVB" 		required="false" 	type="numeric">
        <cfargument name="FTautoriza" 		required="false" 	type="numeric" default="0">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTFlujoTramite" datasource="ftec">(	   TTid
                                                , ETid
                                                , FTpasoactual
                                                , FTpasoaprueba
                                                , FTpasorechaza
                                                , FTautoriza
                                                , FTpasoVB
                                                )
                                        values(<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.TTid#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ETid#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FTpasoactual#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FTpasoaprueba#"	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FTpasorechaza#"	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FTautoriza#"	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FTpasoVB#"	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
        
        
           
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select FTid, TTid, ETid, FTpasoactual, FTpasoaprueba, FTpasorechaza, FTpasoVB
					from <cf_dbdatabase table="FTFlujoTramite" datasource="ftec">
                    where FTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
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
        <cfargument name="FTid" 			required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTFlujoTramite" datasource="ftec">
                where FTid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FTid#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Tipos Proceso --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="FTid" 			required="false" 	type="numeric">
        <cfargument name="TTid" 			required="false" 	type="numeric">
        <cfargument name="ETid" 			required="false" 	type="numeric">
        <cfargument name="FTpasoactual" 	required="false" 	type="numeric">
        <cfargument name="FTpasoaprueba"	required="false" 	type="any">
        <cfargument name="FTpasorechaza"	required="false" 	type="any">
        <cfargument name="FTpasoVB" 		required="false" 	type="any">
         <cfargument name="FTautoriza" 		required="false" 	type="any" default="0">
        
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> set
	                     FTpasoactual	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FTpasoactual#" 		voidnull>
                        , FTpasoaprueba = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FTpasoaprueba#" 	voidnull>
                        , FTpasorechaza = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FTpasorechaza#" 	voidnull>
                        , FTautoriza 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FTautoriza#" 	voidnull>
                        , FTpasoVB 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FTpasoVB#" 	voidnull>
                where FTid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FTid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select FTid, TTid, ETid, TAid, FTorden, FTpasoVB
					from <cf_dbdatabase table="FTFlujoTramite" datasource="ftec">
                    where FTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FTid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
    
    <cffunction access="public" name="AltaDFlujo" returntype="numeric">
        <cfargument name="FTid" 			required="true" 	type="numeric">
        <cfargument name="TAid" 			required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTDFlujoTramite" datasource="ftec">(FTid
                                                , TAid
                                                )
                                        values(<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.FTid#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TAid#" 	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
        
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select FTDid,FTid, TAid
					from <cf_dbdatabase table="FTDFlujoTramite" datasource="ftec">
                    where FTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    
    <cffunction access="public" name="BajaDFlujo">
        <cfargument name="FTDid" 			required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTDFlujoTramite" datasource="ftec">
                where FTDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FTDid#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    
    
</cfcomponent>