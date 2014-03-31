<cfparam name="action" default="IndicadoresTabs.cfm?tab=4">

<cfif isdefined('form.Iid') and #form.Iid# GT 0>
	<cfset form.Iid2 = #form.Iid# >
</cfif>

<cfif isdefined('form.CAmbioGC')>
	<cfset modoGC = 'CAMBIO'>
<cfelse>
    <cfset modoGC = 'ALTA'>
</cfif>
	
    
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.AltaGC")>
		<cfinvoke component="ftec.Componentes.FTGrupoCuentas" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="GCcodigo" 		value="#form.GCcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTGrupoCuentas" method="Alta" >
            	<cfinvokeargument name="Iid" 			value="#form.Iid#">
            	<cfinvokeargument name="GCcodigo" 		value="#form.GCcodigo#">
                <cfinvokeargument name="GCdescripcion"	value="#form.GCdescripcion#">
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Indicadores'>
            <cfset DetErrs 	 = 'El Codigo  ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.BajaGC")>
    	<cfinvoke component="ftec.Componentes.FTGrupoCuentas" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="GCid" 			value="#form.GCid#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.CambioGC")>
    	<cfinvoke component="ftec.Componentes.FTGrupoCuentas" method="Cambio" >
            <cfinvokeargument name="GCid" 			value="#form.GCid#">
            <cfinvokeargument name="Iid" 			value="#form.Iid#">
            <cfinvokeargument name="GCcodigo" 		value="#form.GCcodigo#">
            <cfinvokeargument name="GCdescripcion"	value="#form.GCdescripcion#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
	</cfif>
</cfif>
<cfoutput>


<form action="IndicadoresTabs.cfm?tab=4" method="post" name="sql">
	<input name="modoGC" type="hidden" value="<cfif isdefined("modoGC")><cfoutput>#modoGC#</cfoutput></cfif>">
    <input name="modo"   type="hidden" value="<cfif isdefined("modoGC")>#modoGC#</cfif>">
    <input name="Iid2" type="hidden" value="#form.Iid#">
	<cfif modoGC eq 'CAMBIO'>
        <input name="GCid" type="hidden" value="#form.GCid#">
    </cfif>
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

