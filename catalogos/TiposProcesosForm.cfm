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

<cfif isDefined("session.Ecodigo") and isDefined("Form.TPcodigo") and len(trim(#Form.TPcodigo#)) NEQ 0>
	<cfquery name="rsTipos" datasource="#Session.DSN#" >
	Select *
	from FTTipoProceso
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and TPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TPcodigo#" >		  
		order by TPcodigo asc
	</cfquery>
</cfif>

<cfquery name="rsFTTipoTramite" datasource="#Session.DSN#">
	select 	
        TTid                 
        ,TTcodigo     
        ,TTdescripcion 
	from FTTipoTramite
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by TTdescripcion
</cfquery>




<cfoutput>
<form action="TiposProcesosSQL.cfm" method="post" name="form">
	<input name="TPid" type="hidden" value="<cfif isdefined('rsTipos')> <cfoutput>#rsTipos.TPid#</cfoutput></cfif>"> 
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr valign="baseline" bgcolor="##FFFFFF">
			<td align="right" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:</td>
			<td>
				<input name="TPcodigo" type="text"  size="10" maxlength="10"  alt="El Código" tabindex="1"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsTipos.TPcodigo)#</cfif>" >
			</td>
		</tr>
	
		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td align="right" nowrap><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate>:</td>
			<td> 
				<input type="text" name="TPdescripcion" tabindex="2" size="40" maxlength="60"  alt="La Descripción"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsTipos.TPdescripcion)#</cfif>" >
			</td>
		</tr>
        
        <tr>
             <td  class="fileLabel">Tipo Tramite Asociado:</td>
             <td>
                <select name="TTid">
                    <option value="">--- Seleccionar ---</option>
                    <cfloop query="rsFTTipoTramite">
                        <option value="#TTid#" <cfif modo EQ 'CAMBIO' and rsFTTipoTramite.TTid EQ rsTipos.TTid> selected</cfif>>#TTdescripcion#</option>
                    </cfloop>
                </select>
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
	<cf_qformsRequiredField name="TPcodigo"  description="#MSG_Codigo#">
	<cf_qformsRequiredField name="TPdescripcion" description="#MSG_Descripcion#">
</cf_qforms>
</cfoutput>