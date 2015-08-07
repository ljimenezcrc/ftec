<cf_dbfunction name="op_concat" returnvariable="_cat">
<!--- Valores iniciales de la pantalla  --->
<!---Consulta de impuestos--->

<cfquery name="rsExecento" datasource="#Session.DSN#">
	select Icodigo, Idescripcion , Icodigo #_Cat# ' - ' #_Cat# Idescripcion as Descripcion, Iporcentaje
	from Impuestos 
	where Ecodigo = #Session.Ecodigo#
	and Icodigo = 'EX'
	order by Idescripcion                                 
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_NoSeEncontraronRegistros"
	default="No se encontraron Registros "
	returnvariable="LB_NoSeEncontraronRegistros"/> 
				 
<cfif isdefined("form.Cambio")>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfif not isdefined("form.modo")>    
    	<cfset modo="ALTA">
  	<cfelseif form.modo EQ "CAMBIO">
    	<cfset modo="CAMBIO">
  	<cfelse>
    	<cfset modo="ALTA">
  	</cfif>  
</cfif>



<script src="/cfmx/rh/js/utilesMonto.js"></script>
<!---Consulta de impuestos--->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion , Icodigo #_Cat# ' - ' #_Cat# Idescripcion as Descripcion, Iporcentaje
	from Impuestos 
	where Ecodigo = #Session.Ecodigo#
	order by Idescripcion                                 
</cfquery>




<!---Formas de Pago--->
<cfquery name="rsFPagos" datasource="ftec">
	select FPid ,FPcodigo, FPdescripcion 
		from FTFormaPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by FPdescripcion
</cfquery>
<!---Lugar de Pago--->
<cfquery name="rsLPagos" datasource="ftec">
	select LPid,LPcodigo,LPdescripcion 
		from FTLugarPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by LPdescripcion
</cfquery>
<!---Bancos--->
<cfquery name="rsBancos" datasource="#Session.DSN#">
	select Bid,Bcodigo,Ecodigo,Bdescripcion
	 from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Bdescripcion
</cfquery>

<cfset LvarSNvencompras = 0>

<cfif modo NEQ "ALTA" and isdefined('form.SPid') and form.SPid GT 0>
    <cfquery name="rsSolicitudProcesos" datasource="#Session.DSN#">
        select 	
            a.SPid
            ,a.SPdocumento
            ,a.TPid
            ,a.FPid                 
            ,a.LPid                 
            ,a.Mcodigo    
            ,a.SNcodigo 
            ,a.Bid       
            ,a.SPfecha  
            ,a.SPfechaarribo
            ,a.SPfechavence
            ,a.Rcodigo
            ,a.SPfechafactura            
            ,a.SPfechaReg           
            ,a.Usucodigo            
            ,a.SPestado 
            ,a.SPctacliente            
            ,a.SPacta  
            ,a.SPfechaTrans
            ,a.SPobservacion
            ,d.LPcodigo     
       		,d.LPdescripcion 
            ,e.SNnumero
            ,e.SNnombre
            ,e.SNvencompras
            , 0 as VB
        from <cf_dbdatabase table="FTSolicitudProceso " datasource="ftec"> a
        inner join <cf_dbdatabase table="FTFormaPago " datasource="ftec"> c
        	on a.FPid = c.FPid
            and a.Ecodigo = c.Ecodigo
        left outer join <cf_dbdatabase table="FTLugarPago " datasource="ftec"> d
        	on a.LPid = d.LPid
            and a.Ecodigo = d.Ecodigo
        left outer join SNegocios e
        	on a.SNcodigo = e.SNcodigo
            and a.Ecodigo = e.Ecodigo
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        <cfif isdefined('form.SPid') and #form.SPid# GT 0>
            and a.SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
        </cfif>
        order by a.TPid,a.FPid
    </cfquery>
	<cfset LvarSNvencompras = rsSolicitudProcesos.SNvencompras>    
</cfif>

