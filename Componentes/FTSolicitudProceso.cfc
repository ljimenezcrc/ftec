<cfcomponent name="FTSolicitudProceso"  output="true">

    <cffunction access="public" name="get" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="SPdocumento"		required="true" 	type="string" default="NDF">
        <cfargument name="SNcodigo"			required="false" 	type="numeric" >
        
        <cfquery name="rsExiste" datasource="#Session.DSN#">
            select SPdocumento,SNcodigo
            from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec">
            where SPdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SPdocumento#">
            	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
        </cfquery>
 
        <cfif isdefined('rsExiste') and rsExiste.RecordCount GT 0>
        	<cfreturn 1>
        </cfif>
        <cfreturn 0>
    </cffunction>
	<!--- *************************** --->
	<!--- Alta solicitudes  --->
	<!--- *************************** --->
    
	<cffunction access="public" name="Alta" returntype="numeric">
    	<cfargument name="Ecodigo" 			required="false" 	type="numeric" default="#Session.Ecodigo#">

        <cfargument name="SPdocuento"		required="true" 	type="string" default="NDF">
        <cfargument name="TPid"				required="true" 	type="numeric" default="0">
        <!---<cfargument name="Vid"				required="true" 	type="numeric" default="0">--->
        <cfargument name="FPid"				required="true" 	type="numeric" default="0">
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
        <cfargument name="SPfechafactura"	required="false" 	type="date">
        <cfargument name="SPfechavence"		required="false" 	type="date">
        <cfargument name="SPfechaarribo"	required="false" 	type="date">
       
        
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  

        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> (SPdocumento
								                ,TPid
                                                ,FPid                 
                                                ,LPid                 
                                                ,Mcodigo              
                                                ,SPfechafactura  
                                                ,SPfechavence
                                                ,SPfechaarribo  
                                                ,SPfechaReg           
                                                ,Usucodigo            
                                                ,SPestado             
                                                ,SPacta 
                                                ,Ecodigo
                                                ,SPobservacion
                                                ,SPctacliente
                                                ,Bid
                                                ,SPfechaTrans
                                                ,SNcodigo
                                                
                                          	)
                                        values(	<cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.SPdocumento#" 		voidnull>
                                        		, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.TPid#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.FPid#" 		voidnull>
                                                <cfif isdefined('Arguments.LPid')>
                                                	, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.LPid#" 		voidnull>
                                                <cfelse>
                                                	,null
                                                </cfif>
                                                
                                                <cfif isdefined('Arguments.Mcodigo')>
                                                	, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Mcodigo#" 	voidnull>
                                                <cfelse>
                                                	,null
                                                </cfif>
                                                
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfechafactura#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfechavence#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfechaarribo#" 	voidnull>
                                                ,<cf_dbfunction name="today">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Usucodigo#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SPestado#" 	voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.SPacta#" 		voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Ecodigo#" 	voidnull>
                                                <cfif isdefined('Arguments.SPobservacion')>
                                                	, <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.SPobservacion#" 	voidnull>
                                                <cfelse>
                                                	,null
                                                </cfif>
                                                
                                                <cfif isdefined('Arguments.SPctacliente')>
                                                	, <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.SPctacliente#" 	voidnull>
                                                <cfelse>
                                                	,null
                                                </cfif>
                                                
                                                <cfif isdefined('Arguments.Bid')>
                                                	, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Bid#" 	voidnull>
                                                <cfelse>
                                                	,null
                                                </cfif>
                                                <cfif isdefined('Arguments.SPfechaTrans')>
                                                	, <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfechaTrans#" 	voidnull>
                                                    <!---, <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Arguments.SPfechaTrans,'DD/MM/YYYY')#">--->
                                                <cfelse>
                                                	,null
                                                </cfif>
                                                <cfif isdefined('Arguments.SNcodigo')>
                                                	, <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.SNcodigo#" 	voidnull>
                                                <cfelse>
                                                	,null
                                                </cfif>
                                                )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select SPid,TPid,Vid ,FPid,LPid,Mcodigo,SPfecha,SPfechaReg,Usucodigo,SPestado,SPacta,Ecodigo,SPobservacion,SPctacliente,Bid,SPfechaTrans,SNcodigo
                    from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec">
                    where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
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
        <cfargument name="SPid" 			required="true" 	type="numeric" default="0">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">     

        <cftransaction>  
        	<cfquery name="rsGet" datasource="#Session.DSN#">
                select * 
                from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec">
                where  SPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SPid#" voidnull> 
                and SPestado = 1 <!---ya  aplicado por lo tanto  no se debe eliminar--->
            </cfquery>
 
        	<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            	<cfquery name="rsGet" datasource="#Session.DSN#">
                   select SPid
                    from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec">
                    where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SPid#">
                </cfquery>
                <cfif isdefined('rsGet') and rsGet.RecordCount EQ 0> 
                    <cfquery name="rsDeleteDet" datasource="#Session.DSN#">
                        delete 
                        from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec">
                        where  SPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SPid#" voidnull> 
                    </cfquery>
                    
                    <cfquery name="rsDeleteEnc" datasource="#Session.DSN#">
                        delete 
                        from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec">
                        where  SPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SPid#" voidnull> 
                        and  SPestado = 0
                    </cfquery>
                <cfelse>
           			<cfquery datasource="#Session.DSN#">
                		update <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> set SPestado = -1 	<!---borrado logico para que no se muestre en la lista--->
                        where  SPid	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SPid#" voidnull> 
                    </cfquery>
                </cfif>
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
        <cfargument name="FPid"				required="true" 	type="numeric" default="0">
