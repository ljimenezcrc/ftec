
<cfif Session.Params.ModoDespliegue EQ 1>
	<cfif isdefined("Form.o") and isdefined("Form.sel")>
		<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">		
	<cfelse>

		<cfif isdefined("Form.PosteoAccion")>
			<cfset action = "/cfmx/ftec/catalogos/SolicitudPago.cfm">
		<cfelse>
			<cfset action = "/cfmx/ftec/catalogos/Solicitudes-lista.cfm">
		</cfif>
	</cfif>

</cfif>


<cfif  isdefined("Form.btnNuevo") >
	<cfset action = "/cfmx/ftec/catalogos/SolicitudPago.cfm">
</cfif>

<cfif not isdefined("Form.btnAplicar") and not isdefined("Form.btnEliminar") >
	<cfset action = "/cfmx/ftec/catalogos/SolicitudPago.cfm">
</cfif>
<!--- 
<cf_dump var="#form#" --->>



<cfif isdefined("Form.btnAplicar") and isdefined("Form.chk")>

	<cfquery name="rsSolicitudProcesos" datasource="#Session.DSN#">
		select 	a.SPid,a.TPid, 0 as VB
	    from <cf_dbdatabase table="FTSolicitudProceso " datasource="ftec"> a
	    where a.SPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#" list="true">)
	</cfquery> 
 
    <cfif isDefined('rsSolicitudProcesos') and rsSolicitudProcesos.RecordCount>
	    <cfloop query="rsSolicitudProcesos">
		    <cfinvoke component="ftec.Componentes.FTTramites" method="AplicaTramite" >
		        <cfinvokeargument name="SPid" 		value="#rsSolicitudProcesos.SPid#">
		        <cfinvokeargument name="TPid" 		value="#rsSolicitudProcesos.TPid#">
		        <cfinvokeargument name="VB"       value="#rsSolicitudProcesos.VB#">
		        <cfinvokeargument name="HTcompleto"	value="1">
		        <cfinvokeargument name="Aprueba"	value="1">
				<cfinvokeargument name="Debug"		value="false">
		    </cfinvoke>	
	    </cfloop>

	</cfif>

    <!--- <cfif isdefined("Form.AplicarEnc")>
    	<cfinvokeargument name="Aprueba"	value="1">
    <cfelse>
    	<cfinvokeargument name="Aprueba"	value="0">
    </cfif> --->
    <cfset action = "/cfmx/ftec/catalogos/Solicitudes-lista.cfm">
<!--- <cfelse>
    <cfset action = "/cfmx/ftec/catalogos/Solicitudes-lista.cfm"> --->
</cfif>	




<cfoutput>
<form action="#action#" method="post" name="sql">
    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
    <cfif isdefined("Form.SPid")>
		<input name="SPid" type="hidden" value="#form.SPid#">
	</cfif>
    
	<cfif isdefined("Form.btnNuevo")>
		<input name="modo" type="hidden" value="ALTA">
		<input name="SPid" type="hidden" value="">
	</cfif>
<!---	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	--->
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
