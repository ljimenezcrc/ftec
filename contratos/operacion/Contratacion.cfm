﻿<cfset t = createObject("component", "sif.Componentes.Translate")>
<cf_importLibs>


<!---Etiquetas del Form--->
<cfset LB_RegistroInformacionCesantia = t.translate('LB_RegistroInformacionCesantia','Registro de Información para Estimación de Cesantia','/rh/generales.xml')>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')>
<cfset LB_Fecha = t.translate('LB_Fecha','Fecha','/rh/generales.xml')>
<cfset LB_CentroFuncional = t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>
<cfset LB_Monto = t.translate('LB_Monto','Monto','/rh/generales.xml')>
<cfset LB_CargaProvision = t.translate('LB_CargaProvision','Carga Provisión','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')>
<cfset LB_Provision = t.translate('LB_Provision','Provisión','/rh/generales.xml')>
<cfset LB_Cesantia = t.translate('LB_Cesantia','Cesantia','/rh/generales.xml')>
<cfset LB_Adelanto = t.translate('LB_Adelanto','Adelanto','/rh/generales.xml')>
<cfset LB_Proyecto = t.translate('LB_Proyecto','Proyecto','/rh/generales.xml')>
<cfset LB_ListaContratos = t.translate('LB_ListaContratos','Lista de Contratos','/rh/generales.xml')>

<cfparam name="rsContrato.Cid" 			default="">
<cfparam name="rsContrato.TCid" 		default="">
<cfparam name="rsContrato.Cdescripcion"	default="">
<cfparam name="rsContrato.Cestado" 		default="">
<cfparam name="rsContrato.Ecodigo" 		default="">
<cfparam name="rsContrato.Usucodigo" 	default="">
<cfparam name="rsContrato.PCFechaA"    default="">
<cfparam name="rsContrato.PCFechaF"    default="">
<cfparam name="rsSeccion" 				default="#QueryNew('Sid')#">

<cf_navegacion name="form.Cid" default="">
<cf_importLibs>

<cfinvoke component="ftec.Componentes.FTContratos" method="getTipo" returnvariable="rsTipoContrato"></cfinvoke>
<cfinvoke component="ftec.Componentes.FTContratos" method="get" returnvariable="rsContratoAll"></cfinvoke>

<cfoutput>

