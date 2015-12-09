<cf_importLibs>
<!---Filtros y Navegación--->
<cf_navegacion name="SNcodigo">
<cf_navegacion name="SPid">
<cf_navegacion name="Mcodigo">
<cf_navegacion name="fEOnumero">
<cf_navegacion name="fEOnumero2">
<cf_navegacion name="fObservaciones">
<cf_navegacion name="fEOfecha">
<cf_navegacion name="SNcodigoF">
<cfset navegacion = "">
<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) >
	<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero#">
</cfif>
<cfif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2)) >
	<cfset navegacion = navegacion & "&fEOnumero2=#form.fEOnumero2#">
</cfif>
<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
	<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
</cfif>
<cfif isdefined("Form.fEOfecha") and len(trim(form.fEOfecha))>
	<cfset navegacion = navegacion & "&fEOfecha=#form.fEOfecha#">
</cfif>
<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
	<cfset navegacion = navegacion & "&SNcodigoF=#form.SNcodigoF#">
</cfif>
<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) >
	<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#">
</cfif>
<cfif isdefined("Form.SPid") and len(trim(Form.SPid)) >
	<cfset navegacion = navegacion & "&SPid=#form.SPid#">
</cfif>	
<cfif isdefined("Form.Mcodigo") and len(trim(Form.Mcodigo)) >
	<cfset navegacion = navegacion & "&Mcodigo=#form.Mcodigo#">
</cfif>
<cfset valSNcodF = ''>
<cfif isdefined('form.SNcodigoF') and Len(Trim(form.SNcodigoF))>
	<cfset valSNcodF = form.SNcodigoF>
</cfif>
<cfif NOT IsDefined('form.SNcodigo') OR NOT LEN(TRIM(form.SNcodigo))>
	No se envio el Socio de Negocios<cfabort>
</cfif>
<cfif NOT IsDefined('form.Mcodigo') OR NOT LEN(TRIM(form.Mcodigo))>
	No se envio la Moneda<cfabort>
