 
<cfcomponent name="FTTramitesContratacion">
	<!--- *************************** --->
	<!--- Aplica Tramite  --->
	<!--- *************************** --->

    <cffunction   name="EnviarTramite" access="remote" returnformat="json"  output="true" returntype="query">
    	<cfargument name="PCid"				required="true" 	type="any">
        <cfargument name="Aprueba"			required="true" 	type="any">
<!---        <cfargument name="Estado"			required="true" 	type="any" default="P">--->
        <cftransaction>
            <cfquery name="rsUpdate" datasource="#Session.DSN#">
                update <cf_dbdatabase table="FTPContratacion" datasource="ftec"> set 
                    PCEstado = 	 <cfif #Arguments.Aprueba# EQ 0> 'T'<cfelseif  #Arguments.Aprueba# EQ 1> 'A'  <cfelseif  #Arguments.Aprueba# EQ 2> 'R' <cfelse> 'P'</cfif>
<!---                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"		value="#Arguments.Estado#">--->
                    where PCid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.PCid#">
            </cfquery>
            
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> (Usucodigo
                        ,HTfecha
                        ,ETid
                        ,TPid
                        ,PCid
                        ,HTpasosigue
                        ,DSPid
                        ,HTcompleto
                    )
                values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#session.Usucodigo#" 	voidnull>
                        ,<cf_dbfunction name="now">
                        , 1
                        , null
                        , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.PCid#"		voidnull>
                        , 0
                        ,null
                        ,1
                       )
            </cfquery>
        </cftransaction>
        <cfquery name="rs" datasource="#Session.DSN#">
	        select 1 from dual
        </cfquery>
        
        <cfreturn rs>
    </cffunction>
    


    <cffunction   name="AplicaTramite"  access="remote" returnformat="json"  output="true" returntype="query">
		<cfargument name="PCid"				required="true" 	type="any">
        <cfargument name="Aprueba"			required="true" 	type="any">

        <cfinvoke component="ftec.Componentes.FTPContratacion" method="Get" returnvariable="rsContrato">
            <cfinvokeargument name="PCid" value="#Arguments.PCid#">
        </cfinvoke>
        
        <cfquery name="rsSiguientePasoH" datasource="#Session.DSN#">
            select Usucodigo,HTfecha ETid,TPid,SPid,HTpasosigue
                from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec">
                where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">
                and  HTfecha = (select max(a.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> a 
                				where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCid#"> 
                                	and HTcompleto = 1
                                )
        </cfquery>
        
        
        <cfif isdefined('rsSiguientePasoH') and rsSiguientePasoH.recordCount EQ 0>
        	<cfquery name="rsSiguientePaso" datasource="#Session.DSN#">
                select top(1) c.ETid, b.TTid, a.PCid, 
                	<cfif Arguments.Aprueba EQ 1>
                    	c.FTpasoaprueba 
                    <cfelse>
                    	c.FTpasorechaza 
                    </cfif> as PasoSigue
                    from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a
	                    inner join <cf_dbdatabase table="FTContratos" datasource="ftec"> b
                        	on b.Cid = a.Cid
                    inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c
                        on c.TTid = b.TTid
                where a.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">
                order by c.FTpasoactual asc
             </cfquery>
        <cfelse>
        	<cfquery name="rsSiguientePaso" datasource="#Session.DSN#">
                select c.ETid, a.TTid, a.PCid, 
                	<cfif Arguments.Aprueba EQ 1>
                    	c.FTpasoaprueba 
                    <cfelse>
                    	c.FTpasorechaza 
                    </cfif> as PasoSigue
                		,c.*
                    from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a
                        inner join <cf_dbdatabase table="FTContratos" datasource="ftec"> b
                            on b.Cid = a.Cid
                    inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c
                        on c.TTid = b.TTid
                where a.PCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PCid#">
                	and c.FTpasoactual = #rsSiguientePasoH.HTpasosigue#
                order by c.FTpasoactual asc
             </cfquery>
        </cfif>
        
        <cfif isdefined('rsSiguientePaso') and rsSiguientePaso.recordCount EQ 1>
            <cfquery name="rsDetallesAplicar" datasource="#Session.DSN#">
                select  a.PCid
                    from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a
	                where a.PCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSiguientePaso.PCid#">            
					<cfif isdefined('form.Tramite') and len(#form.Tramite#) GT 0>
                        and a.Vid in (
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
                                                            from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a2
                                                            where a2.PCid = a.PCid)
                                            and a1.HTpasosigue = c1.FTpasoactual
                                            and e1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
                                    where a1.PCid = a.PCid 
                                        and a1.HTfecha = (select max(b11.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> b11 
                                        					where b11.PCid = a1.PCid 
                                                            	and HTcompleto = 1)
                                    )
                    </cfif>
             </cfquery>


				<cfif isdefined('rsDetallesAplicar') and rsDetallesAplicar.RecordCount >
                    <cfinvoke component="ftec.Componentes.FTTramitesContratacion" method="AltaHTramite" >
                        <cfinvokeargument name="ETid" 			value="#rsSiguientePaso.ETid#">
                        <cfinvokeargument name="PCid"			value="#rsSiguientePaso.PCid#">
                        <cfinvokeargument name="HTpasosigue"	value="#rsSiguientePaso.PasoSigue#">
                        <cfinvokeargument name="Debug"			value="false">
                    </cfinvoke>
               </cfif>
        </cfif>
        <cfquery name="rs" datasource="#Session.DSN#">
        	select 1 from dual
        </cfquery>
        
        <cfreturn rs>
    </cffunction>    
    
	<cffunction access="public" name="AltaHTramite" returntype="numeric">
    	<cfargument name="Usucodigo"		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="ETid"				required="true" 	type="numeric">
        <cfargument name="TPid"				required="false" 	type="any">
        <cfargument name="PCid"				required="true" 	type="numeric">
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
												,PCid
												,HTpasosigue
                                                ,DSPid
                                                ,HTcompleto
                                          	)
                                        values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#" 	voidnull>
												,<cf_dbfunction name="now">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.ETid#" 		voidnull>
                                                , null<!---<cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.TPid#" 		voidnull>--->
                                               	, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.PCid#"		voidnull>
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
            	update <cf_dbdatabase table="FTPContratacion" datasource="ftec"> set 
                	PCEstado = 	<cfif #Arguments.HTpasosigue# EQ 0> 'A' <cfelse> 'T' </cfif>
                    where PCid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.PCid#">
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