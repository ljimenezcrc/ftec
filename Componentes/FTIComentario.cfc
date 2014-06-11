<cfcomponent name="FTIComentario"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Tramite        --->
	<!--- *************************** --->
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="ICcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			select ICid
                    ,Iid
                    ,ICfecha
                    ,ICfechadesde
                    ,ICfechahasta	
                    ,ICcodigo	
                    ,ICcomentario
                    ,ICperiodo
				from <cf_dbdatabase table="FTIComentario" datasource="ftec">
				where ICcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.ICcodigo#" voidnull>
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
        <cfargument name="ICfechadesde"	required="false" 	type="date">
        <cfargument name="ICfechahasta"	required="false" 	type="date">
        <cfargument name="ICperiodo"	required="false"	type="string">
        <cfargument name="ICcodigo" 	required="false" 	type="string">
        <cfargument name="ICcomentario" required="false" 	type="string">
        
        <cfargument name="Debug" 		required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTIComentario" datasource="ftec">( Iid
                                        ,ICfecha
                                        ,ICfechadesde
					                    ,ICfechahasta	
                                        ,ICcodigo	
                                        ,ICcomentario	
                                        ,ICperiodo	
                                        )
                                values(	  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Iid#"				voidnull>
                                        , <cf_dbfunction name="today">
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.ICfechadesde#"	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.ICfechahasta#"	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ICcodigo#" 		voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ICcomentario#" 	voidnull>
                                        , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ICperiodo#" 	voidnull>
                                        )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select ICid
                            ,Iid
                            ,ICfecha
                            ,ICfechadesde
		                    ,ICfechahasta	
                            ,ICcodigo	
                            ,ICcomentario
                            ,ICperiodo
                        from <cf_dbdatabase table="FTIComentario" datasource="ftec">
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
        <cfargument name="ICid" 			required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTIComentario" datasource="ftec">
                where ICid = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.ICid#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- **************************--->
	<!--- Cambio Indicador			--->
	<!--- **************************--->
   
	<cffunction access="public" name="Cambio">
        <cfargument name="ICid" 		required="true" 	type="numeric">
       	<cfargument name="Iid" 			required="false" 	type="numeric">
        <cfargument name="ICfechadesde"	required="false" 	type="date">
        <cfargument name="ICfechahasta"	required="false" 	type="date">
        <cfargument name="ICcodigo" 	required="false" 	type="string">
        <cfargument name="ICperiodo" 	required="false" 	type="string">
        <cfargument name="ICcomentario" required="false" 	type="string">

        <cfargument name="Debug" 		required="false" 	type="boolean" 	default="false">   
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTIComentario" datasource="ftec"> set
	                     ICcodigo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ICcodigo#"		voidnull>
                        ,ICcomentario	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ICcomentario#" 	voidnull>
                        ,ICfecha		= <cf_dbfunction name="today">
                        ,ICfechadesde	= <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.ICfechadesde#"	voidnull>
	                    ,ICfechahasta	= <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.ICfechahasta#"	voidnull>
                        ,ICperiodo		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.ICperiodo#"		voidnull>
                where ICid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"				value="#Arguments.ICid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select ICid
                            ,Iid
                            ,ICfecha
                            ,ICfechadesde
		                    ,ICfechahasta	
                            ,ICcodigo	
                            ,ICcomentario
                            ,ICperiodo
					from <cf_dbdatabase table="FTIComentario" datasource="ftec">
                    where ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ICid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
    
</cfcomponent>