</cfif>
<cfif NOT isdefined('form.EOidorden')>
	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.EOidorden, a.Ecodigo, a.EOnumero, a.SNcodigo, #form.SPid# as SPid,
				a.CMCid, a.Mcodigo, a.Rcodigo, a.CMTOcodigo, 
				a.EOfecha, a.Observaciones, a.EOtc, a.EOrefcot, 
				a.Impuesto, a.EOdesc, a.EOtotal, a.Usucodigo, 
				a.EOfalta, a.Usucodigomod, a.fechamod, a.EOplazo, 
				a.NAP, a.NRP, a.NAPcancel, a.EOporcanticipo, a.EOestado, 
				b.Mnombre, 
				(( select min(c.CMCnombre) from CMCompradores c where c.CMCid = a.CMCid )) as CMCnombre, 
				(( select min(d.Rdescripcion) from Retenciones d where a.Ecodigo = d.Ecodigo and a.Rcodigo = d.Rcodigo)) as Rdescripcion ,
				e.SNnombre, 
				<cf_dbfunction name="concat" args="f.CMTOcodigo,' - ',f.CMTOdescripcion"> as descripcion,
				case 
					when f.CMTOte = 1 and a.EOdiasEntrega is null then a.EOidorden
					when f.CMTOtransportista = 1 and a.CRid is null then a.EOidorden
					when f.CMTOtipotrans = 1 and a.EOtipotransporte is null then a.EOidorden
					when f.CMTOincoterm = 1 and a.CMIid is null then a.EOidorden
					when f.CMTOlugarent = 1 and a.EOlugarentrega is null then a.EOidorden
				end as marca
		from EOrdenCM a 
			inner join Monedas b 
				on a.Mcodigo = b.Mcodigo 
			inner join SNegocios e 
				on a.Ecodigo  = e.Ecodigo 
			   and a.SNcodigo = e.SNcodigo 
			inner join CMTipoOrden f 
				on a.Ecodigo =f.Ecodigo 
			   and a.CMTOcodigo = f.CMTOcodigo 
		where a.Ecodigo = #session.Ecodigo#
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			and a.EOestado= 10 
			and ( 
				 select count(1) 
				   from DOrdenCM g 
				  where g.EOidorden = a.EOidorden 
					and g.DOcantidad - g.DOcantsurtida
			    > 0 
					and g.CMtipo = 'S' 
				 ) > 0
		  and ( (select count(1) 
		  			from DOrdenCM g 
					where g.EOidorden = a.EOidorden
					  and g.CMtipo = 'S')
					>
					(select count(1)  
					from DOrdenCM g 
						inner join DDocumentosCxP aa 
						on aa.DOlinea = g.DOlinea 
					where g.EOidorden = a.EOidorden 
					  and g.CMtipo = 'S'))
	
			<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) and isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2))>
				and a.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero2#">
			<cfelseif isdefined("form.fEOnumero") and len(trim(form.fEOnumero))>
				and a.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#">
			<cfelseif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2))>
				and a.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero2#">
			</cfif>
			<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
				and upper(Observaciones) like  upper('%#form.fObservaciones#%')
			</cfif>
			<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
				and e.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigoF#">
			</cfif>
			<cfif isdefined("Form.Mcodigo") and len(trim(Form.Mcodigo)) >
				and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			</cfif>				
			<cfif isdefined("Form.fEOfecha") and len(trim(Form.fEOfecha)) >
				and EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fEOfecha)#">
			</cfif>
		order by descripcion, EOnumero
	</cfquery>
	
	<cfoutput>
	<form action="OrdenCompra.cfm" name="fsolicitud" id="fsolicitud" method="post">
		<input type="hidden" value="#form.SPid#" 	 name="SPid" 	 id="SPid">
		<input type="hidden" value="#form.SNcodigo#" name="SNcodigo" id="SNcodigo">
		<input type="hidden" value="#form.Mcodigo#"  name="Mcodigo"  id="Mcodigo">
		<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
			<tr> 
				<td class="fileLabel" nowrap width="8%" align="right">
					<label for="fEOnumero">Número:</label>
				</td>
				<td nowrap width="31%">
					desde <input type="text" 
							onBlur="javascript:fm(this,0); "
							onFocus="javascript:this.value=qf(this); this.select();"
							onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
							name="fEOnumero" size="10" maxlength="20" value="<cfif isdefined('form.fEOnumero')>#form.fEOnumero#</cfif>" style="text-transform: uppercase; text-align: right;" tabindex="1">
					hasta <input type="text" 
							onBlur="javascript:fm(this,0); "
							onFocus="javascript:this.value=qf(this); this.select();"
							onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"									
							name="fEOnumero2" size="10" maxlength="20" value="<cfif isdefined('form.fEOnumero2')>#form.fEOnumero2#</cfif>" style="text-transform: uppercase; text-align: right;" tabindex="1">
			</td>
			<td class="fileLabel" nowrap width="9%" align="right">Descripci&oacute;n:</td>
			<td nowrap width="25%"><input type="text" name="fObservaciones" size="40" maxlength="100" value="<cfif isdefined('form.fObservaciones')>#form.fObservaciones#</cfif>" style="text-transform: uppercase;" tabindex="1">
			</td>
			<td width="27%" rowspan="2" align="center" valign="middle"><input type="submit" name="btnFiltro" class="btnFiltrar" value="Filtrar"></td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap width="10%">Proveedor:</td>
			<td nowrap width="10%">
				<cf_sifsociosnegocios2 form="fsolicitud" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1" tabindex="1">
			</td>
			<td class="fileLabel" align="right" nowrap>Fecha:</td>
			<td nowrap>
				<cfif isdefined('form.fEOfecha') and Len(Trim(form.fEOfecha))>
					<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fEOfecha" value="#form.fEOfecha#" tabindex="1">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fEOfecha" value="" tabindex="1">
				</cfif>	
			</td>
		  </tr>
		</table>
		</form>
	</cfoutput>
				
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
		<cfinvokeargument name="query" 				value="#rsLista#"/>
		<cfinvokeargument name="cortes" 			value="descripcion"/>
		<cfinvokeargument name="desplegar" 			value="EOnumero, Observaciones, SNnombre, EOfecha, Mnombre, EOtotal"/> 
		<cfinvokeargument name="etiquetas" 			value="N&uacute;mero, Descripci&oacute;n, Proveedor, Fecha, Moneda, Total"/> 
		<cfinvokeargument name="formatos" 			value="V,V,V,D,V,M"/> 
		<cfinvokeargument name="align" 				value="left,left,left,center,left,right"/> 
		<cfinvokeargument name="maxrows" 			value="50"/>
		<cfinvokeargument name="ajustar" 			value="N"/>
		<cfinvokeargument name="irA" 				value="OrdenCompra.cfm"/>
		<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
		<cfinvokeargument name="keys" 				value="EOidorden, SPid"/>
		<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
		<cfinvokeargument name="inactivecol" 		value="marca"/>
		<cfinvokeargument name="usaAjax" 			value="true"/>
		<cfinvokeargument name="conexion" 			value="#session.dsn#"/>
	</cfinvoke>

