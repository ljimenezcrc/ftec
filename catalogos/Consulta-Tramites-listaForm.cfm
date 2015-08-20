<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cfset navegacion = ''>
<!---Carga valores del form----->
<cfif isdefined("url.TipoProceso") and not isdefined("form.TipoProceso") >
	<cfset form.TipoProceso = url.TipoProceso >
</cfif>
<cfif isdefined("url.Vcodigoresp") and not isdefined("form.Vcodigoresp") >
	<cfset form.Vcodigoresp = url.Vcodigoresp >
</cfif>

<!---Carga de valores de navegacion----->			
<cfif isdefined("Form.TipoProceso") and len(trim(form.TipoProceso)) >
	<cfset navegacion = navegacion & "&TipoProceso=#form.TipoProceso#">
</cfif>	
<cfif isdefined("Form.Vcodigoresp") and len(trim(form.Vcodigoresp)) >
	<cfset navegacion = navegacion & "&Vcodigoresp=#form.Vcodigoresp#">
</cfif>
	

<cfquery name="rsTipoProceso" datasource="#session.dsn#">
	select TPid, TPcodigo, TPdescripcion
    from <cf_dbdatabase table="FTTipoProceso" datasource="ftec">
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
    order by TPcodigo,TPdescripcion
</cfquery>

 
<cfif isdefined('from.SPidFiltro') and len(form.SPidFiltro)> 
    <cfset LvarSPid = #form.SPidFiltro#>
<cfelse>
    <cfset LvarSPid = '' >
</cfif>
<!---  
<cfif isdefined('from.SNnumero') and len(form.SNnumero)> 
    <cfset LvarSNnumero = #form.SPidFiltro# >
<cfelse>
    <cfset LvarSNnumero = '' >
</cfif>


<cfif isdefined('from.SPdocumentoFiltro') and len(form.SPdocumentoFiltro)> 
    <cfset LvarSPdocumentoFiltro = #form.SPdocumentoFiltro# >
<cfelse>
    <cfset LvarSPdocumentoFiltro = '' >
</cfif> --->

<cfoutput>
<!---    
<form name="filtroSolicitudes" method="post" action="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	<cfoutput>
	<tr>
  		<td class="fileLabel">Consecutivo</td>
        <td class="fileLabel">Proveedor</td>
        <td class="fileLabel">Documento</td>
  	</tr>
	<tr>
   		<td>
            <input name="SPidFiltro" type="text" id="SPidFiltro" maxlength="10"  style="text-align: right;" value="">
		</td>
        <!--- <td>
            <cf_rhsociosnegociosFA > 
        </td>
        <td>
            <input name="SPdocumentoFiltro" type="text" id="SPdocumentoFiltro" maxlength="25"  style="text-align: right;" value="#LvarSPdocumentoFiltro#" >
        </td>
    	 
        <td align="center">
			<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
        </td> --->
    </tr>
    </cfoutput>

      
    </tr>