<cfif modo NEQ "ALTA" and isdefined('form.DSPidCambio') and form.DSPidCambio GT 0>
	<!--- Periodo/Mes de Auxiliares --->
	<cfquery name="rsPeriodo" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros 
		 where Ecodigo = #Session.Ecodigo#
		   and Pcodigo = 50
	</cfquery>
	<cfquery name="rsMes" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros 
		 where Ecodigo = #Session.Ecodigo#
		   and Pcodigo = 60
	</cfquery>
	<cfset LvarAnoMesAux = rsPeriodo.Pvalor * 100 + rsMes.Pvalor>
	
	<!--- Periodo de Presupuesto --->
	<cfquery name="rsSQLPP" datasource="#Session.DSN#">
		select CPPid, CPPestado
		  from CPresupuestoPeriodo
		 where Ecodigo = #Session.Ecodigo#
		   and #LvarAnoMesAux# between CPPanoMesDesde and CPPanoMesHasta
	</cfquery>
	
    <cfquery name="rsDSolicitudProcesos" datasource="#Session.DSN#">
        select a.*, b.Vcodigo as Vcodigoresp, b.Vdescripcion as Vdescripcionresp , b.Vid as Vpkresp
        ,c.Ccodigo, c.Cdescripcion
		,cp.CPformato
		,cp.CPdescripcion	
		,ofi.Oficodigo
		,ofi.Odescripcion
		,cpc.CPCPtipoControl
		,(select sum( 
					Coalesce(CPCpresupuestado,0) + 
					Coalesce(CPCmodificado,0) + 
					Coalesce(CPCmodificacion_Excesos,0) + 
					Coalesce(CPCvariacion ,0)+ 
					Coalesce(CPCtrasladado ,0)+ 
					Coalesce(CPCtrasladadoE ,0)- 
					Coalesce(CPCreservado_Anterior,0) - 
					Coalesce(CPCcomprometido_Anterior,0) - 
					Coalesce(CPCreservado_Presupuesto ,0)- 
					Coalesce(CPCreservado ,0)- 
					Coalesce(CPCcomprometido ,0)- 
					Coalesce(CPCejecutado ,0)- 
					Coalesce(CPCejecutadoNC ,0)+ 
					Coalesce(CPCnrpsPendientes,0)
					)
			  from CPresupuestoControl d
			 where d.Ecodigo	= ofi.Ecodigo
			   and d.CPPid		= <cfif LEN(TRIM(rsSQLPP.CPPid))>#rsSQLPP.CPPid#<cfelse>-1</cfif>
			   and d.CPCanoMes	>= case cpc.CPCPcalculoControl when 1 then #LvarAnoMesAux# when 2 then 0					else 0		end
			   and d.CPCanoMes	<= case cpc.CPCPcalculoControl when 1 then #LvarAnoMesAux# when 2 then #LvarAnoMesAux#	else 600001 end
			   and d.CPcuenta	= cp.CPcuenta
			   and d.Ocodigo	= ofi.Ocodigo
			) Disponible	,
			eoc.NAP	   
						   
		
		from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> a
			left outer join <cf_dbdatabase table="FTVicerrectoria " datasource="ftec"> b
				on a.Vid = b.Vid       
			left outer join Conceptos c
				on a.Cid = c.Cid
			LEFT OUTER JOIN CFinanciera cf
				on cf.CFcuenta = a.CFcuenta
			LEFT OUTER JOIN CPresupuesto cp
				on cp.CPcuenta = cf.CPcuenta
            LEFT OUTER JOIN CFuncional cfu
                on cfu.CFid = b.CFid
			LEFT OUTER JOIN Oficinas ofi
				on ofi.Ocodigo = cfu.Ocodigo
			LEFT OUTER JOIN CPCuentaPeriodo cpc
				on cpc.CPPid		= <cfif LEN(TRIM(rsSQLPP.CPPid))>#rsSQLPP.CPPid#<cfelse>-1</cfif>
				and cpc.CPcuenta 	= cp.CPcuenta 
			LEFT OUTER JOIN DOrdenCM doc
				on doc.DOlinea = a.DOlinea
			LEFT OUTER JOIN EOrdenCM eoc
				on eoc.EOidorden = doc.EOidorden
			
        where DSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSPidCambio#">
    </cfquery>
</cfif>

<cfquery name="rsFechaHoy" datasource="#Session.DSN#">
	select <cf_dbfunction name='today'> as Fecha 
    from dual
</cfquery>

<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select Rcodigo, Rdescripcion 
	from Retenciones 
	where Ecodigo = #Session.Ecodigo#
	order by Rdescripcion
</cfquery>

