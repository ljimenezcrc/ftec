
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="ftec.Componentes.FTCostosAdmin" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="CAcodigo" 		value="#form.CAcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTCostosAdmin" method="Alta" >
            	<cfinvokeargument name="CAcodigo" 		value="#form.CAcodigo#">
                <cfinvokeargument name="CAdescripcion"	value="#form.CAdescripcion#">
                <cfinvokeargument name="CAporcentaje"	value="#form.CAporcentaje#">
                <cfif isdefined('form.CAobligatorio')> 
                	<cfinvokeargument name="CAobligatorio"	value="1">
                <cfelse> 
                	<cfinvokeargument name="CAobligatorio"	value="0">
                </cfif>
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Tipos Autorizador'>
            <cfset DetErrs 	 = 'El tipo de costo adminitrativo que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
    	<cfinvoke component="ftec.Componentes.FTCostosAdmin" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="CAcodigo" 		value="#form.CAcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
    	<cfinvoke component="ftec.Componentes.FTCostosAdmin" method="Cambio" >
            <cfinvokeargument name="CAid" 			value="#form.CAid#">
            <cfinvokeargument name="CAcodigo" 		value="#form.CAcodigo#">
            <cfinvokeargument name="CAdescripcion"	value="#form.CAdescripcion#">
            <cfinvokeargument name="CAporcentaje"	value="#form.CAporcentaje#">
			<cfif isdefined('form.CAobligatorio')> 
                <cfinvokeargument name="CAobligatorio"	value="1">
            <cfelse> 
                <cfinvokeargument name="CAobligatorio"	value="0">
            </cfif>
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    
		<cfif isdefined("rsDeptocodigoCambio") and rsDeptocodigoCambio.RecordCount GT 0>
			<cf_errorCode	code = "50021" msg = "El Código que desea modificar ya existe.">
		</cfif>
	</cfif>
</cfif>



<form action="CostosAdmin.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>