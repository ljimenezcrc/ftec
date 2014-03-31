<cffunction name="fnPintaReporte" access="private" output="no" hint="Pinta el reporte hacia los archivos planos">
        <cfswitch expression="#form.Indicador#">
            <cfcase value="1">  <!--- 1 - FUNDATEC GASTOS DE OPERACION DE LA UAF --->
                <cfquery  dbtype="query" name = "rsDatos"> 
                    select * from rsCuentasContables
                    where nivel = 0
                    order by Speriodo
                </cfquery> 
                
                <!---<cf_dump var="#rsCuentasContables#">--->
                
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  
        
                <cfset Titulo_Grafico = 'INGRESOS GENERADOS POR EL ITCR Y CUSTODIADOS POR FUNDATEC DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# >  
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
        
                <cfchart format="flash" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="no"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480">  
                  
                    <cfchartseries type="line" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
            </cfcase>
            
            
            <cfcase value="2"><!---2 - Crecimiento del Volumen de los Ingresos del TEC custodiados por la FUNDATEC --->
                <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        a.saldoini, 
                        a.debitos, 
                        a.creditos, 
                        a.saldofin,
                        a.Cdetalle,
                        a.Speriodo, 
                        a.Smes1, 
                        a.Smes2,
                        coalesce((select a1.saldofin from #reporte# a1 
                                    where a1.Speriodo = (a.Speriodo - 1)
                                    and a1.Ccuenta = a.Ccuenta)
                                ,0) as saldofinanterior
                    from #reporte# a
                        inner join CContables c
                            on c.Ccuenta = a.Ccuenta
                    <cfif isdefined("form.ID_NoIncluir")>
                        where a.debitos <> 0.00 or a.creditos <> 0.00
                    <cfelse>
                        where a.saldoini <> 0.00 or a.debitos <> 0.00 or a.creditos <> 0.00
                    </cfif>
                    order by c.Cformato
                </cfquery>
            
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  


                <cfquery  dbtype="query" name = "rsDatos"> 
                    select *, (((saldofin - saldofinanterior) / saldofinanterior) * 100 ) as crecimiento
                    from rsCuentasContables
                    where nivel = 0
                    and Speriodo > #rsMinPeriodo.desde#
                    order by Speriodo
                </cfquery> 
                
<!---                <cfdump var="#rsDatos#">
                <cfdump var="#rsMinPeriodo#">
                <cf_dump var="#rsMaxPeriodo#">--->
                
        
                <cfset Titulo_Grafico = 'RAZON DE CRECIMIENTO DEL INGRESO CON RELACION AL AÑO ANTERIOR DEL '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# >
  
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
        
                <cfchart format="flash" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480">  
                  
                    <cfchartseries type="cone" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="crecimiento"   
                        seriescolor="##3399FF" 
                        serieslabel="crecimiento" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
    
            </cfcase>
        	<cfcase value="3"><!---3 - Gastos de la UAF generados por los servicios de administración de recursos del TEC --->
                <cfquery  dbtype="query" name = "rsDatos"> 
                    select * from rsCuentasContables
                    where nivel = 0
                    order by Speriodo
                </cfquery> 
                
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  
        
                <cfset Titulo_Grafico = 'GASTOS DE OPERACION DE LA UAF DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# >  
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
        
                <cfchart format="flash" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480">  
                  
                    <cfchartseries type="cylinder" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
    
            </cfcase>
            
            <cfcase value="4"><!---4 - Gastos de la UAF generados por los servicios de administración de recursos del TEC --->
	            <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        a.saldoini, 
                        a.debitos, 
                        a.creditos, 
                        a.saldofin,
                        a.Cdetalle,
                        a.Speriodo, 
                        a.Smes1, 
                        a.Smes2,
                        coalesce((select a1.saldofin from #reporte# a1 
                                    where a1.Speriodo = (a.Speriodo - 1)
                                    and a1.Ccuenta = a.Ccuenta)
                                ,0) as saldofinanterior
                    from #reporte# a
                        inner join CContables c
                            on c.Ccuenta = a.Ccuenta
                    <cfif isdefined("form.ID_NoIncluir")>
                        where a.debitos <> 0.00 or a.creditos <> 0.00
                    <cfelse>
                        where a.saldoini <> 0.00 or a.debitos <> 0.00 or a.creditos <> 0.00
                    </cfif>
                    order by c.Cformato
                </cfquery>
            
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  


                <cfquery  dbtype="query" name = "rsDatos"> 
                    select *, (((saldofin - saldofinanterior) / saldofinanterior) * 100 ) as crecimiento
                    from rsCuentasContables
                    where nivel = 0
                    and Speriodo > #rsMinPeriodo.desde#
                    order by Speriodo
                </cfquery> 
                
