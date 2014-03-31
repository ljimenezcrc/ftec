<cfparam name="action" default="IndicadoresTabs.cfm?tab=3">
<cfif isdefined('form.Iid') and #form.Iid# GT 0>
	<cfset form.Iid2 = #form.Iid# >
</cfif>

<cfif isdefined('form.btn_addCuenta')>
	<cfset modoCU = 'ALTA'>
</cfif>

<cfif isdefined('form.Agregar') and form.Agregar EQ 1>
	<cfquery name="rsAddcuenta" datasource="#session.DSN#">
    	insert into FTCuentasIndicadores (Iid,Cuenta,NivelDet,NivelTot,MesInicio,MesFinal
        			<cfif isdefined('form.GCid') and #form.GCid# GT 0>
	                    ,GCid
                    </cfif>
                    )
        	values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
            		,<cfqueryparam cfsqltype="cf_sql_char" value="#form.CtaFinal#">
                    ,12,12,1,12
                    <cfif isdefined('form.GCid') and #form.GCid# GT 0>
                    	, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCid#">
                    </cfif>
                    )
    </cfquery>
</cfif>

<cfif isdefined('form.Borrar') and form.Borrar EQ 1>
	<cfquery name="rsAddcuenta" datasource="#session.DSN#">
    	delete from FTCuentasIndicadores
        where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
        	and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
    </cfquery>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modoCU" type="hidden" value="<cfif isdefined("modoCU")><cfoutput>#modoCU#</cfoutput></cfif>">
    <input name="modo" type="hidden" value="CAMBIO">
    <input name="Iid2" type="hidden" value="#form.Iid#">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

