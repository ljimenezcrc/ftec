<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>

    
<cf_templateheader title="#LB_FTEC#" template="#session.sitio.template#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
			  	<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
					Default="Lista de Tramites Pendientes"
					VSgrupo="103"
					returnvariable="nombre_proceso"/>                                    
				<cf_web_portlet_start titulo="#nombre_proceso#" >		          
					<cfinclude template="/rh/portlets/pNavegacion.cfm">	  	          
					<cfinclude template="Tramites-listaForm.cfm">                  
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>