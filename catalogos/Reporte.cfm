<cffunction name="downloadgrafico"  returntype="any">
    <cfset savedFile = getTempFile(getTempDirectory(),"Download") & "Grafico#NumGrafico#.jpg">
    <cfset fileWrite(savedFile, F01)>
    
    <cfheader name="Content-Disposition" value="attachment;filename=Grafico#NumGrafico#.jpg">
    <cfcontent type="image/jpeg" file="#savedFile#">
    <cfreturn>
</cffunction>

<cffunction name="mestxt"  returntype="any">
	<cfargument name="mes"  type="numeric" required="no">
	
    
    <cfswitch expression="#arguments.mes#">
    	  <cfcase value="1"> 
          	<cfreturn  'ENERO'	>
          </cfcase>
          <cfcase value="2"> 
          	<cfreturn  'FEBRERO'	>
          </cfcase>
          <cfcase value="3"> 
          	<cfreturn  'MARZO'	>
          </cfcase>
          <cfcase value="4"> 
          	<cfreturn  'ABRIL'	>
          </cfcase>
          <cfcase value="5"> 
          	<cfreturn  'MAYO'	>
          </cfcase>
          <cfcase value="6"> 
          	<cfreturn  'JUNIO'	>
          </cfcase>
          <cfcase value="7"> 
          	<cfreturn  'JULIO'	>
          </cfcase>
          <cfcase value="8"> 
          	<cfreturn  'AGOSTO'	>
          </cfcase>
          <cfcase value="9"> 
          	<cfreturn  'SEPTIEMBRE'	>
          </cfcase>
          <cfcase value="10"> 
          	<cfreturn  'OCTUBRE'	>
          </cfcase>
          <cfcase value="11"> 
          	<cfreturn  'NOVIEMBRE'	>
          </cfcase>
          <cfcase value="12"> 
          	<cfreturn  'DICIEMBRE'	>
          </cfcase>
          
    </cfswitch>
</cffunction>


