
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
	<!---<cfinclude template="/commons/Tags/Confirm.cfm">--->
	<cfset action = "/cfmx/ftec/catalogos/SolicitudPago.cfm">
</cfif>

<cfif not isdefined("Form.btnAplicar") and not isdefined("Form.btnEliminar") >
	<cfset action = "/cfmx/ftec/catalogos/SolicitudPago.cfm">
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
    <cfif isdefined("Form.SPid")>
		<input name="SPid" type="hidden" value="#form.SPid#">
	</cfif>
    
	<cfif isdefined("Form.btnNuevo")>
		<input name="modo" type="hidden" value="ALTA">
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
