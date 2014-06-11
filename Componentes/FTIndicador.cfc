<cfcomponent name="FTIndicador"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Tramite        --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Icodigo" 			required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select Iid
                    ,Ecodigo
                    ,Icodigo	
                    ,Idescripcion	
                    ,Ifecha	
                    ,Iformacalculo	
                    ,Iperiodicidad	
                    ,Ifuente	
                    ,Iresponsable	
                    ,Iformapresenta	
                    ,Iusos	
                    ,Inivelagrega	
                    ,Irotroproceso	
                    ,Ivalormeta	
                    ,Irangoacepta	
                    ,Iobservacion
				from <cf_dbdatabase table="FTIndicador" datasource="ftec">
				where Icodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Icodigo#" voidnull>
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
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Icodigo" 			required="false" 	type="string">
        <cfargument name="Idescripcion" 	required="false" 	type="string">
        <cfargument name="Ifecha" 			required="false" 	type="date" >
        <cfargument name="Iformacalculo" 	required="false" 	type="string">
        <cfargument name="Iperiodicidad" 	required="false" 	type="string">
        <cfargument name="Ifuente" 			required="false" 	type="string">
        <cfargument name="Iresponsable" 	required="false" 	type="string">
        <cfargument name="Iformapresenta" 	required="false" 	type="string">
        <cfargument name="Iusos" 			required="false" 	type="string">
        <cfargument name="Inivelagrega" 	required="false" 	type="string">
        <cfargument name="Irotroproceso" 	required="false" 	type="string">
        <cfargument name="Ivalormeta" 		required="false" 	type="string">
        <cfargument name="Irangoacepta" 	required="false" 	type="string">
        <cfargument name="Iobservacion" 	required="false" 	type="string">
        
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTIndicador" datasource="ftec">( Ecodigo
                                        ,Icodigo	
                                        ,Idescripcion	
                                        ,Ifecha	
                                        ,Iformacalculo	
                                        ,Iperiodicidad	
                                        ,Ifuente	
                                        ,Iresponsable	
                                        ,Iformapresenta	
                                        ,Iusos	
                                        ,Inivelagrega	
                                        ,Irotroproceso	
                                        ,Ivalormeta	
                                        ,Irangoacepta	
                                        ,Iobservacion 
                                        )
                                values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Icodigo#"			voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Idescripcion#" 	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#Arguments.Ifecha#"			voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iformacalculo#" 	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iperiodicidad#"	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Ifuente#" 		voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iresponsable#"	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iformapresenta#"	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iusos#" 			voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Inivelagrega#"	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Irotroproceso#" 	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Ivalormeta#"		voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Irangoacepta#" 	voidnull>
										, <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iresponsable#" 	voidnull>
                                        )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select Iid
                        ,Ecodigo
                        ,Icodigo	
                        ,Idescripcion	
                        ,Ifecha	
                        ,Iformacalculo	
                        ,Iperiodicidad	
                        ,Ifuente	
                        ,Iresponsable	
                        ,Iformapresenta	
                        ,Iusos	
                        ,Inivelagrega	
                        ,Irotroproceso	
                        ,Ivalormeta	
                        ,Irangoacepta	
                        ,Iobservacion
                        from <cf_dbdatabase table="FTIndicador" datasource="ftec">
                    where LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
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
		<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Icodigo" 			required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTIndicador" datasource="ftec">
                where Ecodigo = #Session.Ecodigo#
                	and Icodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Icodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- **************************--->
	<!--- Cambio Indicador			--->
	<!--- **************************--->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Iid" 				required="true" 	type="numeric">
       	<cfargument name="Icodigo" 			required="false" 	type="string">
        <cfargument name="Idescripcion" 	required="false" 	type="string">
        <cfargument name="Ifecha" 			required="false" 	type="date">
        <cfargument name="Iformacalculo" 	required="false" 	type="string">
        <cfargument name="Iperiodicidad" 	required="false" 	type="string">
        <cfargument name="Ifuente" 			required="false" 	type="string">
        <cfargument name="Iresponsable" 	required="false" 	type="string">
        <cfargument name="Iformapresenta" 	required="false" 	type="string">
        <cfargument name="Iusos" 			required="false" 	type="string">
        <cfargument name="Inivelagrega" 	required="false" 	type="string">
        <cfargument name="Irotroproceso" 	required="false" 	type="string">
        <cfargument name="Ivalormeta" 		required="false" 	type="string">
        <cfargument name="Irangoacepta" 	required="false" 	type="string">
        <cfargument name="Iobservacion" 	required="false" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTIndicador" datasource="ftec"> set
	                     Icodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Icodigo#"			voidnull>
                        ,Idescripcion	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Idescripcion#" 	voidnull>
                        ,Ifecha			= <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#Arguments.Ifecha#"			voidnull>
                        ,Iformacalculo	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iformacalculo#" 	voidnull>
                        ,Iperiodicidad	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iperiodicidad#"	voidnull>
                        ,Ifuente		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Ifuente#" 		voidnull>
                        ,Iresponsable	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iresponsable#"	voidnull>
                        ,Iformapresenta	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iformapresenta#"	voidnull>
                        ,Iusos			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iusos#" 			voidnull>
                        ,Inivelagrega	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Inivelagrega#"	voidnull>
                        ,Irotroproceso	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Irotroproceso#" 	voidnull>
                        ,Ivalormeta		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Ivalormeta#"		voidnull>
                        ,Irangoacepta	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Irangoacepta#" 	voidnull>
                        ,Iobservacion   = <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Iresponsable#" 	voidnull>
                where Iid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Iid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select Iid
                        ,Ecodigo
                        ,Icodigo	
                        ,Idescripcion	
                        ,Ifecha	
                        ,Iformacalculo	
                        ,Iperiodicidad	
                        ,Ifuente	
                        ,Iresponsable	
                        ,Iformapresenta	
                        ,Iusos	
                        ,Inivelagrega	
                        ,Irotroproceso	
                        ,Ivalormeta	
                        ,Irangoacepta	
                        ,Iobservacion
					from <cf_dbdatabase table="FTIndicador" datasource="ftec">
                    where LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LPid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>