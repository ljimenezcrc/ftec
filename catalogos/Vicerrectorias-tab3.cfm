<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_RecursosHumanos"
    Default="Recursos Humanos"
    returnvariable="LB_RecursosHumanos"/>

<cfif isdefined ('form.Vpk') and len(trim(form.Vpk)) gt 0 and not isdefined ('form.Vcodigo')>
	<cfquery name="rsDato" datasource="#session.dsn#">
		select Vcodigo from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> where Vid=#form.Vpk#
	</cfquery>
	<cfset form.Vcodigo=#rsDato.Vcodigo#>
</cfif>

<cfif isdefined("Url.Vcodigo") and len(trim(Url.Vcodigo)) NEQ 0 and not isdefined("form.Vcodigo")>
	<cfset form.Vcodigo = Url.Vcodigo>
</cfif> 

<cfif isdefined("Url.Identificacion_filtro") and len(trim(Url.Identificacion_filtro)) NEQ 0 and not isdefined("form.Identificacion_filtro")>
	<cfset form.Identificacion_filtro = Url.Identificacion_filtro>
</cfif> 

<cfif isdefined("Url.Nombre_filtro") and len(trim(Url.Nombre_filtro)) NEQ 0 and not isdefined("form.Nombre_filtro")>
	<cfset form.Nombre_filtro = Url.Nombre_filtro>
</cfif> 	

<cfquery name="rsFTVicerrectoria" datasource="#session.dsn#">
	select Vid,Vcodigo, Vdescripcion from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> where Vcodigo='#form.Vcodigo#' and Ecodigo=#session.Ecodigo#
</cfquery>

<cfif len(trim(rsFTVicerrectoria.Vdescripcion)) gt 0>
	<cfset Lvardesc= "#trim(rsFTVicerrectoria.Vcodigo)# - #rsFTVicerrectoria.Vdescripcion#">
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.reset();
		document.filtro.Identificacion_filtro.value = "";
		document.filtro.Nombre_filtro.value   = "";
	}
</script>

<cfset filtro = "">
<cfset navegacion="">
<cfif isdefined("form.Identificacion_filtro") and len(trim(form.Identificacion_filtro)) gt 0 >
	<cfset filtro = filtro & " and b.Pid like '%" & trim(form.Identificacion_filtro) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Identificacion_filtro=" & form.Identificacion_filtro>
</cfif>

<cfif isdefined("form.Nombre_filtro") and len(trim(form.Nombre_filtro)) gt 0 >
	<cfset filtro = filtro & " and upper(rtrim(ltrim( {fn concat({fn concat({fn concat({fn concat(b.Pnombre , ' ' )}, b.Papellido1 )}, ' ' )}, b.Papellido2 )} ))) like '%#ucase(form.Nombre_filtro)#%' " >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Nombre_filtro=" & form.Nombre_filtro>
</cfif>

<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "tab=3">

<cfif isdefined("rsFTVicerrectoria.Vid") and len(trim(rsFTVicerrectoria.Vid)) gt 0 >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Vpk=" & rsFTVicerrectoria.Vid>
</cfif>
		
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_UsuarioAutorizadores"
Default="Usuarios Autorizadores"
returnvariable="LB_UsuarioAutorizadores"/>

