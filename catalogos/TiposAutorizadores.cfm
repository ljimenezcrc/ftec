<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_CatalogoTiposAutorizador"
    Default="Cat&aacute;logo Tipos Autorizador"
    returnvariable="LB_CatalogoTiposAutorizador"/>

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

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_MtoInicio"
    Default="Mto.Desde"
    returnvariable="LB_MtoInicio"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_MtoFin"
    Default="Mto.Hasta"
    returnvariable="LB_MtoFin"/>    

<cf_templateheader title="#LB_FTEC#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoTiposAutorizador#'>
		<cfinclude template="../../rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                    	<cfinvokeargument name="tabla" 				value="FTTipoAutorizador"/>
                        <cfinvokeargument name="columnas"			value="TAid,Ecodigo,TAcodigo, TAdescripcion, TAmontomin, TAmontomax"/>
                        <cfinvokeargument name="desplegar"			value="TAcodigo, TAdescripcion,TAmontomin,TAmontomax"/>
                        <cfinvokeargument name="etiquetas"			value="#LB_Codigo#,#LB_Descripcion#,#LB_MtoInicio#,#LB_MtoFin#"/>
                        <cfinvokeargument name="formatos"			value="S,S,M,M"/>
                        <cfinvokeargument name="filtro"				value="Ecodigo=#session.Ecodigo# order by TAcodigo"/>
                        <cfinvokeargument name="align"				value="left, left,right,right"/>
                        <cfinvokeargument name="ajustar"			value="N,N,N,N"/>
                        <cfinvokeargument name="checkboxes"			value="N"/>
                        <cfinvokeargument name="MaxRows"			value="15"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="mostrar_filtro"		value="true"/>
                        <cfinvokeargument name="keys"				value="Ecodigo,TAid"/>
                        <cfinvokeargument name="irA"				value="TiposAutorizadores.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg"	value="true"/>
					</cfinvoke>
				</td>
				<td  align="left" valign="top" width="50%">
					<cfinclude template="TiposAutorizadoresForm.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>