<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_CatalogoCostosAdmin"
    Default="Cat&aacute;logo Costos Adminitrativos"
    returnvariable="LB_CatalogoCostosAdmin"/>

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
    Key="LB_Obligatorio"
    Default="Obligatorio"
    returnvariable="LB_Obligatorio"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Porcentaje"
    Default="Porcentaje"
    returnvariable="LB_Porcentaje"/>    

<cf_templateheader title="#LB_FTEC#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoCostosAdmin#'>
		<cfinclude template="../../rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
                	 <cf_dbdatabase table="FTCostoAdmin" datasource="ftec" returnvariable = "FTCostoAdmin">
                     
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                    	<cfinvokeargument name="tabla" 				value="#FTCostoAdmin#"/>
                        <cfinvokeargument name="columnas"			value="CAid,Ecodigo,CAcodigo, CAdescripcion, CAporcentaje, case when CAobligatorio = 1 then 'X' else '' end as CAobligatorio "/>
                        <cfinvokeargument name="desplegar"			value="CAcodigo, CAdescripcion, CAporcentaje, CAobligatorio"/>
                        <cfinvokeargument name="etiquetas"			value="#LB_Codigo#,#LB_Descripcion#,#LB_Porcentaje#,#LB_Obligatorio#"/>
                        <cfinvokeargument name="formatos"			value="S,S,M,S"/>
                        <cfinvokeargument name="filtro"				value="Ecodigo=#session.Ecodigo# order by CAcodigo"/>
                        <cfinvokeargument name="align"				value="left, left,right,center"/>
                        <cfinvokeargument name="ajustar"			value="N,N,N,N"/>
                        <cfinvokeargument name="checkboxes"			value="N"/>
                        <cfinvokeargument name="MaxRows"			value="15"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="mostrar_filtro"		value="true"/>
                        <cfinvokeargument name="keys"				value="Ecodigo,CAid"/>
                        <cfinvokeargument name="irA"				value="CostosAdmin.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg"	value="true"/>
					</cfinvoke>
				</td>
				<td  align="left" valign="top" width="50%">
					<cfinclude template="CostosAdminForm.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>