﻿<cfcomponent name="FTAutorizador"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 		required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="TAid" 		required="true" 	type="numeric">
        <cfargument name="Vid" 			required="true" 	type="numeric">
        <cfargument name="Usucodigo" 	required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			 select TAid, Vid, Usucodigo, Afdesde, Afhasta, Ecodigo, Ainactivo, TAresponsable
                from FTAutorizador
				where TAid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TAid#" voidnull>
                	and Vid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Vid#" voidnull>
                    and Usucodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>
    

<!---TAid, Vid, Usucodigo, Afdesde, Afhasta, Ecodigo, Ainactivo, TAresponsable

    
TAid
Vid
Usucodigo
Afdesde
Afhasta
Ecodigo
Ainactivo
TAresponsable--->
    
	<!--- *************************** --->
	<!--- Alta Tipos de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Vid"				required="true" 	type="numeric" default="0">
        <cfargument name="Usucodigo"		required="true" 	type="numeric" default="0">
        <cfargument name="Afdesde" 			required="true" 	type="date">
        <cfargument name="Afhasta" 			required="true" 	type="date">
        <cfargument name="Ainactivo"		required="true" 	type="numeric" default="0">
        <cfargument name="TAresponsable"	required="true" 	type="numeric" default="0">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into FTCostoAdmin(	  Ecodigo
                                            , Vid
                                            , Usucodigo
                                            , Afdesde
                                            , Afhasta
                                            , Ainactivo
                                            , TAresponsable
                                                )
                                        values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Vid#" 			voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Usucodigo#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.Afdesde#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.Afhasta#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Ainactivo#"  		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TAresponsable#"	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TAid, Vid, Usucodigo, Afdesde, Afhasta, Ecodigo, Ainactivo, TAresponsable
                	from FTAutorizador
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
        <cfargument name="TAid" 			required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from FTAutorizador
                where Ecodigo = #Session.Ecodigo#
                    and TAid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CAcodigo#" voidnull> 
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
        <cfargument name="Vid"				required="true" 	type="numeric" default="0">
        <cfargument name="Usucodigo"		required="true" 	type="numeric" default="0">
        <cfargument name="Afdesde" 			required="true" 	type="date">
        <cfargument name="Afhasta" 			required="true" 	type="date">
        <cfargument name="Ainactivo"		required="true" 	type="numeric" default="0">
        <cfargument name="TAresponsable"	required="true" 	type="numeric" default="0">
        
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update FTAutorizador set
                      Afdesde 	  = <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.Afdesde#" 		voidnull>
                    , Afhasta	 	  = <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.Afhasta#" 		voidnull>
                    , Ainactivo 	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Ainactivo#"  		voidnull>
                    , TAresponsable = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TAresponsable#"	voidnull>
                where TAid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TAid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select TAid, Vid, Usucodigo, Afdesde, Afhasta, Ecodigo, Ainactivo, TAresponsable
                	from FTAutorizador
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