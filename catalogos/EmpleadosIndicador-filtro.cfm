<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesNominasAplicadas" Default="Reporte de deducciones nóminas aplicadas" returnvariable="LB_ReporteDeDeduccionesNominasAplicadas"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Generar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Debeselecionarunperiodoymes" Default="Debe seleccionar un periodo y mes" returnvariable="MSG_Debeselecionarunperiodoymes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaRige" 	Default="Fecha Rige" returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaVence" 	Default="Fecha Vence" returnvariable="LB_FechaVence"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Fecha" 		Default="Las fechas son requeridas" returnvariable="MSG_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeTiposDeDeduccion" Default="Lista de Tipos de Deduccion" returnvariable="LB_ListaDeTiposDeDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO" Default="Codigo" XmlFile="/rh/generales.xml"returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" Default="Descripcion" XmlFile="/rh/generales.xml"returnvariable="LB_DESCRIPCION"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Deduccion" 	Default="Deducci�n" returnvariable="MSG_Deduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_ElTipoDeDeduccionYaFueAgregado" Default="El tipo de deduccion ya fue agregado" returnvariable="MSG_TipoDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarAlMenosUnTipoDeDeduccion" Default="Debe seleccionar al menos un tipo de deduccion" returnvariable="MSG_SelTipoDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes" Default="Debe seleccionar una nomina o un periodo/mes" returnvariable="MSG_DebeSeleccionarUnaNominaOUnPeriodoMes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" 	Default="Periodo" 	returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" 		Default="Mes" 		returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" 		Default="Grupo Oficinas" 		returnvariable="LB_Oficina"/>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfif isdefined('form.CHK')>
	<cfdump var="#mes1#">
</cfif>

<cf_dbfunction name="concat" args="'<img src=/cfmx/ftec/imagenes/check.gif style=cursor:pointer />', ''" returnvariable="imgNoAplica">



<form name="form1" method="post" action="EmpleadoIndicadoresTabs.cfm">
    
    <cfoutput>
        <table width="100%" cellpadding="3" cellspacing="0" align="center" border="0">
            <tr>		
                <td align="right"><b><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</b></td>
                <td align="left">
                    <cf_rhcfuncional tabindex="1" AgregarEnLista = "true" >
                </td>
                <td width="272" align="right"><b>#LB_Periodo#:&nbsp;</b></td>
                <td colspan="2">
                    <select name="periodo">
                        <option value=""></option>
                        <cfloop index="i" from="-5" to="0">
                            <cfset vn_anno = year(DateAdd("yyyy", i, now()))>
                            <option value="#vn_anno#">#vn_anno#</option>
                        </cfloop>
                    </select>
                </td>
              <cfset paso = 1>	
                <td align="right"><b>#LB_Mes#:&nbsp;</b></td>
                <td colspan="2">
                    <select name="mes">	<option value=""></option>
                        <cfloop query="rsMeses">
                            <option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
                        </cfloop>
                    </select>
                 </td>
            </tr>
            <tr>				
                <td colspan="8" align="center">
                    <input type="submit" name="btnConsultar" value="#BTN_Consultar#" class="BTNAplicar">
                </td>
            </tr>
        </table>	
        <input type="image" id="imgNoAplica" src="/cfmx/ftec/imagenes/check.gif" title="NoAplica" style="display:none;">
    </cfoutput>
    
   
    <cfif isdefined('form.Periodo') and #form.Periodo# GT 0 and not isdefined('form.BtnFiltrar')>
    
        <cfset finicio = createdate(#form.Periodo#, #form.Mes#,1)>
        <cfset ffin = dateadd('m',1,#finicio#)>
        <cfset ffin = dateadd('d',-1,#ffin#)>
        
        <cf_dbfunction name="op_concat" returnvariable="_cat">
        
        <cfquery name="rsListaEmpleados" datasource="#session.DSN#">
            select  distinct  a.DEid, a.RHPid, f.CFid, cf.CFcodigo, cf.CFdescripcion, cf.CFcodigo #_cat# ' - ' #_cat# cf.CFdescripcion as CentroFuncional,
            de.DEapellido1 #_cat# ' ' #_cat#  de.DEapellido2  #_cat# ' ' #_cat#  de.DEnombre as Nombre 
            , coalesce(e.EImes,#form.mes#) as mes, coalesce(e.EIperiodo,#form.periodo#) as periodo
            , case when coalesce(e.EInoaplica,0) = 0 then #preservesinglequotes(imgNoAplica)# 
                    else
                    ''
              end as NoAPlica
              ,coalesce(EInoaplica,1) as EInoaplica
            from LineaTiempo a
            inner join DatosEmpleado de
                on a.DEid  = de.DEid
            inner join RHPlazas f
                    on a.RHPid = f.RHPid
                        and a.Ecodigo = f.Ecodigo
            inner join CFuncional cf
                on f.CFid = cf.CFid
            left  join <cf_dbdatabase table="FTEmpleadoIndicador" datasource="ftec"> e
                on de.DEid = e.DEid
                    and e.EImes = #form.mes#
                    and e.EIperiodo = #form.periodo#
            where ((a.LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#finicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#ffin#"> )
                or (a.LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#finicio#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#ffin#">  )

                or <cfqueryparam cfsqltype="cf_sql_date" value="#finicio#"> between a.LTdesde and a.LThasta
                or <cfqueryparam cfsqltype="cf_sql_date" value="#ffin#"> between a.LTdesde and a.LThasta
                )
                and f.CFid in (#LISTACFUNCIONAL0#) <!---#form.CFid#--->
            <!---order by e.EIperiodo, e.EImes, de.DEapellido1 #_cat# ' ' #_cat#  de.DEapellido2  #_cat# ' ' #_cat#  de.DEnombre--->

        </cfquery> 
        
        <cfquery name="rsloop" dbtype="query">
            select * from rsListaEmpleados
            where EInoaplica = 1
        </cfquery>
        
        <cfloop query="rsloop">
            <cfquery name="rsInsert" datasource="#session.DSN#">
                insert into <cf_dbdatabase table="FTEmpleadoIndicador" datasource="ftec">   (DEid
                                                ,CFid
                                                ,EImes
                                                ,EIperiodo
                                                ,EInoaplica) 
                                       values ( #rsloop.DEid#
                                                , #rsloop.CFid#
                                                ,#form.mes#
                                                ,#form.periodo#
                                                ,0
                                             )
            </cfquery>
        </cfloop>
</cfif>        
</form>

