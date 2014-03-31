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

<cf_dbfunction name="op_concat" returnvariable="_cat">

<script src="/cfmx/rh/js/utilesMonto.js"></script>

<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion , Icodigo #_Cat# ' - ' #_Cat# Idescripcion as Descripcion, Iporcentaje
	from Impuestos 
	where Ecodigo = #Session.Ecodigo#
	order by Idescripcion                                 
</cfquery>


<cfquery name="rsFPagos" datasource="#Session.DSN#">
	select 	
        FPid                 
        ,FPcodigo     
        ,FPdescripcion 
	from FTFormaPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by FPdescripcion
</cfquery>


<cfquery name="rsLPagos" datasource="#Session.DSN#">
	select 	
        LPid                 
        ,LPcodigo     
        ,LPdescripcion 
	from FTLugarPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by LPdescripcion
</cfquery>

<cfquery name="rsBancos" datasource="#Session.DSN#">
	select 	
        Bid
        ,Bcodigo
        ,Ecodigo
        ,Bdescripcion
	from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Bdescripcion
</cfquery>


<cfif modo NEQ "ALTA" and isdefined('form.SPid') and #form.SPid# GT 0>
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
        from FTSolicitudProceso a
        inner join FTFormaPago c
        	on a.FPid = c.FPid
            and a.Ecodigo = c.Ecodigo
        left outer join FTLugarPago d
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
    
    

    
	
<!---<cfelseif modo EQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("url.DEid") AND Len(Trim(url.DEid)) NEQ 0>
	<cfquery name="rsEmpleadoDef" datasource="#Session.DSN#">
		select a.DEid, 
			   <cf_dbfunction name="concat" args="a.DEapellido1|' '|a.DEapellido2|', '|a.DEnombre" delimiters="|"> as 	NombreEmp,
		       a.DEidentificacion, 
			   a.NTIcodigo
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>--->
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
<cfoutput>

