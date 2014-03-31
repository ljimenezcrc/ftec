<cfparam name="action" default="IndicadoresTabs.cfm?tab=1">
<cfif isdefined('form.CambioIN')>
	<cfparam name="modoIN" default="CAMBIO">
<cfelse>
	<cfparam name="modoIN" default="ALTA">
</cfif>    


<cfif not isdefined("Form.NuevoIN")>
	<cfif isdefined("Form.AltaIN")>
		<cfinvoke component="ftec.Componentes.FTIndicador" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="Icodigo" 		value="#form.Icodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTIndicador" method="Alta" >
            	<cfinvokeargument name="Icodigo" 		value="#form.Icodigo#">
                <cfinvokeargument name="Idescripcion"	value="#form.Idescripcion#">
                <cfinvokeargument name="Ifecha"			value="#form.Ifecha#">
                <cfinvokeargument name="Iformacalculo"	value="#form.Iformacalculo#">
                <cfinvokeargument name="Iperiodicidad"	value="#form.Iperiodicidad#">
                <cfinvokeargument name="Ifuente"		value="#form.Ifuente#">
                <cfinvokeargument name="Iresponsable"	value="#form.Iresponsable#">
                <cfinvokeargument name="Iformapresenta"	value="#form.Iformapresenta#">
                <cfinvokeargument name="Iusos"			value="#form.Iusos#">
                <cfinvokeargument name="Inivelagrega"	value="#form.Inivelagrega#">
                <cfinvokeargument name="Irotroproceso"	value="#form.Irotroproceso#">
                <cfinvokeargument name="Ivalormeta"		value="#form.Ivalormeta#">
                <cfinvokeargument name="Irangoacepta"	value="#form.Irangoacepta#">
                <cfinvokeargument name="Iobservacion"	value="#form.Iobservacion#">
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Indicadores'>
            <cfset DetErrs 	 = 'El tipo de Indicador que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.BajaIN")>
    	<cfinvoke component="ftec.Componentes.FTIndicador" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="Icodigo" 		value="#form.Icodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
		<cfset modoIN="BAJA">
	<cfelseif isdefined("Form.CambioIN")>
    	<cfinvoke component="ftec.Componentes.FTIndicador" method="Cambio" >
            <cfinvokeargument name="Iid" 			value="#form.Iid#">
            <cfinvokeargument name="Icodigo" 		value="#form.Icodigo#">
            <cfinvokeargument name="Idescripcion"	value="#form.Idescripcion#">
            <cfinvokeargument name="Ifecha"			value="#form.Ifecha#">
            <cfinvokeargument name="Iformacalculo"	value="#form.Iformacalculo#">
            <cfinvokeargument name="Iperiodicidad"	value="#form.Iperiodicidad#">
            <cfinvokeargument name="Ifuente"		value="#form.Ifuente#">
            <cfinvokeargument name="Iresponsable"	value="#form.Iresponsable#">
            <cfinvokeargument name="Iformapresenta"	value="#form.Iformapresenta#">
            <cfinvokeargument name="Iusos"			value="#form.Iusos#">
            <cfinvokeargument name="Inivelagrega"	value="#form.Inivelagrega#">
            <cfinvokeargument name="Irotroproceso"	value="#form.Irotroproceso#">
            <cfinvokeargument name="Ivalormeta"		value="#form.Ivalormeta#">
            <cfinvokeargument name="Irangoacepta"	value="#form.Irangoacepta#">
            <cfinvokeargument name="Iobservacion"	value="#form.Iobservacion#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
    
	</cfif>
</cfif>
<cfoutput>
    <form action="IndicadoresTabs.cfm?tab=1" method="post" name="sql">
        <input name="modoIN"   type="hidden" value="<cfif isdefined("modoIN")>#modoIN#</cfif>">
        <cfif modoIN eq 'CAMBIO'><input name="Iid" type="hidden" value="#form.Iid#"></cfif>
    </form>
</cfoutput>




<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>