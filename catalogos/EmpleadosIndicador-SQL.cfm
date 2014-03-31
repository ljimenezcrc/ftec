

<cfquery name="rsupdate" datasource="#session.DSN#">
	select coalesce(EInoaplica,0) as EInoaplica, EIid  from <cf_dbdatabase table="FTEmpleadoIndicador " datasource="ftec"> where EIid in (#form.CHK#)
</cfquery>
<cfloop query="rsupdate">

    <cfquery name="rsupdate1" datasource="#session.DSN#">
        update <cf_dbdatabase table="FTEmpleadoIndicador " datasource="ftec"> set EInoaplica = case when #rsupdate.EInoaplica# = 0 then 1 else 0 end
        where EIid = #rsupdate.EIid#
    </cfquery>

</cfloop>
   
   
<cflocation  url = "EmpleadoIndicadoresTabs.cfm?tab=2">
