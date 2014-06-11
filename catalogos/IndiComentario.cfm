<cfif isDefined("Form.ICid") and Len(Trim(Form.ICid)) GT 0 >
	<cfset Form.modoCO = "CAMBIO" >
<cfelse>
    <cfset Form.modoCO = "ALTA" >
</cfif>

<cfif isDefined("Form.GCid") and Len(Trim(Form.GCid)) GT 0 >
	<cfset Form.modoCUG = "CAMBIO" >
<cfelse>
    <cfset Form.modoCUG = "ALTA" >
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
    <cf_dbdatabase table="FTIComentario" datasource="ftec" returnvariable="FTIComentario">
        <td valign="top">
            <cfinvoke component="commons.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                <cfinvokeargument name="tabla" 				value="#preservesinglequotes(FTIComentario)# "/>
                <cfinvokeargument name="columnas"			value="ICid,Iid, ICcodigo, ICperiodo"/>
                <cfinvokeargument name="desplegar"			value="ICcodigo, ICperiodo"/>
                <cfinvokeargument name="etiquetas"			value="Código, Periodo"/>
                <cfinvokeargument name="formatos"			value="S,S"/>
                <cfinvokeargument name="filtro"				value="Iid=#form.Iid# order by ICcodigo"/>
                <cfinvokeargument name="align"				value="left, center"/>
                <cfinvokeargument name="ajustar"			value="N,N"/>
                <cfinvokeargument name="checkboxes"			value="N"/>
                <cfinvokeargument name="MaxRows"			value="15"/>
                <cfinvokeargument name="filtrar_automatico"	value="true"/>
                <cfinvokeargument name="filtrar_automatico"	value="true"/>
                <cfinvokeargument name="mostrar_filtro"		value="true"/>
                <cfinvokeargument name="keys"				value="ICid,Iid"/>
                <cfinvokeargument name="irA"				value="IndicadoresTabs.cfm?tab=2"/>
                <cfinvokeargument name="showEmptyListMsg"	value="true"/>
                <cfinvokeargument name="PageIndex" 			value="2">
                <cfinvokeargument name="incluyeform" value="true"/> 
				<cfinvokeargument name="formName" value="FListaComent"/> 
            </cfinvoke>
        </td>
        <td  align="left" valign="top" width="50%">
            <cfinclude template="IndiComentarioForm.cfm">
        </td>
    </tr>
</table>