</cfif>
<script language="javascript1.2" type="text/javascript">
	function funcAplicar(){
		var continuar = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				continuar = document.lista.chk.checked;
			}
			else {
				for (var k = 0; k < document.lista.chk.length; k++) {
					if (document.lista.chk[k].checked) {
						continuar = true;
						break;
					}
				}
			}
			if (!continuar) { alert('Debe seleccionar una Orden de Compra'); }
		}
		else {
			alert('No existen Ordenes de compra')
		}

		if ( continuar ){
			document.lista.action = 'ordenCompra-sql.cfm';
			document.lista.submit();
		}	

		return continuar;
	}
</script>

<!--- Lista del Detalle (Con el Encabezado) --->
<cfif isdefined("form.EOidorden")>
<style type="text/css">
<!--
.style4 {font-size: 12px}
-->
</style>

<!--- Consulta del encabezado de la Orden ---> 
	<cfquery name="rsOrden" datasource="#Session.DSN#">
		select  e.EOidorden, e.ts_rversion, <!---Ocultos--->
			e.EOnumero,rtrim(e.CMTOcodigo) as CMTOcodigo,SNcodigo, <!---Línea 1--->
			EOfecha,e.Mcodigo,EOtc, <!---Línea 2--->
			EOplazo,
			coalesce(EOdesc,0.00)as EOdesc,
			Rcodigo, <!---Línea 3--->
			coalesce(<cf_dbfunction name="sPart" args="Observaciones,1,20">, 'N/A') as Observaciones, <!---Línea 5 --->
			coalesce(Impuesto,0.00) as Impuesto,
			e.EOtotal,  <!---Cálculados en el SQL--->
			e.Ecodigo, CMCid, <!---Están en la session--->
			EOrefcot,e.Usucodigo,EOfalta,Usucodigomod,fechamod, <!---Campos de Control --->
			NAP,EOestado, EOporcanticipo, CMFPid, CMIid,
			coalesce(EOdiasEntrega, 0) as EOdiasEntrega, coalesce(EOtipotransporte,'N/A') as EOtipotransporte, coalesce(EOlugarentrega,'N/A') as EOlugarentrega, CRid,
			CMTOte,CMTOtransportista, CMTOtipotrans, CMTOincoterm,CMTOlugarent
		from EOrdenCM e		    
			left outer join CMTipoOrden tor
				on tor.Ecodigo=e.Ecodigo
					and tor.CMTOcodigo=e.CMTOcodigo
		where e.Ecodigo =  #Session.Ecodigo# 
		  and e.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>

	<cfquery name="rsMontoDesc" datasource="#Session.DSN#">
		Select sum(coalesce(DOmontodesc,0)) as sumaDesc
		from DOrdenCM
		where Ecodigo =  #Session.Ecodigo# 
		  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		  and CMtipo = 'S'
	</cfquery>
	
	<cfif isdefined('rsOrden') and rsOrden.recordCount GT 0 and rsOrden.Mcodigo NEQ ''>
		<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
			Select Mcodigo,Mnombre
			from Monedas
			where Ecodigo= #Session.Ecodigo# 
				and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.Mcodigo#">
		</cfquery>
	</cfif>

	<!--- Nombre del Socio --->
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNcodigo, SNidentificacion, <cf_dbfunction name="sPart" args="SNnombre, 1, 20"> as SNnombre  from SNegocios 
		where Ecodigo =  #Session.Ecodigo# 
		  	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOrden.SNcodigo#">
	</cfquery>
	
	
	<!--- Formas de Pago --->
	<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
		select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
		from CMFormasPago
		where Ecodigo =  #Session.Ecodigo# 
			<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre)) and rsOrden.CMFPid NEQ ''>
				and CMFPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.CMFPid#">
			</cfif>
		order by CMFPcodigo
	</cfquery>
	<!--- Formas de pago por defecto del socio de negocio seleccionado ----->
	<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
		<cfquery name="rsFormaPagoSocio" datasource="#Session.DSN#">
			select b.CMFPid
			from SNegocios a
				left outer join CMFormasPago b
					on a.SNplazocredito = b.CMFPplazo
					and a.Ecodigo = b.Ecodigo
			where a.SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#"> 		
				and a.Ecodigo =  #Session.Ecodigo#  
		</cfquery>
	</cfif>		

