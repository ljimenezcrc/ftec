<!--- Devuelve el nombre de la table calificado con la base de datos correspondiente al datasource --->
<cfparam name="Attributes.table"			type="string" default="">
<cfparam name="Attributes.datasource"		type="string" default="">
<cfparam name="Attributes.returnvariable"	type="string" default="">

<!--- Validar el datasource --->
<cfif Len(trim(Attributes.datasource)) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="cf_dbdatabase: Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif>

<!--- Validar el table --->
<cfif Len(trim(Attributes.table)) Is 0>
	<cfthrow message="cf_dbdatabase: Falta el atributo table">
</cfif>


<cfif Len(trim(Application.dsinfo[Attributes.datasource].schema)) Is 0>
	<cfparam name="Application.dsinfo.#Attributes.datasource#.schema" default="">
	<cfparam name="Application.dsinfo.#Attributes.datasource#.schemaError" default="">

	<cfif Len(trim(Application.dsinfo[Attributes.datasource].schemaError)) is 0>
		<cfthrow message="cf_dbdatabase: No se ha implementado el Schema para el tipo del datasource=#Attributes.datasource# (se implementa en home.Componentes.DbUtils)"
		>
	<cfelse>
		<cfthrow message="cf_dbdatabase: No está definido el Schema para el datasource=#Attributes.datasource#: #Application.dsinfo[Attributes.datasource].schemaError#"
		>
	</cfif>
</cfif>

<cfset LvarTable = "">
<cfif Application.dsinfo[Attributes.datasource].type is 'sybase' OR Application.dsinfo[Attributes.datasource].type is 'sqlserver'>
	<cfset LvarTable = "#Application.dsinfo[Attributes.datasource].schema#..#Attributes.table#">
<cfelseif Application.dsinfo[Attributes.datasource].type is 'oracle' OR Application.dsinfo[Attributes.datasource].type is 'db2'>
	<cfset LvarTable = "#Application.dsinfo[Attributes.datasource].schema#.#Attributes.table#">
<cfelse>
	<cfthrow message="cf_dbdatabase no implementado en tipo base de datos #Attributes.name# (modificar '.schema' en /home/Componentes/DbUtils.cfc)">
</cfif>
<cfif Attributes.returnvariable EQ "">
	<cfoutput>#LvarTable#</cfoutput>
<cfelse>
	<cfset Caller[Attributes.returnvariable] = LvarTable>
</cfif>

