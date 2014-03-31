<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfset lvCAporcentaje  = 0.00>

<cfif isDefined("session.Ecodigo") and isDefined("Form.CAcodigo") and len(trim(#Form.CAcodigo#)) NEQ 0>
	<cfquery name="rsTipos" datasource="#Session.DSN#" >
	Select *
	from <cf_dbdatabase table="FTCostoAdmin" datasource="ftec">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CAcodigo#" >		  
		order by CAcodigo asc
	</cfquery>
    

	<cfset lvCAporcentaje = rsTipos.CAporcentaje>
</cfif>


<cfoutput>
<form action="CostosAdminSQL.cfm" method="post" name="form">
	<input name="CAid" type="hidden" value="<cfif isdefined('rsTipos')> <cfoutput>#rsTipos.CAid#</cfoutput></cfif>"> 
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr valign="baseline" bgcolor="##FFFFFF">
			<td align="right" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:</td>
			<td>
				<input name="CAcodigo" type="text"  size="10" maxlength="10"  alt="El Código" tabindex="1"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsTipos.CAcodigo)#</cfif>" >
			</td>
		</tr>
	
		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td align="right" nowrap><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate>:</td>
			<td> 
				<input type="text" name="CAdescripcion" tabindex="2" size="40" maxlength="60"  alt="La Descripción"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsTipos.CAdescripcion)#</cfif>" >
			</td>
		</tr>
        <tr>
        	<td align="right" nowrap><cf_translate key="LB_Porcentaje">Porcentaje</cf_translate>:</td>
        	<td>
				<cf_inputNumber name="CAporcentaje" value="#lvCAporcentaje#" enteros="5" decimales="2" negativos="false" comas="no" tabIndex = 3>
            </td>
        </tr>
        <tr>
        	<td align="right"><input type="checkbox" <cfif modo eq "CAMBIO" and rsTipos.CAobligatorio eq 1>checked</cfif> name="CAobligatorio" value="checkbox"></td>
            <td align="left" nowrap><cf_translate key="LB_Obligatorio">Obligatorio</cf_translate></td>
            
         </tr>

		<tr valign="baseline"> 
			<td colspan="5" align="center" nowrap>
				<cfset tabindex=5>
				<cfinclude template="../../rh/portlets/pBotones.cfm">
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
<cf_qforms form="form">
	<cf_qformsRequiredField name="Deptocodigo"  description="#MSG_Codigo#">
	<cf_qformsRequiredField name="Ddescripcion" description="#MSG_Descripcion#">
</cf_qforms>
</cfoutput>