<!--- Tipos de Orden --->
<cfquery name="rsTipoOrden" datasource="#session.DSN#">
	select rtrim(CMTOcodigo) as CMTOcodigo, CMTOdescripcion
	from CMTipoOrden
	where Ecodigo= #Session.Ecodigo# 
	<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
		and CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsOrden.CMTOcodigo)#">
	</cfif>
</cfquery>
<!--- Retenciones --->
<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select Rcodigo, Rdescripcion 
	from Retenciones 
	where Ecodigo =  #Session.Ecodigo# 
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre)) and rsOrden.Rcodigo NEQ '' and rsOrden.Rcodigo NEQ '-1'>
			and Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsOrden.Rcodigo#">
		</cfif>
	order by Rdescripcion
</cfquery>

<!--- Courier --->
<cfquery name="rsCourier" datasource="sifcontrol">
	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo =  #Session.Ecodigo# 
	and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">

	union

	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo is null
	and Ecodigo is null
	and EcodigoSDC is null

	order by 2
</cfquery>



<cfoutput>
<table align="center" width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap class="subTitulo"><font size="2">Encabezado Orden de Compra</font></td>
  </tr>
</table>
<table align="center" width="70%"  border="0" cellspacing="2" cellpadding="0" summary="Formulario del Encabezado de Ordenes de Compra (EOrdenCM)">
  <tr>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
  </tr>
  <!---Línea 1--->
	<tr>
    <td nowrap align="left"><strong>N&uacute;mero de Orden:&nbsp;</strong></td>
    <td nowrap align="right">
			<!---Número de Orden: Este campo se llena con un cálculo en el SQL --->
			<input type="text" name="EOnumero" size="18" tabindex="1"
				style="border: 0px none; background-color: ##FFFFFF;" maxlength="10" readonly=""  align="right"	
				value="<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>#rsOrden.EOnumero#<cfelse>N/D</cfif>"></td>
    <td nowrap align="left" width="10%"><strong>Tipo de Orden:&nbsp;</strong></td>
    <td nowrap width="10%" align="right">
			<!---Tipo de Orden--->
			<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
				<input type="hidden" name="CMTOcodigo" value="#rsOrden.CMTOcodigo#">
				#rsTipoOrden.CMTOcodigo# - #rsTipoOrden.CMTOdescripcion#
			</cfif>
		</td>
    <td nowrap align="left"><strong>Provedor:&nbsp;</strong></td>
    <td nowrap width="10%" align="right">
			<!---Provedor--->
			<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
				#rsNombreSocio.SNnombre# 
				<input type="hidden" name="SNcodigo" value="#rsOrden.SNcodigo#">
			<cfelseif isdefined("form.SNcodigo") and len(trim(form.SNCodigo))>			
				<cf_sifsociosnegocios2 sntiposocio="P" tabindex="1" idquery="#form.SNcodigo#">
			</cfif>
		</td>
  </tr>
	<!---Línea 2--->
  <tr>
    <td nowrap align="left"><strong>Fecha:&nbsp;</strong></td>
    <td nowrap align="right">
			<!---Fecha--->
			<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
				<input type="hidden" name="EOfecha" id="EOfecha" value="<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>#LSDateFormat(rsOrden.EOfecha,'dd/mm/yyyy')#</cfif>">
				#LSDateFormat(rsOrden.EOfecha,'dd/mm/yyyy')#
			</cfif> 
		</td>
    <td nowrap align="left"><strong>Moneda:&nbsp;</strong></td>
    <td nowrap align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
		 <input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsOrden.Mcodigo#">
		 <input type="hidden" name="TC" id="TC" value="#rsOrden.EOtc#">
			#rsMonedaSel.Mnombre#
		</cfif>  
 	</td>
    <td nowrap align="left" width="10%"><strong>Tipo de Cambio:&nbsp;</strong></td>
    <td nowrap width="10%" align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
			<input type="hidden" name="EOtc" id="EOtc" value="#LSNumberFormat(rsOrden.EOtc,',9.0000')#">
			#LSNumberFormat(rsOrden.EOtc,',9.0000')#
		</cfif> 
		</td>
  </tr>
	<!---Línea 3--->
  <tr>
    <td nowrap align="left"><strong>Retenci&oacute;n:&nbsp;</strong></td>
    <td nowrap align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
			<input type="hidden" name="Rcodigo" id="Rcodigo" value="<cfif len(trim(rsOrden.Rcodigo))>#rsOrden.Rcodigo#<cfelse>-1</cfif>">
			<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre)) and Len(Trim(rsOrden.Rcodigo))>
				#rsRetenciones.Rdescripcion#
			<cfelse>
				-- Sin Retenci&oacute;n --
			</cfif>
			
		<cfelse>
			<select name="Rcodigo" tabindex="1">
				<option value="-1" >-- Sin Retenci&oacute;n --</option>
				<cfloop query="rsRetenciones"> 
					<option value="#rsRetenciones.Rcodigo#">#rsRetenciones.Rdescripcion#</option>
				</cfloop>
			</select>
		</cfif> 
	</td>
    <td nowrap align="left"><strong>Descuento:&nbsp;</strong></td>
    <td nowrap align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
			<input type="hidden" name="EOdesc" id="EOdesc" value="<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>#LSCurrencyFormat(rsMontoDesc.sumaDesc,'none')#</cfif>">
			#LSCurrencyFormat(rsMontoDesc.sumaDesc,'none')#
		</cfif> 	
	</td>
    <td nowrap align="left"><strong>Anticipo % :&nbsp;</strong></td>
    <td nowrap align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
			<input type="hidden" name="EOporcanticipo" id="EOporcanticipo" value="#LSCurrencyFormat(rsOrden.EOporcanticipo,'none')#">
			#rsOrden.EOporcanticipo#
		</cfif> 
		</td>
  </tr>
	<!---Línea 4--->
  <tr>
    <td nowrap align="left"><strong>Formas de Pago:&nbsp;</strong></td>
    <td nowrap align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
			<input type="hidden" name="CMFPid" id="CMFPid" value="#rsCMFormasPago.CMFPid#">
			#rsCMFormasPago.CMFPdescripcion#
		</cfif> 
	</td>
    <td nowrap align="left"><strong>Plazo de Cr&eacute;dito:&nbsp;</strong></td>
    <td nowrap align="right">
	 	<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre)) and rsOrden.EOplazo NEQ 0>#rsOrden.EOplazo#<cfelse>0</cfif>d&iacute;as. 
	</td>
    <td nowrap align="left"><strong>Descripci&oacute;n:&nbsp;</strong></td>
    <td colspan="3" nowrap align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
			<input type="hidden" name="Observaciones" id="Observaciones" value="#rsOrden.Observaciones#">
			#rsOrden.Observaciones#
		</cfif> 
    </td>
    </tr>
  <tr>
    <td nowrap align="left"><strong>Lugar de Entrega:&nbsp;</strong></td>
    <td nowrap align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>#rsOrden.EOlugarentrega#<cfelse>N/A</cfif>
	</td>
    <td nowrap align="left"><strong>Tipo de Transporte:&nbsp;</strong></td>
    <td nowrap align="right">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>#rsOrden.EOtipotransporte#</cfif>
	</td>
    <td nowrap align="left"><strong>Tiempo de Entrega:&nbsp;</strong></td>
    <td nowrap align="right">
      <cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>#rsOrden.EOdiasEntrega#<cfelse>0</cfif> d&iacute;as. 
	</td>
  </tr>
  <tr>
  </tr> 
  <tr><td nowrap colspan="6">&nbsp;</td></tr>