<!---Buscar Oferente--->
<cfif isdefined('form.btnBuscarOferente')>
    <cfinvoke component="ftec.Componentes.BuscarOferente" method="Contratos" returnvariable="rsOferente">
        <cfinvokeargument name="Identificacion"	value="#form.PCIdentificacion#">
        <cfinvokeargument name="TipoIdentificacion"	value="#form.PCTidentificacion#">
    </cfinvoke>
    
    <cfif not rsOferente.RecordCount >
        <cfinvoke component="ftec.Componentes.BuscarOferente" method="Empleado" returnvariable="rsOferente">
            <cfinvokeargument name="Identificacion"	value="#form.PCIdentificacion#">
        </cfinvoke>
    </cfif>

    <cfif not rsOferente.RecordCount >
        <cfinvoke component="ftec.Componentes.BuscarOferente" method="Padron" returnvariable="rsOferente">
            <cfinvokeargument name="Identificacion" value="#form.PCIdentificacion#">
        </cfinvoke>
    </cfif>

    <cfif not rsOferente.RecordCount >
        <cfinvoke component="ftec.Componentes.BuscarOferente" method="NDF" returnvariable="rsOferente">
            <cfinvokeargument name="Identificacion" value="#form.PCIdentificacion#">
        </cfinvoke>
    </cfif>

    <!--- <cf_dump var="#rsOferente#"> --->


	<cfif isdefined('rsOferente') and rsOferente.RecordCount>
        <cfquery name="rsForm"  datasource="ftec">
            select
                <cfif isdefined('form.Cid') and len(form.Cid) NEQ 0>
                     #form.Cid# as Cid
                <cfelse>
                     null as Cid
                </cfif>
                <cfif isdefined('form.PCid') and len(#form.PCid#)>
                    ,#form.PCid# as PCid
                <cfelse>
                    , null as PCid
                </cfif>--->
                <cfif isdefined('form.Vid') and len(#form.Vid#)>
                    ,#form.Vid# as Vid
                <cfelse>
                    , -1 as Vid
                </cfif>
                <cfif isdefined('form.TCid') and len(form.TCid)>
                     ,#form.TCid# as TCid
                <cfelse>
                     , -1 as TCid
                </cfif>
                ,'#form.Cdescripcion#' as Cdescripcion
                ,'#rsOferente.PCTidentificacion#' as PCTidentificacion
                ,'#rsOferente.PCIdentificacion#' as PCIdentificacion   
                ,'#rsOferente.PCSexo#' as PCSexo
                ,'#rsOferente.PCEstadoCivil#' as PCEstadoCivil
                ,'#rsOferente.PCnombre#' as PCnombre
                ,'#rsOferente.PCapellido1#' as PCapellido1
                ,'#rsOferente.PCapellido2#' as PCapellido2
                <!--- , getdate() as PCFechaN--->
            from dual
        </cfquery>
    </cfif>    
</cfif>


<!---Guarda el Contrato--->
<cfif isdefined('form.btnGContrato')>
	<cfinvoke component="ftec.Componentes.FTPContratacion" method="set" returnvariable="LvarPCid">
		<cfif isdefined('form.PCid') and LEN(TRIM(form.PCid))>
			<cfinvokeargument name="PCid" value="#form.PCid#">
		</cfif>
        <cfinvokeargument name="Vid"                value="#form.Vid#">
        <cfinvokeargument name="Cid" 				value="#form.Cid#">
        <cfinvokeargument name="PCTidentificacion" 	value="#form.PCTidentificacion#">
        <cfinvokeargument name="PCIdentificacion" 	value="#form.PCIdentificacion#">
        <cfinvokeargument name="PCNombre" 			value="#form.PCNombre#">
        <cfinvokeargument name="PCApellido1" 		value="#form.PCApellido1#">
        <cfinvokeargument name="PCApellido2" 		value="#form.PCApellido2#">
        <cfinvokeargument name="PCSexo" 			value="#form.PCSexo#">
        <cfinvokeargument name="PCEstadoCivil" 		value="#form.PCEstadoCivil#">
        <!--- <cfinvokeargument name="PCFechaN" 			value="#form.PCFechaN#"> --->
        <cfinvokeargument name="PCFechaA"             value="#form.PCFechaA#">
        <cfinvokeargument name="PCFechaF"             value="#form.PCFechaF#">

	</cfinvoke>
	

    
	<cfset form.PCid = LvarPCid>

    <cfinvoke component="ftec.Componentes.FTDatosVariables" method="SETVALOR">
        <cfinvokeargument name="form" value="#form#">
    </cfinvoke>
    <cfset form.modo = 'CAMBIO'>
    <cfset form.PCestado = 'Proceso'>

    
<!---Elimina el contrato--->
<cfelseif isdefined('form.BtnEliminar')>
	<cfinvoke component="ftec.Componentes.FTPContratacion" method="delete">
		<cfinvokeargument name="PCid" value="#form.PCid#">
	</cfinvoke>
	<cfset form.PCid = "">
    
<!---Regresa a la lista--->	
<cfelseif isdefined('form.btnRegresar')>
	<cfset form.PCid = "">

<!---Ènvia al tramite el contrato---> 

<cfelseif isdefined('form.btnTramite')>
    <cfinvoke component="ftec.Componentes.FTTramitesContratacion" method="EnviarTramite">
        <cfinvokeargument name="PCid" value="#form.PCid#">
        <cfinvokeargument name="Aprueba" value="0"> <!--- lo esta enviando al tramite --->
    </cfinvoke>

</cfif>

<cfif LEN(TRIM(form.Cid))>
	<cfinvoke component="ftec.Componentes.FTContratos" method="get" returnvariable="rsContrato">
		<cfinvokeargument name="Cid" value="#form.Cid#">
	</cfinvoke>
	<cfinvoke component="ftec.Componentes.FTContratos" method="getSeccion" returnvariable="rsSeccion">
		<cfinvokeargument name="Cid" value="#form.Cid#">
	</cfinvoke>
	<cfinvoke component="ftec.Componentes.FTContratos" method="getFTSeccionesD" returnvariable="rsFTSeccionesD">
		<cfinvokeargument name="Cid" value="#form.Cid#">
	</cfinvoke>	
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="getFTDatosVariables" returnvariable="rsFTDatosVariables">
	</cfinvoke>	
</cfif>

</cfoutput>



<cf_templateheader title="Contratos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Creación de Contrato'>
		<form name="fmContratacion" class="form-inline"  role="form" action="Contratacion.cfm" method="post">
			<cfif (isdefined('form.modo') and form.modo EQ 'CAMBIO' ) OR isdefined('form.btnNContracion') OR isdefined('form.btnBuscarOferente')>
                <cfinclude template="Contratacion-form.cfm">
            <cfelse>
                <cfinclude template="Contratacion-list.cfm">	
            </cfif>		
        </form>
	<cf_web_portlet_end>																			
<cf_templatefooter>