<cfset navegacion = "" >
<style type="text/css">
	.Rojo {color: #FF0000}
	.Azul {color: #0000FF}
</style>
 
<cfoutput>

<form  name="fEncabezado" method="post" action="SolicitudPago-Sql.cfm" >
	<input type="hidden" name="modo" 		value="#modo#">
    <input type="hidden" name="SPid" 		value="<cfif isdefined('form.SPid')> #form.SPid# </cfif>">
	<input type="hidden" name="TPid" 		value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.TPid#</cfif>">
    <input type="hidden" name="SPfp" 		value="<cfif isdefined('form.FPid')> #form.FPid# </cfif>">
    <input type="hidden" name="Tramite" 	value="<cfif isdefined('form.Tramite')> #form.Tramite# </cfif>">   
    <input type="hidden" name="VB" 			value="<cfif isdefined('form.VB')> #form.VB# </cfif>">   
    <input type="hidden" name="SNvencompras" value="<cfoutput>#LvarSNvencompras#</cfoutput>" id="SNvencompras"  > 
    	<cfif modo NEQ "ALTA" and isdefined('rsSolicitudProcesos')>
    	<div class="row">
			<div class="col-sm-2">
				Consecutivo
			</div>
			<div class="col-sm-5">
				<input disabled="disabled"name="SPid" type="text" id="SPid" maxlength="25"  style="text-align: right;" value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPid#</cfif>" >
			</div>
		</div>
		</cfif>
    	<!---Documento y Forma de Pago--->
		<div class="row">
			<div class="col-sm-2">
				Documento
			</div>
			<div class="col-sm-5">
				<input name="SPdocumento" type="text" id="SPdocumento" maxlength="25"  style="text-align: right;" value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPdocumento#</cfif>" >
			</div>
			<div class="col-sm-2">Forma de Pago</div>
			<div class="col-sm-3">
				<select name="FPid"  id="FPid" onchange="javascript:Fpago(this);" style="width:90%">
					<option value="">--- Seleccionar ---</option>
					<option value="2" <cfif modo neq 'ALTA' and isdefined("rsSolicitudProcesos") and rsSolicitudProcesos.FPid eq 2 >selected</cfif> >Cheque</option>
					<option value="3" <cfif modo neq 'ALTA' and isdefined("rsSolicitudProcesos") and rsSolicitudProcesos.FPid eq 3 >selected<cfelseif modo eq 'ALTA'>selected</cfif> >Transferencia</option>
				</select>
			</div>
		</div>
		<!---Acta y Retencion--->
		<div class="row">
			<div class="col-sm-2">
				N°.Acta
			</div>
			<div class="col-sm-5">
				<input name="SPacta" type="text" id="SPacta" maxlength="15"  style="text-align: right;" value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPacta#</cfif>" >
			</div>
			<div class="col-sm-2">
				Retención al Pagar
			</div>
			<div class="col-sm-3">
				 <select name="Rcodigo" tabindex="1" style="width:90%"> 
					<option  title="-- Sin Retención --" value="-1"> -- Sin Retención -- </option>
					<cfloop query="rsRetenciones">
						<option  title="#rsRetenciones.Rcodigo#" value="#rsRetenciones.Rcodigo#" 
						<cfif modo NEQ "ALTA" and isdefined('rsRetenciones') and isdefined('rsDocumento') and rsRetenciones.Rcodigo EQ rsDocumento.Rcodigo>selected
													<cfelseif modo NEQ 'ALTA' and isdefined('form.Rcodigo') and isdefined('rsRetenciones') and rsRetenciones.Rcodigo EQ form.Rcodigo>selected</cfif>> #rsRetenciones.Rdescripcion# </option>
					</cfloop>
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2">
				Proveedor
			</div>
			<div class="col-sm-5">
				<cfif modo NEQ "ALTA" and isdefined('rsSolicitudProcesos')>
					<cf_rhsociosnegociosFA form="fEncabezado"  query="#rsSolicitudProcesos#"> 
				<cfelse>
					<cf_rhsociosnegociosFA form="fEncabezado" FuncJSalCerrar="CalculaFechaVen();"> 
				</cfif>
			</div>
			<div class="col-sm-2">
				Moneda
			</div>
			<div class="col-sm-3">
				<cfif isdefined('modo') and  modo eq 'CAMBIO' and isdefined('rsSolicitudProcesos')>
				   <cf_sifmonedas Conexion="#session.DSN#" form="fEncabezado" query="#rsSolicitudProcesos#"  Mcodigo="Mcodigo" tabindex="1" >
				<cfelse>
					<cf_sifmonedas Conexion="#session.DSN#" form="fEncabezado" Mcodigo="Mcodigo" tabindex="1">
				</cfif>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2">
				Fecha Arribo
			</div>
			<div class="col-sm-5">
				 <cfif modo NEQ 'ALTA'>
					<cf_sifcalendario form="fEncabezado" name="SPfechaarribo" value="#LSDateFormat(rsSolicitudProcesos.SPfechaarribo,'dd/mm/yyyy')#" tabindex="1" Function="CalculaFechaVen();">
				 <cfelseif isdefined("form.SPfechaarribo")>
					<cf_sifcalendario form="fEncabezado" name="SPfechaarribo" value="#LSDateFormat(form.SPfechaarribo,'dd/mm/yyyy')#"        tabindex="1" Function="CalculaFechaVen();">
				 <cfelse>
					<cf_sifcalendario form="fEncabezado" name="SPfechaarribo" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1" Function="CalculaFechaVen();">
				 </cfif>
			</div>
			<div id="divCheque">
				<div class="col-sm-2">
					Lugar Entrega
				</div>
				<div class="col-sm-3">
					<select name="LPid" style="width:90%">
						<option value="">--- Seleccionar ---</option>
						<cfloop query="rsLPagos">
							<option value="#LPid#" <cfif modo EQ 'CAMBIO' and rsLPagos.LPid EQ rsSolicitudProcesos.LPid> selected</cfif>>#LPdescripcion#</option>
						</cfloop>
					</select>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2">
				Fecha Factura
			</div>
			<div class="col-sm-5">
				<cfif modo NEQ 'ALTA'>
					<cf_sifcalendario form="fEncabezado" name="SPfechafactura" value="#LSDateFormat(rsSolicitudProcesos.SPfechafactura,'dd/mm/yyyy')#" tabindex="1" Function="CalculaFechaVen();">
				<cfelseif isdefined("form.SPfechafactura")>
					<cf_sifcalendario form="fEncabezado" name="SPfechafactura" value="#LSDateFormat(form.SPfechafactura,'dd/mm/yyyy')#"        tabindex="1" Function="CalculaFechaVen();">
				<cfelse>
					<cf_sifcalendario  form="fEncabezado" name="SPfechafactura" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1" Function="CalculaFechaVen();">
				</cfif>
			</div>
			<div class="col-sm-2">
			
			</div>
			<div class="col-sm-3">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2">
				Fecha Vencimiento	
			</div>
			<div class="col-sm-5">
				 <cfif modo NEQ 'ALTA'>
					<cf_sifcalendario form="fEncabezado" name="SPfechavence" value="#LSDateFormat(rsSolicitudProcesos.SPfechavence,'dd/mm/yyyy')#" tabindex="1" >
				<cfelseif isdefined("form.SPfechavence")>
					<cf_sifcalendario form="fEncabezado" name="SPfechavence" value="#LSDateFormat(form.SPfechavence,'dd/mm/yyyy')#"        tabindex="1" >
				<cfelse>
					<cf_sifcalendario  form="fEncabezado" name="SPfechavence" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1" >
				</cfif>
			</div>
			<div class="col-sm-2">
			
			</div>
			<div class="col-sm-3">
			</div>
		</div>
		<div id="divTransferencia">
			<div class="row">
				<div class="col-sm-2">
					Fecha Transacción	
				</div>
				<div class="col-sm-5">
					 <cfif modo NEQ "ALTA">
						<cf_sifcalendario form="fEncabezado" name="SPfechaTrans" value="#LSDateFormat(rsSolicitudProcesos.SPfechaTrans,'dd/mm/yyyy')#">
					<cfelse>
						<cf_sifcalendario form="fEncabezado" name="SPfechaTrans" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					</cfif>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2">
				Observación	
			</div>
			<div class="col-sm-10">
				<textarea name="SPobservacion" style="width:90%"  id="SPobservacion"><cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPobservacion#</cfif></textarea>
			</div>
		</div>			
		<div class="row">
			<div class="col-sm-12">
					<cfif isdefined('form.Tramite') and modo EQ 'CAMBIO'>
						<cf_botones modo="#modo#" exclude= "Nuevo,Alta,Limpiar,Cambio,Baja" formName = "fEncabezado"  sufijo="Enc" include="Aplicar,Rechazar,Regresar" >

					<cfelseif modo EQ 'CAMBIO'>
						<cf_botones modo="#modo#" incluyeForm="true" formName = "fEncabezado"  sufijo="Enc" include="Aplicar,Eliminar,Regresar" exclude="BAJA" >
					<cfelse>
						<cf_botones modo="#modo#" incluyeForm="true" formName = "fEncabezado"  sufijo="Enc" >
					</cfif>
			</div>
		</div>    
</form>

    

<form  name="fDetalle" method="post" action="SolicitudPago-Sql.cfm">
	<input type="hidden" name="modo" value="#modo#">
    <input type="hidden" name="SPid" value="#form.SPid#">
    <input type="hidden" name="SPidDelete" value="<cfoutput>#form.SPid#</cfoutput>">
    <input type="hidden" name="DSPidCambio" value="<cfif isdefined('form.DSPid')><cfoutput>#form.DSPid#</cfoutput></cfif>">
	<input type="hidden" name="VB" value="<cfif isdefined('form.VB')><cfoutput>#form.VB#</cfoutput></cfif>">

	<cfif modo EQ 'CAMBIO' and not isdefined('form.Tramite') >
    <table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">
        <tr>
        	<td colspan="5"> 
            	<fieldset>
                <legend><b>&nbsp;Detalle&nbsp;</b></legend>
                    <table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">
                        <!---************************************* detalle solicitud***************************************---->	
                        <tr><td>&nbsp;</td></tr>
	                    <tr> 
                            <td  align="right">Concepto:</td>
	                        <td>
								<cfif modo NEQ "ALTA" and isdefined('rsDSolicitudProcesos')>
                                    <cf_sifconceptos size="22" form="fDetalle"  verclasificacion="0" tabindex="1" query="#rsDSolicitudProcesos#"> 
                                <cfelse>
                                    <cf_sifconceptos size="22" form="fDetalle"  verclasificacion="0" tabindex="1">
                                </cfif>
                            </td>
                            <td  align="right">Impuesto:</td>
                            <td >
                                <select name="Icodigo" tabindex="1"> 
                                    <option  title="-- Seleccione --" value=""> -- Seleccione -- </option>
                                    <cfloop query="rsImpuestos">
										<option value="#Icodigo#" <cfif modo EQ 'CAMBIO' and isdefined('rsDSolicitudProcesos') and rsImpuestos.Icodigo EQ rsDSolicitudProcesos.Icodigo> selected<cfelseif modo EQ 'CAMBIO' and rsExecento.Icodigo EQ rsImpuestos.Icodigo >selected</cfif>>#rsImpuestos.Descripcion#</option>
                                    </cfloop>
                                </select>
                            </td>
                      	</tr>
                        <tr>
                        	<td align="right">Proyecto:</td>
	                        <td>
								<cfif modo NEQ "ALTA" and isdefined('rsDSolicitudProcesos')>
                                    <cf_FTvicerrectoria form="fDetalle"  size="30"  name="Vcodigoresp" desc="Vdescripcionresp" titulo="Seleccione Proyecto" proyectos="1"  usuario="1" query="#rsDSolicitudProcesos#"> 
                                <cfelse>
                                    <cf_FTvicerrectoria tabindex="1" form="fDetalle" size="30" id="Vpkresp" name="Vcodigoresp" desc="Vdescripcionresp" titulo="Seleccione Proyecto" proyectos="1"  usuario="1">
                                </cfif>
                            </td>
                        </tr>            
                        <tr><td>&nbsp;</td></tr>
                        <tr> 
                        	<td  align="right">Descripci&oacute;n:</td>
                            <td>
                            	<cfif modo NEQ "ALTA" and isdefined('rsDSolicitudProcesos')>
                                    <input name="DSPdescripcion" type="text" id="DSPdescripcion" size="60" maxlength="255"  style="text-align: left;"  value="#rsDSolicitudProcesos.DSPdescripcion#" />
                                <cfelse>
	                                <input name="DSPdescripcion" type="text" id="DSPdescripcion" size="60" maxlength="255"  style="text-align: left;"  value="" />
                                </cfif>
                            </td>
                            <td  class="fileLabel" align="right">Monto</td>
                            <td>
                                <cfif modo NEQ "ALTA" and isdefined('rsDSolicitudProcesos')>
                                    <cf_inputNumber name="DSPmonto"  value="#rsDSolicitudProcesos.DSPmonto#" enteros="15" decimales="2" negativos="false" comas="no">
                                <cfelse>
	                                 <cf_inputNumber name="DSPmonto"  value="0.00" enteros="15" decimales="2" negativos="false" comas="no">
                                </cfif>
                            </td>
                        </tr>
                    </table>
         	</td>
        </tr>   
		<cfif modo NEQ "ALTA" and isdefined('rsDSolicitudProcesos')>
			<tr>
				<td colspan="4">
					<cfif NOT LEN(TRIM(rsDSolicitudProcesos.CPformato))>
						<span class="Rojo">No se pudo recuperar la cuenta de Presupuesto</span>
					<cfelseif NOT LEN(TRIM(rsDSolicitudProcesos.Oficodigo))>
						<span class="Rojo">No se pudo recuperar la Oficina a afectar Presupuesto</span>
					<cfelseif NOT rsSQLPP.RecordCount>
						<span class="Rojo">No existe un periodo de presupuesto configurado para el periodo y mes de Auxiliares</span>
					<cfelseif ListFind('0,2',rsSQLPP.CPPestado)>
						<span class="Rojo">El periodo presupuestario se encuentra cerrado o Inactivo</span>
					<cfelseif ListFind('5',rsSQLPP.CPPestado)>
						<span class="Rojo">No se está controlando presupuesto</span>	
					<cfelseif LEN(TRIM(rsDSolicitudProcesos.NAP))> 
						<span class="Azul">La solicitud de pago ya posee un compromiso presupuestario asociado con la orden de compra. El numero de aprobación presupuestaria es <cfoutput><em>#rsDSolicitudProcesos.NAP#</em></cfoutput></span>
					<cfelseif LEN(TRIM(rsDSolicitudProcesos.CPCPtipoControl)) and rsDSolicitudProcesos.CPCPtipoControl EQ 0>
						<span class="Rojo">La cuenta presupuestaria <cfoutput><em>#rsDSolicitudProcesos.CPformato#</em> posee control Abierto</cfoutput>
					<cfelseif NOT LEN(TRIM(rsDSolicitudProcesos.Disponible))>
						<span class="Rojo">La cuenta presupuestaria <cfoutput><em>#rsDSolicitudProcesos.CPformato#</em>  para la Oficina <em>#rsDSolicitudProcesos.Odescripcion#</em> no esta formulada para el periodo presupuestario Activo</cfoutput>
					<cfelseif rsDSolicitudProcesos.Disponible LT rsDSolicitudProcesos.DSPmonto>
						<span class="Rojo">La cuenta presupuestaria <cfoutput><em>#rsDSolicitudProcesos.CPformato#</em>  para la Oficina <em>#rsDSolicitudProcesos.Odescripcion#</em> no posee fondos suficientes. Disponible <em>#LSnumberFormat(rsDSolicitudProcesos.Disponible,'999,999,9999.99')#</em> </cfoutput>
					<cfelse>
						<span class="Azul">Se afectará la cuenta presupuestaria <cfoutput><em>#rsDSolicitudProcesos.CPformato#</em> en la oficina <em>#rsDSolicitudProcesos.Odescripcion#</em> la cual tienen un disponible de <em>#LSnumberFormat(rsDSolicitudProcesos.Disponible,'999,999,9999.99')#</em></cfoutput></span>	
					</cfif>
				</td>
			</tr> 
		</cfif>
      	<tr align="center"> 
        	<td colspan="4">
				<br>
					<cfif modo EQ 'CAMBIO'>
						<input type="button" class="btnNormal"  tabindex="1" name="OrdenCompra" value="Orden Compra" onClick="javascript:SelectOC(#rsSolicitudProcesos.SNcodigo#,#rsSolicitudProcesos.SPid#,#rsSolicitudProcesos.Mcodigo#);">		    
					</cfif>
					<cfif modo NEQ "ALTA" and isdefined('rsDSolicitudProcesos') and form.DSPidCambio GT 0 >
                        <cf_botones modo="Cambio" exclude= ",Alta,Limpiar,Baja" formName = "fDetalle" incluyeForm="true" sufijo="Det">
                    <cfelse>
                         <cf_botones modo="Alta" incluyeForm="true" formName = "fDetalle" sufijo="Det">
                    </cfif>
					
				<br>
			</td>
      	</tr>
	</table>	
    </cfif>

</form>
</cfoutput>

<cf_dbfunction name="to_char" args="a.DSPid" returnvariable="Lvar_DSPid">
<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/edit_o.gif  onclick=editarlinea(' | #Lvar_DSPid# |') style=cursor:pointer />'" delimiters="|"  returnvariable="Lvar_editarregistro">
  
<cfif isdefined('form.SPid') and form.SPid GT 0  and modo EQ 'CAMBIO' >

	<cfquery name="rsLista" datasource="#Session.DSN#">		
		select distinct
			a.SPid            
			,a.DSPid
			,a.Vid
			,a.Cid
			,a.DSPdocumento    
			, <cf_dbfunction name="sPart"args="a.DSPdescripcion,1,60"> as DSPdescripcion
			,a.DSPobjeto   
			,a.DSPmonto
			,a.Vid as Vpkresp
			,c.Vcodigo as Vcodigoresp
			,c.Vdescripcion as Vdescripcionresp
			,d.Cdescripcion
			,coalesce(a.DSPimpuesto,0) as DSPimpuesto
			,a.Icodigo
			,a.DSPmontototal
			,#preservesinglequotes(Lvar_editarregistro)# as editar
			,CASE WHEN a.DOlinea IS NULL THEN 'N/A' ELSE Convert(varchar(10),eoc.EOnumero) + '-' + Convert(varchar(10),doc.DOconsecutivo)  END OrdenCompra
		from <cf_dbdatabase table="FTDSolicitudProceso " datasource="ftec"> a
			inner join <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> b
				on a.SPid = b.SPid
			LEFT OUTER JOIN DOrdenCM doc
				on doc.DOlinea = a.DOlinea
			LEFT OUTER JOIN EOrdenCM eoc
				on eoc.EOidorden = doc.EOidorden
			
			left outer join <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> c
				on a.Vid = c.Vid
				and a.Ecodigo = c.Ecodigo
				<cfif modo EQ 'CAMBIO' and isdefined('form.Tramite')>
					and a.Vid in (
								select e1.Vid
								from <cf_dbdatabase table="FTHistoriaTramite " datasource="ftec"> a1
									inner join <cf_dbdatabase table="FTTipoProceso " datasource="ftec"> b1
										on a1.TPid = b1.TPid
									inner join <cf_dbdatabase table="FTFlujoTramite " datasource="ftec"> c1
										on b1.TTid = c1.TTid
									inner join <cf_dbdatabase table="FTDFlujoTramite " datasource="ftec"> d1
										on c1.FTid = d1.FTid
									inner join <cf_dbdatabase table="FTAutorizador " datasource="ftec"> e1
										on d1.TAid = e1.TAid
										and e1.Vid in (select a.Vid
														from <cf_dbdatabase table="FTDSolicitudProceso " datasource="ftec"> a
														where A.SPid = a.SPid
														and coalesce(a.DScambiopaso,0) = 0)
										and a1.HTpasosigue = c1.FTpasoactual
										and e1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
								where a1.SPid = a.SPid 
									and a1.HTfecha = (select max(b11.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite " datasource="ftec"> b11 where b11.SPid = a1.SPid and HTcompleto = 1)
								)
				</cfif>
                                            
		   inner join Conceptos d
				on a.Cid = d.Cid
		where b.SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
		and coalesce(DScambiopaso,0) = 0
	</cfquery>	

	<cfquery name="rsListaTotal" datasource="#Session.DSN#">		
		select 
			sum(a.DSPmontototal) as Total
		from <cf_dbdatabase table="FTDSolicitudProceso " datasource="ftec"> a
			inner join <cf_dbdatabase table="FTSolicitudProceso " datasource="ftec"> b
				on a.SPid = b.SPid
		where b.SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
	</cfquery>	
                

            
	<form name="lista" method="post" action="SolicitudPago-Sql.cfm">
		<input type="hidden" name="modo" value="#modo#">
		<input type="hidden" name="SPidDelete" value="<cfoutput>#form.SPid#</cfoutput>">
		<table align="center" width="90%"><tr><td>
		<div class="row">
			<div class="col-sx-12">
				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" 				value="#rsLista#"/>
					<cfinvokeargument name="desplegar" 			value="Cdescripcion, DSPdescripcion, Vdescripcionresp,Icodigo,OrdenCompra,DSPimpuesto, DSPmonto, DSPmontototal,editar"/>
					<cfinvokeargument name="etiquetas" 			value="Concepto,     Descripción,    Proyecto,        Tipo Imp,OC,        Mto.Imp,     Monto,    Total,&nbsp;"/>
					<cfinvokeargument name="formatos" 			value="V,V,V,V,V,M,M,M,G"/>
					<cfinvokeargument name="align" 				value="left,left,left,left,right,right,right,right,right, right"/>
					<cfinvokeargument name="ajustar" 			value="S"/>
					<cfinvokeargument name="irA" 				value="SolicitudPago.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
					<cfinvokeargument name="EmptyListMsg" 		value="#LB_NoSeEncontraronRegistros#"/>
					<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
					<cfinvokeargument name="maxRows" 			value="30"/>
					<cfinvokeargument name="checkboxes" 		value="S"/>
					<cfinvokeargument name="checkall" 			value="S"/>
					<cfinvokeargument name="form_method" 		value="post"/>
					<cfinvokeargument name="incluyeform" 		value="false"/>
					<cfinvokeargument name="keys" 				value="DSPid"/>	
					<cfinvokeargument name="showLink" 			value="false"/>	
				</cfinvoke>
			</div>
		</div>
		<div class="row">
			<div class="col-sx-12" align="right">
	 			<cfoutput>Total: #LSnumberFormat(rsListaTotal.Total,'999,999,999.99')#</cfoutput>
	 		</div>
	 	</div>
	 <cfif rsLista.recordcount gt 0 and not isdefined('form.Tramite')>
	 		<div class="row">
				<div class="col-sx-12" align="center">
					<cf_botones incluyeForm="true" form="lista"  values="Eliminar" names="BajaDet" functions="funcEliminar();">
				</div>
			</div>
	</cfif>
	</td></tr></table>
	</form>
</cfif>

<cfoutput>


<script src="/cfmx/sif/js/qForms/qforms.js"></script>


<cf_qforms form="fEncabezado" objForm="objForm">
<cfif modo EQ "CAMBIO" and not isdefined('form.Tramite')>
	<cf_qforms form="fDetalle" objForm="objForm2">
</cfif>


<script type="text/javascript">

	function CalculaFechaVen(){ 
		if(document.getElementById('SPfechafactura').value !=''){
			fechaVencimiento = fndateadd(document.getElementById('SPfechafactura').value,document.getElementById('SNvencompras').value);
			document.getElementById('SPfechavence').value = fndateformat(fechaVencimiento);
		}
		else
			document.getElementById('SPfechavence').value ='';
	}
	<!---►►Funcion que suma Dias a un string con formato fecha◄◄--->
	function fndateadd(fecha, dias){
		f = fecha.split('/');
		stringFecha = new Date(f[2],f[1]-1,f[0]);
		return new Date(stringFecha.getTime() + dias * 86400000); //Cantidad de milesegundos en un Dia
	}
	<!---►►Funcion que convierte una fecha a un string de tipo DD/MM/YYYY◄◄--->
	function fndateformat(fecha){
		var dd   = fecha.getDate();
		var mm   = fecha.getMonth()+1;//Enero is 0
		var yyyy = fecha.getFullYear();
		if(dd<10){dd='0'+dd;}
		if(mm<10){mm='0'+mm;}
		return dd+'/'+mm+'/'+yyyy;;
	}
	
	var _divCheque = document.getElementById("divCheque");
		_divdivTransferencia = document.getElementById("divTransferencia");

		Fpago(document.fEncabezado.FPid);
		CalculaFechaVen();
		
		<!---objForm.Vpkresp.required = true;
		objForm.Vpkresp.description ="Proyecto";--->
		
		
		objForm.FPid.required = true;
		objForm.FPid.description ="Forma de pago";
		objForm.SPdocumento.required = true;
		objForm.SPdocumento.description ="Documento";
		
		<cfif modo EQ "CAMBIO" and not isdefined('form.Tramite')>
			
			objForm2.DSPdescripcion.required = true;
			objForm2.DSPdescripcion.description ="Descripción";
			
			objForm2.Ccodigo.required = true;
			objForm2.Ccodigo.description ="Concepto";
			
			objForm2.Vcodigoresp.required = true;
			objForm2.Vcodigoresp.description ="Proyecto";
			
			objForm2.Icodigo.required = true;
			objForm2.Icodigo.description ="Impuesto";
			
			
			
			objForm2.DSPmonto.required = true;
			objForm2.DSPmonto.description ="Monto";
			<!---objForm2.DSPobjeto.required = true;
			objForm2.DSPobjeto.description ="Objeto Gasto";--->
		</cfif>
		function Fpago(obj) {
			switch(obj.value) {
				case '1' :
					_divCheque.style.display = 'none';
					_divdivTransferencia.style.display = 'none';
					objForm.LPid.required = false;
					objForm.Bid.required = false;
					<!---objForm.SPctacliente.required = false;--->
					objForm.SPfechaTrans.required = false;
					objForm.SNnumero.required = false;
				break;
				case '2' :
					_divCheque.style.display = '';
					_divdivTransferencia.style.display = 'none';

					objForm.LPid.required = true;
					objForm.LPid.description ="Lugar Entrega";
					<!---objForm.SPctacliente.required = false;--->
					objForm.SPfechaTrans.required = false;
					objForm.SNnumero.required = false;
					
				break;
				case '3' :
					_divCheque.style.display = 'none';
					_divdivTransferencia.style.display = '';
					objForm.LPid.required = false;
					<!---objForm.Bid.required = true;
					objForm.Bid.description ="Banco";
					
					objForm.SPctacliente.required = true;
					objForm.SPctacliente.description ="Cuenta Cliente";--->
					
					objForm.SPfechaTrans.required = true;
					objForm.SPfechaTrans.description ="Fecha Transaccion";
					
					objForm.SNnumero.required = true;
					objForm.SNnumero.description ="Socio de Negocio";
								
				break;
				default:
					_divCheque.style.display = 'none';
					_divdivTransferencia.style.display = 'none';
					objForm.LPid.required = false;
					<!---objForm.SPctacliente.required = false;--->
					objForm.SPfechaTrans.required = false;
					objForm.SNnumero.required = false;
					
			}
		}
	
		function validaForm(f) {
			if (f.obj.LPid.value == 2) {
				objForm.LPid.required = true;
			}
		}


    
        function fnAlgunoMarcadolista(){
            if (document.lista.chk) {
                if (document.lista.chk.value) {
                    return document.lista.chk.checked;
                } else {
                    for (var i=0; i<document.lista.chk.length; i++) {
                        if (document.lista.chk[i].checked) { 
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        function funcEliminar(){
            if (!fnAlgunoMarcadolista()){
                alert("¡Debe seleccionar al menos una detalle para eliminar!");
                return false;
            }else{
                if ( confirm("¿Desea eliminar las detalle marcadas?") )	{
                    document.lista.action = 'SolicitudPago-Sql.cfm';
                    return true;
                }
                return false;
            }		
        }
		
		function editarlinea(id) {
			document.fDetalle.DSPidCambio.value=id;
			document.fDetalle.submit();
		}
		<!---Funcion para Seleccionar las Orden de Compra--->
    	function SelectOC(SNcodigo, SPid, Mcodigo) {
			var params ="";
			params = "&form=form"+
			popUpWindow("OrdenCompra.cfm?SNcodigo="+SNcodigo+"&SPid="+SPid+"&Mcodigo="+Mcodigo+params,50,50,900,750);
		}
		var popUpWin=0; 
		function popUpWindow(URLStr, left, top, width, height){
	  		if(popUpWin){
				if(!popUpWin.closed) popUpWin.close();
	  		}
	  		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
		function funcRefrescar(){
			document.fDetalle.action = 'SolicitudPago.cfm';
			document.fDetalle.submit();
		}

    </script>
</cfoutput>