<cfcomponent>
    <cffunction name="Get" access="remote" returntype="any">
     <cfargument name="Tipo" required="true">
            <cfquery name="GetData" datasource="minisif">
                select CIid, Indicador, Cuenta, NivelDet, NivelTot, MesInicio, MesFinal
                from FTCuentasIndicadores
                where Indicador = <cfqueryparam value="#arguments.Tipo#" cfsqltype="cf_sql_integer" />
            </cfquery>

		<cfreturn #SerializeJSON(GetData,true)#>
	</cffunction>
</cfcomponent>