</table>
</cfoutput>

<!--- Fin Encabezado --->
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="subTitulo"><font size="2">Lista de Detalles</font>

        </td>
	</tr>
</table>
<!---Lista de Items--->
<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden))>
<cfquery name="rsListaItems" datasource="#session.dsn#">
	select 	a.DOlinea, 
			#form.SPid# as SPid,
			u.Ucodigo,
			u.Udescripcion,	
			a.DOconsecutivo, 
			case a.CMtipo when 'A' then 'Artículo' when 'S' then 'Servicio' when 'F' then 'Activo' end as CMTipodesc,
			a.DOdescripcion, 
			a.DOcantidad - a.DOcantsurtida 
			<!---Menos Cantidad en digitacion de CxP--->
			- Coalesce((select sum(dcp.DDcantidad)
					from DDocumentosCxP dcp
				  where dcp.DOlinea = a.DOlinea			
				 ),0)
			<!---Menos Cantidad en Digitacion de SP---> 
			- Coalesce((select sum(coalesce(dsp.DSPcantidad,1))
				from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> dsp
			  where dsp.DOlinea = a.DOlinea			
			 ),0)
			as DOSaldocantidad, 
			a.DOcantidad,
			<!---Cantidad en digitacion de CxP--->
			Coalesce((select sum(dcp.DDcantidad)
				from DDocumentosCxP dcp
			  where dcp.DOlinea = a.DOlinea			
			 ),0) CantidadEnCP,
			<!---Cantidad en Digitacion de SP---> 
			Coalesce((select sum(coalesce(dsp.DSPcantidad,1))
				from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> dsp
			  where dsp.DOlinea = a.DOlinea			
			 ),0) CantidadEnSP,
			 
			
			case when a.DOcontrolCantidad = 1 
			then 
			   a.DOpreciou
			else
			   a.DOpreciou -coalesce(a.DOmontoSurtido,0)
			 end 
			 as DOpreciou,
			a.DOmontodesc,
			case when a.DOcontrolCantidad = 1 
			 then 
			     a.DOtotal - a.DOmontodesc
			  else
  			     a.DOtotal -coalesce(a.DOmontoSurtido,0) - a.DOmontodesc 
			  end
			  as total,
  		    coalesce(a.DOmontoSurtido,0) as DOmontoSurtido,
			a.EOidorden,
			case CMtipo 
			    when 'A' then (select min(e.Acodigo) from Articulos e where e.Aid = a.Aid) 
				when 'F' then '-' 
				when 'S' then (select min(f.Ccodigo) from Conceptos f where f.Cid = a.Cid) 
			end as Codigo,
            case 
               	when a.DOcantidad - a.DOcantsurtida 
			<!---Menos Cantidad en digitacion de CxP--->
			- Coalesce((select sum(dcp.DDcantidad)
					from DDocumentosCxP dcp
				  where dcp.DOlinea = a.DOlinea			
				 ),0)
			<!---Menos Cantidad en Digitacion de SP---> 
			- Coalesce((select Count(1)
				from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> dsp
			  where dsp.DOlinea = a.DOlinea			
			 ),0)  > 0 then 
					0
                else
                	#form.SPid# 
            end as chico
            
	from DOrdenCM a
		left outer join  Unidades u
			on u.Ucodigo = a.Ucodigo
			and u.Ecodigo= a.Ecodigo	

	where a.Ecodigo =  #Session.Ecodigo# 
	  and a.CMtipo = 'S'
		<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden))>
			and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfif>
			and a.DOcantidad - a.DOcantsurtida 
			> 0
	Order by DOconsecutivo
