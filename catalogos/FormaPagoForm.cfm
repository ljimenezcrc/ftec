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

<cfif isDefined("session.Ecodigo") and isDefined("Form.FPcodigo") and len(trim(#Form.FPcodigo#)) NEQ 0>
	<cfquery name="rsTipos" datasource="#Session.DSN#" >
	Select *
	from FTFormaPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and FPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FPcodigo#" >		  
		order by FPcodigo asc
	</cfquery>
</cfif>

<cfoutput>
<form action="FormaPagoSQL.cfm" method="post" name="form">
	<input name="FPid" type="hidden" value="<cfif isdefined('rsTipos')> <cfoutput>#rsTipos.FPid#</cfoutput></cfif>"> 
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr valign="baseline" bgcolor="##FFFFFF">
			<td align="right" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:</td>
			<td>
				<input name="FPcodigo" type="text"  size="10" maxlength="10"  alt="El Código" tabindex="1"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsTipos.FPcodigo)#</cfif>" >
			</td>
		</tr>
	
		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td align="right" nowrap><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate>:</td>
			<td> 
				<input type="text" name="FPdescripcion" tabindex="2" size="40" maxlength="60"  alt="La Descripción"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsTipos.FPdescripcion)#</cfif>" >
			</td>
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
	<cf_qformsRequiredField name="FPcodigo"  description="#MSG_Codigo#">
	<cf_qformsRequiredField name="FPdescripcion" description="#MSG_Descripcion#">
</cf_qforms>
</cfoutput>