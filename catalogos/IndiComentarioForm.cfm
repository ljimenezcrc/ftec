<!---<cfif isdefined("Form.Cambio")>
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



<cfif isDefined("Form.ICid") and Len(Trim(Form.ICid)) GT 0 >
	<cfset Form.modoCO = "CAMBIO" >
<cfelse>
    <cfset Form.modoCO = "ALTA" >
</cfif>
--->

<cfif modoCO neq 'ALTA'>
	<cfquery name="rsComentarios" datasource="#Session.DSN#" >
	Select *
	from <cf_dbdatabase table="FTIComentario" datasource="ftec">
	where ICid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ICid#">
	</cfquery>
</cfif>



<cfoutput>
<form action="IndiComentarioSQL.cfm" method="post" name="Fcomentario">
	<input name="ICid" type="hidden" value="<cfif isdefined('rsComentarios')> <cfoutput>#rsComentarios.ICid#</cfoutput></cfif>"> 
    <input name="Iid" type="hidden" value="<cfif isdefined('form.Iid')> <cfoutput>#form.Iid#</cfoutput></cfif>"> 
    
	<table width="100%" height="75%" align="center" cellpadding="1" cellspacing="0">
		<tr>
			<td align="right" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:</td>
			<td><input name="ICcodigo" type="text" id="ICcodigo" tabindex="1"value="<cfif #modoCO# NEQ "ALTA">#HTMLEditFormat(rsComentarios.ICcodigo)#</cfif>"  size="10" maxlength="10"  alt="El Código" ></td>
        </tr>
        
        <tr>
            <td align="right" nowrap>Fecha de actualización:</td>
            <td>
                <cfif modoCO neq 'ALTA'>
                    <cf_sifcalendario  form= "Fcomentario" name="ICfecha" value="#LSDateFormat(rsComentarios.ICfecha,'dd/mm/yyyy')#">
                <cfelse>
                    <cf_sifcalendario  form= "Fcomentario" name="ICfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                </cfif>
            </td>
		</tr>
        
        <tr>
            <td align="right" nowrap>Periódo:</td>
           <td><input name="ICperiodo" type="text" id="ICperiodo" tabindex="1"value="<cfif #modoCO# NEQ "ALTA">#HTMLEditFormat(rsComentarios.ICperiodo)#</cfif>"  size="20" maxlength="20"  alt="Periódo" ></td>
		</tr>
        
		<tr valign="middle"> 
			<td align="right" nowrap>Comentario:</td>
			<td><textarea name="ICcomentario"  cols="75" rows="3"  id="ICcomentario" tabindex="2" alt="La Descripción"><cfif #modoCO# NEQ "ALTA">#HTMLEditFormat(rsComentarios.ICcomentario)#</cfif></textarea></td>
		</tr>
        <tr valign="baseline"> 
			<td colspan="5" align="center" nowrap>
				<cf_botones  modo="#modoCO#" form="Fcomentario" sufijo="CO" >
			</td>
		</tr>
	</table>
</form>


<cfif isdefined('url.tab') and url.tab eq 2>

<cf_qforms form="Fcomentario">
	<cf_qformsRequiredField name="ICcodigo"  	description="Codigo">
	<cf_qformsRequiredField name="ICcomentario" description="Comentario">
</cf_qforms>
</cfif>
</cfoutput>

