<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_CatalogoTiposTramites"
    Default="Cat&aacute;logo Tipos Tramite"
    returnvariable="LB_CatalogoTiposTramites"/>

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
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoTiposTramites#'>
		<cfinclude template="../../rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
                	<cf_dbdatabase table="FTTipoTramite" datasource="ftec" returnvariable="FTTipoTramite">
                    
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                    	<cfinvokeargument name="tabla" 				value="#FTTipoTramite#"/>
                        <cfinvokeargument name="columnas"			value="TTid, TTcodigo, TTdescripcion, Ecodigo"/>
                        <cfinvokeargument name="desplegar"			value="TTcodigo, TTdescripcion"/>
                        <cfinvokeargument name="etiquetas"			value="C&oacute;digo, Descripci&oacute;n"/>
                        <cfinvokeargument name="formatos"			value="S,S"/>
                        <cfinvokeargument name="filtro"				value="Ecodigo=#session.Ecodigo# order by TTcodigo"/>
                        <cfinvokeargument name="align"				value="left, left"/>
                        <cfinvokeargument name="ajustar"			value="N,N"/>
                        <cfinvokeargument name="checkboxes"			value="N"/>
                        <cfinvokeargument name="MaxRows"			value="15"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="mostrar_filtro"		value="true"/>
                        <cfinvokeargument name="keys"				value="Ecodigo,TTid"/>
                        <cfinvokeargument name="irA"				value="TiposTramites.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg"	value="true"/>
					</cfinvoke>
				</td>
				<td  align="left" valign="top" width="50%">
					<cfinclude template="TiposTramitesForm.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>