<!---        <cfargument name="SPfecha"			required="true" 	type="date">--->
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
        <cfargument name="SPfechafactura"	required="false" 	type="date">
        <cfargument name="SPfechavence"		required="false" 	type="date">
        <cfargument name="SPfechaarribo"	required="false" 	type="date">
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        
        
       <!--- <cf_dump var="#Arguments#">--->
        

        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                update <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> set 
                    TPid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.TPid#" 		voidnull>
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
                    ,SPfechafactura = <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfechafactura#" 	voidnull>
                    ,SPfechavence 	= <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfechavence#" 	voidnull>
                    ,SPfechaarribo 	= <cf_jdbcquery_param cfsqltype="cf_sql_date"	value="#Arguments.SPfechaarribo#" 	voidnull>
                                
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
                    from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec">
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
     
    
    <cffunction access="public" name="AltaDetalle" returntype="numeric" hint="Funcion para agregar una nueva linea a la Solicitud de Pago">
    	<cfargument name="Ecodigo"			required="false" 	type="numeric"  default="#session.Ecodigo#">
        <cfargument name="SPid"				required="true" 	type="numeric" >
        <cfargument name="Vid"				required="false" 	type="numeric" default="-1" hint="Id de Vicerrectoria, Proyecto">
        <cfargument name="Cid"				required="true" 	type="numeric" >
        <cfargument name="Icodigo"			required="true" 	type="string" >
        <cfargument name="DSPdescripcion"	required="true" 	type="string" >
        <cfargument name="DSPmonto"			required="false" 	type="numeric" default="0.00" >
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
        <cfargument name="DOlinea" 			required="false" 	type="numeric" hint="Id del Detalle de la Orden de compra" default="-1">  
		<cfargument name="CFid" 			required="false" 	type="numeric" hint="Id del centro funcional" default="-1">  
		           
        <cfquery name="rsImp" datasource="#Session.DSN#">
            select Icodigo, coalesce(Iporcentaje,0) as imp
            from Impuestos 
            where Ecodigo = #Session.Ecodigo#
              and Icodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.Icodigo#" voidnull>
        </cfquery>
        <cfif Arguments.DOlinea EQ -1>
			<cfquery name="rsCuentaConcepto" datasource="#Session.DSN#">
				select Cid, Ccodigo, Cdescripcion,cuentac
				from Conceptos 
				where Ecodigo = #session.Ecodigo#
				  and Cid     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Cid#">
			</cfquery>
			
			<cfquery name="rsCFid" datasource="#session.DSN#">
				select a.CFid,b.CFcuentac
					from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> a
						inner join CFuncional b
							on a.CFid = b.CFid
				where a.Vid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vid#">
			</cfquery>
			<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
			
			<cfif isdefined('rsCuentaConcepto') and rsCuentaConcepto.recordcount EQ 1 and isdefined('rsCFid') and rsCFid.recordcount EQ 1 >
				<cfset LvarComplementoConcepto 	= rsCuentaConcepto.cuentac>
				<cfset LvarFormatoCuenta 		= rsCFid.CFcuentac>
			
				<cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,trim(LvarComplementoConcepto),'?')>
				
				<cfquery name="rsCCuenta" datasource="#session.DSN#">
					select a.CCuenta, a.*
					from CContables a
					where a.Cformato = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#LvarFormatoCuenta#">
				</cfquery>
				<cfif isdefined('rsCCuenta') and rsCCuenta.recordcount EQ 0>
					<cfset TitleErrs = 'Operación Inválida'>
					<cfset MsgErr	 = 'Contabilidad'>
					<cfset DetErrs 	 = 'La cuenta Contable ' & #LvarFormatoCuenta# & ' no existe favor Verificar.'>
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
				</cfif>
				
				<cfquery name="rsCFuenta" datasource="#session.DSN#">
					select a.CFcuenta, a.*
					from CFinanciera a
					where a.CFformato = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#LvarFormatoCuenta#">
				</cfquery>
				
				 <cfif isdefined('rsCFuenta') and rsCFuenta.recordcount EQ 0>
					<cfset TitleErrs = 'Operación Inválida'>
					<cfset MsgErr	 = 'Contabilidad'>
					<cfset DetErrs 	 = 'La cuenta Financiera '& #LvarFormatoCuenta# & ' no existe favor Verificar.'>
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
				</cfif>
			
			<cfelse>
				<cfset TitleErrs = 'Operación Inválida'>
				<cfset MsgErr	 = 'Parámetros RH Tipos Nómina'>
				<cfset DetErrs 	 = 'El concepto no tiene complemento definido / el centro funcional no tiene definida una mascara, Verificar.'>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
			</cfif>
			<cfset LvarCcuenta  = rsCCuenta.Ccuenta>
			<cfset LvarCFcuenta = rsCFuenta.CFcuenta>
		<cfelse>
			<!---Si viene de una Orden de compra se toma la Cuenta de alli--->
			<cfquery name="rsCFuenta" datasource="#session.DSN#">
                select a.CFcuenta, a.Ccuenta
                 from CFinanciera a
				 	inner join DOrdenCM b
				   		on b.CFcuenta = a.CFcuenta
                where b.DOlinea = #Arguments.DOlinea#
            </cfquery>
			<cfset LvarCcuenta  = rsCFuenta.CFcuenta>
			<cfset LvarCFcuenta = rsCFuenta.Ccuenta>
			<cfif Arguments.Vid EQ -1 and Arguments.CFid NEQ -1>
				<cfquery name="rsVid" datasource="#session.DSN#">
					select a.Vid
						from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> a
							inner join CFuncional b
								on a.CFid = b.CFid
					where b.CFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.CFid#">
				</cfquery>
				
				<cfif rsVid.RecordCount and LEN(TRIM(rsVid.Vid))>
					<cfset Arguments.Vid = rsVid.Vid>
				</cfif>
			</cfif>
		</cfif>
                <cftry>
                <cftransaction> 
                <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                        insert into <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> (SPid
                                                        ,Vid
                                                        ,Cid
                                                        ,Icodigo
                                                        <!---,DSPdocumento  --->
                                                        ,DSPdescripcion                 
                                                        <!---,DSPobjeto   --->                
                                                        ,DSPmonto
                                                        ,DSPimpuesto
                                                        ,Ecodigo  
                                                        ,Ccuenta   
                                                        ,CFcuenta  
                                                        ,DSPmontototal 
														,DOlinea
														 
                                                    )
                                                values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.SPid#"voidnull>
                                                        ,<cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.Vid#" null="#Arguments.Vid EQ -1#">
                                                        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Cid#" voidnull>
                                                        ,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.Icodigo#" voidnull>
                                                        ,<cf_jdbcquery_param cfsqltype="cf_sql_varchar"		value="#Arguments.DSPdescripcion#" 	voidnull>
                                                        ,<cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.DSPmonto#" 	voidnull> 
                                                        ,((#Arguments.DSPmonto# * #rsImp.imp#) / 100 ) 
                                                        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#"	voidnull>
                                                        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#LvarCcuenta#"	voidnull>
                                                        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#LvarCFcuenta#"	voidnull>
                                                        ,((#Arguments.DSPmonto# * #rsImp.imp#) / 100 ) + #Arguments.DSPmonto#
														,<cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.DOlinea#" null="#Arguments.DOlinea EQ -1#">
                                                        )
                        <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
                    </cfquery>
                    <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
                    
                    <cfset Lvar_Iid = rsInsert.Identity>
            
                    <cfif Arguments.Debug>
                        <cfquery name="rsDebug" datasource="#Session.DSN#">
                            select DSPid,SPid,DSPdocumento,DSPdescripcion,DSPobjeto,DSPmonto
                            from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec">
                            where DSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                        </cfquery>
                        <cfdump var="#Arguments#">
                        <cfdump var="#rsDebug#">
                        <cfabort>
                    </cfif>
                    </cftransaction>
                        <cfcatch type="any">
                    <!---<cfif vDebug>--->
                        <cfoutput>
                            <ul>
                                <h1>Other Error: #cfcatch#</h1>
                                <li><b>Message:</b> #cfcatch.Message#
                                <li><b>Detail:</b> #cfcatch.Detail#
                                <li><b>Native error code:</b> #cfcatch.NativeErrorCode#
                                <li><b>SQLState:</b> #cfcatch.SQLState#
                            <cfif isdefined('cfcatch.Sql')>
								<li><b>SQL:</b> #cfcatch.Sql#
							</cfif>
							<cfif isdefined('cfcatch.queryError')>
                                <li><b>queryError:</b> #cfcatch.queryError#
							</cfif>
							<cfif isdefined('cfcatch.where')>
                                <li><b>where:</b> #cfcatch.where#
							</cfif>
                            </ul>
                        </cfoutput>
                        <cfabort>
                   <!--- </cfif>
                    <cfsetting requesttimeout="#(GetRequestTimeout() + 3)#">--->
                </cfcatch>
            </cftry>
		<cfreturn Lvar_Iid>
	</cffunction>
    
    <cffunction access="public" name="CambioDetalle">
    	<cfargument name="Ecodigo"			required="false" 	type="numeric"  default="#session.Ecodigo#">
        <cfargument name="DSPid"			required="true" 	type="numeric" >
        <cfargument name="Vid"				required="true" 	type="numeric" >
        <cfargument name="Cid"				required="true" 	type="numeric" >
        <cfargument name="Icodigo"			required="true" 	type="string" >
        <cfargument name="DSPdescripcion"	required="true" 	type="string" >
        <cfargument name="DSPmonto"			required="false" 	type="numeric" default="0.00" >
        <cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">  
                
        
        
        <cfquery name="rsImp" datasource="#Session.DSN#">
            select Icodigo, coalesce(Iporcentaje,0) as imp
            from Impuestos 
            where Ecodigo = #Session.Ecodigo#
                and Icodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Arguments.Icodigo#" voidnull>
        </cfquery>
        
                
        <cfquery name="rsCuentaConcepto" datasource="#Session.DSN#">
            select Cid, Ccodigo, Cdescripcion,cuentac
            from Conceptos 
            where Ecodigo = #session.Ecodigo#
                and Cid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Cid#">
        </cfquery>
        
        <cfquery name="rsCFid" datasource="#session.DSN#">
            select a.CFid,b.CFcuentac
            from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> a
                inner join CFuncional b
                on a.CFid = b.CFid
            where a.Vid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#Arguments.Vid#">
        </cfquery>
        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
        
        <cfif isdefined('rsCuentaConcepto') and rsCuentaConcepto.recordcount EQ 1 and isdefined('rsCFid') and rsCFid.recordcount EQ 1 >
            <cfset LvarComplementoConcepto 	= #rsCuentaConcepto.cuentac#>
            <cfset LvarFormatoCuenta 		= #rsCFid.CFcuentac#>
        
            <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,trim(LvarComplementoConcepto),'?')>
            
            <cfquery name="rsCCuenta" datasource="#session.DSN#">
                select a.CCuenta, a.*
                from CContables a
                where a.Cformato = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#LvarFormatoCuenta#">
            </cfquery>
            <cfif isdefined('rsCCuenta') and rsCCuenta.recordcount EQ 0>
                <cfset TitleErrs = 'Operación Inválida'>
                <cfset MsgErr	 = 'Contabilidad'>
                <cfset DetErrs 	 = 'La cuenta Contable ' & #LvarFormatoCuenta# & ' no existe favor Verificar.'>
                <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
            </cfif>
            
            <cfquery name="rsCFuenta" datasource="#session.DSN#">
                select a.CFcuenta, a.*
                from CFinanciera a
                where a.CFformato = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#LvarFormatoCuenta#">
            </cfquery>
            
             <cfif isdefined('rsCFuenta') and rsCFuenta.recordcount EQ 0>
                <cfset TitleErrs = 'Operación Inválida'>
                <cfset MsgErr	 = 'Contabilidad'>
                <cfset DetErrs 	 = 'La cuenta Financiera '& #LvarFormatoCuenta# & ' no existe favor Verificar.'>
                <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
            </cfif>
        
        <cfelse>
            <cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros RH Tipos Nómina'>
            <cfset DetErrs 	 = 'El concepto no tiene complemento definido / el centro funcional no tiene definida una mascara, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
        </cfif>
                <cftry>
                <cftransaction> 
                <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                        update <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec">  set 
                        								Vid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Vid#" voidnull>
                                                        ,Cid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Cid#" voidnull>
                                                        ,Icodigo = <cf_jdbcquery_param  cfsqltype="cf_sql_varchar" 	value="#Arguments.Icodigo#" voidnull>
                                                        ,DSPdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"	value="#Arguments.DSPdescripcion#" 	voidnull>                
                                                        ,DSPmonto = <cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#Arguments.DSPmonto#" 	voidnull>
                                                        ,DSPimpuesto = ((#Arguments.DSPmonto# * #rsImp.imp#) / 100 )
                                                        ,Ecodigo  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#"voidnull>
                                                        ,Ccuenta   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsCCuenta.Ccuenta#"voidnull>
                                                        ,CFcuenta  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#rsCFuenta.CFcuenta#"voidnull>
                                                        ,DSPmontototal  = ((#Arguments.DSPmonto# * #rsImp.imp#) / 100 ) + #Arguments.DSPmonto#   
						where DSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DSPid#">                                                        
                    </cfquery>
            
                    <cfif Arguments.Debug>
                        <cfquery name="rsDebug" datasource="#Session.DSN#">
                            select DSPid,SPid,DSPdocumento,DSPdescripcion,DSPobjeto,DSPmonto
                            from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec">
                            where DSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                        </cfquery>
                        <cfdump var="#Arguments#">
                        <cfdump var="#rsDebug#">
                        <cfabort>
                    </cfif>
                    </cftransaction>
                        <cfcatch type="any">
                    <!---<cfif vDebug>--->
                        <cfoutput>
                            <ul>
                                <h1>Other Error: #cfcatch#</h1>
                                <li><b>Message:</b> #cfcatch.Message#
                                <li><b>Detail:</b> #cfcatch.Detail#
                                <li><b>Native error code:</b> #cfcatch.NativeErrorCode#
                                <li><b>SQLState:</b> #cfcatch.SQLState#
                                <li><b>SQL:</b> #cfcatch.Sql#
                                
                                <li><b>queryError:</b> #cfcatch.queryError#
                                <li><b>where:</b> #cfcatch.where#
                            </ul>
                        </cfoutput>
                        <cfabort>
                   <!--- </cfif>
                    <cfsetting requesttimeout="#(GetRequestTimeout() + 3)#">--->
                </cfcatch>
            </cftry>
		<cfreturn >
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
                from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec">
                where  DSPid in (<cfqueryparam cfsqltype="cf_sql_varchar"  list="yes" value="#Arguments.DSPid#"> )
            </cfquery>	
        </cftransaction>
        <cfreturn>
	</cffunction>
    

</cfcomponent>