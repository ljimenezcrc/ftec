<cfif not isdefined("Form.NuevoEnc")>

	<cfif isdefined("Form.AplicarEnc") or isdefined("Form.RechazarEnc")>
    	
    	<cfinvoke component="ftec.Componentes.FTTramites" method="AplicaTramite" >
            <cfinvokeargument name="SPid" 		value="#form.SPid#">
            <cfinvokeargument name="TPid" 		value="#form.TPid#">
            <cfinvokeargument name="HTcompleto"	value="1">

            <!---<cfinvokeargument name="Vid"		value="#form.Vpkresp#">--->
            <cfif isdefined("Form.AplicarEnc")>
            	<cfinvokeargument name="Aprueba"	value="1">
            <cfelse>
            	<cfinvokeargument name="Aprueba"	value="0">
            </cfif>
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>
    
	<cfelseif isdefined("Form.AltaEnc")>
        <cfinvoke component="ftec.Componentes.FTSolicitudProceso" method="Alta" returnvariable="Lvar_ID" >
            <cfinvokeargument name="TPid" 			value="1">
            <cfinvokeargument name="SPdocumento"	value="#form.SPdocumento#">
            <cfinvokeargument name="FPid"			value="#form.FPid#">
            <cfinvokeargument name="SPfechavence"	value="#form.SPfechavence#">
            <cfinvokeargument name="SPfechaarribo"	value="#form.SPfechaarribo#">
            <cfinvokeargument name="SPfechafactura"	value="#form.SPfechafactura#">
            <cfinvokeargument name="SPacta"			value="#form.SPacta#">
            <cfinvokeargument name="SNcodigo"		value="#form.SNcodigo#">
            <cfinvokeargument name="Mcodigo"		value="#form.Mcodigo#">
            <cfinvokeargument name="SPobservacion"	value="#form.SPobservacion#">
            <cfif isdefined('form.FPid') and form.FPid EQ 2>
            	<cfinvokeargument name="LPid"		value="#form.LPid#">
            <cfelseif isdefined('form.FPid') and form.FPid EQ 3>
               <!--- <cfinvokeargument name="Bid"			value="#form.Bid#">
                <cfinvokeargument name="SPctacliente"	value="#form.SPctacliente#">--->
                <cfinvokeargument name="SPfechaTrans"	value="#form.SPfechaTrans#">
            </cfif>
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>
        
        <cfset modo = 'CAMBIO'>
        <cfset SPid = Lvar_ID>
    <cfelseif isdefined("Form.EliminarEnc")>
    	
       
        <cfinvoke component="ftec.Componentes.FTSolicitudProceso" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="SPid" 		value="#form.SPid#">
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>
        <cfset modo = 'ALTA'>
	    <cflocation url="Solicitudes-lista.cfm">
	<cfelseif isdefined("Form.CambioEnc")>
       
    	<cfinvoke component="ftec.Componentes.FTSolicitudProceso" method="Cambio" >
            <cfinvokeargument name="SPid" 		value="#form.SPid#">
            <cfinvokeargument name="TPid" 			value="1">
            <cfinvokeargument name="SPdocumento"	value="#form.SPdocumento#">
            <cfinvokeargument name="FPid"			value="#form.FPid#">
            <cfinvokeargument name="SPfechavence"	value="#form.SPfechavence#">
            <cfinvokeargument name="SPfechaarribo"	value="#form.SPfechaarribo#">
            <cfinvokeargument name="SPfechafactura"	value="#form.SPfechafactura#">
            <cfinvokeargument name="SPacta"			value="#form.SPacta#">
            <cfinvokeargument name="SNcodigo"		value="#form.SNcodigo#">
            <cfinvokeargument name="Mcodigo"		value="#form.Mcodigo#">
            <cfinvokeargument name="SPobservacion"	value="#form.SPobservacion#">
            <cfif isdefined('form.FPid') and form.FPid EQ 2>
            	<cfinvokeargument name="LPid"		value="#form.LPid#">
            <cfelseif isdefined('form.FPid') and form.FPid EQ 3>
                <!---<cfinvokeargument name="Bid"			value="#form.Bid#">
                <cfinvokeargument name="SPctacliente"	value="#form.SPctacliente#">--->
                <cfinvokeargument name="SPfechaTrans"	value="#form.SPfechaTrans#">
            </cfif>
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>
	<cfelseif isdefined("Form.AltaDet")>
    		
        <cfinvoke component="ftec.Componentes.FTSolicitudProceso" method="AltaDetalle" returnvariable="Lvar_ID" >
            <cfinvokeargument name="SPid" 			value="#form.SPid#">
            <cfinvokeargument name="Vid" 			value="#form.Vpkresp#">
            <cfinvokeargument name="Cid" 			value="#form.Cid#">
            <cfinvokeargument name="Icodigo" 		value="#form.Icodigo#">
            <cfinvokeargument name="DSPdescripcion"	value="#form.DSPdescripcion#">
            <cfinvokeargument name="DSPmonto"		value="#form.DSPmonto#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    <cfelseif isdefined("Form.BajaDet")>     
		<cfset modo = 'CAMBIO'>
        <cfset SPid = #form.SPidDelete#>
        <cfif isdefined('form.CHK')>
            <cfinvoke component="ftec.Componentes.FTSolicitudProceso" method="BajaDetalle" >
                <cfinvokeargument name="DSPid" 			value="#form.CHK#">
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
        </cfif>
    <cfelseif isdefined("Form.CambioDet")>
        <cfinvoke component="ftec.Componentes.FTSolicitudProceso" method="CambioDetalle" >
            <cfinvokeargument name="DSPid" 			value="#form.DSPidCambio#">
            <cfinvokeargument name="Vid" 			value="#form.Vid#">
            <cfinvokeargument name="Cid" 			value="#form.Cid#">
            <cfinvokeargument name="Icodigo" 		value="#form.Icodigo#">
            <cfinvokeargument name="DSPdescripcion"	value="#form.DSPdescripcion#">
            <cfinvokeargument name="DSPmonto"		value="#form.DSPmonto#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    </cfif>
<cfelse>    
	<cfset modo = 'ALTA'>
</cfif>


<cfif  isdefined('form.Tramite') and #form.Tramite# EQ 1>
    <form action="Tramites-lista.cfm" method="post" name="sql"></form>
<cfelseif  isdefined("Form.AplicarEnc") or isdefined("Form.RechazarEnc")>
	<form action="Solicitudes-lista.cfm" method="post" name="sql"></form>
<cfelseif isdefined("Form.RegresarEnc")>    
	<form action="Solicitudes-lista.cfm" method="post" name="sql"></form>
<cfelse>
    <form action="SolicitudPago.cfm" method="post" name="sql">
        <input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>">
        <input name="SPid" type="hidden" value="<cfoutput>#SPid#</cfoutput>">
        
        <cfif isdefined("Form.NuevoDet")>
            <input name="DSPid" type="hidden" value="">
	        <input name="DSPidCambio" type="hidden" value="">
        <cfelse>
        	<input name="DSPidCambio" type="hidden" value=" <cfif isdefined('DSPidCambio')> <cfoutput>#DSPidCambio#</cfoutput> </cfif>">
	        <input name="DSPid" type="hidden" value="<cfif isdefined('DSPidCambio')>  <cfoutput>#DSPidCambio#</cfoutput>  </cfif>">
		</cfif>

    </form>
</cfif>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
