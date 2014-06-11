<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Filtrar" Default="Filtrar" XmlFile="/rh/generales.xml" returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Restablecer" Default="Restablecer" XmlFile="/rh/generales.xml" returnvariable="BTN_Restablecer"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Regional" Default="Regional" returnvariable="LB_Regional"/>

<cfif isDefined("Form.Iid") and Len(Trim(Form.Iid)) GT 0 >
	<cfset Form.modoCO = "CAMBIO" >
<cfelse>
    <cfset Form.modoCO = "ALTA" >
</cfif>

<script language="JavaScript1.2" type="text/javascript">
    function funcRestablecer(){
        document.filtro.fRHFfecha.value = '01/01/<cfoutput>#datepart('yyyy', Now())#</cfoutput>';
    }
</script>

<cf_dbfunction name="OP_concat"	returnvariable="cat">

<!---<cf_dump var="#form#">--->

<table width="100%" cellpadding="0" cellspacing="0">
    <tr>
        <!--- Lista de Feriados --->
        <td valign="top" width="50%">
            <cfset imagen1 = "<img src=/cfmx/rh/imagenes/checked.gif border=0>">
			<cfset imagen2 = "<img src=/cfmx/rh/imagenes/unchecked.gif border=0>">
            <cfset columna = "" >
            <cfif isdefined("form.btnFiltrar") and isdefined("form.fRHFfecha") and len(trim(form.fRHFfecha)) gt 0 >
                <cfset columna = ", '#form.fRHFfecha#' as fRHFfecha,  'Filtrar' as btnFiltrar" >
            <cfelse>
                <!---<cfset columna = ", '01/01/#datepart('yyyy', Now())#' as fRHFfecha, btnFiltrar='Filtrar'" >--->
                <cfset columna = ", 01/01/#datepart('yyyy', Now())# as fRHFfecha " >
            </cfif>
            
            <!---<cfquery name="rsEmpleados" datasource="#session.DSN#">
                select distinct a.DEid as DEidPK, a.DEid, b.DEtarjeta, b.DEidentificacion , b.DEapellido1 #cat# ' ' #cat# b.DEapellido2  #cat# ' ' #cat# b.DEnombre as Nombre
                from RHFeriados a
                inner join DatosEmpleado b
                    on a.DEid = b.DEid
                where a.Ecodigo = #session.Ecodigo# 
	        </cfquery>

	         <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaEmpleados">
                <cfinvokeargument name="query" value="#rsEmpleados#"/>
                <cfinvokeargument name="desplegar" value="DEtarjeta, DEidentificacion, Nombre"/>
                <cfinvokeargument name="etiquetas" value="Numero,Identificacion,Nombre"/>
                <cfinvokeargument name="formatos" value="S,S,S"/>
                <cfinvokeargument name="align" value="left, left, left"/>
                <cfinvokeargument name="ajustar" value="N"/>
                <cfinvokeargument name="checkboxes" value="N"/>
                <cfinvokeargument name="irA" value="FeriadosTabs.cfm?tab=2"/>
                <cfinvokeargument name="keys" value="DEid"/>
                <cfinvokeargument name="showEmptyListMsg" value="true"/> 
                <cfinvokeargument name="incluyeform" value="true"/> 
                <cfinvokeargument name="formName" value="FListaEmpleados"/> 
                <cfinvokeargument name="PageIndex" value="2">
            </cfinvoke>
        </td>
        <!--- mantenimiento --->
        <td valign="top" width="50%"> <cfinclude template="formFeriadosEmpleado.cfm"></td>--->
    </tr>
</table>
