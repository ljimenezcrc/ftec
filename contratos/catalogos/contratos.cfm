<cfparam name="rsContrato.Cid" 			default="">
<cfparam name="rsContrato.TCid" 		default="">
<cfparam name="rsContrato.TTid" 		default="">
<cfparam name="rsContrato.Cdescripcion"	default="">
<cfparam name="rsContrato.Cestado" 		default="">
<cfparam name="rsContrato.Ecodigo" 		default="">
<cfparam name="rsContrato.Usucodigo" 	default="">
<cfparam name="rsSeccion" 				default="#QueryNew('Sid')#">

<cf_navegacion name="form.Cid" default="">
<cf_importLibs>

<cfinvoke component="ftec.Componentes.FTContratos" method="getTipo" returnvariable="rsTipoContrato"></cfinvoke>
<cfinvoke component="ftec.Componentes.FTContratos" method="get" returnvariable="rsContratoAll"></cfinvoke>
<cfinvoke component="ftec.Componentes.FTTipoTramite" method="Get" returnvariable="rsTipoTramite"></cfinvoke>



<!---Guarda el Contrato--->
<cfif isdefined('form.btnGuardar')>
	<cfinvoke component="ftec.Componentes.FTContratos" method="set" returnvariable="LvarCid">
		<cfif LEN(TRIM(form.Cid))>
			<cfinvokeargument name="Cid"	 		value="#form.Cid#">
		</cfif>
		<cfif LEN(TRIM(form.TCid))>
			<cfinvokeargument name="TCid" 			value="#form.TCid#">
		</cfif>
		<cfif LEN(TRIM(form.TTid))>
			<cfinvokeargument name="TTid" 			value="#form.TTid#">
		</cfif>
			<cfinvokeargument name="Cdescripcion" 	value="#form.Cdescripcion#">
			<cfinvokeargument name="Cestado" 		value="#form.Cestado#">
	</cfinvoke>
	<cfset form.Cid = LvarCid>
<!---Elimina el contrato--->
<cfelseif isdefined('form.BtnEliminar')>
	<cfinvoke component="ftec.Componentes.FTContratos" method="delete">
		<cfinvokeargument name="Cid" value="#form.Cid#">
	</cfinvoke>
	<cfset form.Cid = "">
<!---Regresa a la lista--->	
<cfelseif isdefined('form.btnRegresar')>
	<cfset form.Cid = "">
<!---Crea una nueva Seccion--->
<cfelseif isdefined('form.btnGSeccion')>
	<cfinvoke component="ftec.Componentes.FTContratos" method="SetSeccion">
		<cfif isdefined('form.Cid')>
			<cfinvokeargument name="Cid" value="#form.Cid#">
		</cfif>
		<cfif isdefined('form.Sid')>
			<cfinvokeargument name="Sid" 		value="#form.Sid#">
			<cfinvokeargument name="Cpermisos" 	value="#form.Cpermisos#">
			<cfinvokeargument name="STexto" 	value="#FORM['Editor_' & form.Sid]#">
		</cfif>
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

<cf_templateheader title="Contratos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Creacion de Plantillas de contratos'>
		<cfif LEN(TRIM(rsContrato.Cid)) OR isdefined('form.BtnNuevo')>
			<cfinclude template="contratos-form.cfm">
		<cfelse>
			<cfinclude template="Contratos-list.cfm">
		</cfif>		
	<cf_web_portlet_end>	
<cf_templatefooter>