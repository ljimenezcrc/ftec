<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="ftec.Componentes.FTFlujoTramite" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="TTid" 			value="#form.TTid#">
            <cfinvokeargument name="ETid" 			value="#form.ETid#">
            <cfinvokeargument name="FTpasoactual" 	value="#form.FTpasoactual#">
            <cfinvokeargument name="FTpasoaprueba" 	value="#form.FTpasoaprueba#">
            <cfinvokeargument name="FTpasorechaza" 	value="#form.FTpasorechaza#">
            <cfinvokeargument name="FTpasoVB"  value="#form.FTpasoVB#">
            <cfif isdefined('form.FTautoriza')>
	            <cfinvokeargument name="FTautoriza" 	value="1">
            <cfelse>
                <cfinvokeargument name="FTautoriza" 	value="0">
            </cfif>
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTFlujoTramite" method="Alta" >
                <cfinvokeargument name="TTid" 			value="#form.TTid#">
                <cfinvokeargument name="ETid" 			value="#form.ETid#">
                <cfinvokeargument name="FTpasoactual" 	value="#form.FTpasoactual#">
                <cfinvokeargument name="FTpasoaprueba" 	value="#form.FTpasoaprueba#">
                <cfinvokeargument name="FTpasorechaza" 	value="#form.FTpasorechaza#">
                <cfinvokeargument name="FTpasoVB"       value="#form.FTpasoVB#">
                <cfinvokeargument name="Debug"		value="false">
            </cfinvoke>
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Tipos Estado Tramites'>
            <cfset DetErrs 	 = 'El paso de tramite que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
    	<cfinvoke component="ftec.Componentes.FTFlujoTramite" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="FTid" 	value="#form.FTid#">
            <cfinvokeargument name="Debug"	value="false">
        </cfinvoke>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
    	<cfinvoke component="ftec.Componentes.FTFlujoTramite" method="Cambio" >
			<cfinvokeargument name="FTid"			value="#form.FTid#">
            <cfinvokeargument name="FTpasoactual" 	value="#form.FTpasoactual#">
            <cfinvokeargument name="FTpasoaprueba" 	value="#form.FTpasoaprueba#">
            <cfinvokeargument name="FTpasorechaza" 	value="#form.FTpasorechaza#">
            <cfinvokeargument name="FTpasoVB"  value="#form.FTpasoVB#">
            <cfif isdefined('form.FTautoriza')>
	            <cfinvokeargument name="FTautoriza" 	value="1">
            <cfelse>
                <cfinvokeargument name="FTautoriza" 	value="0">
            </cfif>
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    <cfelseif isdefined("Form.ALtaDFlujo")>
    	<cfinvoke component="ftec.Componentes.FTFlujoTramite" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="TTid" 			value="#form.TTid#">
            <cfinvokeargument name="ETid" 			value="#form.ETid#">
            <cfinvokeargument name="FTpasoactual" 	value="#form.FTpasoactual#">
            <cfinvokeargument name="FTpasoaprueba" 	value="#form.FTpasoaprueba#">
            <cfinvokeargument name="FTpasorechaza" 	value="#form.FTpasorechaza#">
            <cfinvokeargument name="FTpasoVB"  value="#form.FTpasoVB#">
            <cfif isdefined('form.FTautoriza')>
	            <cfinvokeargument name="FTautoriza" 	value="1">
            <cfelse>
                <cfinvokeargument name="FTautoriza" 	value="0">
            </cfif>
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTFlujoTramite" method="Alta"  returnvariable="LvarID">
                <cfinvokeargument name="TTid" 			value="#form.TTid#">
                <cfinvokeargument name="ETid" 			value="#form.ETid#">
                <cfinvokeargument name="FTpasoactual" 	value="#form.FTpasoactual#">
                <cfinvokeargument name="FTpasoaprueba" 	value="#form.FTpasoaprueba#">
                <cfinvokeargument name="FTpasorechaza" 	value="#form.FTpasorechaza#">
                <cfinvokeargument name="FTpasoVB"  value="#form.FTpasoVB#">
                <cfinvokeargument name="FTautoriza" 	value="1">
                
            </cfinvoke>
        <cfelse>
            <cfinvoke component="ftec.Componentes.FTFlujoTramite" method="Cambio" >
                <cfinvokeargument name="FTid"			value="#form.FTid#">
                <cfinvokeargument name="FTpasoactual" 	value="#form.FTpasoactual#">
                <cfinvokeargument name="FTpasoaprueba" 	value="#form.FTpasoaprueba#">
                <cfinvokeargument name="FTpasorechaza" 	value="#form.FTpasorechaza#">
                <cfinvokeargument name="FTpasoVB"  value="#form.FTpasoVB#">
                <cfif isdefined('form.FTautoriza')>
                    <cfinvokeargument name="FTautoriza" 	value="1">
                <cfelse>
                    <cfinvokeargument name="FTautoriza" 	value="0">
                </cfif>
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
        </cfif>
    	<cfinvoke component="ftec.Componentes.FTFlujoTramite" method="AltaDFlujo" >
        	<cfif isdefined('form.FTid') and #form.FTid# GT 0>
				<cfinvokeargument name="FTid"	value="#form.FTid#">
            <cfelse>
            	<cfinvokeargument name="FTid"	value="#LvarID#">
            </cfif>
            <cfinvokeargument name="TAid" 	value="#form.TAid#">
            <cfinvokeargument name="Debug"	value="false">
        </cfinvoke>
        <cfset modo="CAMBIO">
     <cfelseif isdefined('Form.btnBorrarAutorizador.X')>
        <cfinvoke component="ftec.Componentes.FTFlujoTramite" method="BajaDFlujo">
            <cfinvokeargument name="FTDid" 		value="#form.FTDid_#">
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>
        <cfset modo="CAMBIO">
	</cfif>
</cfif>



<form action="FlujoTramites.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
    <cfif not isdefined('form.Nuevo')>
        <input name="FTid" type="hidden" value="<cfif isdefined('form.FTid')> <cfoutput>#form.FTid#</cfoutput></cfif>"> 
    </cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
