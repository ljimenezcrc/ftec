<cfif isdefined ('form.CFpk') and len(trim(form.CFpk)) gt 0 and not isdefined ('form.CFcodigo')>
	<cfquery name="rsDato" datasource="#session.dsn#">
		select CFcodigo from CFuncional where CFid=#form.CFpk#
	</cfquery>
	<cfset form.CFcodigo=#rsDato.CFcodigo#>
</cfif>

<cfif isdefined("Url.CFcodigo") and len(trim(Url.CFcodigo)) NEQ 0 and not isdefined("form.CFcodigo")>
	<cfset form.CFcodigo = Url.CFcodigo>
</cfif> 

<cfif isdefined("Url.Codigo_filtro") and len(trim(Url.Codigo_filtro)) NEQ 0 and not isdefined("form.Codigo_filtro")>
	<cfset form.Codigo_filtro = Url.Codigo_filtro>
</cfif> 

<cfif isdefined("Url.Costo_filtro") and len(trim(Url.Costo_filtro)) NEQ 0 and not isdefined("form.Costo_filtro")>
	<cfset form.Costo_filtro = Url.Costo_filtro>
</cfif> 	

<!---<cfdump var="#form#">--->
<cfset filtro = "">
<cfset navegacion="tab=7">
<cfif isdefined("form.Codigo_filtro") and len(trim(form.Codigo_filtro)) gt 0 >
	<cfset filtro = filtro & " and c.Ccodigo like '%" & trim(form.Codigo_filtro) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Codigo_filtro=" & form.Codigo_filtro>
</cfif>

<cfif isdefined("form.Costo_filtro") and len(trim(form.Costo_filtro)) gt 0 >
	<cfset filtro = filtro & " and upper(rtrim(ltrim(c.Cdescripcion))) like '%#ucase(form.Costo_filtro)#%'" >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Costo_filtro=" & form.Costo_filtro>
</cfif>


	<script language="JavaScript1.2" type="text/javascript">
		function resete(){
			document.filtro1.reset();
			document.filtro1.Codigo_filtro.value = "";
			document.filtro1.Costo_filtro.value   = "";	
		}
	</script>
    
	<cfset regresar = "/cfmx/rh/admin/catalogos/CFuncional.cfm">	 
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
			<tr>
				<td valign="top" width="40%">
				<form style="margin:0;" name="filtro1" method="post">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_CODIGO"
						Default="C&oacute;digo"
						returnvariable="LB_CODIGO"/>
		
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_COSTO"
						Default="Costo"
						returnvariable="LB_COSTO"/>
                        
                        <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_PORCENTAJE"
						Default="Porcentaje"
						returnvariable="LB_PORCENTAJE"/>
		
							<table border="0" width="100%" class="areaFiltro">
								<tr> 
									<cfoutput>
										<td><strong>#LB_CODIGO#</strong></td>
										<td><strong>#LB_COSTO#</strong></td>
									</cfoutput>
								</tr>
								<tr> 
									<td><input type="text" name="Codigo_filtro" value="<cfif isdefined("form.Codigo_filtro") and len(trim(form.Codigo_filtro)) gt 0 ><cfoutput>#form.Codigo_filtro#</cfoutput></cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" ></td>
									<td><input type="text" name="Costo_filtro" value="<cfif isdefined("form.Costo_filtro") and len(trim(form.Costo_filtro)) gt 0 ><cfoutput>#form.Costo_filtro#</cfoutput></cfif>" size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
									<td nowrap>
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Filtrar"
										Default="Filtrar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Filtrar"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Limpiar"
										Default="Limpiar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Limpiar"/>	
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Regresar"
										Default="REgresar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Regresar"/>	
                                        <cfoutput>
                                            <input type="hidden" name="tab" value="7" />
                                            <input type="hidden" name="modo" value="ALTA" />
                                            <input type="hidden" name="CFpk" value="#form.CFpk#" />
                                            <input type="submit" name="Filtrar" value="#BTN_Filtrar#">
                                            <input type="button" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript:resete();">
                                        </cfoutput>    
									</td>
								<input type="hidden" id="CFcodigo" name="CFcodigo" value="<cfif isdefined("form.CFcodigo") and len(trim(form.CFcodigo)) neq 0><cfoutput>#form.CFcodigo#</cfoutput></cfif>">
									<cfif isdefined ('form.CFcodigo') and len(trim(form.CFcodigo)) gt 0>
										<cfquery name="rsCFid" datasource="#session.dsn#">
											select CFid from CFuncional where CFcodigo='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#
										</cfquery>
										<cfif rsCFid.recordcount gt 0>
											<cfset LvarCFid=rsCFid.CFid>
										<cfelse>
											<cfset LvarCFid=''>
										</cfif>
									</cfif>
								</tr>								
							</table>
						</form>
		
		
					<!--- Lista de Usuarios definidos para el Centro Funcional --->
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaRet"
					>
						<cfinvokeargument name="tabla" value="CfuncionalConc cfc
                        								inner join Conceptos c
                                                        on c.Cid = cfc.Cid
                                                        and c.Ecodigo = cfc.Ecodigo"/>
						<cfinvokeargument name="columnas" value="cfc.CFCid, cfc.Cid, c.Ccodigo, c.Cdescripcion, c.Cporc, 7 as tab, #LvarCFid# as CFpk"/>
						<cfinvokeargument name="desplegar" value="Ccodigo, Cdescripcion, Cporc"/>
						<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_COSTO#,#LB_PORCENTAJE#"/>
						<cfinvokeargument name="formatos" value="V, V, V"/>
						<cfinvokeargument name="align" value="left, left, center"/>
						<cfinvokeargument name="filtro" value="cfc.Ecodigo = #session.Ecodigo# 
                                                               and cfc.CFid = #LvarCFid#
                                                               and c.Ctipo = 'G'
                                                               #filtro#"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="incluyeForm" value="true">
						<cfinvokeargument name="formName" value="formListCostos">
						<cfinvokeargument name="irA" value="CFuncional.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="conexion" value="#session.dsn#"/>
					</cfinvoke>
				</td>
		
				<td width="60%" valign="top">
					<cfinclude template="formCFcosto.cfm">
				</td>
			
			</tr>
		</table>


