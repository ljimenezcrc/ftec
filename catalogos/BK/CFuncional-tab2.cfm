<table width="100%" border="0" cellpadding="1" cellspacing="0">
	
	<tr valign="top">
		<td colspan="2"  class="tituloListas">
		<div align="left" style="background-color:#E5E5E5; font-size:13px;">
			<cfif modo NEQ "ALTA">
				<cfoutput>
					<cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>: #trim(rsForm.CFcodigo)#-#rsForm.CFdescripcion#
				</cfoutput>
			</cfif>
		</div>
		</td>
	</tr>
	<tr><td valign="top"><cfinclude template="formCuentas.cfm"></td></tr>
</table>