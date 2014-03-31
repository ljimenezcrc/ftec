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


<cfoutput>


<form action="#action#" method="post" name="sql">
	<cfif isdefined("Form.o") and isdefined("Form.sel") and isdefined("Form.DEid")>
		<cfoutput>
		<cfparam name="Form.o_1" default="#Form.o#">
		<input type="hidden" name="o" value="#Form.o_1#">
		<cfparam name="Form.sel_1" default="#Form.sel#">
		<input type="hidden" name="sel" value="#Form.sel_1#">
		<cfparam name="Form.DEid_1" default="#Form.DEid#">
		<input type="hidden" name="DEid" value="#Form.DEid_1#">
		</cfoutput>
	<cfelseif (Session.Params.ModoDespliegue EQ 0)>
		<input type="hidden" name="o" value="3">
	</cfif>
	<cfif not isdefined("Form.PosteoAccion")>		
		<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0>
			<input name="Usuario" type="hidden" value="#Form.Usuario#"> 
		</cfif>
		<cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
			<input name="DLffin" type="hidden" value="#Form.DLffin#"> 
		</cfif>
		<cfif isdefined("Form.DLfvigencia") and Len(Trim(Form.DLfvigencia)) NEQ 0>
			<input name="DLfvigencia" type="hidden" value="#Form.DLfvigencia#"> 
		</cfif>
		<cfif isdefined("Form.RHAlinea") and Len(Trim(Form.RHAlinea)) NEQ 0 and not isdefined("form.btnAplicar") and not isdefined("form.btnEliminar")>
			<input name="RHAlinea" type="hidden" value="#Form.RHAlinea#">
			<input name="modo" type="hidden" value="CAMBIO">
		<cfelse>
			<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		</cfif>
	</cfif>
    
    
    <cfif isdefined("Form.SPid")>
		<input name="SPid" type="hidden" value="#form.SPid#">
	</cfif>
    
	<cfif isdefined("Form.btnNuevo")>
		<input name="modo" type="hidden" value="ALTA">
	</cfif>
    
    <cfif isdefined("Form.Tramite")>
		<input name="Tramite" type="hidden" value="#Form.Tramite#">
	</cfif>
   
    
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
