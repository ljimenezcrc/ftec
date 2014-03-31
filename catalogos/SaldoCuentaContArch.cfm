<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>


	<cf_templateheader title="#nav__SPdescripcion#">
	    <cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top">
						<cfset Form.Archivo = 'S'>
						<cfinclude template="SaldoCuentaContform.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
