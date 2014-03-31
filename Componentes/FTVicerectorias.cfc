<cfcomponent name="FTVicerectorias"  output="true">
	<!--- *************************** --->
	<!--- Lee  Tipo de Autorizadores --->
	<!--- *************************** --->

	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Vcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			 select Ecodigo, Vcodigo, Vdescripcion, Vpadre, CFid, Vesproyecto, Vfinicio, Vffinal, Vestado, Mcodigo, Vmonto
                from FTVicerrectoria
				where Vcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Vcodigo#" voidnull>
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
        <cfargument name="Vcodigo" 			required="true" 	type="string">
    	<cfargument name="Vdescripcion" 	required="true" 	type="string">
        <cfargument name="Vpadre"			required="false" 	type="any" default="">
        <cfargument name="CFid" 			required="false" 	type="numeric">
  <!--- <cfargument name="Vctaingreso" 		required="true" 	type="string">
        <cfargument name="Vctagasto" 		required="true" 	type="string">
        <cfargument name="Vctasaldoinicial" required="true" 	type="string">--->
        <cfargument name="Vesproyecto"		required="true" 	type="numeric" default="0">
        <cfargument name="Vfinicio" 		required="true" 	type="date">
        <cfargument name="Vffinal" 			required="true" 	type="date">
        <cfargument name="Vestado"			required="true" 	type="numeric" default="0">
        <cfargument name="Mcodigo"			required="true" 	type="numeric" default="0">
        <cfargument name="Vmonto"			required="true" 	type="numeric" default="0.00">
        <cfargument name="Usucodigo" 		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  

        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into FTVicerrectoria(	  
                                              Ecodigo
                                            , Vcodigo
                                            , Vdescripcion
                                            , Vpadre
                                            , CFid
                                            <!---, Vctaingreso
                                            , Vctagasto
                                            , Vctasaldoinicial--->
                                            , Vesproyecto
                                            , Vfinicio
                                            , Vffinal
                                            , Vestado
                                            , Mcodigo
                                            , Vmonto
                                            , Usucodigo                
                                            )
                                    values(	  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Vcodigo#" 		voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Vdescripcion#" 	voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vpadre#" 			voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CFid#" 			voidnull>
                                            <!---, <cf_jdbcquery_param cfsqltype="cf_sql_char"		value="#Arguments.Vctaingreso#"		voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_char"		value="#Arguments.Vctagasto#"  		voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Vctasaldoinicial#"voidnull>--->
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Vesproyecto#" 	voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.Vfinicio#" 		voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.Vffinal#"			voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vestado#"  		voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Mcodigo#"  		voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.Vmonto#"  		voidnull>
                                            , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#"  		voidnull>
                                            
                                            )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select Ecodigo, Vcodigo, Vdescripcion, Vpadre, CFid, Vesproyecto, Vfinicio, Vffinal, Vestado, Mcodigo, Vmonto
                    from FTVicerrectoria
                    where Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
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
        <cfargument name="Vcodigo" 		required="true" 	type="string">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from FTVicerrectoria
                where Ecodigo = #Session.Ecodigo#
                	and Vcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Vcodigo#" voidnull>
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Tipos de Autorizadores --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	
        <cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Vid" 				required="true" 	type="numeric">
        <cfargument name="Vcodigo" 			required="true" 	type="string">
    	<cfargument name="Vdescripcion" 	required="true" 	type="string">
        <cfargument name="Vpadre"			required="false" 	type="any" default="">
        <cfargument name="CFid" 			required="false" 	type="numeric">
        
        <cfargument name="Vesproyecto"		required="true" 	type="numeric" default="0">
        <cfargument name="Vfinicio" 		required="false" 	type="any">
        <cfargument name="Vffinal" 			required="false" 	type="any">
        <cfargument name="Vestado"			required="false" 	type="any" default="0">
        <cfargument name="Mcodigo"			required="false" 	type="any" default="0">
        <cfargument name="Vmonto"			required="false" 	type="any" default="0.00">
        <cfargument name="Usucodigo" 		required="false" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update FTVicerrectoria set
                          Vcodigo			= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Vcodigo#" 		voidnull>
                        , Vdescripcion		= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Vdescripcion#" 	voidnull>
                        , Vpadre			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vpadre#" 			voidnull>
                        , CFid				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CFid#" 			voidnull>
                        <!---, Vctaingreso		= <cf_jdbcquery_param cfsqltype="cf_sql_char"		value="#Arguments.Vctaingreso#"		voidnull>
                        , Vctagasto			= <cf_jdbcquery_param cfsqltype="cf_sql_char"		value="#Arguments.Vctagasto#"  		voidnull>
                        , Vctasaldoinicial	= <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Vctasaldoinicial#"voidnull>--->
                        , Vesproyecto		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Vesproyecto#" 	voidnull>
                        <cfif isdefined('Arguments.Vesproyecto') and Arguments.Vesproyecto EQ 1>
                            , Vfinicio			= <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.Vfinicio#" 		voidnull>
                            , Vffinal			= <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.Vffinal#"			voidnull>
                            , Vestado			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vestado#"  		voidnull>
                            , Mcodigo			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Mcodigo#"  		voidnull>
                            , Vmonto			= <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.Vmonto#"  		voidnull>
                        <cfelse>
                        	, Vfinicio			= null
                            , Vffinal			= null
                            , Vestado			= 0
                            , Mcodigo			= null
                            , Vmonto			= null
                        </cfif>
                        , Usucodigo			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#"  		voidnull>
                where Vid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select Ecodigo, Vcodigo, Vdescripcion, Vpadre, CFid, Vesproyecto, Vfinicio, Vffinal, Vestado, Mcodigo, Vmonto
                    from FTVicerrectoria
                    where Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Vid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>