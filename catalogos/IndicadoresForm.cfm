
<!-- Establecimiento del modo -->
	<cfif isdefined("form.Cambio")>
        <cfset modoIN="CAMBIO">
    <cfelse>
        <cfif not isdefined("form.modoIN")>
            <cfset modoIN="ALTA">
        <cfelseif form.modoIN EQ "CAMBIO">
            <cfset modoIN="CAMBIO">
        <cfelse>
            <cfset modoIN="ALTA">
        </cfif>
    </cfif>    

<cfif isdefined('form.Iid2') and #form.Iid2# GT 0>
	<cfset form.Iid = #form.Iid2#>
    <cfset modoIN = 'CAMBIO'>
</cfif>

<cfif modoIN neq 'ALTA'>
	<cfquery name="rsTipos" datasource="#Session.DSN#" >
	Select *
	from <cf_dbdatabase table="FTIndicador" datasource="ftec">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Iid = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Iid#" >		  
		order by Icodigo asc
	</cfquery>
</cfif>

<cfoutput>
<form action="IndicadoresSQL.cfm" method="post" name="form">
	<input name="Iid" type="hidden" value="<cfif isdefined('rsTipos')> <cfoutput>#rsTipos.Iid#</cfoutput></cfif>"> 
	<table width="100%" height="75%" align="center" cellpadding="1" cellspacing="0">
		<tr>
			<td align="right" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:</td>
			<td><input name="Icodigo" type="text" id="Icodigo" tabindex="1"value="<cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Icodigo)#</cfif>"  size="10" maxlength="10"  alt="El Código" ></td>
        </tr>
        
        
        <tr>
            <td align="right" nowrap>Fecha de actualización:</td>
            <td>
                <cfif modoIN neq 'ALTA'>
                    <cf_sifcalendario  form= "form" name="Ifecha" value="#LSDateFormat(rsTipos.Ifecha,'dd/mm/yyyy')#">
                <cfelse>
                    <cf_sifcalendario  form= "form" name="Ifecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                </cfif>
            </td>
		</tr>
        
		<tr valign="middle"> 
			<td align="right" nowrap>Descripción:</td>
			<td><textarea name="Idescripcion"  cols="75" rows="3"  id="Idescripcion" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Idescripcion)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Forma de cálculo:</td>
			<td><textarea name="Iformacalculo" cols="75" rows="3" id="Iformacalculo" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Iformacalculo)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Periodicidad:</td>
			<td><textarea name="Iperiodicidad" cols="75" rows="3" id="Iperiodicidad" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Iperiodicidad)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Fuente de información:</td>
			<td><textarea name="Ifuente"  cols="75" rows="3" id="Ifuente" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Ifuente)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Responsable:</td>
			<td><textarea name="Iresponsable"  cols="75" rows="3" id="Iresponsable" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Iresponsable)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Forma de representación:</td>
			<td><textarea name="Iformapresenta"  cols="75" rows="3" id="Iformapresenta" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Iformapresenta)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Usos:</td>
			<td><textarea name="Iusos"  cols="75" rows="3" id="Iusos" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Iusos)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Nivel de agregación:</td>
			<td><textarea name="Inivelagrega"  cols="75" rows="3" id="Inivelagrega" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Inivelagrega)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Relación con otros procesos:</td>
			<td><textarea name="Irotroproceso"  cols="75" rows="3" id="Irotroproceso" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Irotroproceso)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Valor meta:</td>
			<td><textarea name="Ivalormeta"  cols="75" rows="3" id="Ivalormeta" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Ivalormeta)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Rango aceptable:</td>
			<td><textarea name="Irangoacepta"  cols="75" rows="3" id="Irangoacepta" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Irangoacepta)#</cfif></textarea></td>
		</tr>
        
        <tr valign="middle"> 
			<td align="right" nowrap>Observaciones:</td>
			<td><textarea name="Iobservacion"  cols="75" rows="3" id="Iobservacion" tabindex="2" alt="La Descripción"><cfif #modoIN# NEQ "ALTA">#HTMLEditFormat(rsTipos.Iobservacion)#</cfif></textarea></td>
		</tr>

		<tr valign="baseline"> 
			<td colspan="5" align="center" nowrap>
				<cf_botones  modo="#modoIN#" form="form" sufijo="IN" >
			</td>
		</tr>
	</table>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Codigo"/>
<cfif not isdefined('url.tab') or (isdefined('url.tab') and url.tab eq 1)>
    <cf_qforms form="form">
        <cf_qformsRequiredField name="Icodigo"  description="#MSG_Codigo#">
        <cf_qformsRequiredField name="Idescripcion" description="#MSG_Descripcion#">
    </cf_qforms>
</cfif>
</cfoutput>