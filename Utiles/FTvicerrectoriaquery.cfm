<!--- Recibe conexion, form, name, desc, ecodigo y dato --->


<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfparam name="url.conexion" default="#session.DSN#">

<cfif isdefined("url.dato") and len(trim(url.dato))>
	
    <cfquery name="rs" datasource="#url.conexion#">
        select Vid, rtrim(ltrim(Vcodigo)) as Vcodigo, Vdescripcion
        from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec">
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
        and rtrim(ltrim(upper(Vcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
        <cfif isdefined("url.excluir") and len(trim(url.excluir )) and url.excluir neq -1>
            and Vid not in ( #url.excluir# )
        </cfif>
    </cfquery>
    
	<cfif rs.recordcount gt 0>
		<script language="JavaScript">
			if(window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value='<cfoutput>#rs.Vid#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>)	
				window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value='<cfoutput>#rs.Vcodigo#</cfoutput>';
			if(window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value='<cfoutput>#rs.Vdescripcion#</cfoutput>';
			<cfoutput>
				if (window.parent.func#url.name#) { window.parent.func#url.name#();}			
			</cfoutput>
		</script>
	<cfelse>
		<script language="JavaScript">
			if(window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.id#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>)	
				window.parent.document.<cfoutput>#url.formulario#.#url.name#</cfoutput>.value="";
			if(window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>)
				window.parent.document.<cfoutput>#url.formulario#.#url.desc#</cfoutput>.value="";
		</script>
	</cfif>
</cfif>