<!---                <cfdump var="#rsDatos#">
                <cfdump var="#rsMinPeriodo#">
                <cf_dump var="#rsMaxPeriodo#">--->

        
                <cfset Titulo_Grafico = 'RAZON DE CRECIMIENTO DEL GASTO OPERATIVO DE LA UAF CON RELACION AL AÑO ANTERIOR DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# >  
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
        
                <cfchart format="flash" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480">  
                  
                    <cfchartseries type="bar" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="crecimiento"   
                        seriescolor="##3399FF" 
                        serieslabel="crecimiento" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
    
            </cfcase>
           
            <cfcase value="5"><!---4 - Gastos de la UAF generados por los servicios de administración de recursos del TEC --->
                <cfquery  dbtype="query" name = "rsDatos"> 
                    select * from rsCuentasContables
                    where nivel = 0
                    order by Speriodo
                </cfquery> 
                
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  
        
                <cfset Titulo_Grafico = 'RAZON ENTRE LA CANTIDAD DE PROYECTOS ACTIVOS Y LA CANTIDAD DE FUNCIONARIOS DE LA UAF EN EL AÑO DE ANALISIS DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# >  
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
        
                <cfchart format="flash" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480">  
                  
                    <cfchartseries type="cone" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
    
            </cfcase>
            
             <cfcase value="6"><!---Razón entre la cantidad de ingresos custodiados por la FUNDATEC en el periodo de análisis y la cantidad de funcionarios de la UAF en el periodo de análisis. --->
                <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        a.saldoini, 
                        a.debitos, 
                        a.creditos, 
                        a.saldofin,
                        a.Cdetalle,
                        a.Speriodo, 
                        a.Smes1, 
                        a.Smes2,
                        coalesce((select count(DEid)
									from FTEmpleadoIndicador 
                                    where EIperiodo =  a.Speriodo)
                                ,0) as CantEmpledos
                    from #reporte# a
                        inner join CContables c
                            on c.Ccuenta = a.Ccuenta
                    <cfif isdefined("form.ID_NoIncluir")>
                        where a.debitos <> 0.00 or a.creditos <> 0.00
                    <cfelse>
                        where a.saldoini <> 0.00 or a.debitos <> 0.00 or a.creditos <> 0.00
                    </cfif>
                    order by c.Cformato
                </cfquery>
                
              
            
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  


                <cfquery  dbtype="query" name = "rsDatos"> 
                    select *, (saldofin / CantEmpledos) as crecimiento
                    from rsCuentasContables
                    where nivel = 0
                    and Speriodo > #rsMinPeriodo.desde#
                    order by Speriodo
                </cfquery> 
                
        
                <cfset Titulo_Grafico = 'RAZON ENTRE LA CANTIDAD DE INGRESOS CUSTODIADOS Y LA CANTIDAD DE FUNCIONARIOS DE LA UAF EN EL AÑO DE ANALISIS DEL '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# >  
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
        
                <cfchart format="flash" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480">  
                  
                    <cfchartseries type="line" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
    
            </cfcase>
             <cfcase value="7"><!---7 Razón entre el costo administrativo cobrado por la FUNDATEC y los ingresos del TEC custodiados por FUNDATEC, en el periodo de análisis.  --->
                <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        a.saldoini, 
                        a.debitos, 
                        a.creditos, 
                        a.saldofin,
                        a.Cdetalle,
                        a.Speriodo, 
                        a.Smes1, 
                        a.Smes2,
                        a.GCid,
                        coalesce((select sum(aa.saldofin) from  #reporte# aa 
                    		where aa.nivel = 0 
                            	and aa.Speriodo = a.Speriodo
                            	and aa.GCid = (select y.GCid 
                                				from FTGrupoCuentas y 
                                                where y.Iid = #form.Indicador# 
                                                and upper(ltrim(rtrim(y.GCcodigo))) = 'Z1' )
                        	group by aa.Speriodo,aa.GCid),0) as montoZ1
                            
                        ,coalesce((select sum(aa.saldofin) from  #reporte# aa 
                    		where aa.nivel = 0 
	                            and aa.Speriodo = a.Speriodo
	                            and aa.GCid = (select z.GCid 
                                				from FTGrupoCuentas z
                                                where z.Iid = #form.Indicador# 
                                                and upper(ltrim(rtrim(z.GCcodigo))) = 'Y1' )
                        	group by aa.Speriodo,aa.GCid),0) as montoY1
                            
                    from #reporte# a
                        inner join CContables c
                            on c.Ccuenta = a.Ccuenta
                    <cfif isdefined("form.ID_NoIncluir")>
                        where a.debitos <> 0.00 or a.creditos <> 0.00
                    <cfelse>
                        where a.saldoini <> 0.00 or a.debitos <> 0.00 or a.creditos <> 0.00
                    </cfif>
                    order by c.Cformato, a.nivel
                </cfquery>
            
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  


                <cfquery  dbtype="query" name = "rsDatos"> 
                    select *
                    from rsCuentasContables
                    where nivel = 0
                    order by Speriodo
                </cfquery> 
                
                <!--- --and Speriodo > #rsMinPeriodo.desde#--->
                
                <cf_dump var="#rsCuentasContables#"><strong></strong>
        
                <cfset Titulo_Grafico = 'RAZON ENTRE EL COSTO ADMINISTRATIVO COBRADO Y LOS INGRESOS CUSTODIADOS EN EL AÑO DE ANALISIS DEL '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# >  
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
        
                <cfchart format="flash" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480">  
                  
                    <cfchartseries type="Pyramid" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
    
            </cfcase>
            

             <cfcase value="8"><!---4 - Gastos de la UAF generados por los servicios de administración de recursos del TEC --->
                <cfquery  dbtype="query" name = "rsDatos"> 
                    select * from rsCuentasContables
                    where nivel = 0
                    order by Speriodo
                </cfquery> 
                
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  
        
                <cfset Titulo_Grafico = 'RAZON DE CRECIMIENTO DE LOS INGRESOS DE LA UAF POR CONCEPTO DE COSTOS ADMINISTRATIVOS EN EL AÑO DE ANALISIS DEL '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# >  
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
        
                <cfchart format="flash" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480">  
                  
                    <cfchartseries type="bar" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
    
            </cfcase>            
        </cfswitch>
        
        <cf_dump var="Proceso Concluido">
</cffunction>