<cffunction name="fnPintaReporte" access="private" output="no" hint="Pinta el reporte hacia los archivos planos">
	<cfset MesIni = mestxt(#form.MesInicial#)>
    <cfset MesFin = mestxt(#form.MesFinal#)>
    
    <cfswitch expression="#form.Indicador#">
        
            <cfcase value="1">  <!--- 1 - FUNDATEC GASTOS DE OPERACION DE LA UAF --->
                <cfquery  dbtype="query" name = "rsDatos"> 
                    select 
                    Ccuenta, 
                    Ecodigo, 
                    Cformato, 
                    Cdescripcion, 
                    nivel, 
                    (saldoini) *-1 as saldoini, 
                    debitos, 
                    creditos, 
                    (saldofin) * -1 as saldofin,
                    Cdetalle,
                    Speriodo, 
                    Smes1, 
                    Smes2
                    from rsCuentasContables
                    where nivel = 0
                    order by Speriodo
                </cfquery> 

                <cfif rsDatos.Smes1 NEQ rsDatos.Smes2>
                    <cfif rsDatos.Smes1 EQ 1>
                        <cfquery  dbtype="query" name = "rsDatosIni"> 
                            select 
                            sum(saldoini) * -1 as saldoini
                            from rsCuentasContables
                            where nivel <> 0
                            and Smes1 = #rsDatos.Smes1#
                            group by Speriodo
                        </cfquery> 
                        <!--- <cfdump var="#rsDatosIni#"> --->

                        <cfquery  dbtype="query" name = "rsDatos"> 
                            select 
                            <!---Ccuenta, 
                            Ecodigo, 
                            Cformato, 
                            Cdescripcion, 
                            nivel, 
                            (saldoini) *-1 as saldoini, 
                            debitos, 
                            creditos, 
                            (saldofin) * -1 as saldofin,
                            Cdetalle,
                            Speriodo, 
                            Smes1, 
                            Smes2,--->
                            Speriodo,
                            sum(Creditos - Debitos) + #rsDatosIni.saldoini# as saldofin
                            from rsCuentasContables
                            where nivel <> 0
                            group by Speriodo
                        </cfquery> 
                    <cfelse>
                        <cfquery  dbtype="query" name = "rsDatos"> 
                            select 
                            <!---Ccuenta, 
                            Ecodigo, 
                            Cformato, 
                            Cdescripcion, 
                            nivel, 
                            (saldoini) *-1 as saldoini, 
                            debitos, 
                            creditos, 
                            (saldofin) * -1 as saldofin,
                            Cdetalle,
                            Speriodo, 
                            Smes1, 
                            Smes2,--->
                            Speriodo,
                            sum(Creditos - Debitos) as saldofin
                            from rsCuentasContables
                            where nivel <> 0
                            group by Speriodo
                        </cfquery>
                    </cfif>


<!--- 
                    <cfquery  dbtype="query" name = "rsDatos"> 
                        select 
                        Ccuenta, 
                        Ecodigo, 
                        Cformato, 
                        Cdescripcion, 
                        nivel, 
                        (saldoini) *-1 as saldoini, 
                        debitos, 
                        creditos, 
                        (saldofin) * -1 as saldofin,
                        Cdetalle,
                        Speriodo, 
                        Smes1, 
                        Smes2,
                        Speriodo
                        
                        from rsCuentasContables
                        where nivel <> 0
                        
                    </cfquery> 
                    <cf_dump var="#rsDatos#"> --->

                </cfif>
                
                <!--- group by Debitos,Creditos --->
                <!--- <cf_dump var="#rsDatos#"> --->
                
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  
        
                <cfset Titulo_Grafico = 'FUNDATEC'& chr(13)& chr(10)& ' INGRESOS GENERADOS POR EL ITCR Y CUSTODIADOS POR FUNDATEC'& 
													chr(13)& chr(10)& 'DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# & 
													chr(13)& chr(10)& 'EN COLONES' &
													chr(13)& chr(10)& ' PARA LOS MESES DE:' & #MesIni# & ' a ' & #MesFin# >  

                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
                
               <cfset NumGrafico = 'F01'>  
			<div align="center" >               
              <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="no"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                    <!---name="F01">  --->
                    >

                    <cfchartseries type="line" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart>
                
                <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="no"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                    name="F01">  
                    >

                    <cfchartseries type="line" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart>
            </div> 
            
            <cfset savedFile = getTempFile(getTempDirectory(),"Download") & "Grafico#NumGrafico#.jpg">
    		<cfset fileWrite(savedFile, F01)>
            
            <div align="center"> <h3>Comentarios </h3></div> 
            <cfoutput>
             <tr>
    	        <td>
                    <table align="center" border="0" width="80%">
                    	<tr>
                           <td width="20%">
                            <div align="center"> <h4>Periodo </h3></div>
                            </td>
                            <td width="20%">
                                <div align="center"> <h4>Código</h3></div>
                            </td>
                            <td>
                                <div align="center"> <h4>Comentarios </h3></div>
                            </td>
                        </tr>
        	        </table>
            	</td>
	        </tr>
            <cfloop from="#form.PeriodoInicio#" to ="#form.PeriodoFinal#" index="i">	
            	<cfset fcinicio = createdate(#i#,#form.MesInicial#,01)>

                <cfset dia = day(dateadd("s",-1,dateadd("m", datediff("m",0,createdate(#i#,#form.MesFinal#,01))+1,0)))>
				
                <cfset fcfin = createdate(#i#,#form.MesFinal#,#dia#)>

                <cfquery name="rsComentarios" datasource="#session.dsn#">
                    select *
                    from <cf_dbdatabase table="FTIComentario" datasource="ftec">
                    where Iid  = #form.Indicador#
                    and ICfechadesde = #fcinicio#
                    and ICfechahasta = #fcfin#
                </cfquery>
                <tr>
                    <td>
                    <table align="center" border="0" width="80%">
                    
                        <tr>
                           <td width="20%">
                            <div align="center"> <h5>#rsComentarios.ICperiodo# </h3></div>
                            </td>
                            <td width="20%">
                                <div align="center"> <h5>#rsComentarios.ICcodigo# </h3></div>
                            </td>
                            <td>
                                <div align="center"> <h5>#rsComentarios.ICcomentario# </h3></div>
                            </td>
                        </tr>
                    </table>
                    </td>
                </tr>
                
 			</cfloop>
            </cfoutput>
  
  
    
            <div align="center">
                <input type="button" name="Regresar"  value="Regresar" onclick="history.back(1)"/>
            </div>     

            <div align="center">
              <cf_dump var="Proceso Concluido">
            </div>
            

                 
<!---				<cfset sObj = SpreadsheetNew()>
                <cfset SpreadsheetAddRow(sObj, "")>
                <cfset SpreadsheetAddImage(sObj,F01,"jpg","1,1,30,20")>
                <cfheader name="Content-Disposition" value="inline; filename=GraficoF01.xls">
                <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(sObj)#">--->

             </cfcase>
            
            
            <cfcase value="2"><!---2 - Crecimiento del Volumen de los Ingresos del TEC custodiados por la FUNDATEC --->
                <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        (a.saldoini) *-1 as saldoini, 
                        a.debitos, 
                        a.creditos, 
                        (a.saldofin) * -1 as saldofin,
                        a.Cdetalle,
                        a.Speriodo, 
                        a.Smes1, 
                        a.Smes2,
                        coalesce((select ((a1.saldofin)*-1) from #reporte# a1 
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
                
                <cfif isdefined('rsCuentasContables') and rsCuentasContables.RecordCount EQ 0 >
                    <cfset TitleErrs = 'Operación Inválida'>
                    <cfset MsgErr	 = 'Indicadores'>
                    <cfset DetErrs 	 = 'No existe cuentas relacionadas al Indicador, Verificar.'>
                    <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
                </cfif>
            
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
                
        

				<cfset Titulo_Grafico = 'FUNDATEC'& 
                                        chr(13)& chr(10)& 'RAZON DE CRECIMIENTO DEL INGRESO CON RELACION AL AÑO ANTERIOR'& 
                                        chr(13)& chr(10)& 'DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# & 
                                        chr(13)& chr(10)& ' PARA LOS MESES DE:' & #MesIni# & ' a ' & #MesFin# >  
                                                      
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
                
                <cfset NumGrafico = 'F02'>
		       <div align="center">
                <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                    <!---name="#NumGrafico#"--->
                    >  
                  
                    <cfchartseries type="cone" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="crecimiento"   
                        seriescolor="##3399FF" 
                        serieslabel="crecimiento" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
                </div>
                
                <div align="center">
                    <input type="button" name="Regresar"  value="Regresar" onclick="history.back(1)"/>
                </div>     
    
                <div align="center">
                  <cf_dump var="Proceso Concluido">
                </div>
                
                <!---<cfset sObj = SpreadsheetNew()>
                <cfset SpreadsheetAddRow(sObj, "")>
                <cfset SpreadsheetAddImage(sObj,F01,"png","1,1,30,20")>
                <cfheader name="Content-Disposition" value="inline; filename=GraficoF02.xls">
                <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(sObj)#">--->
                
<!---                <cfset savedFile = getTempFile(getTempDirectory(),"Download") & "Grafico#NumGrafico#.jpg">
                <cfset fileWrite(savedFile, F02)>
                
                <cfheader name="Content-Disposition" value="attachment;filename=Grafico#NumGrafico#.jpg">
                <cfcontent type="image/jpeg" file="#savedFile#">
--->    
            </cfcase>
        	<cfcase value="3"><!---3 - Gastos de la UAF generados por los servicios de administración de recursos del TEC --->
                <cfquery  dbtype="query" name = "rsDatos"> 
                    select 
                        Ccuenta, 
                        Ecodigo, 
                        Cformato, 
                        Cdescripcion, 
                        nivel, 
                        (saldoini) *-1 as saldoini, 
                        debitos, 
                        creditos, 
                        (saldofin) * -1 as saldofin,
                        Cdetalle,
                        Speriodo, 
                        Smes1, 
                        Smes2 
                    from rsCuentasContables
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
        
 				<cfset Titulo_Grafico = 'FUNDATEC'& 
                        chr(13)& chr(10)& 'GASTOS DE OPERACION DE LA UAF'& 
                        chr(13)& chr(10)& 'DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# & 
                        chr(13)& chr(10)& ' PARA LOS MESES DE:' & #MesIni# & ' a ' & #MesFin# >    
                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
                
                <cfset NumGrafico = 'F03'>
        
                <div align="center">
                <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                    <!---name="#NumGrafico#"--->
                    >  
                  
                    <cfchartseries type="cylinder" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
                
                <!---<cfset sObj = SpreadsheetNew()>
                <cfset SpreadsheetAddRow(sObj, "")>
                <cfset SpreadsheetAddImage(sObj,F01,"png","1,1,30,20")>
                <cfheader name="Content-Disposition" value="inline; filename=GraficoF03.xls">
                <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(sObj)#">--->
                
                </div>
                
                <div align="center">
                    <input type="button" name="Regresar"  value="Regresar" onclick="history.back(1)"/>
                </div>     
    
                <div align="center">
                  <cf_dump var="Proceso Concluido">
                </div>
            </cfcase>
            
            <cfcase value="4"><!---4 - Gastos de la UAF generados por los servicios de administración de recursos del TEC --->
	            <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        (a.saldoini)*-1 as saldoini, 
                        a.debitos, 
                        a.creditos, 
                        (a.saldofin)*-1 as saldofin,
                        a.Cdetalle,
                        a.Speriodo, 
                        a.Smes1, 
                        a.Smes2,
                        coalesce((select ((a1.saldofin)*-1) from #reporte# a1 
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
                
                <cfif isdefined('rsCuentasContables') and rsCuentasContables.RecordCount EQ 0 >
                    <cfset TitleErrs = 'Operación Inválida'>
                    <cfset MsgErr	 = 'Indicadores'>
                    <cfset DetErrs 	 = 'No existe cuentas relacionadas al Indicador, Verificar.'>
                    <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
                </cfif>
            
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

        
 				<cfset Titulo_Grafico = 'FUNDATEC'& 
                                        chr(13)& chr(10)& 'RAZON DE CRECIMIENTO DEL GASTO OPERATIVO DE LA UAF' &chr(13)& chr(10)& ' CON RELACION AL AÑO ANTERIOR'& 
                                        chr(13)& chr(10)& 'DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# & 
                                        chr(13)& chr(10)& ' PARA LOS MESES DE:' & #MesIni# & ' a ' & #MesFin# >  



                <cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
                <cfset NumGrafico = 'F04'>
        
                <div align="center">
                <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                    <!---name="#NumGrafico#"--->
                    >  
                  
                    <cfchartseries type="bar" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="crecimiento"   
                        seriescolor="##3399FF" 
                        serieslabel="crecimiento" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
               <!--- <cfset sObj = SpreadsheetNew()>
                <cfset SpreadsheetAddRow(sObj, "")>
                <cfset SpreadsheetAddImage(sObj,F01,"png","1,1,30,20")>
                <cfheader name="Content-Disposition" value="inline; filename=GraficoF04.xls">
                <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(sObj)#">--->
                
               </div>
                
                <div align="center">
                    <input type="button" name="Regresar"  value="Regresar" onclick="history.back(1)"/>
                </div>     
    
                <div align="center">
                  <cf_dump var="Proceso Concluido">
                </div>
    
            </cfcase>
           
            <cfcase value="5"><!---4 - Gastos de la UAF generados por los servicios de administración de recursos del TEC --->
                <cfquery  dbtype="query" name = "rsDatos"> 
                    select Ccuenta, 
                        Ecodigo, 
                        Cformato, 
                        Cdescripcion, 
                        nivel, 
                        (saldoini) *-1 as saldoini, 
                        debitos, 
                        creditos, 
                        (saldofin) * -1 as saldofin,
                        Cdetalle,
                        Speriodo, 
                        Smes1, 
                        Smes2 
                    from rsCuentasContables
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
        
                 
                <cfset Titulo_Grafico = 'FUNDATEC'& 
                                        chr(13)& chr(10)& 'RAZON ENTRE LA CANTIDAD DE PROYECTOS ACTIVOS Y LA CANTIDAD' &chr(13)& chr(10)& ' DE FUNCIONARIOS DE LA UAF EN EL AÑO DE ANALISIS'& 
                                        chr(13)& chr(10)& 'DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# & 
                                        chr(13)& chr(10)& ' PARA LOS MESES DE:' & #MesIni# & ' a ' & #MesFin# > 
                                        
				<cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
                <cfset NumGrafico = 'F05'>
        
                <div align="center">
                <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                   <!--- name="#NumGrafico#"--->
                   >  
                  
                    <cfchartseries type="cone" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
                <!---<cfset sObj = SpreadsheetNew()>
                <cfset SpreadsheetAddRow(sObj, "")>
                <cfset SpreadsheetAddImage(sObj,F01,"png","1,1,30,20")>
                <cfheader name="Content-Disposition" value="inline; filename=GraficoF05.xls">
                <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(sObj)#">--->
                
                 </div>
                
                <div align="center">
                    <input type="button" name="Regresar"  value="Regresar" onclick="history.back(1)"/>
                </div>     
    
                <div align="center">
                  <cf_dump var="Proceso Concluido">
                </div>
    
            </cfcase>
            
             <cfcase value="6"><!---Razón entre la cantidad de ingresos custodiados por la FUNDATEC en el periodo de análisis y la cantidad de funcionarios de la UAF en el periodo de análisis. --->
                <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        (a.saldoini) *-1 as saldoini, 
                        a.debitos, 
                        a.creditos, 
                        (a.saldofin) *-1 as saldofin,
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
                
                <cfif isdefined('rsCuentasContables') and rsCuentasContables.RecordCount EQ 0 >
                    <cfset TitleErrs = 'Operación Inválida'>
                    <cfset MsgErr	 = 'Indicadores'>
                    <cfset DetErrs 	 = 'No existe cuentas relacionadas al Indicador, Verificar.'>
                    <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
                </cfif>
                
              
            
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  


                <cfquery  dbtype="query" name = "rsDatos"> 
                    select Ccuenta, 
                        Ecodigo, 
                        Cformato, 
                        Cdescripcion, 
                        nivel, 
                        saldoini, 
                        debitos, 
                        creditos, 
                        saldofin,
                        Cdetalle,
                        Speriodo, 
                        Smes1, 
                        Smes2,
	                    (saldofin / CantEmpledos) as crecimiento
                    from rsCuentasContables
                    where nivel = 0
                    and Speriodo > #rsMinPeriodo.desde#
                    order by Speriodo
                </cfquery> 
                
        
                 <cfset Titulo_Grafico = 'FUNDATEC'& 
                                        chr(13)& chr(10)& 'RAZON ENTRE LA CANTIDAD DE INGRESOS CUSTODIADOS Y LA CANTIDAD' &chr(13)& chr(10)& 'RAZON ENTRE LA CANTIDAD DE INGRESOS CUSTODIADOS Y LA CANTIDAD'& 
                                        chr(13)& chr(10)& 'DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# & 
                                        chr(13)& chr(10)& ' PARA LOS MESES DE:' & #MesIni# & ' a ' & #MesFin# > 
				
				<cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
                <cfset NumGrafico = 'F06'>
        
                <div align="center">
                <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                    <!---name="#NumGrafico#"--->
                    >  
                  
                    <cfchartseries type="line" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
                <!---<cfset sObj = SpreadsheetNew()>
                <cfset SpreadsheetAddRow(sObj, "")>
                <cfset SpreadsheetAddImage(sObj,F01,"png","1,1,30,20")>
                <cfheader name="Content-Disposition" value="inline; filename=GraficoF06.xls">
                <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(sObj)#">--->
                
                 </div>
                
                <div align="center">
                    <input type="button" name="Regresar"  value="Regresar" onclick="history.back(1)"/>
                </div>     
    
                <div align="center">
                  <cf_dump var="Proceso Concluido">
                </div>
    
            </cfcase>
             <cfcase value="7"><!---7 Razón entre el costo administrativo cobrado por la FUNDATEC y los ingresos del TEC custodiados por FUNDATEC, en el periodo de análisis.  --->
                <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        (a.saldoini *-1) as saldoini, 
                        a.debitos, 
                        a.creditos, 
                        (a.saldofin *-1) as saldofin,
                        a.Cdetalle,
                        a.Speriodo, 
                        a.Smes1, 
                        a.Smes2,
                        a.GCid,
                        coalesce((select sum((aa.saldofin*-1)) from  #reporte# aa 
                    		where aa.nivel = 0 
                            	and aa.Speriodo = a.Speriodo
                            	and aa.GCid = (select y.GCid 
                                				from FTGrupoCuentas y 
                                                where y.Iid = #form.Indicador# 
                                                and upper(ltrim(rtrim(y.GCcodigo))) = 'Z1' )
                        	group by aa.Speriodo,aa.GCid),0) as montoZ1
                            
                        ,coalesce((select sum((aa.saldofin*-1)) from  #reporte# aa 
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
                
                <cfif isdefined('rsCuentasContables') and rsCuentasContables.RecordCount EQ 0 >
                    <cfset TitleErrs = 'Operación Inválida'>
                    <cfset MsgErr	 = 'Indicadores'>
                    <cfset DetErrs 	 = 'No existe cuentas relacionadas al Indicador, Verificar.'>
                    <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
                </cfif>
            
                <cfquery  dbtype="query" name = "rsMinPeriodo"> 
                    select min(Speriodo) desde from rsCuentasContables
                    where nivel = 0
                </cfquery>
                
                <cfquery  dbtype="query" name = "rsMaxPeriodo"> 
                    select max(Speriodo) hasta from rsCuentasContables
                    where nivel = 0
                </cfquery>  


                <cfquery  dbtype="query" name = "rsDatos"> 
                    select *, (montoY1 / montoY1) *100 as saldofin
                    from rsCuentasContables
                    where nivel = 0
                    order by Speriodo
                </cfquery> 
                
                <!--- --and Speriodo > #rsMinPeriodo.desde#--->
                
        
                <cfset Titulo_Grafico = 'FUNDATEC'& 
                                        chr(13)& chr(10)& 'RAZON ENTRE EL COSTO ADMINISTRATIVO COBRADO Y LOS INGRESOS' &chr(13)& chr(10)& 'CUSTODIADOS EN EL AÑO DE ANALISIS'& 
                                        chr(13)& chr(10)& 'DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# & 
                                        chr(13)& chr(10)& ' PARA LOS MESES DE:' & #MesIni# & ' a ' & #MesFin# >
				<cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'>  
                <cfset NumGrafico = 'F07'>
        
                <div align="center">
                <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                    <!---name="#NumGrafico#"--->
                    >  
                  
                    <cfchartseries type="Pyramid" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="saldofin"   
                        seriescolor="##3399FF" 
                        serieslabel="saldofin" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
                
                <!---<cfset sObj = SpreadsheetNew()>
                <cfset SpreadsheetAddRow(sObj, "")>
                <cfset SpreadsheetAddImage(sObj,F01,"png","1,1,30,20")>
                <cfheader name="Content-Disposition" value="inline; filename=GraficoF07.xls">
                <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(sObj)#">--->
                
                </div>
                
                <div align="center">
                    <input type="button" name="Regresar"  value="Regresar" onclick="history.back(1)"/>
                </div>     
    
                <div align="center">
                  <cf_dump var="Proceso Concluido">
                </div>
    
            </cfcase>
            

             <cfcase value="8"> <!---8 - Razón el crecimiento de los ingresos de la UAF por concepto de costos administrativos cobrados al ITCR en relación con el periodo anterior --->
             	 <cfquery name="rsCuentasContables" datasource="#session.dsn#">
                    select 
                        a.Ccuenta, 
                        a.Ecodigo, 
                        c.Cformato, 
                        <cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
                        a.nivel, 
                        (a.saldoini * -1) as saldoini, 
                        a.debitos, 
                        a.creditos, 
                        (a.saldofin * -1) as saldofin,
                        a.Cdetalle,
                        a.Speriodo, 
                        a.Smes1, 
                        a.Smes2,
                        coalesce((select (a1.saldofin * -1) from #reporte# a1 
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
                
                <cfif isdefined('rsCuentasContables') and rsCuentasContables.RecordCount EQ 0 >
                    <cfset TitleErrs = 'Operación Inválida'>
                    <cfset MsgErr	 = 'Indicadores'>
                    <cfset DetErrs 	 = 'No existe cuentas relacionadas al Indicador, Verificar.'>
                    <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
                </cfif>
            
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
        
                <cfset Titulo_Grafico = 'FUNDATEC'& 
                                        chr(13)& chr(10)& 'RAZON DE CRECIMIENTO DE LOS INGRESOS DE LA UAF POR CONCEPTO DE' &chr(13)& chr(10)& 'COSTOS ADMINISTRATIVOS EN EL AÑO DE ANALISIS'& 
                                        chr(13)& chr(10)& 'DEL  '& #rsMinPeriodo.desde# &  ' AL ' &  #rsMaxPeriodo.hasta# & 
                                        chr(13)& chr(10)& ' PARA LOS MESES DE:' & #MesIni# & ' a ' & #MesFin# >
                
				<cfset Titulo_EjeY = 'Colones'>  
                <cfset Titulo_EjeX = 'Periodos Analizados'> 
                <cfset NumGrafico = 'F08'>
        
                <div align="center">
                <cfchart format="jpg" 
                    xaxistitle="#Titulo_EjeX#" 
                    yaxistitle="#Titulo_EjeY#"
                    show3d="yes"  title="#Titulo_Grafico#"
                    chartheight="480"
                    chartwidth="480"
                    <!---name="#NumGrafico#"--->
                    >  
                  
                    <cfchartseries type="bar" 
                        query="rsDatos" 
                        itemcolumn="Speriodo" 
                        valuecolumn="crecimiento"   
                        seriescolor="##3399FF" 
                        serieslabel="crecimiento" 
                        datalabelstyle="value"> 
                    </cfchartseries> 
                </cfchart> 
                
                <!---<cfset sObj = SpreadsheetNew()>
                <cfset SpreadsheetAddRow(sObj, "")>
                <cfset SpreadsheetAddImage(sObj,F01,"png","1,1,30,20")>
                <cfheader name="Content-Disposition" value="inline; filename=GraficoF08.xls">
                <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(sObj)#">--->
                
                </div>
                
                <div align="center">
                    <input type="button" name="Regresar"  value="Regresar" onclick="history.back(1)"/>
                </div>     
    
                <div align="center">
                  <cf_dump var="Proceso Concluido">
                </div>

            </cfcase>            
        </cfswitch>
		<cfreturn>
</cffunction>