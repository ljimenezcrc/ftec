
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="ftec.Componentes.FTTipoAutorizador" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="TAcodigo" 		value="#form.TAcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTTipoAutorizador" method="Alta" >
            	<cfinvokeargument name="TAcodigo" 		value="#form.TAcodigo#">
                <cfinvokeargument name="TAdescripcion"	value="#form.TAdescripcion#">
                <cfinvokeargument name="TAmontomin"		value="#form.TAmontomin#">
                <cfinvokeargument name="TAmontomax"		value="#form.TAmontomax#">
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Tipos Autorizador'>
            <cfset DetErrs 	 = 'El tipo de autorizador que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
    	<cfinvoke component="ftec.Componentes.FTTipoAutorizador" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="TAcodigo" 		value="#form.TAcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
    	<cfinvoke component="ftec.Componentes.FTTipoAutorizador" method="Cambio" >
            <cfinvokeargument name="TAid" 			value="#form.TAid#">
            <cfinvokeargument name="TAcodigo" 		value="#form.TAcodigo#">
            <cfinvokeargument name="TAdescripcion"	value="#form.TAdescripcion#">
            <cfinvokeargument name="TAmontomin"		value="#form.TAmontomin#">
            <cfinvokeargument name="TAmontomax"		value="#form.TAmontomax#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    
		<cfif isdefined("rsDeptocodigoCambio") and rsDeptocodigoCambio.RecordCount GT 0>
			<cf_errorCode	code = "50021" msg = "El Código que desea modificar ya existe.">
		</cfif>
	</cfif>
</cfif>



<form action="TiposAutorizadores.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>