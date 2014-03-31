<cfcomponent name="FTTramites"  output="true">

    
	<!--- *************************** --->
	<!--- Aplica Tramite  --->
	<!--- *************************** --->
    <cffunction access="public" name="AplicaTramite">
		<cfargument name="SPid"				required="true" 	type="any">
        <cfargument name="TPid"				required="true" 	type="any">
        <cfargument name="HTcompleto"		required="no" 		type="any">
        
        <!---<cfargument name="Vid"				required="true" 	type="any">--->
        <cfargument name="Aprueba"			required="true" 	type="any">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        <cfquery name="rsSiguientePasoH" datasource="#Session.DSN#">
            select Usucodigo,HTfecha ETid,TPid,SPid,HTpasosigue
                from FTHistoriaTramite
                where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SPid#">
                and  HTfecha = (select max(a.HTfecha) from FTHistoriaTramite a where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SPid#"> and HTcompleto = 1)
        </cfquery>
        
        <cfif isdefined('rsSiguientePasoH') and rsSiguientePasoH.recordCount EQ 0>
        	<cfquery name="rsSiguientePaso" datasource="#Session.DSN#">
                select top(1) c.ETid, a.TPid, a.SPid, 
                	<cfif Arguments.Aprueba EQ 1>
                    	c.FTpasoaprueba 
                    <cfelse>
                    	c.FTpasorechaza 
                    </cfif> as PasoSigue
                    from FTSolicitudProceso a
                        inner join FTTipoProceso b
                            on a.TPid = b.TPid
                    inner join FTFlujoTramite c
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
                    from FTSolicitudProceso a
                        inner join FTTipoProceso b
                            on a.TPid = b.TPid
                    inner join FTFlujoTramite c
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
                    from FTSolicitudProceso a
                        inner join FTDSolicitudProceso b
                            on a.SPid = b.SPid
                            and coalesce(b.DScambiopaso,0) = 0
                            <cfif isdefined('form.Tramite') and len(#form.Tramite#) GT 0>
                            	and b.Vid in (
                                            select e1.Vid
                                            from FTHistoriaTramite a1
                                                inner join FTTipoProceso b1
                                                    on a1.TPid = b1.TPid
                                                inner join FTFlujoTramite c1
                                                    on b1.TTid = c1.TTid
                                                inner join FTDFlujoTramite d1
                                                    on c1.FTid = d1.FTid
                                                inner join FTAutorizador e1
                                                    on d1.TAid = e1.TAid
                                                    and e1.Vid in (select b.Vid
                                                                    from FTDSolicitudProceso a
                                                                    where a.SPid = a.SPid)
                                                    and a1.HTpasosigue = c1.FTpasoactual
                                                    and e1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
                                            where a1.SPid = a.SPid 
                                                and a1.HTfecha = (select max(b11.HTfecha) from FTHistoriaTramite b11 where b11.SPid = a1.SPid and HTcompleto = 1)
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
                    from FTDSolicitudProceso
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
                        from  FTHistoriaTramite
                        where SPid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#">
                        and HTcompleto = 1
                        and HTpasosigue = 0
                    </cfquery>

                    <cfif isdefined('rsPostearEcabezado') and rsPostearEcabezado.RecordCount EQ 1>
                        <cfquery name="rsEncabezado" datasource="#Session.DSN#">
                            select b.CFcuentaCxP
                            		,'FC' as CPTcodigo
                                    , 0 as EDexterno
                                    , 0 as Ocodigo
                                    , 0 as EDselect
                                    , 0 as Interfaz
                                    , 0 as EDtipocambio
                                    , (select sum(x.DSPimpuesto) from FTDSolicitudProceso x where x.SPid = a.SPid) as EDimpuesto
                                    , 0 as EDporcdescuento
                                    , 0 as EDdescuento
                                    , 1 as EDtipocambio
                                    , (select sum(x.DSPmonto) from FTDSolicitudProceso x where x.SPid = a.SPid) as EDtotal
                                    ,  a.* 
                            from  FTSolicitudProceso a
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
                insert into FTHistoriaTramite (Usucodigo
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
            	update FTDSolicitudProceso set 
                	DScambiopaso = 	<cfif #Arguments.HTcompleto# EQ 0> 1 <cfelse> 0 </cfif>
                    where SPid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#">
                    <cfif #Arguments.HTcompleto# EQ 0> 
                     	and DSPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.DSPid#">
                    </cfif>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select Usucodigo,HTfecha,ETid,TPid,SPid,HTpasosigue
                    from FTHistoriaTramite
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
    
    
    <!---    
    <!--- ********************* --->
	<!--- Baja tipo Autorizador --->
	<!--- ********************* --->
    <cffunction access="public" name="Baja">
        <cfargument name="SPid" 			required="true" 	type="numeric" default="0">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     
        
        <cftransaction>  
        	<cfquery name="rsGet" datasource="#Session.DSN#">
                select * 
                from FTSolicitudProceso
                where  SPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SPid#" voidnull> 
                and SPestado = 1
            </cfquery>
            
        	<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            	<cfquery name="rsDeleteDet" datasource="#Session.DSN#">
                    delete 
                    from FTDSolicitudProceso
                    where  SPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SPid#" voidnull> 
                </cfquery>
                
            	<cfquery name="rsDeleteEnc" datasource="#Session.DSN#">
                    delete 
                    from FTSolicitudProceso
                    where  SPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SPid#" voidnull> 
                    and  SPestado = 0
                </cfquery>
            <cfelse>
				<cfset TitleErrs = 'Mensaje'>
                <cfset MsgErr	 = 'Solicitudes'>
                <cfset DetErrs 	 = 'La solicitud ya fue aplicada, no se puede eliminar.'>
                <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
            </cfif>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    
    
    <!--- *************************** --->
	<!--- Cambio Encabezado solicitud --->
	<!--- *************************** --->
	<cffunction access="public" name="Cambio">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">

        <cfargument name="TPid"				required="true" 	type="numeric" default="0">
        <cfargument name="Vid"				required="true" 	type="numeric" default="0">
        <cfargument name="FPid"				required="true" 	type="numeric" default="0">
        <cfargument name="SPfecha"			required="true" 	type="date">
        <cfargument name="Usucodigo"		required="true" 	type="numeric" default="#session.Usucodigo#">
        <cfargument name="SPestado"			required="true" 	type="numeric" default="0">
        <cfargument name="SPacta"			required="true" 	type="string" default="NDF">
        <cfargument name="LPid"				required="false" 	type="numeric" >
        <cfargument name="Mcodigo"			required="false" 	type="numeric" >
        <cfargument name="SPobservacion"	required="false" 	type="string" >
        <cfargument name="SPctacliente"		required="false" 	type="string" >
        <cfargument name="Bid"				required="false" 	type="numeric">
        <cfargument name="SPfechaTrans"		required="false" 	type="date">
        <cfargument name="SNcodigo"			required="false" 	type="numeric" >
        <cfargument name="SPfechaReg"		required="false" 	type="date">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
       

        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update FTSolicitudProceso set 
                    TPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.TPid#" 		voidnull>
                    ,Vid  	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vid#" 		voidnull>
                    ,FPid   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPid#" 		voidnull>
                    <cfif isdefined('Arguments.LPid')>
                    	,LPid 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.LPid#" 		voidnull>
                    <cfelse>
                    	,LPid 	= null
                    </cfif>              
                    <cfif isdefined('Arguments.Mcodigo')>
                    	,Mcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Mcodigo#" 	voidnull>
                    <cfelse>
                    	,Mcodigo = null
                    </cfif>               
                    ,SPfecha 	= <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfecha#" 	voidnull>            
                    ,SPfechaReg = <cf_dbfunction name="today">        
                    ,Usucodigo  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#" 	voidnull>         
                    ,SPestado   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPestado#" 	voidnull>        
                    ,SPacta  	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.SPacta#" 		voidnull>
                    <cfif isdefined('Arguments.SPobservacion')>
                        ,SPobservacion =  <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.SPobservacion#" 	voidnull>
                    <cfelse>
                        ,SPobservacion =  null
                    </cfif>
                    
                    <cfif isdefined('Arguments.SPctacliente')>
                       ,SPctacliente =   <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.SPctacliente#" 	voidnull>
                    <cfelse>
                       ,SPctacliente =  null
                    </cfif>
                    
                    <cfif isdefined('Arguments.Bid')>
                       , Bid =   <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Bid#" 	voidnull>
                    <cfelse>
                       , Bid =  null
                    </cfif>
                    <cfif isdefined('Arguments.SPfechaTrans')>
                        ,SPfechaTrans =   <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfechaTrans#" 	voidnull>
                    <cfelse>
                       , SPfechaTrans =  null
                    </cfif>
                    <cfif isdefined('Arguments.SNcodigo')>
                        ,SNcodigo =   <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SNcodigo#" 	voidnull>
                    <cfelse>
                       , SNcodigo =  null
                    </cfif>
                where SPid=  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPid#" voidnull>
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select  
                        SPid
                        TPid
                        ,Vid  
                        ,FPid                 
                        ,LPid                 
                        ,Mcodigo              
                        ,SPfecha              
                        ,SPfechaReg           
                        ,Usucodigo            
                        ,SPestado             
                        ,SPacta 
                        ,Ecodigo
                    from FTSolicitudProceso
                    where SPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SPid#" voidnull> 
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
		</cftransaction>
		<cfreturn>
	</cffunction>
	    
    <!---detalle de solicitud--->
       
    
    <cffunction access="public" name="AltaDetalle" returntype="numeric">
        <cfargument name="SPid"				required="true" 	type="numeric" >
        <cfargument name="DSPdocumento"		required="true" 	type="string" >
        <cfargument name="DSPdescripcion"	required="true" 	type="string" >
        <cfargument name="DSPobjeto"		required="false" 	type="string" >
        <cfargument name="DSPmonto"			required="false" 	type="numeric" default="0.00" >
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        <cftransaction> 
        <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into FTDSolicitudProceso (SPid
                                                ,DSPdocumento  
                                                ,DSPdescripcion                 
                                                ,DSPobjeto                   
                                                ,DSPmonto            
                                          	)
                                        values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.SPid#" 			voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.DSPdocumento#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.DSPdescripcion#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.DSPobjeto#" 		voidnull>                                               
                                                 , <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.DSPmonto#" 	voidnull>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select DSPid,SPid,DSPdocumento,DSPdescripcion,DSPobjeto,DSPmonto
                    from FTDSolicitudProceso
                    where DSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
      		</cftransaction>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <!--- ********************* --->
	<!--- Baja detalle --->
	<!--- ********************* --->
    <cffunction access="public" name="BajaDetalle">
        <cfargument name="DSPid" 			required="true" 	type="any" default="0">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        <cftransaction>   
            <cfquery name="rsDebug" datasource="#Session.DSN#">
                delete 
                from FTDSolicitudProceso
                where  DSPid in (<cfqueryparam cfsqltype="cf_sql_varchar"  list="yes" value="#Arguments.DSPid#"> )
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>--->
    

</cfcomponent>