<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="">
	<cfset regresar = "/cfmx/ftec/catalogos/Vicerrectorias.cfm">	 
	<cfinclude template="/rh/portlets/pNavegacion.cfm">

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="left" colspan="2">
				<strong><font size="2">
				<cf_translate key="LB_Vicerrectoria">Unidad Operativa</cf_translate>:
				</font></strong> 
				<font size="2"><cfoutput>#Lvardesc#</cfoutput></font>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td valign="top" width="40%">
			<form style="margin:0;" name="filtro" id="filtro" method="post">
						<table border="0" width="100%" class="areaFiltro">
							<tr> 
								<cfoutput>
									<td><strong>C&oacute;digo</strong></td>
									<td><strong>Descripci&oacute;n</strong></td>
								</cfoutput>
							</tr>
							<tr> 
								<td><input type="text" name="Identificacion_filtro" value="<cfif isdefined("form.Identificacion_filtro") and len(trim(form.Identificacion_filtro)) gt 0 ><cfoutput>#form.Identificacion_filtro#</cfoutput></cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" ></td>
								<td><input type="text" name="Nombre_filtro" value="<cfif isdefined("form.Nombre_filtro") and len(trim(form.Nombre_filtro)) gt 0 ><cfoutput>#form.Nombre_filtro#</cfoutput></cfif>" size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
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
									
									<input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
									<input type="button" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar1();">
								</td>
							<input type="hidden" id="Vcodigo" name="Vcodigo" value="<cfif isdefined("form.Vcodigo") and len(trim(form.Vcodigo)) neq 0><cfoutput>#form.Vcodigo#</cfoutput></cfif>">
								<cfif isdefined ('form.Vcodigo') and len(trim(form.Vcodigo)) gt 0>
									<cfquery name="rsVid" datasource="#session.dsn#">
										select Vid from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> where Vcodigo='#form.Vcodigo#' and Ecodigo=#session.Ecodigo#
									</cfquery>
									<cfif rsVid.recordcount gt 0>
										<cfset LvarVid=rsVid.Vid>
									<cfelse>
										<cfset LvarVid=''>
									</cfif>
								</cfif>
							</tr>								
						</table>
					</form>
	
				<!--- Lista de Usuarios Autorizadores para RH y Compras del Centro Funcional --->
                <cf_dbdatabase table="FTCostoProyecto " datasource="ftec" returnvariable="FTCostoProyecto">
                <cf_dbdatabase table="FTCostoAdmin " datasource="ftec" returnvariable="FTCostoAdmin">
                <cf_dbdatabase table="FTVicerrectoria " datasource="ftec" returnvariable="FTVicerrectoria">
                
				<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet" >
					<cfinvokeargument name="tabla" value="#FTCostoProyecto# a,  #FTCostoAdmin# b"/>
					<cfinvokeargument name="columnas" value="a.CPid
                                                            , a.CPid as CPpk
                                                            , a.Vid
                                                            , a.CAid
                                                            , a.CAid as CApk
                                                            , a.CPporcentaje
                                                            , a.CPexoneracion
                                                            , a.CPfdesde
                                                            , a.CPfhasta
                                                            , a.CPdistribuido
                                                            , a.CPvalorcatalogo   
                                                            , a.Usucodigo 
                                                            , b.CAcodigo
                                                            , b.CAdescripcion
                                                            , b.CAobligatorio
                                                            , 3 as tab
                                                            , #LvarVid# as Vpk
                                                            , case when b.CAobligatorio = 1 then'X' else '' end as Obligatorio
                                                            , case when a.CPdistribuido = 1 then'X' else '' end as Distribuido "/>
					<cfinvokeargument name="desplegar" value="CAcodigo, CAdescripcion, Obligatorio, Distribuido"/>
					<cfinvokeargument name="etiquetas" value="Codigo,Descripcion,Obligatorio, Distribuido"/>
					<cfinvokeargument name="formatos" value="V, V, V, V"/>
					<cfinvokeargument name="align" value="left, left, center, center"/>
					<cfinvokeargument name="filtro" value="b.Ecodigo =#session.Ecodigo#
                    										and a.CAid = b.CAid
															and a.Vid = (select Vid from #FTVicerrectoria# where Vcodigo ='#form.Vcodigo#' and Ecodigo=#session.Ecodigo#)
							#filtro# 
							order by b.CAdescripcion"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="incluyeForm" value="true">
					<cfinvokeargument name="formName" value="formListCostos">
					<cfinvokeargument name="irA" value="Vicerrectorias.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="conexion" value="#session.dsn#"/>
					<cfinvokeargument name="key" value="Vpk,CPpk,CApk"/>
					<cfinvokeargument name="PageIndex" value="1">
				</cfinvoke>
			</td>
	
			<td width="60%" valign="top">
				<cfinclude template="ViceCostosForm.cfm">
			</td>
		
		</tr>
	</table>


	<script language="JavaScript1.2" type="text/javascript">
	function limpiar1(){
		document.getElementById('filtro').reset();
		document.getElementById('filtro').Identificacion_filtro.value = "";
		document.getElementById('filtro').Nombre_filtro.value   = "";	
	}
	</script>

<cf_web_portlet_end>
