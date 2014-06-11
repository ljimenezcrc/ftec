<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_CatalogoTiposEstadoTramites"
    Default="Cat&aacute;logo Tipos Estado Tramite"
    returnvariable="LB_CatalogoTiposEstadoTramites"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Codigo"
    Default="C&oacute;digo"
    returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Descripcion"
    Default="Descripci&oacute;n"
    returnvariable="LB_Descripcion"/>

<cf_templateheader title="#LB_FTEC#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoTiposEstadoTramites#'>
		<cfinclude template="../../rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
	                <cf_dbdatabase table="FTEstadoTramite" datasource="ftec" returnvariable="FTEstadoTramite">
                    
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                    	<cfinvokeargument name="tabla" 				value="#FTEstadoTramite#"/>
                        <cfinvokeargument name="columnas"			value="ETid, ETcodigo, ETdescripcion, Ecodigo"/>
                        <cfinvokeargument name="desplegar"			value="ETcodigo, ETdescripcion"/>
                        <cfinvokeargument name="etiquetas"			value="C&oacute;digo, Descripci&oacute;n"/>
                        <cfinvokeargument name="formatos"			value="S,S"/>
                        <cfinvokeargument name="filtro"				value="Ecodigo=#session.Ecodigo# order by ETcodigo"/>
                        <cfinvokeargument name="align"				value="left, left"/>
                        <cfinvokeargument name="ajustar"			value="N,N"/>
                        <cfinvokeargument name="checkboxes"			value="N"/>
                        <cfinvokeargument name="MaxRows"			value="15"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="mostrar_filtro"		value="true"/>
                        <cfinvokeargument name="keys"				value="Ecodigo,ETid"/>
                        <cfinvokeargument name="irA"				value="EstadoTramites.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg"	value="true"/>
					</cfinvoke>
				</td>
				<td  align="left" valign="top" width="50%">
					<cfinclude template="EstadoTramitesForm.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>