<!---onSubmit="javascript: return validaForm(this);"--->
<form  name="fEncabezado" method="post" action="SolicitudPago-Sql.cfm" >
	<input type="hidden" name="modo" value="#modo#">
    <input type="hidden" name="SPid" value="<cfif isdefined('form.SPid')> #form.SPid# </cfif>">
	<input type="hidden" name="TPid" value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.TPid#</cfif>">
    <input type="hidden" name="SPfp" value="<cfif isdefined('form.FPid')> #form.FPid# </cfif>">
    <input type="hidden" name="Tramite" value="<cfif isdefined('form.Tramite')> #form.Tramite# </cfif>">    
    
    
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">
        <tr>
            <td colspan="5"> 
                <fieldset>
                    <legend><b>&nbsp;Encabezado&nbsp;</b></legend>
                    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="1">
                        <!---************************************* CAMPOS DEL MANTENIMIENTO ***************************************---->	
                        <!--- Línea No. 1 --->
                        <tr>
                        <td colspan="2">
                            <table>
                                <td align="right">Documento:</td>
                                <td nowrap>
                                        <input name="SPdocumento" type="text" id="SPdocumento" size="25" maxlength="25"  style="text-align: right;" 
                                        value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPdocumento#</cfif>" >
                                </td>
                                <td  class="fileLabel">N°.Acta:</td>
                                <td nowrap>
                                    <input name="SPacta" type="text" id="SPacta" size="18" maxlength="15"  style="text-align: right;" 
                                    value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPacta#</cfif>" >
                                </td>
                            </table>
						</td>
                        <td align="right">Forma de Pago:</td>	
                            <td>    
                                <select name="FPid"  id="FPid" onchange="javascript:Fpago(this);">
                                	<option value="">--- Seleccionar ---</option>
                                    <!---<option value="1" <cfif modo neq 'ALTA' and isdefined("rsSolicitudProcesos") and rsSolicitudProcesos.FPid eq 1 >selected</cfif> >Caja Chica</option>--->
                                    <option value="2" <cfif modo neq 'ALTA' and isdefined("rsSolicitudProcesos") and rsSolicitudProcesos.FPid eq 2 >selected</cfif> >Cheque</option>
                                    <option value="3" <cfif modo neq 'ALTA' and isdefined("rsSolicitudProcesos") and rsSolicitudProcesos.FPid eq 3 >selected</cfif> >Transferencia</option>
                                </select>
                            </td>

                        <tr>
                        <td align="right">Proveedor: 
                        <td  align="left"  colspan="1">
                            <cfif modo NEQ "ALTA">
                                <cf_rhsociosnegociosFA form="fEncabezado"  query="#rsSolicitudProcesos#"> 
                            <cfelse>
                                <cf_rhsociosnegociosFA form="fEncabezado" > 
                            </cfif>
                        </td>
                        <td  nowrap="nowrap"  align="right">Retenci&oacute;n al Pagar:&nbsp;</td>
                        <td>
                            <select name="Rcodigo" tabindex="1"> 
                                <option  title="-- Sin Retención --" value="-1"> -- Sin Retención -- </option>
                                <cfloop query="rsRetenciones">
                                    <option  title="#rsRetenciones.Rcodigo#" value="#rsRetenciones.Rcodigo#" 
                                    <cfif modo NEQ "ALTA" and isdefined('rsRetenciones') and isdefined('rsDocumento') and rsRetenciones.Rcodigo EQ rsDocumento.Rcodigo>selected
                                                                <cfelseif modo NEQ 'ALTA' and isdefined('form.Rcodigo') and isdefined('rsRetenciones') and rsRetenciones.Rcodigo EQ form.Rcodigo>selected</cfif>> #rsRetenciones.Rdescripcion# </option>
                                </cfloop>
                            </select>
                        </td>
                        </tr>
                        
                        <!---<tr>
							<!---►►Cuenta◄◄--->
                            <td><div align="right">&nbsp;Cuenta:&nbsp;</div></td>
                            <td  colspan="2"><cfoutput>
                                <cfif LvarComplementoXorigen>
                                  <input 	type="hidden" 	name="Ccuenta" 	id="Ccuenta"  	value="<cfif modo NEQ "ALTA">#rsCtaDocumento.Ccuenta#</cfif>" />
                                  <input	type="text"		name="SNCta" 	id="SNCta" 		value="<cfif modo NEQ "ALTA">#TRIM(rsCtaDocumento.CFformato)#  -  #trim(rsCtaDocumento.CFdescripcion)#</cfif>" 
                                        size="70" style="border:none;" readonly="yes" tabindex="1" />
                                  <cfelse>
                                  <cfif modo NEQ "ALTA">
                                    <cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsDocumento#" auxiliares="N" movimiento="S" 
                                                    ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato" igualTabFormato="S">
                                    <cfelse>
                                    <cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" 
                                                    ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato" igualTabFormato="S">
                                  </cfif>
                                </cfif>
                            </cfoutput>
                          </tr>--->
                        
                       
                        <tr>
						<!---►►Fecha de Arribo◄◄--->
                        <td><div align="right">Fecha&nbsp;Arribo:&nbsp;</div></td>
                        <td>
                            <cfif modo NEQ 'ALTA'>
                                <cf_sifcalendario form="fEncabezado" name="SPfechaarribo" value="#LSDateFormat(rsSolicitudProcesos.SPfechaarribo,'dd/mm/yyyy')#" tabindex="1" >
                            <cfelseif isdefined("form.SPfechaarribo")>
                                <cf_sifcalendario form="fEncabezado" name="SPfechaarribo" value="#LSDateFormat(form.SPfechaarribo,'dd/mm/yyyy')#"        tabindex="1" >
                            <cfelse>
                                <cf_sifcalendario form="fEncabezado" name="SPfechaarribo" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1" >
                            </cfif>
                        </td>
                        <!---►►Moneda◄◄--->
                        <td><div align="right">Moneda:&nbsp;</div></td>
                        <td>
							<cfif isdefined('modo') and  modo eq 'CAMBIO'>
                               <cf_sifmonedas Conexion="#session.DSN#" form="fEncabezado" query="#rsSolicitudProcesos#"  Mcodigo="Mcodigo" tabindex="1">
                            <cfelse>
                                <cf_sifmonedas Conexion="#session.DSN#" form="fEncabezado" Mcodigo="Mcodigo" tabindex="1">
                            </cfif>
                        </td>
                      </tr>
                      <tr>
                      <!---►►Fecha Factura◄◄--->
                        <td><div align="right">Fecha&nbsp;Factura:&nbsp;</div></td>
                        <td>
							<cfif modo NEQ 'ALTA'>
                                <cf_sifcalendario form="fEncabezado" name="SPfechafactura" value="#LSDateFormat(rsSolicitudProcesos.SPfechafactura,'dd/mm/yyyy')#" tabindex="1" >
                            <cfelseif isdefined("form.SPfechafactura")>
                                <cf_sifcalendario form="fEncabezado" name="SPfechafactura" value="#LSDateFormat(form.SPfechafactura,'dd/mm/yyyy')#"        tabindex="1" >
                            <cfelse>
                                <cf_sifcalendario  form="fEncabezado" name="SPfechafactura" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1" >
                            </cfif>
                        </td>
						
						
                        <td colspan="2">
							<table border="0">
    		                    <tr id="divCheque" > 
            			            <td>Lugar Entrega:</td>
                                    <td>
                                        <select name="LPid">
                                            <option value="">--- Seleccionar ---</option>
                                            <cfloop query="rsLPagos">
                                                <option value="#LPid#" <cfif modo EQ 'CAMBIO' and rsLPagos.LPid EQ rsSolicitudProcesos.LPid> selected</cfif>>#LPdescripcion#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </td>

                       <!---►►Tipo de Cambio◄◄--->
                        <!---<td><div align="right">Tipo Cambio:&nbsp;</div></td>
                        <td><input name="EDtipocambio" type="text" tabindex="1" 
                                
                                onChange="javascript:validatcLOAD(this.form);"
                                onkeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                                onfocus="javascript:if(!document.form1.EDtipocambio.disabled) document.form1.EDtipocambio.select();" 
                                style="text-align:right" 
                                value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.EDtipocambio##LSCurrencyFormat('0','none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="10" maxlength="10" />
                        </td>--->
                      </tr>
                      <tr>
                      <!---►►Fecha de vencimiento◄◄--->
                        <td><div align="right">Fecha&nbsp;Vencimiento:&nbsp;</div></td>
                        <td>
                            <cfif modo NEQ 'ALTA'>
                                <cf_sifcalendario form="fEncabezado" name="SPfechavence" value="#LSDateFormat(rsSolicitudProcesos.SPfechavence,'dd/mm/yyyy')#" tabindex="1" >
                            <cfelseif isdefined("form.SPfechavence")>
                                <cf_sifcalendario form="fEncabezado" name="SPfechavence" value="#LSDateFormat(form.SPfechavence,'dd/mm/yyyy')#"        tabindex="1" >
                            <cfelse>
                                <cf_sifcalendario  form="fEncabezado" name="SPfechavence" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1" >
                            </cfif>
                        </td>
                        
                        <!---►►Oficina◄◄--->
                        <!---<td><div align="right">Oficina:&nbsp;</div></td>
                        <td><select name="Ocodigo" tabindex="1">
                            <cfoutput query="rsOficinas">
                              <option value="#rsOficinas.Ocodigo#" 
                                        <cfif modo NEQ "ALTA" and rsOficinas.Ocodigo EQ rsDocumento.Ocodigo>selected
                                        <cfelseif modo EQ 'ALTA' and isdefined('form.Ocodigo') and rsOficinas.Ocodigo EQ form.Ocodigo>selected</cfif>> #rsOficinas.Odescripcion# </option>
                            </cfoutput>
                          </select>
                        </td>--->
                      </tr>
                      <tr>
                          <td colspan="4" >Observaci&oacute;n:
                                <textarea name="SPobservacion" cols="150" id="SPobservacion"><cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPobservacion#</cfif></textarea>
                           </td>
                        </tr>
                      <tr>
                      <!---►►Pagos a Terceros◄◄--->
                        <!---<td  align="right"> Pagos a terceros:&nbsp; </td>
                        <td >
                            <cfif modo NEQ "ALTA">
                              <cf_cboTESRPTCid query="#rsDocumento#" tabindex="1" SNid="#rsNombreSocio.SNid#">
                              <cfelse>
                              <cfset form.TESRPTCid = "">
                              <cf_cboTESRPTCid tabindex="1" SNid="#LvarSNid#">
                            </cfif>
                        </td>--->
                        <!---►►Retencion◄◄--->
                        
                      </tr>
                      <tr>
                        <tr>
                        	<table border="0" id="divTransferencia" width="100%">
                                <!---<tr>
                                <td  class="fileLabel">Banco:
                                    <select name="Bid">
                                        <option value="">--- Seleccionar ---</option>
                                        <cfloop query="rsBancos">
                                            <option value="#Bid#" <cfif modo EQ 'CAMBIO' and rsBancos.Bid EQ rsSolicitudProcesos.Bid> selected</cfif>>#Bdescripcion#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td  class="fileLabel">Cuenta Cliente:
                                    <input name="SPctacliente" type="text" id="SPctacliente" size="20" maxlength="20"  style="text-align: right;" 
                                    value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPctacliente#</cfif>" >
                                </td>
                                </tr>--->
                                
                                <tr> <td colspan="4">
                                	<table border="0" width="100%">
                                    <tr>
                                        <td  class="fileLabel">Fecha Transacci&oacute;n:</td>
                                        <td>
                                            <cfif modo NEQ "ALTA">
                                                <cf_sifcalendario form="fEncabezado" name="SPfechaTrans" value="#LSDateFormat(rsSolicitudProcesos.SPfechaTrans,'dd/mm/yyyy')#">
                                            <cfelse>
                                                <cf_sifcalendario form="fEncabezado" name="SPfechaTrans" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                                            </cfif>
                                        </td>  
                                    </tr>
                                    </table>
                                </td>
                                </tr>
                            </table>
                        </tr>

                  <tr align="center"> 
                            <td colspan="5" align="center">
                                <br>
                                <cfif isdefined('form.Tramite') and #modo# EQ 'CAMBIO'>
                                	<cf_botones modo="#modo#" exclude= "Nuevo,Alta,Limpiar,Cambio,Baja" formName = "fEncabezado"  sufijo="Enc" include="Aplicar,Rechazar,Regresar" >
								<cfelseif #modo# EQ 'CAMBIO'>
	                               	<cf_botones modo="#modo#" incluyeForm="true" formName = "fEncabezado"  sufijo="Enc" include="Aplicar,Regresar" >
                                <cfelse>
                                	<cf_botones modo="#modo#" incluyeForm="true" formName = "fEncabezado"  sufijo="Enc" >
                                </cfif>
                                <br>
                            </td>
                        </tr>
                        
                        
                    </table>
                </fieldset>
            </td>
        </tr>
      	
	</table>
    
