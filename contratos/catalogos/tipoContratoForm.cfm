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

 
<cfif isDefined("session.Ecodigo") and isDefined("Form.TCcodigo") and len(trim(Form.TCcodigo))>
	<cfquery name="rsTipos" datasource="#Session.DSN#" >
	Select *
	from <cf_dbdatabase table="FTtipocontrato" datasource="ftec">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and TCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TCcodigo#" >		  
		order by TCcodigo asc
	</cfquery>
</cfif>

<cfoutput>
<form action="tipoContratoSQL.cfm" method="post" name="form">
	<input name="TCid" type="hidden" value="<cfif isdefined('rsTipos')> <cfoutput>#rsTipos.TCid#</cfoutput></cfif>"> 
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr valign="baseline" bgcolor="##FFFFFF">
			<td align="right" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:</td>
			<td>
				<input name="TCcodigo" type="text"  size="10" maxlength="10"  alt="El Código" tabindex="1"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsTipos.TCcodigo)#</cfif>" >
			</td>
		</tr>
	
		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td align="right" nowrap><cf_translate key="LB_Descripcion">Descripción</cf_translate>:</td>
			<td> 
				<input type="text" name="TCdescripcion" tabindex="2" size="40" maxlength="60"  alt="La Descripción"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsTipos.TCdescripcion)#</cfif>" >
			</td>
		</tr>

		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td> 
				<input name="TCnoaplicaconsec"  id="TCnoaplicaconsec" type="checkbox" tabindex="1" 	value="0" 
				<cfif modo neq 'ALTA' and rsTipos.TCnoaplicaconsec eq 1 >checked="checked"</cfif> >
			</td>
			<td align="right" nowrap><cf_translate key="LB_noaplica">No aplica Consecutivo</cf_translate></td>
		</tr>

		<tr valign="baseline"> 
			<td colspan="5" align="center" nowrap>
				<cfset tabindex=5>
				<cfinclude template="/rh/portlets/pBotones.cfm">
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
	<cf_qformsRequiredField name="TCcodigo"  description="#MSG_Codigo#">
	<cf_qformsRequiredField name="TCdescripcion" description="#MSG_Descripcion#">
</cf_qforms>
</cfoutput>