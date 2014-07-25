<cfparam name="form.DVobligatorio" default="0">
<cfparam name="Param" 			   default="">

 

<cfif isdefined('ALTA')>
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="ALTA" returnvariable="DVid">
 		<cfinvokeargument name="DVetiqueta" 	value="#form.DVetiqueta#">
 		<cfinvokeargument name="DVexplicacion" 	value="#form.DVexplicacion#">
		<cfinvokeargument name="DVtipoDato"	 	value="#form.DVtipoDato#">
		<cfinvokeargument name="DVlongitud" 	value="#form.DVlongitud#">
		<cfinvokeargument name="DVdecimales" 	value="#form.DVdecimales#">
		<cfinvokeargument name="DVmascara" 		value="#form.DVmascara#">
		<cfinvokeargument name="DVobligatorio" 	value="#form.DVobligatorio#">
	</cfinvoke>
	<cfset Param = "DVid=#DVid#">
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="CAMBIO">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
 		<cfinvokeargument name="DVetiqueta" 	value="#form.DVetiqueta#">
 		<cfinvokeargument name="DVexplicacion" 	value="#form.DVexplicacion#">
		<cfinvokeargument name="DVtipoDato"	 	value="#form.DVtipoDato#">
		<cfinvokeargument name="DVlongitud" 	value="#form.DVlongitud#">
		<cfinvokeargument name="DVdecimales" 	value="#form.DVdecimales#">
		<cfinvokeargument name="DVmascara" 		value="#form.DVmascara#">
		<cfinvokeargument name="DVobligatorio" 	value="#form.DVobligatorio#">
    </cfinvoke>
	<cfset Param = "DVid=#form.DVid#">
<cfelseif isdefined('BAJA')>
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="BAJA">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
	</cfinvoke>
<cfelseif isdefined('ALTADET')>
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="ALTALISTA">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
		<cfinvokeargument name="DVLcodigo" 		value="#form.DVLcodigo#">
		<cfinvokeargument name="DVLdescripcion" value="#form.DVLdescripcion#">
	</cfinvoke>
	<cfset Param = "DVid=#form.DVid#">
<cfelseif isdefined('BAJADET')>
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="BAJALISTA">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
		<cfinvokeargument name="DVLcodigo" 		value="#form.DVLcodigo#">
		<cfinvokeargument name="DVLdescripcion" value="#form.DVLdescripcion#">
	</cfinvoke>
	<cfset Param = "DVid=#form.DVid#">
<cfelseif isdefined('CAMBIODET')>
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="CAMBIOLISTA">
		<cfinvokeargument name="DVid" 			value="#form.DVid#">
		<cfinvokeargument name="DVLcodigo" 		value="#form.DVLcodigo#">
		<cfinvokeargument name="DVLdescripcion" value="#form.DVLdescripcion#">
	</cfinvoke>
	<cfset Param = "DVid=#form.DVid#">
</cfif>
<cflocation url="DatosVariables.cfm?#Param#">