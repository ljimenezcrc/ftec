
<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>    
    
<cf_templateheader title="#LB_FTEC#" template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<script language="JavaScript" type="text/JavaScript">
		<!--
		function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		//-->
		</script>
	
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
					Default="Solicitud de Pago"
					VSgrupo="103"
					returnvariable="nombre_proceso"/>
				
					<cf_web_portlet_start titulo="#nombre_proceso#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr valign="top"> 
								<td align="center">
									<cfinclude template="SolicitudPago-Form.cfm">
								</td>
							</tr>
							<tr valign="top"> <td>&nbsp;</td></tr>
						</table>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>	
