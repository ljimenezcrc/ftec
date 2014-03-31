<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TDdescripcion" Default="Descripci&oacute;n" returnvariable="LB_TDdescripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TDcodigo" Default="Codigo Deducci&oacute;n" returnvariable="LB_TDcodigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoRebajado" Default="Monto Rebajado" returnvariable="LB_MontoRebajado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DEduccion" Default="Deducci&oacute;n" returnvariable="LB_DEduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Referencia" Default="Referencia" returnvariable="LB_Referencia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PeriodoNom" Default="Periodo de N&oacute;mina" returnvariable="LB_PeriodoNom"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DeduccionTipo" Default="Deducci&oacute;n tipo" returnvariable="LB_DeduccionTipo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" 		Default="Grupo Oficinas" 		returnvariable="LB_Oficina"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_del" Default="Del" returnvariable="LB_del"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_al" Default="al" returnvariable="LB_al"/>

<cfoutput>
	<cfquery name="TotalDeducciones" dbtype="query">
		select sum(Monto) as total
		from rsDeducciones
	</cfquery>

	<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
		select TDid, TDcodigo, TDdescripcion 
		from TDeduccion 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			<cfif isdefined("form.TDidlist") and len(trim(form.TDidlist))>
                and TDid  in (#form.TDidlist#)
            </cfif>
	</cfquery>
		
	<cfset vs_params = ''>
	<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
		<cfset vs_params = vs_params & '&Periodo=#form.Periodo#'>
	</cfif>
	<cfif isdefined("form.Mes") and len(trim(form.Mes))>
		<cfset vs_params = vs_params & '&Mes=#form.Mes#'>
	</cfif>
	<cfif isdefined("form.TDidlist") and len(trim(form.TDidlist))>
		<cfset vs_params = vs_params & '&TDidlist=#form.TDidlist#'>
	</cfif>	
	

	
	<cfset LvarFileName = "DeduccionesAplicadas#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title= "#LB_ReporteDeDeduccionesNominasAplicadas#"
				filename="#LvarFileName#"
				irA="repDeduccionesNominasAplicadas-filtro.cfm">

				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>	
				<cfif isdefined("form.Id_Oficina") and len(trim(form.Id_Oficina))>					
                    <cfset Filtro4="#LB_Oficina# : #form.Id_Oficina#">
                <cfelse>
                    <cfset Filtro4="">
                </cfif>
						<cfsavecontent variable="ENCABEZADO_IMP">
						<td align="center" colspan="6"><strong><font size="2">
						<cf_EncReporte
							Titulo="#LB_ReporteDeDeduccionesNominasAplicadas#"
							filtro2="#LB_del# #LSDateFormat(fdesde, "dd/mm/yyyy")# #LB_al# #LSDateFormat(fhasta, "dd/mm/yyyy")#"
                            filtro4="#Filtro4#">
						</cfsavecontent>
						#ENCABEZADO_IMP#
					</tr>
					<cfif (isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes)))
							or (isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta)))> 
						<cfif rsDeducciones.RecordCount NEQ 0>
							<cfset actual = ''>
							<cfset actualCF = ''>
							
							<cfset subtotal = -1>
							<cfset subtotalcf = -1>
							
							<cfloop query="rsDeducciones">

                            		<cfif isdefined("form.ChkEmp")>
									
									        <cfif subtotal GTE 0 and actual NEQ rsDeducciones.DEidentificacion>
												<cfif not cf><tr><td colspan="6"><hr></td></tr></cfif>
												<tr>
													<td colspan="3" align="right"><b><cf_translate key="LB_SubTotal">SubTotal</cf_translate>:</b>&nbsp;</td>
													<td align="right">#LSNumberFormat(subtotal,'999,999,999.99')#</font></td>
												</tr>
											</cfif>
											
											<!----- centro funcional---------------------->
									        <cfif cf and subtotalcf GTE 0 and  actualCF NEQ rsDeducciones.CFcodigo >
												<tr><td colspan="6"><hr></td></tr>
												<tr>
													<td colspan="3" align="right"><b><cf_translate key="LB_SubTotal">SubTotal CF</cf_translate>:</b>&nbsp;</td>
													<td align="right">#LSNumberFormat(subtotalcf,'999,999,999.99')#</font></td>
												</tr>
											</cfif>
											<cfif cf and actualCF NEQ rsDeducciones.CFcodigo>	
												<cfset actualCF = rsDeducciones.CFcodigo>
												<cfset subtotalcf = 0>
												<tr>
													<td colspan="6" align="LEFT">
														<b><u><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:
															#CFcodigo# #CFdescripcion#</u></b>
													</td>
												</tr>
												<tr><td colspan="6"><br></td></tr>
											</cfif>
											
											
											<cfif actual NEQ rsDeducciones.DEidentificacion>
                                                <cfset actual = rsDeducciones.DEidentificacion>
                                                <cfset subtotal = 0>
                                                
                                                <tr class="tituloListas">
                                                    <td><b>#LB_Identificacion#</b></td>
                                                    <td><b>#LB_Nombre#</b></td>
                                                </tr>
                                                <tr <cfif rsDeducciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
                                                <td><font  style="font-size:14px; font-family:'Arial'">#rsDeducciones.DEidentificacion#</font></td>
                                                <td><font  style="font-size:14px; font-family:'Arial'">#rsDeducciones.Nombre#</font></td>
                                                </tr>
                                                <tr class="tituloListas">
                                                    <td><b>#LB_Deduccion#</b></td>
                                                    <td><b>#LB_Referencia#</b></td>
                                                    <td><b>#LB_PeriodoNom#</b></td>
                                                    <td align="right"><b>#LB_MontoRebajado#</b></td>
                                                </tr>
                                            </cfif>

											
                                      <cfelse>
									  
									        <cfif subtotal GTE 0 and actual NEQ rsDeducciones.TDdescripcion>
												<cfif not cf><tr><td colspan="6"><hr></td></tr></cfif>
												<tr>
													<td colspan="3" align="right"><b><cf_translate key="LB_SubTotal">SubTotal</cf_translate>:</b>&nbsp;</td>
													<td align="right">#LSNumberFormat(subtotal,'999,999,999.99')#</font></td>
												</tr>
											</cfif>
											
									        <cfif cf and subtotalcf GTE 0 and  actualCF NEQ rsDeducciones.CFcodigo>
												<tr><td colspan="6"><hr></td></tr>
												<tr>
													<td colspan="3" align="right"><b><cf_translate key="LB_SubTotal">SubTotal CF</cf_translate>:</b>&nbsp;</td>
													<td align="right">#LSNumberFormat(subtotalcf,'999,999,999.99')#</font></td>
												</tr>
											</cfif>

											<cfif cf and actualCF NEQ rsDeducciones.CFcodigo>	
												<cfset actualCF = rsDeducciones.CFcodigo>
												<cfset subtotalcf = 0>
												<tr>
													<td colspan="6" align="LEFT">
														<b><u><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:
															#CFcodigo# #CFdescripcion#</u></b>
													</td>
												</tr>
												<tr><td colspan="6"><br></td></tr>
											</cfif>
													
                                              <cfif actual NEQ rsDeducciones.TDdescripcion>
                                                        <cfset actual = rsDeducciones.TDdescripcion>

                                                        <cfset subtotal = 0>
														
                                                        
                                                        <tr class="tituloListas">
                                                            <td><b>#LB_TDcodigo#</b></td>
                                                            <td><b>#LB_TDdescripcion#</b></td>
                                                        </tr>
                                                        <tr <cfif rsDeducciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
                                                        <td><font  style="font-size:14px; font-family:'Arial'">#rsDeducciones.TDcodigo#</font></td>
                                                        <td><font  style="font-size:14px; font-family:'Arial'">#rsDeducciones.TDdescripcion#</font></td>
                                                        </tr>
														
                                                        <tr class="tituloListas">
                                                            <td><b>#LB_Nombre#</b></td>
                                                            <td><b>#LB_Referencia#</b></td>
                                                            <td><b>#LB_PeriodoNom#</b></td>
                                                            <td align="right"><b>#LB_MontoRebajado#</b></td>
                                                        </tr>
                                                </cfif>
                                       </cfif>
                                    
                                    <tr>
                                   	<cfif isdefined("form.ChkEmp")>
                                    	<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.TDdescripcion#</font></td>
                                    <cfelse>
                                        <td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.DEidentificacion# - #rsDeducciones.Nombre#</font></td>
                                     </cfif>
                                    <td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.Ddescripcion# - #rsDeducciones.Dreferencia#</font></td>
                                    <td><font  style="font-size:11px; font-family:'Arial'"><cfif showNominas>#LSDateFormat(rsDeducciones.RCdesde,'dd/mm/yyyy')# - #LSDateFormat(rsDeducciones.RChasta,'dd/mm/yyyy')#<cfelse>#LSDateFormat(fdesde,'dd/mm/yyyy')# - #LSDateFormat(fhasta,'dd/mm/yyyy')#</cfif></font></td>
                                    <td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDeducciones.Monto,'999,999,999.99')#</font></td>
                                    </tr>
                                    <cfset subtotal = subtotal + rsDeducciones.Monto> 
	                                <cfset subtotalcf = subtotalcf + rsDeducciones.Monto> 
                                
							</cfloop>
                            <tr><td colspan="6"><hr></td></tr>
                            <tr>
                                <td colspan="3" align="right"><b><cf_translate key="LB_SubTotal">SubTotal</cf_translate>:</b>&nbsp;</td>
                                <td align="right">#LSNumberFormat(subtotal,'999,999,999.99')#</font></td>
                            </tr>
							
                            <tr><td colspan="6"><br /><br /><br /><hr></td></tr>
                            <tr>
								<td colspan="3" align="right"><b><cf_translate key="LB_Total">Total</cf_translate>:</b>&nbsp;</td>
								<td align="right">#LSNumberFormat(TotalDeducciones.total,'999,999,999.99')#</font></td>
							</tr>
							<tr><td colspan="4" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
						<cfelse>
							<tr><td colspan="4" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
						</cfif>
					</cfif>
				</table>			
			</td>
		</tr>
	</table>
</cfoutput>

