<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_CatalogoIndicadores"
    Default="Catálogo de Indicadores"
    returnvariable="LB_CatalogoIndicadores"/>

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
    
<cfif (isDefined("Form.Iid2") and Len(Trim(Form.Iid2)) GT 0)>
    <cfset Form.Iid = #Form.Iid2# >
</cfif>
    
    
<cfif (isDefined("Form.Iid") and Len(Trim(Form.Iid)) GT 0)>
	<cfset Form.modoIN = "CAMBIO" >
<cfelse>
    <cfset Form.modoIN = "ALTA" >
</cfif>


<cfquery name="rsListaIndicadores" datasource="#session.DSN#">
    Select Iid, Icodigo, Idescripcion,<cf_dbfunction name="sPart" args="Idescripcion,1,60"> as descripcion, Ecodigo								
    From <cf_dbdatabase table="FTIndicador" datasource="ftec">
    Where Ecodigo= #session.Ecodigo# 
    order by Icodigo 
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td valign="top">
        	<cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaIndicadores">
                <cfinvokeargument name="query" value="#rsListaIndicadores#"/>
                 <cfinvokeargument name="columnas"			value="Iid, Icodigo,,Idescripcion, descripcion, Ecodigo"/>
                <cfinvokeargument name="desplegar"			value="Icodigo, descripcion"/>
                <cfinvokeargument name="etiquetas"			value="C&oacute;digo, Descripci&oacute;n"/>
                <cfinvokeargument name="formatos"			value="S,S"/>
                <cfinvokeargument name="align" value="left, left"/>
                <cfinvokeargument name="ajustar" value="N"/>
                <cfinvokeargument name="checkboxes" value="N"/>
                <cfinvokeargument name="irA" value="IndicadoresTabs.cfm?tab=1"/>
                <cfinvokeargument name="keys" value="Iid"/>
                <cfinvokeargument name="showEmptyListMsg" value="true"/> 
                <cfinvokeargument name="incluyeform" value="true"/> 
				<cfinvokeargument name="formName" value="FListaFeriados"/> 
				<cfinvokeargument name="PageIndex" value="1">
            </cfinvoke>
        </td>
        
        <td  align="left" valign="top" width="50%">
            <cfinclude template="IndicadoresForm.cfm">
        </td>
    </tr>
</table>
