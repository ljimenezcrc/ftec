<cfif isDefined("Form.GCid") and Len(Trim(Form.GCid)) GT 0 >
	<cfset Form.modoGC = "CAMBIO" >
<cfelse>
    <cfset Form.modoGC = "ALTA" >
</cfif>


<cfquery name="rsIndicador" datasource="#session.dsn#">
	select Icodigo, Idescripcion 
    from <cf_dbdatabase table="FTIndicador" datasource="ftec"> 
    where Iid='#form.Iid#' 
</cfquery>

<cfif len(trim(rsIndicador.Idescripcion)) gt 0>
	<cfset Lvardesc= "#trim(rsIndicador.Icodigo)# - #rsIndicador.Idescripcion#">
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
        <td align="left" colspan="2">
            <strong><font size="2">Indicador:</font></strong> 
            <font size="2"><cfoutput>#Lvardesc#</cfoutput></font>
        </td>
    </tr>
    <tr></tr>
    <tr> 
    <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec" returnvariable="FTGrupoCuentas">
        <td valign="top">
            <cfinvoke component="commons.Componentes.pListas" method="pListaRH" returnvariable="pListaRetGrupo">
                <cfinvokeargument name="tabla" 				value="#preservesinglequotes(FTGrupoCuentas)# "/>
                <cfinvokeargument name="columnas"			value="GCid, Iid, GCcodigo, GCdescripcion"/>
                <cfinvokeargument name="desplegar"			value="GCcodigo, GCdescripcion"/>
                <cfinvokeargument name="etiquetas"			value="Código, Descripcion"/>
                <cfinvokeargument name="formatos"			value="S,S"/>
                <cfinvokeargument name="filtro"				value="Iid=#form.Iid# order by GCcodigo"/>
                <cfinvokeargument name="align"				value="left, center"/>
                <cfinvokeargument name="ajustar"			value="N,N"/>
                <cfinvokeargument name="checkboxes"			value="N"/>
                <cfinvokeargument name="MaxRows"			value="15"/>
                <cfinvokeargument name="filtrar_automatico"	value="true"/>
                <cfinvokeargument name="filtrar_automatico"	value="true"/>
                <cfinvokeargument name="mostrar_filtro"		value="true"/>
                <cfinvokeargument name="keys"				value="GCid,Iid"/>
                <cfinvokeargument name="irA"				value="IndicadoresTabs.cfm?tab=4"/>
                <cfinvokeargument name="showEmptyListMsg"	value="true"/>
                <cfinvokeargument name="PageIndex" 			value="8">
                <cfinvokeargument name="incluyeform" value="true"/> 
				<cfinvokeargument name="formName" value="FListaGrupo"/> 
            </cfinvoke>
        </td>
        <td  align="left" valign="top" width="50%">
            <cfinclude template="IndiGrupoForm.cfm">
        </td>
    </tr>
</table>
