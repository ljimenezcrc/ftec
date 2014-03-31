<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="ftec.Componentes.FTTipoProceso" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="TPcodigo" 		value="#form.TPcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTTipoProceso" method="Alta" >
            	<cfinvokeargument name="TTid" 			value="#form.TTid#">
            	<cfinvokeargument name="TPcodigo" 		value="#form.TPcodigo#">
                <cfinvokeargument name="TPdescripcion"	value="#form.TPdescripcion#">
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Tipos Estado Tramites'>
            <cfset DetErrs 	 = 'El tipo de proceso que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
    	<cfinvoke component="ftec.Componentes.FTTipoProceso" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="TPcodigo" 		value="#form.TPcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
    	<cfinvoke component="ftec.Componentes.FTTipoProceso" method="Cambio" >
            <cfinvokeargument name="TPid" 			value="#form.TPid#">
            <cfinvokeargument name="TTid" 			value="#form.TTid#">
            <cfinvokeargument name="TPcodigo" 		value="#form.TPcodigo#">
            <cfinvokeargument name="TPdescripcion"	value="#form.TPdescripcion#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    
	</cfif>
</cfif>



<form action="TiposProcesos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>