<cfinvoke Key="LB_RecursosHumanos" 		Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TAB_Indicadores" 	default="Tipos de Indicador" returnvariable="TAB_Indicadores" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="TAB_Observaciones" 	default="Comentarios" returnvariable="TAB_Observaciones" />

<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>

<cfif IsDefined('url.tab')>
	<cfset form.tab = url.tab>
<cfelse>
	<cfparam name="form.tab" default="1">
</cfif>


<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" nowrap="nowrap">
				<cf_web_portlet_start titulo="Indicadores">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr valign="top">
							<td align="left" width="100%" nowrap="nowrap" height="450" valign="top">
                                
                                <cf_tabs width="99%">
                                    <cf_tab text="#TAB_Indicadores#" selected="#form.tab is '1'#">
                                        <cf_web_portlet_start border="true" titulo="#TAB_Indicadores#" >
                                            <cfinclude template="Indicadores.cfm">
                                        <cf_web_portlet_end>
                                    </cf_tab>
                                    <cfif isdefined('form.Iid')>
                                        <cf_tab text="#TAB_Observaciones#" selected="#form.tab is '2'#">
                                            <cf_web_portlet_start border="true" titulo="#TAB_Observaciones#" >
                                                <cfinclude template="IndiComentario.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                    </cfif>
                                    <cfif isdefined('form.Iid')>
                                        <cf_tab text="Cuentas" selected="#form.tab is '3'#">
                                            <cf_web_portlet_start border="true" titulo="Cuentas" >
                                                <cfinclude template="IndiCuentas.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                    </cfif>
                                    <cfif isdefined('form.Iid')>
                                        <cf_tab text="Grupos para Cuentas" selected="#form.tab is '4'#">
                                            <cf_web_portlet_start border="true" titulo="Grupos para Cuentas" >
                                                <cfinclude template="IndiGrupo.cfm">
                                            <cf_web_portlet_end>
                                        </cf_tab>
                                    </cfif>
                                </cf_tabs>
                            </td> 
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	