<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="ftec.Componentes.FTEstadoTramite" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="ETcodigo" 		value="#form.ETcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTEstadoTramite" method="Alta" >
            	<cfinvokeargument name="ETcodigo" 		value="#form.ETcodigo#">
                <cfinvokeargument name="ETdescripcion"	value="#form.ETdescripcion#">
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Tipos Estado Tramites'>
            <cfset DetErrs 	 = 'El tipo de estado tramite que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
    	<cfinvoke component="ftec.Componentes.FTEstadoTramite" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="ETcodigo" 		value="#form.ETcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
    	<cfinvoke component="ftec.Componentes.FTEstadoTramite" method="Cambio" >
            <cfinvokeargument name="ETid" 			value="#form.ETid#">
            <cfinvokeargument name="ETcodigo" 		value="#form.ETcodigo#">
            <cfinvokeargument name="ETdescripcion"	value="#form.ETdescripcion#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    
	</cfif>
</cfif>



<form action="EstadoTramites.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>