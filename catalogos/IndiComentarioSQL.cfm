<cfparam name="action" default="IndicadoresTabs.cfm?tab=2">
<cfif isdefined('form.Iid') and #form.Iid# GT 0>
	<cfset form.Iid2 = #form.Iid# >
</cfif>
<cfif isdefined('form.CAmbioCO')>
	<cfset modoCO = 'CAMBIO'>
<cfelse>
    <cfset modoCO = 'ALTA'>
</cfif>
	
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.AltaCO")>
		<cfinvoke component="ftec.Componentes.FTIComentario" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="ICcodigo" 		value="#form.ICcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTIComentario" method="Alta" >
            	<cfinvokeargument name="Iid" 			value="#form.Iid#">
            	<cfinvokeargument name="ICcodigo" 		value="#form.ICcodigo#">
                <cfinvokeargument name="ICcomentario"	value="#form.ICcomentario#">
                <cfinvokeargument name="ICfechadesde"	value="#form.ICfechadesde#">
                <cfinvokeargument name="ICfechahasta"	value="#form.ICfechahasta#">
                <cfinvokeargument name="ICperiodo"		value="#form.ICperiodo#">
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Indicadores'>
            <cfset DetErrs 	 = 'El tipo de Indicador que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.BajaCO")>
    	<cfinvoke component="ftec.Componentes.FTIComentario" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="ICid" 			value="#form.ICid#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.CambioCO")>
    	<cfinvoke component="ftec.Componentes.FTIComentario" method="Cambio" >
            <cfinvokeargument name="ICid" 			value="#form.ICid#">
            <cfinvokeargument name="Iid" 			value="#form.Iid#">
            <cfinvokeargument name="ICcodigo" 		value="#form.ICcodigo#">
            <cfinvokeargument name="ICcomentario"	value="#form.ICcomentario#">
            <cfinvokeargument name="ICfechadesde"	value="#form.ICfechadesde#">
            <cfinvokeargument name="ICfechahasta"	value="#form.ICfechahasta#">
            <cfinvokeargument name="ICperiodo"		value="#form.ICperiodo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    
	</cfif>
</cfif>
<cfoutput>


<form action="IndicadoresTabs.cfm?tab=2" method="post" name="sql">
	<input name="modoCO" type="hidden" value="<cfif isdefined("modoCO")><cfoutput>#modoCO#</cfoutput></cfif>">
    <input name="modo"   type="hidden" value="<cfif isdefined("modoDE")>#modoCO#</cfif>">
    <input name="Iid2" type="hidden" value="#form.Iid#">
	<cfif modoCO eq 'CAMBIO'>
        <input name="ICid" type="hidden" value="#form.ICid#">
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

