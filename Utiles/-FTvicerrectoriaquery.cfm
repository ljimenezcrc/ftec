<!--- Recibe conexion, form, name, desc, ecodigo y dato --->
    <cf_dump var="#url#">
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfquery name="rs" datasource="#url.conexion#">
		select Vid as Vid, rtrim(ltrim(Vcodigo)) as Vcodigo, Vdescripcion
		from FTVicerrectoria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
		and rtrim(ltrim(upper(Vcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
		<cfif isdefined("url.excluir") and len(trim(url.excluir)) NEQ 0>
			and Vid not in(<cfqueryparam cfsqltype="cf_sql_integer" value="#url.excluir#" list="yes">)
		</cfif>
	</cfquery>

    

	<script language="JavaScript">	
		<cfif isdefined('rs') and rs.recordCount GT 0>
			parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.Vid#</cfoutput>";
			parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.Vcodigo#</cfoutput>";
			parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Vdescripcion#</cfoutput>";
		<cfelse>
			parent.<cfoutput>#url.form#.#url.id#</cfoutput>.value="";
			parent.<cfoutput>#url.form#.#url.name#</cfoutput>.value="";
			parent.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="";
		</cfif>
		<cfif isdefined("url.onblur") and len(trim(url.onblur))>
			window.parent.<cfoutput>#url.onblur#</cfoutput>;
		</cfif>
	</script>	
</cfif>