<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cfset filtro    = "where Ecodigo = #Session.Ecodigo# ">

<cfif isdefined('form.filtro_DVetiqueta') and len(trim(form.filtro_DVetiqueta))>
	<cfset filtro = filtro & " and upper(DVetiqueta) like '%#ucase(form.filtro_DVetiqueta)#%'">
</cfif>
<cfif isdefined('form.filtro_DVexplicacion') and len(trim(form.filtro_DVexplicacion))>
	<cf_dbfunction name="sPart"		args="DVexplicacion,1,80" returnVariable="DVexplicacion">
	<cfset filtro = filtro & " and upper(#DVexplicacion#) like '%#ucase(form.filtro_DVexplicacion)#%'">
</cfif>	
<cfif isdefined('form.Filtro_DVtipoDato') and form.Filtro_DVtipoDato NEQ -1>
	<cfset filtro = filtro & " and upper(DVtipoDato) =  '#ucase(form.Filtro_DVtipoDato)#'">
</cfif>	
<cfif isdefined('form.Filtro_DVobligatorio') and form.Filtro_DVobligatorio NEQ -1>
	<cfset filtro = filtro & " and DVobligatorio =  #form.Filtro_DVobligatorio#">
</cfif>	

<cfquery name="rsDVtipoDato" datasource="#session.DSN#">
	select '-1' as value, '-- Todos -- ' as description from dual
	union all
	select 'C' as value, 'Texto Corto' as description from dual
	union all
	select 'v' as value, 'Texto Largo' as description from dual
	union all
	select 'N' as value, 'Numerico' as description from dual
	union all
	select 'L' as value, 'Lista' as description from dual
	union all
	select 'F' as value, 'Fecha' as description from dual
	union all
	select 'H' as value, 'Hora' as description from dual
	union all
	select 'K' as value, 'Logico' as description from dual
	order by 1
</cfquery>
<cfquery name="rsDVobligatorio" datasource="#session.DSN#">
	select '-1' as value, '-- Todos --' as description from dual
	union all
	select '1' as value, 'Requeridos' as description from dual
	union all
	select '0' as value, 'NO Requeridos' as description from dual
</cfquery>

<cfquery name="ListaDV" datasource="#session.dsn#">
	select DVid , DVetiqueta,  <cf_dbfunction name="sPart"		args="DVexplicacion,1,80" > as DVexplicacion, 
	case when DVobligatorio = 0 then '#unchecked#' else '#checked#' end as DVobligatorio,
    case when  DVtipoDato = 'C'  then 'Texto Corto' 
		 when  DVtipoDato = 'V'  then 'Texto Largo' 
	     when  DVtipoDato = 'N' then 'Numerico' 
		 when  DVtipoDato = 'L' then 'Lista' 
		 when  DVtipoDato = 'F' then 'Fecha' 
		 when  DVtipoDato = 'H' then 'Hora' 
		 when  DVtipoDato = 'K' then 'Logico' 
		 else 'otro' end as DVtipoDato					
	from <cf_dbdatabase table="FTDatosVariables" datasource="ftec"> 
	#preservesinglequotes(filtro)#
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
		<cfinvokeargument name="query" 				value="#ListaDV#"/>
		<cfinvokeargument name="desplegar" 			value="DVetiqueta, DVexplicacion, DVtipoDato, DVobligatorio"/>
		<cfinvokeargument name="etiquetas" 			value="Codigo,Descripcion,Tipo,Obligatorio"/>
		<cfinvokeargument name="formatos" 			value="S,S,S,U"/>
		<cfinvokeargument name="align" 				value="left,left,left,left"/>
		<cfinvokeargument name="formName" 			value="ValoreVariables"/>
		<cfinvokeargument name="checkboxes" 		value="N"/>
		<cfinvokeargument name="keys" 				value="DVid"/>
		<cfinvokeargument name="ira" 				value="datosVariables.cfm"/>
		<cfinvokeargument name="MaxRows" 			value="10"/>
		<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
		<cfinvokeargument name="PageIndex" 			value="1"/>
		<cfinvokeargument name="mostrar_filtro" 	value="true"/>
		<cfinvokeargument name="rsDVtipoDato" 	    value="#rsDVtipoDato#"/>
		<cfinvokeargument name="rsDVobligatorio" 	value="#rsDVobligatorio#"/>	
		<cfinvokeargument name="PageIndex" 	value="1"/>	
</cfinvoke>