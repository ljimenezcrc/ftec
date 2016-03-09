<cfparam name="modo" 	 	  	 		 default="ALTA">
<cfparam name="modoDet" 	 	    	 default="ALTA">
<cfparam name="Param" 			    	 default="">
<cfparam name="MostrarValoreLista" 		 default="FALSE">
<cfparam name="DVLeligido.DVLcodigo" 	 default="">
<cfparam name="DVLeligido.DVLdescripcion"default="">
<cfparam name="DVLeligido.DVLorden"		 default="">
<cfparam name="DV.DVetiqueta" 	 		 default="">
<cfparam name="DV.DVtipoDato" 	 		 default="">
<cfparam name="DV.DVlongitud" 	 		 default="">
<cfparam name="DV.DVdecimales" 	 		 default="">
<cfparam name="DV.DVmascara" 			 default="">
<cfparam name="DV.DVobligatorio" 		 default="">
<cfparam name="DV.DVexplicacion" 		 default="">

<cfif (isdefined('form.DVid') and len(trim(form.DVid)) GT 0) or (isdefined('url.DVid') and len(trim(url.DVid)))>
	<cfset modo = "CAMBIO">
	<cfif not isdefined('form.DVid') or len(trim(form.DVid)) EQ 0>
		<cfset form.DVid = url.DVid>
	</cfif>
</cfif>

<cf_templateheader title="Datos Variables">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Datos Variables">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="65%" valign="top">
						<cfinclude  template="DatosVariables-lista.cfm">
				  </td>
					<td width="35%">
						<cfinclude  template="DatosVariables-form.cfm">
				  </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>