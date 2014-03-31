

<cfif modoGC neq 'ALTA'>
	<cfquery name="rsgrupo" datasource="#Session.DSN#" >
	Select *
	from <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec">
	where GCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GCid#">
	</cfquery>
</cfif>



<cfoutput>
<form action="IndiGrupoSQL.cfm" method="post" name="Fgrupo">
	<input name="GCid" type="hidden" value="<cfif isdefined('rsgrupo')> <cfoutput>#rsgrupo.GCid#</cfoutput></cfif>"> 
    <input name="Iid" type="hidden" value="<cfif isdefined('form.Iid')> <cfoutput>#form.Iid#</cfoutput></cfif>"> 
    
	<table width="100%" height="75%" align="center" cellpadding="1" cellspacing="0">
		<tr>
			<td align="right" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:</td>
			<td><input name="GCcodigo" type="text" id="GCcodigo" tabindex="1"value="<cfif #modoGC# NEQ "ALTA">#HTMLEditFormat(rsgrupo.GCcodigo)#</cfif>"  size="10" maxlength="10"  alt="El Código" ></td>
        </tr>
        
        <tr>
			<td align="right" nowrap>Descripcion:</td>
			<td><input name="GCdescripcion" type="text" id="GCdescripcion" tabindex="2"value="<cfif #modoGC# NEQ "ALTA">#HTMLEditFormat(rsgrupo.GCdescripcion)#</cfif>"  size="100" maxlength="100"  alt="La descripcion" ></td>
        </tr>
        
        <tr valign="baseline"> 
			<td colspan="5" align="center" nowrap>
				<cf_botones  modo="#modoGC#" form="Fcomentario" sufijo="GC" >
			</td>
		</tr>
	</table>
</form>


<cfif isdefined('url.tab') and url.tab eq 4>

<cf_qforms form="Fgrupo">
	<cf_qformsRequiredField name="GCcodigo"  	description="Codigo">
	<cf_qformsRequiredField name="GCdescripcion" description="Comentario">
</cf_qforms>
</cfif>
</cfoutput>

