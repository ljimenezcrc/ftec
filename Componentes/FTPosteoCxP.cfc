<cfcomponent name="FTPosteoCxP"  output="true">
	<!--- *************************** --->
	<!--- Alta Encabezado --->
	<!--- *************************** --->
	<cffunction access="public" name="Alta" returntype="numeric">
        <cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="CPTcodigo" 		required="false" 	type="string" >
        <cfargument name="EDdocumento" 		required="false" 	type="string" >
        <cfargument name="SNcodigo" 		required="false" 	type="numeric" >
        <cfargument name="Mcodigo" 			required="false" 	type="numeric" >
        <cfargument name="EDtipocambio" 	required="false" 	type="numeric" >
        <cfargument name="EDdescuento" 		required="false" 	type="numeric" >
        <cfargument name="EDporcdescuento" 	required="false" 	type="numeric" >
        <cfargument name="EDimpuesto" 		required="false" 	type="numeric" >
        <cfargument name="EDtotal" 			required="false" 	type="numeric" >
        <cfargument name="Ocodigo" 			required="false" 	type="numeric" >
        <cfargument name="Ccuenta" 			required="false" 	type="numeric" >
        <cfargument name="EDfecha" 			required="false" 	type="date" >
        <cfargument name="Rcodigo" 			required="false" 	type="string" default="-1" >
        <cfargument name="EDusuario" 		required="false" 	type="string" >
        <cfargument name="EDselect" 		required="false" 	type="numeric" >
        <cfargument name="EDdocref" 		required="false" 	type="numeric"  default="-1">
        <cfargument name="EDfechaarribo" 	required="false" 	type="date" >
        <cfargument name="id_direccion" 	required="false" 	type="numeric"  default="-1">
        <cfargument name="TESRPTCid" 		required="false" 	type="numeric"  default="-1">
        <cfargument name="BMUsucodigo" 		required="false" 	type="numeric"  default="#session.Usucodigo#">
        <cfargument name="TESRPTCietu" 		required="false" 	type="numeric" default="-1" >
        <cfargument name="folio" 			required="false" 	type="numeric" default="-1" >
        <cfargument name="EDvencimiento" 	required="false" 	type="date" >
        <cfargument name="EVestado" 		required="false" 	type="numeric"  default="-1">
        
        <cfargument name="SPid" 			required="true" 	type="numeric">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        <cfquery name="rsInsertEDocCP" datasource="#session.DSN#">
            insert into EDocumentosCxP (Ecodigo, CPTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio,
                                        EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha, 
                                        Rcodigo, EDusuario, EDselect, EDdocref, EDfechaarribo, id_direccion, TESRPTCid, BMUsucodigo,TESRPTCietu,
                                        folio,EDvencimiento,EVestado)
            values ( 	 #Session.Ecodigo# ,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.CPTcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.EDdocumento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.SNcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#Arguments.EDtipocambio#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Arguments.EDdescuento#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="0">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Arguments.EDimpuesto#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Arguments.EDtotal#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.Ocodigo#">, 
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ccuenta#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Arguments.EDfecha,'DD/MM/YYYY')#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Arguments.Rcodigo#" voidnull null="#Arguments.Rcodigo EQ -1#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Session.usuario#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="0">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Arguments.EDdocref#" voidnull null="#Arguments.EDdocref EQ -1#">,
                        <cfif isdefined("Arguments.EDfechaarribo") and len(trim(Arguments.EDfechaarribo))>
                            <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Arguments.EDfechaarribo,'DD/MM/YYYY')#">,
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Arguments.EDfecha,'DD/MM/YYYY')#">,  
                        </cfif>
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#" voidnull null="#Arguments.id_direccion EQ -1#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TESRPTCid#" voidnull null="#Arguments.TESRPTCid EQ -1#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
                        ,1
                        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Folio#" voidnull null="#Arguments.Folio EQ -1#"> 
                        ,<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSDateFormat(Arguments.EDvencimiento,'DD/MM/YYYY')#" voidnull>
                        ,<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.EVestado#" voidnull null="#Arguments.EVestado EQ -1#">
                        )
            <cf_dbidentity1 datasource="#session.DSN#">
        </cfquery>
   		<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertEDocCP" returnvariable="IdEDocCP">
            
		<cfset Lvar_Iid = rsInsertEDocCP.Identity>
        
        <cfquery name="rsInsertDDocCP" datasource="#session.DSN#">
            update EDocumentosCxP set EDtotal = EDtotal + EDimpuesto
                where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
        </cfquery>
        
        <cfquery name="rsInsertDDocCP" datasource="#session.DSN#">
            select a.SPid,a.Vid,a.Cid,a.Ecodigo,a.Icodigo,a.DSPid,
                a.DSPdocumento,a.DSPdescripcion,a.DSPobjeto,a.DSPmonto,a.DScambiopaso, c.CFid, a.Ccuenta, a.CFcuenta, Coalesce(a.DOlinea,-1) DOlinea
                from  <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> a
                inner join <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> b
                    on a.Vid =  b.Vid
                inner join CFuncional c
                    on b.CFid = c.CFid
                where a.SPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#">
        </cfquery>
        
        <cfloop query="rsInsertDDocCP">												
            <cfquery name="InsertDDocCP" datasource="#session.DSN#">
                insert into DDocumentosCxP 
                    (	IDdocumento,
                        Aid,
                        Cid,
                        DDdescripcion,
                        DDdescalterna,
                        CFid,
                        Alm_Aid,  
                        Dcodigo,
                        DDcantidad,
                        DDpreciou, 
                        DDdesclinea,
                        DDporcdesclin, 
                        DDtotallinea, 
                        DDtipo, 
                        Ccuenta,
                        CFcuenta,
                        Ecodigo, 
                        OCTtipo,
                        OCTtransporte,
                        OCTfechaPartida,
                        OCTobservaciones,
                        OCCid,
                        OCid,						
                        Icodigo,
                        BMUsucodigo,
                        DSespecificacuenta,
                        FPAEid,
                        CFComplemento,
						DOlinea)
                values	 (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsInsertDDocCP.Cid#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInsertDDocCP.DSPdescripcion#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsInsertDDocCP.CFid#">, 
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	
                    <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#rsInsertDDocCP.DSPmonto#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="0">, 
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="0">, 		
                    <cfqueryparam cfsqltype="cf_sql_money" value="#rsInsertDDocCP.DSPmonto#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="S">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsInsertDDocCP.Ccuenta#">, 
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsInsertDDocCP.CFcuenta#">, 
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
                    <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_char" value="#rsInsertDDocCP.Icodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    0,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertDDocCP.DOlinea#" null="#rsInsertDDocCP.DOlinea EQ -1#">
            ) 		
            </cfquery>
        </cfloop>

        <cfif Arguments.Debug>
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                select Ecodigo, CPTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio,
                        EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha, 
                        Rcodigo, EDusuario, EDselect, EDdocref, EDfechaarribo, id_direccion, TESRPTCid, BMUsucodigo,TESRPTCietu,
                        folio,EDvencimiento,EVestado
                from EDocumentosCxP
                where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
            </cfquery>
            <cfdump var="#Arguments#">
            <cfdump var="#rsDebug#">
            <cfabort>
        </cfif>
    	<cfreturn Lvar_Iid>
	</cffunction>

</cfcomponent>