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

<cfif isdefined("Url.Ingreso_filtro") and len(trim(Url.Ingreso_filtro)) NEQ 0 and not isdefined("form.Ingreso_filtro")>
	<cfset form.Ingreso_filtro = Url.Ingreso_filtro>
</cfif> 	

<cfquery name="rsCFuncional" datasource="#session.dsn#">
	select CFcodigo, CFdescripcion from CFuncional where CFcodigo='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#
</cfquery>


<cfset filtro = "">
<cfset navegacion="">
<cfif isdefined("form.Codigo_filtro") and len(trim(form.Codigo_filtro)) gt 0 >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Codigo_filtro=" & form.Codigo_filtro>
</cfif>

<cfif isdefined("form.Ingreso_filtro") and len(trim(form.Ingreso_filtro)) gt 0 >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ingreso_filtro=" & form.Ingreso_filtro>
</cfif>
		
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_UsuarioCFuncionals"
Default="Usuarios del Centro Funcional"
returnvariable="LB_UsuarioCFuncionals"/>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar2(){
		document.filtro2.reset();
		document.filtro2.Codigo_filtro.value = "";
		document.filtro2.Costo_filtro.value   = "";	
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
				<form style="margin:0;" name="filtro2" method="post">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_CODIGO"
						Default="Codigo"
						returnvariable="LB_CODIGO"/>
		
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_INGRESO"
						Default="Ingreso"
						returnvariable="LB_INGRESO"/>
                        
                        <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_COSTO"
						Default="Codigo del Costo"
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
										<td><strong>#LB_INGRESO#</strong></td>
									</cfoutput>
								</tr>
								<tr> 
									<td><input type="text" name="Codigo_filtro" value="<cfif isdefined("form.Codigo_filtro") and len(trim(form.Codigo_filtro)) gt 0 ><cfoutput>#form.Codigo_filtro#</cfoutput></cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" ></td>
									<td><input type="text" name="Ingreso_filtro" value="<cfif isdefined("form.Ingreso_filtro") and len(trim(form.Ingreso_filtro)) gt 0 ><cfoutput>#form.Ingreso_filtro#</cfoutput></cfif>" size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
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
                                            <input type="hidden" name="tab" value="8" />
                                            <input type="hidden" name="modo" value="ALTA" />
                                            <input type="hidden" name="CFpk" value="#form.CFpk#" />
                                            <input type="submit" name="Filtrar" value="#BTN_Filtrar#">
                                            <input type="button" name="Limpiar2" value="#BTN_Limpiar#" onClick="javascript:limpiar2();">
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
					
					<cfquery name="rsSelectI" datasource="#session.dsn#">
                    	select cfc.CFCid as CFCid2, cfc.Cid, c.Ccodigo, cfc.CFCid_Costo, c.Cdescripcion, cfc.CFCporc, 8 as tab, #LvarCFid# as CFpk,
                        (select c2.Ccodigo from Conceptos c2 
                        inner join CfuncionalConc cfc2 
                        on cfc2.Cid = c2.Cid
                        and cfc2.Ecodigo = c2.Ecodigo
                        where c2.Cid = (select Cid from CfuncionalConc where CFCid = cfc.CFCid_Costo)
                        and c2.Ecodigo = #session.Ecodigo# and cfc2.CFid = cfc.CFid) as CFCid_Costos,
                        cfc.CFCporc, cfc.CFCtipo, cfc.CFCid_Costo, cfl.CFdescripcion
                        from CfuncionalConc cfc
                        inner join Conceptos c
                        on c.Cid = cfc.Cid
                        and c.Ecodigo = cfc.Ecodigo
                        inner join CFuncional cfl
                        on cfl.CFid = cfc.CFidD
                        and cfl.Ecodigo = cfc.Ecodigo
                        where cfc.Ecodigo = #session.Ecodigo# 
                        and cfc.CFid = #LvarCFid#
                        and c.Ctipo = 'I'
                        <cfif isdefined("form.Codigo_filtro") and len(trim(form.Codigo_filtro)) gt 0 >
							and c.Ccodigo like '%trim(form.Codigo_filtro)%'
                        </cfif>
                        <cfif isdefined("form.Ingreso_filtro") and len(trim(form.Ingreso_filtro)) gt 0 >
							and upper(rtrim(ltrim(c.Cdescripcion))) like upper('%#form.Ingreso_filtro#%')
                        </cfif>    
                    </cfquery>
                    <cfif rsSelectI.CFCtipo eq 1>
                    	<cfset desplegar = "Ccodigo, Cdescripcion, CFdescripcion, CFCporc">
                        <cfset etiquetas = "#LB_CODIGO#,#LB_INGRESO#,CF Destino, #LB_PORCENTAJE#">
						<cfset formatos = "V, V, V, V">
                        <cfset align = "left, left, left, left">
                    <cfelse>
                    	<cfset desplegar = "Ccodigo, Cdescripcion, CFCid_Costos, CFdescripcion, CFCporc">
                        <cfset etiquetas = "#LB_CODIGO#,#LB_INGRESO#, #LB_COSTO#, CF Destino, #LB_PORCENTAJE#">
						<cfset formatos = "V, V, V, V, V">
                        <cfset align = "left, left, left, left, left">    
                    </cfif>
					<!--- Lista de Usuarios definidos para el Centro Funcional --->
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"
					>
						<cfinvokeargument name="query" value="#rsSelectI#"/>
						<cfinvokeargument name="desplegar" value="#desplegar#"/>
						<cfinvokeargument name="etiquetas" value="#etiquetas#"/>
						<cfinvokeargument name="formatos" value="#formatos#"/>
                        <cfinvokeargument name="align" value="#align#"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="incluyeForm" value="true">
						<cfinvokeargument name="formName" value="formListIngresos">
						<cfinvokeargument name="irA" value="CFuncional.cfm"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>                        
					</cfinvoke>
				</td>
		
				<td width="60%" valign="top">
					<cfinclude template="formCFingreso.cfm">
				</td>
			
			</tr>
	
		</table>

	