</form>



<form  name="fDetalle" method="post" action="SolicitudPago-Sql.cfm">
	<input type="hidden" name="modo" value="#modo#">
    <input type="hidden" name="SPid" value="#form.SPid#">

<!---<input type="hidden" name="TPid" value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.TPid#</cfif>">
<input type="hidden" name="SPfp" value="<cfif isdefined('form.FPid')> #form.FPid# </cfif>">--->

    

	<cfif modo EQ 'CAMBIO' and not isdefined('form.Tramite')>
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
	                        <td><cf_sifconceptos size="22" form="fDetalle"  verclasificacion="0" tabindex="1"></td>
                            <td  align="right">Impuesto:</td>
                            <td >
                                <select name="Icodigo" tabindex="1"> 
                                    <option  title="-- Seleccione --" value=""> -- Seleccione -- </option>
                                    <cfloop query="rsImpuestos">
                                        <option  title="#rsImpuestos.Icodigo#" value="#rsImpuestos.Icodigo#"> #rsImpuestos.Descripcion# </option>
                                    </cfloop>
                                </select>
                            </td>
                      	</tr>
                        <tr>
                        	<td align="right">Proyecto:</td>
	                        <td><cf_FTvicerrectoria tabindex="1" form="fDetalle" size="30" id="Vpkresp" name="Vcodigoresp" desc="Vdescripcionresp" titulo="Seleccione Proyecto" proyectos="1"  usuario="1"></td>
                        </tr>            
                        <tr><td>&nbsp;</td></tr>
                        <tr> 
                        	<td  align="right">Descripci&oacute;n:</td>
                            <td>
                                <input name="DSPdescripcion" type="text" id="DSPdescripcion" size="60" maxlength="255"  style="text-align: left;"  value="" />
                            </td>
                            <td  class="fileLabel" align="right">Monto</td>
                            <td>
	                            <cf_inputNumber name="DSPmonto"  value="0.00" enteros="15" decimales="2" negativos="false" comas="no">
                            </td>
                            <!---<td  align="right">Objeto de Gasto</td>
                            <td>
                                <input name="DSPobjeto" type="text" id="DSPobjeto" size="60" maxlength="60"   value="" />
                            </td>--->
                        </tr>
                    </table>
         	</td>
        </tr>    
      	<tr align="center"> 
        	<td colspan="4">
				<br>
                   <cf_botones modo="Alta" incluyeForm="true" formName = "fDetalle" sufijo="Det">
				<br>
			</td>
      	</tr>
	</table>	
    </cfif>

