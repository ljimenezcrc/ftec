<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_CatalogoTiposContrato"
    Default="Catálogo Tipos Contrato"
    returnvariable="LB_CatalogoTiposContrato"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Codigo"
    Default="Código"
    returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Descripcion"
    Default="Descripción"
    returnvariable="LB_Descripcion"/>

<cf_templateheader title="#LB_FTEC#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoTiposContrato#'>
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
                	<cf_dbdatabase table="FTtipocontrato" datasource="ftec" returnvariable="FTtipocontrato">
                    
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                    	<cfinvokeargument name="tabla" 				value="#FTtipocontrato#"/>
                        <cfinvokeargument name="columnas"			value="TCid, TCcodigo, TCdescripcion, Ecodigo"/>
                        <cfinvokeargument name="desplegar"			value="TCcodigo, TCdescripcion"/>
                        <cfinvokeargument name="etiquetas"			value="Código, Descripción"/>
                        <cfinvokeargument name="formatos"			value="S,S"/>
                        <cfinvokeargument name="filtro"				value="Ecodigo=#session.Ecodigo# order by TCcodigo"/>
                        <cfinvokeargument name="align"				value="left, left"/>
                        <cfinvokeargument name="ajustar"			value="N,N"/>
                        <cfinvokeargument name="checkboxes"			value="N"/>
                        <cfinvokeargument name="MaxRows"			value="15"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="mostrar_filtro"		value="true"/>
                        <cfinvokeargument name="keys"				value="Ecodigo,TCid"/>
                        <cfinvokeargument name="irA"				value="tipoContrato.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg"	value="true"/>
					</cfinvoke>
				</td>
				<td  align="left" valign="top" width="50%">
					<cfinclude template="tipoContratoForm.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>