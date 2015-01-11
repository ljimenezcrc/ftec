<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/> 
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Solicitud de Pago"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>   
<cf_importLibs>
<cf_templateheader title="#LB_FTEC#" template="#session.sitio.template#">							
	<cf_web_portlet_start titulo="#nombre_proceso#">
		<cfinclude template="SolicitudPago-Form.cfm">		
	<cf_web_portlet_end>
<cf_templatefooter>