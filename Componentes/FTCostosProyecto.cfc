<cfcomponent name="FTCostosProyecto"  output="true">
	<!--- *************************** --->
	<!--- Lee  Costo de proyecto --->
	<!--- *************************** ---> 
	<cffunction access="public" name="Get" returntype="query">
    	<cfargument name="Ecodigo" 		required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Vid" 			required="true" 	type="numeric">
        <cfargument name="CAid"			required="true" 	type="numeric">
        <cfargument name="Debug"		required="false" 	type="boolean" 	default="false">        
        <cfquery name="rsGetTipo" datasource="#Session.DSN#">
			 select CPid, Vid, CAid, CPporcentaje, CPexoneracion, CPfdesde, CPfhasta, CPDistribuido, CPvalorcatalogo, Usucodigo
                from <cf_dbdatabase table="FTCostoProyecto" datasource="ftec">
				where Vid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Vid#" voidnull>
                    and CAid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CAid#" voidnull>
		</cfquery>

		<cfif Arguments.Debug>
			<cfdump var="#Arguments#">
			<cfdump var="#rsGetTipo#">
			<cfabort>
		</cfif>
		<cfreturn rsGetTipo>
	</cffunction>
    
    
    <cffunction access="public" name="AltaObligatorios">
	    <cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Vid"				required="true" 	type="numeric" default="0">
        <cfargument name="CPfdesde" 		required="true" 	type="date">
        <cfargument name="CPfhasta" 		required="true" 	type="date">
        <cfargument name="Usucodigo"		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
    
    	<cfquery name="rsCostosObligatorios" datasource="#Session.DSN#">
       		select CAid, CAcodigo, CAdescripcion, CAporcentaje, CAobligatorio, Ecodigo
            	from <cf_dbdatabase table="FTCostoAdmin" datasource="ftec">
                where CAobligatorio = 1
        </cfquery>

        <cfif isdefined('rsCostosObligatorios') and rsCostosObligatorios.RecordCount GT 0>
        	<cfloop query="rsCostosObligatorios">
                <cfinvoke component="ftec.Componentes.FTCostosProyecto" method="Alta"  returnvariable="Lvar_Iid">
                    <cfinvokeargument name="Vid" 				value="#Arguments.Vid#">
                    <cfinvokeargument name="CAid" 				value="#rsCostosObligatorios.CAid#">
                    <cfinvokeargument name="CPporcentaje" 		value="#rsCostosObligatorios.CAporcentaje#">
                    <cfinvokeargument name="CPexoneracion" 		value="0">
                    <cfinvokeargument name="CPfdesde" 			value="#Arguments.CPfdesde#">
                    <cfinvokeargument name="CPfhasta" 			value="#Arguments.CPfhasta#">
                    <cfinvokeargument name="CPDistribuido" 		value="0">
                    <cfinvokeargument name="CPvalorcatalogo" 	value="1">
                    <cfinvokeargument name="Debug" 				value="false">
                </cfinvoke>
            </cfloop>
        </cfif>
    </cffunction>
    
    
	<!--- *************************** --->
	<!--- Alta Costos de proyecto --->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="Vid"				required="true" 	type="numeric" default="0">
        <cfargument name="CAid"				required="true" 	type="numeric" default="0">
        <cfargument name="CPporcentaje"		required="true" 	type="numeric" default="0.00">
        <cfargument name="CPexoneracion"	required="true" 	type="numeric" default="0">
        <cfargument name="CPfdesde" 		required="true" 	type="date">
        <cfargument name="CPfhasta" 		required="true" 	type="date">
        <cfargument name="CPDistribuido"	required="true" 	type="numeric" default="0">
        <cfargument name="CPvalorcatalogo"	required="true" 	type="numeric" default="1">
        <cfargument name="Usucodigo"		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTCostoProyecto" datasource="ftec">( Vid
                                            , CAid
                                            , CPporcentaje
                                            , CPexoneracion
                                            , CPfdesde
                                            , CPfhasta
                                            , CPdistribuido
                                            , CPvalorcatalogo   
                                            , Usucodigo 
                                          )
                                        values(   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Vid#" 			voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CAid#" 			voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CPporcentaje#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CPexoneracion#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.CPfdesde#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.CPfhasta#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CPdistribuido#"  	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CPvalorcatalogo#" voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#"		voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select CPid, Vid, CAid, CPporcentaje, CPexoneracion, CPfdesde, CPfhasta, CPDistribuido, CPvalorcatalogo, Usucodigo
                	from <cf_dbdatabase table="FTCostoProyecto" datasource="ftec">
                    where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <!--- ********************* --->
	<!--- Baja Costos Proyecto  --->
	<!--- ********************* --->
    <cffunction access="public" name="Baja">
		<cfargument name="Ecodigo" 	required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="CPid" 	required="true" 	type="numeric" default="0">
        <cfargument name="Debug" 	required="false" 	type="boolean" 	default="false">     
        
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from <cf_dbdatabase table="FTCostoProyecto" datasource="ftec">
                where CPid 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CPid#" voidnull> 
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    <!--- *************************** --->
	<!--- Cambio Costos de Proyecto   --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="CPid"				required="true" 	type="numeric" default="0">
        <cfargument name="Vid"				required="true" 	type="numeric" default="0">
        <cfargument name="CAid"				required="true" 	type="numeric" default="0">
        <cfargument name="CPporcentaje"		required="true" 	type="numeric" default="0.00">
        <cfargument name="CPexoneracion"	required="true" 	type="numeric" default="0">
        <cfargument name="CPfdesde" 		required="true" 	type="date">
        <cfargument name="CPfhasta" 		required="true" 	type="date">
        <cfargument name="CPDistribuido"	required="true" 	type="numeric" default="0">
        <cfargument name="CPvalorcatalogo"	required="true" 	type="numeric" default="0">
        <cfargument name="Usucodigo"		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  


		<cfif isdefined('Arguments.CPDistribuido') and #Arguments.CPDistribuido# EQ 0>
            <cfquery name="rsGet" datasource="#Session.DSN#">
                 select CPDid, CPid, Vid, CPDporcentaje  
                    from <cf_dbdatabase table="FTCostoProyectoD" datasource="ftec">
                    where CPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CPid#" voidnull>
            </cfquery>
            
            <cfif isdefined('rsGet') and rsGet.RecordCount GT 0>
                <cfloop query="rsGet">
                    <cfinvoke component="ftec.Componentes.FTCostosProyectoD" method="Baja">
                        <cfinvokeargument name="CPDid" 		value="#rsGet.CPDid#">
                        <cfinvokeargument name="Debug"		value="false">
                    </cfinvoke>
                </cfloop>
            </cfif>
		</cfif>
        
        <cftransaction> 
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTCostoProyecto" datasource="ftec"> set
                    CPporcentaje		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CPporcentaje#" 	voidnull>
                    , CPexoneracion		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CPexoneracion#" 	voidnull>
                    , CPfdesde			= <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.CPfdesde#" 		voidnull>
                    , CPfhasta			= <cf_jdbcquery_param cfsqltype="cf_sql_date"		value="#Arguments.CPfhasta#" 		voidnull>
                    , CPDistribuido		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CPDistribuido#"  	voidnull>
                    , CPvalorcatalogo	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CPvalorcatalogo#" voidnull>
                    , Usucodigo 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#"		voidnull>
                where CPid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CPid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select CPid, Vid, CAid, CPporcentaje, CPexoneracion, CPfdesde, CPfhasta, CPDistribuido, CPvalorcatalogo, Usucodigo
                	from <cf_dbdatabase table="FTCostoProyecto" datasource="ftec">
                    where CPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CPid#" voidnull>
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>