</table>
</form> --->
</cfoutput>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	
        <cfquery name="rsListaSolicitudes" datasource="#Session.DSN#">
                select distinct
                	a.SPdocumento,
                    a.SPid,
                    a.TPid,
                    a.FPid,
                    a.SPfechafactura,
                    a.SPestado,
                    b.SNnumero #_Cat# ' - ' #_Cat# b.SNnombre as Proveedor,
                    c.FPcodigo,
                    c.FPdescripcion,
                    d.TPcodigo #_Cat# ' - ' #_Cat#  d.TPdescripcion as Tipo, 
                    d.TPcodigo
                    ,(select 
                        coalesce(sum(a1.DSPmontototal),0.00)
                    from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> a1
                        inner join <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> b1
                            on a1.SPid = b1.SPid
                    where b1.SPid = a.SPid) as Total
                    , e.Usucodigo
                    , 1 as Tramite   
                    ,(select  m.Miso4217 #_Cat# ' - ' #_Cat#  m.Msimbolo from Monedas m where m.Ecodigo =  a.Ecodigo and m.Mcodigo = a.Mcodigo) as Moneda 
                    , case when ((select coalesce(sum(a1.DSPmonto),0.00) 
                                    from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> a1 
                                    inner join <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> b1 
                                        on a1.SPid = b1.SPid 
                                    where b1.SPid = a.SPid) between f.TAmontomin and f.TAmontomax
                                ) then 0
                            else 1
                    end as VB
                    ,(select Usulogin from Usuario where Usucodigo = a.Usucodigo) as Usulogin
                from <cf_dbdatabase table="FTSolicitudProceso" datasource="ftec"> a
                inner join SNegocios b
					on a.SNcodigo = b.SNcodigo
                inner join <cf_dbdatabase table="FTFormaPago" datasource="ftec"> c
                    on a.FPid = c.FPid
                    and a.Ecodigo = c.Ecodigo
                inner join <cf_dbdatabase table="FTTipoProceso" datasource="ftec"> d
                    on a.TPid = d.TPid
                    and a.Ecodigo = c.Ecodigo
                    
                inner join <cf_dbdatabase table="FTAutorizador" datasource="ftec"> e
                    on  e.Vid in (select Vid from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> a1 where a1.SPid = a.SPid <!--- and coalesce(DScambiopaso,0) = 0 --->)
                        and <cf_dbfunction name="today"> between e.Afdesde and  e.Afhasta

                inner join <cf_dbdatabase table="FTTipoAutorizador" datasource="ftec"> f
                    on e.TAid = f.TAid
                    and ( (e.Usucodigo in (
                                        select e1.Usucodigo
                                            from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> a11
                                                inner join <cf_dbdatabase table="FTTipoProceso" datasource="ftec"> b1
                                                    on a11.TPid = b1.TPid
                                                inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c1
                                                    on b1.TTid = c1.TTid
                                                inner join <cf_dbdatabase table="FTDFlujoTramite" datasource="ftec"> d1
                                                    on c1.FTid = d1.FTid
                                                inner join <cf_dbdatabase table="FTAutorizador" datasource="ftec"> e1
                                                    on d1.TAid = e1.TAid
                                                    and e1.Vid in (select a2.Vid
                                                                    from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> a2
                                                                    where a2.SPid = a11.SPid)
                                                                    <!---and coalesce(a2.DScambiopaso,0) = 0) --->
                                                    and a11.HTpasosigue = 0
                                        where a11.SPid = a.SPid 
                                            and a11.HTfecha = (select max(b11.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> b11 where b11.SPid = a11.SPid and HTcompleto = 1)
                                            and HTcompleto = 1                                                
                                        )
                        ) 
                    )    
            
                inner join <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> ht
                    on a.SPid = ht.SPid
                        and ht.HTfecha = (select max(b1.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> b1 where ht.SPid = b1.SPid)
                         and ht.HTpasosigue = 0 <!---solo lee los que ya se finalizaron --->   
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and a.SPestado = 1
                
                and e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">  
                
            
            <!--- <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">--->
            <cfif isdefined("Form.TipoProceso") and Len(Trim(Form.TipoProceso)) NEQ 0>
                <cfif Form.TipoProceso NEQ "-1">
                    and d.TPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TipoProceso#">
                </cfif>
            </cfif>
            <!---<cfif isdefined("Form.Vcodigoresp") and Len(Trim(Form.Vcodigoresp)) NEQ 0>
                and b.Vcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Vcodigoresp#">
            </cfif>--->
        </cfquery>  

        <!--- <cf_dump var="#rsListaSolicitudes#"> --->
    
        <form style="margin:0" name="listaSolicitudes" method="post" action="/cfmx/ftec/catalogos/Consulta-Tramites-listaSql.cfm">
        <tr>
            <td>                
            <cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                <cfinvokeargument name="query" value="#rsListaSolicitudes#"/>
                <cfinvokeargument name="desplegar" value="SPid,Tipo, Proveedor,SPdocumento,Usulogin,SPfechafactura, Moneda, Total"/>
                <cfinvokeargument name="etiquetas" value="Consecutivo,Tipo,Proveedor,Documento,Usuario Reg,Fecha Fact, Moneda, Monto"/>
                <cfinvokeargument name="formatos" value="I,V,V,V,V,D,S,M"/>
                <cfinvokeargument name="align" value="center,left, left,left,center,center,center, right"/>
                <cfinvokeargument name="ajustar" value="S"/>
                <cfinvokeargument name="irA" value="/cfmx/ftec/catalogos/Consulta-Tramites-listaSql.cfm"/>
                <cfinvokeargument name="keys" value="SPid"/>
                <cfinvokeargument name="MaxRows" value="20"/>
                <cfinvokeargument name="formName" value="listaSolicitudes"/> <!------>
                <cfinvokeargument name="debug" value="N"/>
                <cfinvokeargument name="navegacion" value="#navegacion#"/>
                <cfinvokeargument name="incluyeForm" value="true"/>	
                <cfinvokeargument name="showEmptyListMsg" value="yes"/>
				<cfinvokeargument name="EmptyListMsg" value="No se encontraron registros"/>
                
            </cfinvoke>
            </td>
        </tr>

<!---         
<cfinvokeargument name="checkall" value="S"/>
<cfinvokeargument name="checkboxes" value="S"/>
<cfinvokeargument name="botones" value="Aplicar"/>
<cfinvokeargument name="filtrar_automatico" value="true"/>
<cfinvokeargument name="mostrar_filtro" value="true"/>
<cfinvokeargument name="filtrar_por" value="SPid,Proveedor,SPdocumento,Usulogin,SPfechafactura"/>

<td align="center">
            <input name="btnAplicar" type="submit" id="AplicarSolicitud" value="Aplicar Solicitud">
        </td> --->
    </form>
	<tr><td>&nbsp;</td></tr>
</table>
