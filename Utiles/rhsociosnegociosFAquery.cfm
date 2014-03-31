<!---
	<cfparam name="url.form" default="form1">
	<cfparam name="url.desc" default="SNnombre">
	<cfparam name="url.SNnumero" default="SNnumero">
	<cfparam name="url.id" default="SNcodigo">
	<cfparam name="url.FuncJSalCerrar" default="">
	<cfparam name="url.SNtiposocio" default="">
	--->
		
	<cfif isdefined("url.SNnumero") and url.SNnumero NEQ "">
		<cfquery name="rs" datasource="#Session.DSN#">			
			select * from SNegocios 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			  and rtrim(ltrim(upper(SNnumero))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.SNnumero))#">
			  
		  <cfif Len(Trim(url.SNtiposocio)) GT 0 and url.SNtiposocio EQ "P"> 
		  	  and SNtiposocio != 'C'
		  <cfelseif Len(Trim(url.SNtiposocio)) GT 0 and url.SNtiposocio EQ "C">
		  	  and SNtiposocio != 'P'
		  </cfif>								
		</cfquery>
		
		<script language="JavaScript">
			window.parent.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value="<cfoutput>#rs.SNcodigo#</cfoutput>";
			window.parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.SNnombre#</cfoutput>";
			
			<cfif Len(Trim(url.FuncJSalCerrar)) GT 0> parent.<cfoutput>#url.FuncJSalCerrar#</cfoutput> </cfif>
		</script>

	</cfif>