</form>
</cfoutput>

<!---<cf_dbfunction name="to_char" args="a.DSPid" returnvariable="Lvar_DSPid">
<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/edit_o.gif  onclick=editarlinea(' | #Lvar_DSPid# |') style=cursor:pointer />'" delimiters="|"  returnvariable="Lvar_editarregistro">
--->  
<cfif isdefined('form.SPid') and form.SPid GT 0>
    <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td align="center">
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
                        <!---,#preservesinglequotes(Lvar_editarregistro)# as editar--->
                    from FTDSolicitudProceso a
                        inner join FTSolicitudProceso b
                            on a.SPid = b.SPid
                        inner join FTVicerrectoria c
                            on a.Vid = c.Vid
                            and a.Ecodigo = c.Ecodigo
                            <cfif modo EQ 'CAMBIO' and isdefined('form.Tramite')>
                            	and a.Vid in (
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
                                                    and e1.Vid in (select a.Vid
                                                                    from FTDSolicitudProceso a
                                                                    where A.SPid = a.SPid
                                                                    and coalesce(a.DScambiopaso,0) = 0)
                                                    and a1.HTpasosigue = c1.FTpasoactual
                                                    and e1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
                                            where a1.SPid = a.SPid 
                                                and a1.HTfecha = (select max(b11.HTfecha) from FTHistoriaTramite b11 where b11.SPid = a1.SPid and HTcompleto = 1)
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
                    from FTDSolicitudProceso a
                        inner join FTSolicitudProceso b
                            on a.SPid = b.SPid
                    where b.SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
                </cfquery>	
                

                <cfinvoke component="sif.Componentes.Translate"
                 method="Translate"
                 key="LB_NoSeEncontraronRegistros"
                 default="No se encontraron Registros "
                 returnvariable="LB_NoSeEncontraronRegistros"/> 

                <form name="lista" method="post" action="SolicitudPago-Sql.cfm">
                    <input type="hidden" name="modo" value="#modo#">
                    <input type="hidden" name="SPidDelete" value="<cfoutput>#form.SPid#</cfoutput>">

                    
                    <cfinvoke component="rh.Componentes.pListas"
                     method="pListaQuery"
                     returnvariable="pListaRet">
                        <cfinvokeargument name="query" value="#rsLista#"/>
                        <cfinvokeargument name="desplegar" value="Cdescripcion, DSPdescripcion, Vdescripcionresp,Icodigo,DSPimpuesto, DSPmonto, DSPmontototal"/>
                        <cfinvokeargument name="etiquetas" value="Concepto,Descripción, Proyecto,Tipo Imp, Mto.Imp,Monto, Total"/>
                        <cfinvokeargument name="formatos" value="V,V,V,V,M,M,,M,G"/>
                        <cfinvokeargument name="align" value="left, left, left,left,right,right,right, right"/>
                        <cfinvokeargument name="ajustar" value="N"/>
                        <cfinvokeargument name="irA" value="SolicitudPago.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg" value="true"/>
                        <cfinvokeargument name="EmptyListMsg" value="#LB_NoSeEncontraronRegistros#"/>
                        <cfinvokeargument name="navegacion" value="#navegacion#"/>
                        <cfinvokeargument name="maxRows" value="30"/>
                        <cfinvokeargument name="checkboxes" value="S"/>
                        <cfinvokeargument name="checkall" value="S"/>
                        <cfinvokeargument name="form_method" value="post"/>
                        <cfinvokeargument name="incluyeform" value="false"/>
                        <cfinvokeargument name="keys" value="DSPid"/>	
                        <cfinvokeargument name="showLink" value="false"/>	
                    </cfinvoke>
                    
                 <div  align="right"><cfoutput><b>Total: </b> #LSnumberFormat(rsListaTotal.Total,'999,999,999.99')#</cfoutput></div>
				 <cfif rsLista.recordcount gt 0 and not isdefined('form.Tramite')>
                    <cf_botones incluyeForm="true" form="lista"  values="Eliminar" names="BajaDet" functions="funcEliminar();">
                </cfif>
                </form>
               </td>
            </tr>
		</table>
</cfif>

<cfoutput>


<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<cf_qforms form="fEncabezado" objForm="objForm">
<cfif modo EQ "CAMBIO" and not isdefined('form.Tramite')>
	<cf_qforms form="fDetalle" objForm="objForm2">
</cfif>

<script language="JavaScript1.2" type="text/javascript">

	var _divCheque = document.getElementById("divCheque");
		_divdivTransferencia = document.getElementById("divTransferencia");

		Fpago(document.fEncabezado.FPid);
		
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
					objForm.SPctacliente.required = false;
					objForm.SPfechaTrans.required = false;
					objForm.SNnumero.required = false;
				break;
				case '2' :
					_divCheque.style.display = '';
					_divdivTransferencia.style.display = 'none';

					objForm.LPid.required = true;
					objForm.LPid.description ="Lugar Entrega";
					objForm.SPctacliente.required = false;
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
					objForm.SPctacliente.required = false;
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
		
		<!---function editarlinea(id) {
			alert(id);
			document.fDetalle.SPid.value=id;
			document.fDetalle.submit();
		}--->

    
    </script>
</cfoutput>