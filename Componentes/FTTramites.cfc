<cfcomponent name="FTTramites"  output="true">
	<!--- *************************** --->
	<!--- Aplica Tramite  --->
	<!--- *************************** --->
    <cffunction access="public" name="AplicaTramite">
		<cfargument name="SPid"				required="true" 	type="any">
        <cfargument name="TPid"				required="true" 	type="any">
        <cfargument name="HTcompleto"		required="no" 		type="any">
        <cfargument name="Aprueba"			required="true" 	type="any">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        <cfquery name="rsSiguientePasoH" datasource="#Session.DSN#">
            select Usucodigo,HTfecha ETid,TPid,SPid,HTpasosigue
                from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec">
                where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SPid#">
                and  HTfecha = (select max(a.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> a 
                				where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SPid#"> 
                                	and HTcompleto = 1
                                )
        </cfquery>
 
        
        <cfif isdefined('rsSiguientePasoH') and rsSiguientePasoH.recordCount EQ 0>
        	<cfquery name="rsSiguientePaso" datasource="#Session.DSN#">
                select top(1) c.ETid, a.TPid, a.SPid, 
                	<cfif Arguments.Aprueba EQ 1>
                    	c.FTpasoaprueba 
                    <cfelse>
                    	c.FTpasorechaza 
                    </cfif> as PasoSigue
                    from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> a
                        inner join <cf_dbdatabase table="FTTipoProceso" datasource="ftec"> b
                            on a.TPid = b.TPid
                    inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c
                        on b.TTid = c.TTid
                where a.SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SPid#">
                order by c.FTpasoactual asc
             </cfquery>
        <cfelse>
        	<cfquery name="rsSiguientePaso" datasource="#Session.DSN#">
                select c.ETid, a.TPid, a.SPid, 
                	<cfif Arguments.Aprueba EQ 1>
                    	c.FTpasoaprueba 
                    <cfelse>
                    	c.FTpasorechaza 
                    </cfif> as PasoSigue
                		,c.*
                    from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> a
                        inner join <cf_dbdatabase table="FTTipoProceso" datasource="ftec"> b
                            on a.TPid = b.TPid
                    inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c
                        on b.TTid = c.TTid
                where a.SPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SPid#">
                	and c.FTpasoactual = #rsSiguientePasoH.HTpasosigue#
                order by c.FTpasoactual asc
             </cfquery>
        </cfif>
        
        <cfif isdefined('rsSiguientePaso') and rsSiguientePaso.recordCount EQ 1>
<!---   <cfdump var="#rsSiguientePaso#">  --->
            <cfquery name="rsDetallesAplicar" datasource="#Session.DSN#">
                select  a.TPid, a.SPid, b.DSPid
                    from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> a
                        inner join <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> b
                            on a.SPid = b.SPid
                            and coalesce(b.DScambiopaso,0) = 0
                            <cfif isdefined('form.Tramite') and len(#form.Tramite#) GT 0>
                            	and b.Vid in (
                                            select e1.Vid
                                            from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> a1
                                                inner join <cf_dbdatabase table="FTTipoProceso" datasource="ftec"> b1
                                                    on a1.TPid = b1.TPid
                                                inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c1
                                                    on b1.TTid = c1.TTid
                                                inner join <cf_dbdatabase table="FTDFlujoTramite" datasource="ftec"> d1
                                                    on c1.FTid = d1.FTid
                                                inner join <cf_dbdatabase table="FTAutorizador" datasource="ftec"> e1
                                                    on d1.TAid = e1.TAid
                                                    and e1.Vid in (select b.Vid
                                                                    from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> a
                                                                    where a.SPid = a.SPid)
                                                    and a1.HTpasosigue = c1.FTpasoactual
                                                    and e1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
                                            where a1.SPid = a.SPid 
                                                and a1.HTfecha = (select max(b11.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> b11 where b11.SPid = a1.SPid and HTcompleto = 1)
                                            )
                            </cfif>
                where a.SPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSiguientePaso.SPid#">
             </cfquery>
             
             <!---<cf_dump var="#rsDetallesAplicar#">--->
             <cfloop query="rsDetallesAplicar"> 
                <cfinvoke component="ftec.Componentes.FTTramites" method="AltaHTramite" >
                    <cfinvokeargument name="ETid" 			value="#rsSiguientePaso.ETid#">
                    <cfinvokeargument name="TPid" 			value="#rsSiguientePaso.TPid#">
                    <cfinvokeargument name="SPid"			value="#rsSiguientePaso.SPid#">
                    <cfinvokeargument name="DSPid"			value="#rsDetallesAplicar.DSPid#">
                    <cfinvokeargument name="HTpasosigue"	value="#rsSiguientePaso.PasoSigue#">
                    <cfinvokeargument name="Debug"			value="false">
                </cfinvoke>
               </cfloop>
               <cfquery name="rsCambioPaso" datasource="#Session.DSN#" result="res">
               		select 1
                    from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec">
                    where SPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#">
                    and coalesce(DScambiopaso,0) = 0
               </cfquery>
               <cfif isdefined('rsCambioPaso') and rsCambioPaso.RecordCount EQ 0>
                   <cfinvoke component="ftec.Componentes.FTTramites" method="AltaHTramite" >
                        <cfinvokeargument name="ETid" 			value="#rsSiguientePaso.ETid#">
                        <cfinvokeargument name="TPid" 			value="#rsSiguientePaso.TPid#">
                        <cfinvokeargument name="SPid"			value="#rsSiguientePaso.SPid#">
                        <cfinvokeargument name="HTcompleto"			value="1">
                        <cfinvokeargument name="HTpasosigue"	value="#rsSiguientePaso.PasoSigue#">
                        <cfinvokeargument name="Debug"			value="false">
                    </cfinvoke>
                    
                    <cfquery name="rsPostearEcabezado" datasource="#Session.DSN#">
                        select * 
                        from  <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec">
                        where SPid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#">
                        and HTcompleto = 1
                        and HTpasosigue = 0
                    </cfquery>

                    <cfif isdefined('rsPostearEcabezado') and rsPostearEcabezado.RecordCount EQ 1>
                        <cfquery name="rsSP" datasource="#Session.DSN#">
                            select Mcodigo ,SPfechaarribo 
                            from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> a 
                            where a.SPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#">
                        </cfquery>
                        
                        <cfquery name="TCsug" datasource="#Session.DSN#">
                            select tc.Mcodigo,tc.TCcompra,tc.TCventa,tc.Hfecha,tc.Hfechah
                            from Htipocambio tc
                            where tc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and tc.Mcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSP.Mcodigo#">
                                and tc.Hfecha <= '#dateformat(rsSP.SPfechaarribo,'yyyymmdd')#'
                                and tc.Hfechah > '#dateformat(rsSP.SPfechaarribo,'yyyymmdd')#'
                        </cfquery>
                        
                        <cfif isdefined('TCsug') and TCsug.RecordCount GT 0>
                        	<cfset LvarTC = TCsug.TCcompra>
                        <cfelse>
	                        <cfset LvarTC = 1>
                        </cfif>
                    
                        <cfquery name="rsEncabezado" datasource="#Session.DSN#">
                            select b.CFcuentaCxP
                            		,'FC' as CPTcodigo
                                    , 0 as EDexterno
                                    , (select min(cf.Ocodigo)
                                        from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec">  a1
                                        inner join <cf_dbdatabase table="FTVicerrectoria" datasource="ftec">  b1
                                        on b1.Vid = a1.Vid
                                        inner join CFuncional cf
                                        on cf.CFid = b1.CFid
                                        where a1.SPid = a.SPid) as Ocodigo
                                    , 0 as EDselect
                                    , 0 as Interfaz
                                    <!---, 0 as EDtipocambio--->
                                    , (select sum(x.DSPimpuesto) from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> x where x.SPid = a.SPid) as EDimpuesto
                                    , 0 as EDporcdescuento
                                    , 0 as EDdescuento
                                    , #LvarTC# as EDtipocambio
                                    , (select sum(x.DSPmonto) from  <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> x where x.SPid = a.SPid) as EDtotal
                                    ,  a.* 
                            from  <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> a
                            inner join SNegocios b
                            	on a.SNcodigo = b.SNcodigo
                            where SPid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#">
                        </cfquery>
                    
                       <cfinvoke component="ftec.Componentes.FTPosteoCxp" method="Alta" >
                            <cfinvokeargument name="CPTcodigo" 		value="#rsEncabezado.CPTcodigo#">
                            <cfinvokeargument name="EDdocumento" 	value="#rsEncabezado.SPdocumento#">
                            <cfinvokeargument name="SNcodigo" 		value="#rsEncabezado.SNcodigo#">
                            <cfinvokeargument name="Mcodigo" 		value="#rsEncabezado.Mcodigo#">
                            <cfinvokeargument name="EDtipocambio" 	value="#rsEncabezado.EDtipocambio#">
                            <cfinvokeargument name="EDdescuento" 	value="#rsEncabezado.EDdescuento#">
                            <cfinvokeargument name="EDporcdescuento"value="#rsEncabezado.EDporcdescuento#">
                            <cfinvokeargument name="EDimpuesto" 	value="#rsEncabezado.EDimpuesto#">
                            <cfinvokeargument name="EDtotal" 		value="#rsEncabezado.EDtotal#">
                            <cfinvokeargument name="Ocodigo" 		value="#rsEncabezado.Ocodigo#">
                            <cfinvokeargument name="Ccuenta" 		value="#rsEncabezado.CFcuentaCxP#">
                            <cfinvokeargument name="EDfecha" 		value="#rsEncabezado.SPfechaReg#">
                            <cfinvokeargument name="Rcodigo" 		value="#rsEncabezado.Rcodigo#">
                            <cfinvokeargument name="EDusuario" 		value="#session.Usulogin#">
                            <cfinvokeargument name="EDselect" 		value="#rsEncabezado.EDselect#">
                            <!---<cfinvokeargument name="EDdocref" 		value="#rsEcabezado.#">--->
                            <cfinvokeargument name="EDfechaarribo" 	value="#rsEncabezado.SPfechaarribo#">
                           <!--- <cfinvokeargument name="id_direccion" 	value="#rsEncabezado.#">
                            <cfinvokeargument name="TESRPTCid" 		value="#rsEncabezado.#"--->>
                            <cfinvokeargument name="BMUsucodigo" 	value="#rsEncabezado.Usucodigo#">
                            <!---<cfinvokeargument name="TESRPTCietu" 	value="#rsEncabezado.#">
                            <cfinvokeargument name="folio" 			value="#rsEncabezado.#">--->
                            <cfinvokeargument name="EDvencimiento" 	value="#rsEncabezado.SPfechavence#">
                            <!---<cfinvokeargument name="EVestado" 		value="#rsEncabezado.#">--->
                            <cfinvokeargument name="EDexterno" 		value="#rsEncabezado.EDexterno#">
                            <cfinvokeargument name="SPid" 			value="#Arguments.SPid#">
                            <cfinvokeargument name="Debug"			value="false">
                        </cfinvoke>
                   </cfif>
               </cfif>
        </cfif>
        <cfreturn>
    </cffunction>    
    
	<cffunction access="public" name="AltaHTramite" returntype="numeric">
    	<cfargument name="Usucodigo"		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="ETid"				required="true" 	type="numeric">
        <cfargument name="TPid"				required="true" 	type="any">
        <cfargument name="SPid"				required="true" 	type="numeric">
		<cfargument name="HTpasosigue"		required="true" 	type="numeric">
        <cfargument name="DSPid"			required="false" 	type="numeric"  default="0">
        <cfargument name="HTcompleto"		required="false" 	type="numeric" default="0">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="true">  
         
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> (Usucodigo
												,HTfecha
												,ETid
												,TPid
												,SPid
												,HTpasosigue
                                                ,DSPid
                                                ,HTcompleto
                                          	)
                                        values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#" 	voidnull>
												,<cf_dbfunction name="now">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.ETid#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TPid#" 		voidnull>
                                               	, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#"		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.HTpasosigue#"		voidnull>
                                                <cfif #Arguments.DSPid# GT 0>
	                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.DSPid#"		voidnull>
                                                 <cfelse>
                                                	,null
                                                </cfif>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.HTcompleto#"		voidnull>
                                               )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
            <cfquery name="rsUpdate" datasource="#Session.DSN#">
            	update <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> set 
                	DScambiopaso = 	<cfif #Arguments.HTcompleto# EQ 0> 1 <cfelse> 0 </cfif>
                    where SPid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#">
                    <cfif #Arguments.HTcompleto# EQ 0> 
                     	and DSPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.DSPid#">
                    </cfif>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select Usucodigo,HTfecha,ETid,TPid,SPid,HTpasosigue
                    from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec">
                    where HTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <cffunction access="public" name="getEmail" output="false" returntype="string">
        <cfargument name="Usucodigo" required="yes" type="numeric">
        <cfquery name="rs" datasource="asp">
            select b.Pemail1 as Email
            from Usuario a
            	inner join DatosPersonales b
                	on a.datos_personales = b.datos_personales
            where a.Usucodigo = #Arguments.Usucodigo#
        </cfquery>
        <cfreturn rs.Email>
	</cffunction>

</cfcomponent>