
<!--- Recibe conexion, form, name, desc, ecodigo y dato --->

<cf_dump var="#dato#">
<cfif isdefined("url.dato") and url.dato NEQ "">
	<cfscript>
		LVid = "";
		LVcodigo  = ""; 
		LVdescripcion = "";
	</cfscript>
	<cftry>
		<cfquery name="rs" datasource="#url.conexion#">
			select Vid, rtrim(ltrim(Vcodigo)) as Vcodigo, Vdescripcion
			from FTVicerrectoria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigo#">
			and rtrim(ltrim(upper(Vcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.dato))#">
			<cfif isdefined("url.excluir") and len(trim(url.excluir )) and url.excluir neq -1>
				and Vid not in ( #url.excluir# )
			</cfif>
		</cfquery>
        
		<cfscript>
			if (rs.Recordcount){
				if (len(rs.Vid)) LVid = rs.CFid;
				if (len(rs.Vcodigo)) LVcodigo = rs.Vcodigo;
				if (len(rs.Vdescripcion)) LVdescripcion = rs.Vdescripcion;
			}
		</cfscript>
		<cfcatch>
			<script language="javascript" type="text/javascript">
				alert("<cfoutput>#cfcatch.Message#</cfoutput>");
			</script>
		</cfcatch>
	</cftry>
	<script language="JavaScript">
		var descAnt = window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
		window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#LVid#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#trim(LVcodigo)#</cfoutput>";
		window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#trim(LVdescripcion)#</cfoutput>";
		<cfoutput>
		if (window.parent.func#trim(Url.name)#) {window.parent.func#trim(Url.name)#();}		
		</cfoutput>
	</script>
</cfif>