</cfquery>
<!---<cfdump var="#rsListaItems#">--->
</cfif>
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
        	<cfset navegacion = "">
			<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden)) >
				<cfset navegacion = navegacion & "&EOidorden=#form.EOidorden#">
			</cfif>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
					<cfinvokeargument name="query" 		value="#rsListaItems#">
					<cfinvokeargument name="desplegar" 	value="DOconsecutivo,CMTipodesc,Codigo,DOdescripcion,DOcantidad,CantidadEnCP,CantidadEnSP, DOmontoSurtido, DOSaldocantidad,Udescripcion,DOpreciou,DOmontodesc,total">
					<cfinvokeargument name="etiquetas"	value="L&iacute;nea,Tipo,C&oacute;digo,Descripci&oacute;n,Cantidad Ordenada, Tramitando en CxP, Tramitando en SP,Surtido en CxP,Cantidad sin Surtir,Unidad Medida,Precio,Descuento,Total">
					<cfinvokeargument name="formatos" 	value="V,V,V,V,V,M,M,M,M,V,M,M,M,S">
					<cfinvokeargument name="align" 		value="left,left,left,left,right,right,right,right,center,right,right,right,right,right">
					<cfinvokeargument name="ajustar" 	value="S">
				<cfif isdefined ("rsListaItems") and rsListaItems.recordcount GT 0>
					<cfinvokeargument name="botones"	value="Agregar"/>
				</cfif>
                <cfinvokeargument name="showEmptyListMsg" 	value="true">
				<cfinvokeargument name="irA" 				value="OrdenCompra-SQL.cfm">
				<cfinvokeargument name="formName" 			value="form3">
				<cfinvokeargument name="keys" 				value="SPid,DOlinea">
				<cfinvokeargument name="funcion" 			value="ProcesarLinea">
				<cfinvokeargument name="fparams" 			value="DOlinea">
				<cfinvokeargument name="checkboxes" 		value="S"/>
                <cfinvokeargument name="checkall" 			value="S"/>
				<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
				<cfinvokeargument name="usaAjax" 			value="true"/>
				<cfinvokeargument name="conexion" 			value="#session.dsn#"/>				
				<cfinvokeargument name="maxrows" 			value="15"/>
                <cfinvokeargument name="inactivecol"  		value="chico"/>
			</cfinvoke>
		</td>
	</tr>
	<tr>
		<tr>
			<td>
				 Las columnas deshabilitadas indican que ya se encuentran asignadas a alguna Factura.
			</td>
		</tr>
	</tr>
</table>
<script language='javascript' type='text/JavaScript' >
<!--//
	function ProcesarLinea(Linea){
		return false;
	}
//-->
</script>

<hr width="99%" align="center">
</cfif>
<!---Javascript Incial--->
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js" type="text/javascript"></script>