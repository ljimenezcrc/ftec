<cfset botones="Nuevo">
<cfset Action="/cfmx/ftec/catalogos/Vicerrectorias-lista.cfm">	

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ListaDeVicerrectorias"
		Default="Lista de Unidades Operativas y Proyectos"
		returnvariable="LB_ListaDeVicerrectorias"/>
	
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_ListaDeVicerrectorias#">
	  					
		<cfinclude template="/rh/portlets/pNavegacion.cfm">

		
		<cfif isdefined("url.Vcodigof") and len(trim(url.Vcodigof))NEQ 0>
			<cfset form.Vcodigof=url.Vcodigof> 
		</cfif>
					
		<cfif isdefined("url.Vdescripcionf") and len(trim(url.Vdescripcionf))NEQ 0>
			<cfset form.Vdescripcionf=url.Vdescripcionf> 
		</cfif>
					
<!---		<cfif isdefined("url.Ocodigof") and len(trim(url.Ocodigof))NEQ 0>
			<cfset form.Ocodigof=url.Ocodigof> 
		</cfif>
		<cfif isdefined("url.Dcodigof") and len(trim(url.Dcodigof))NEQ 0>
			<cfset form.Dcodigof=url.Dcodigof> 
		</cfif>
--->					
		<cfset navegacion = "">
					
		<cfif isdefined("form.Vcodigof") and len(trim(form.Vcodigof))NEQ 0>
			<cfset navegacion = navegacion  &  "Vcodigof="&form.Vcodigof>			
		</cfif>
					
		<cfif isdefined("form.Vdescripcionf") and len(trim(form.Vdescripcionf))NEQ 0>
			<cfif len(trim(navegacion)) NEQ 0>	
					<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Vdescripcionf="&form.Vdescripcionf>
				<cfelse> 	
					<cfset navegacion = navegacion & "Vdescripcionf="&form.Vdescripcionf>
			</cfif> 
		</cfif>
					
		<!---<cfif isdefined("form.Ocodigof") and len(trim(form.Ocodigof))NEQ 0>
			<cfif len(trim(navegacion)) NEQ 0>	
					<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Ocodigof="&form.Ocodigof>
				<cfelse> 	
					<cfset navegacion = navegacion & "Ocodigof="&form.Ocodigof>
			</cfif> 
		</cfif>--->
					
		<!---<cfif isdefined("form.Dcodigof") and len(trim(form.Dcodigof))NEQ 0>
			<cfif len(trim(navegacion)) NEQ 0>	
					<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Dcodigof="&form.Dcodigof>
				<cfelse> 	
					<cfset navegacion = navegacion & "Dcodigof="&form.Dcodigof>
			</cfif>
		</cfif>--->
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
	  					
					<table width="100%">
						<tr>
							<td class="tituloListas">
								<form name="form1" method="post" action="<cfoutput>#Action#</cfoutput>">
									<table width="100%">
										<tr>
											<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">Código</cf_translate></td>
											<td><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripción</cf_translate></td>
											<!---<td><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
											<td><cf_translate key="LB_Departamento" XmlFile="/rh/generales.xml">Departamento</cf_translate></td>
											--->
                                            <td></td>
                                            <td></td>
                                            <td></td>
										</tr>
										<tr>
											<td>
												<input name="Vcodigof" type="text" size="8" maxlength="10" tabindex="1"
													value="<cfif isdefined("form.Vcodigof") and len(trim(form.Vcodigof))NEQ 0><cfoutput>#form.Vcodigof#</cfoutput></cfif>"/>
											</td>
											<td>
												<input name="Vdescripcionf" type="text"  size="30" maxlength="60" tabindex="1"
													value="<cfif isdefined("form.Vdescripcionf") and len(trim(form.Vdescripcionf))NEQ 0><cfoutput>#form.Vdescripcionf#</cfoutput></cfif>"/>
											</td>
											<!---<td>
												<cfquery name="rsOficinas" datasource="#session.DSN#">
												select Ocodigo, Oficodigo, Odescripcion  as  Odescripcion
												from Oficinas where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
												</cfquery>
												<select name="Ocodigof" tabindex="1">
													<option value=""></option>
													<cfloop query="rsOficinas">
														<option value="<cfoutput>#rsOficinas.Ocodigo#</cfoutput>" <cfif isdefined("form.Ocodigof") and form.Ocodigof EQ rsOficinas.Ocodigo> selected </cfif>><cfoutput>#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</cfoutput></option>
													</cfloop>
												</select>								</td>
											<td>
												<cfquery name="rsDeptos" datasource="#session.DSN#">
												select Dcodigo, Deptocodigo, Ddescripcion 
												from Departamentos where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
												</cfquery>
												<select name="Dcodigof" tabindex="1">
													<option value=""></option>
													<cfloop query="rsDeptos">
														<option value="<cfoutput>#rsDeptos.Dcodigo#</cfoutput>" <cfif isdefined("form.Dcodigof") and form.Dcodigof EQ rsDeptos.Dcodigo> selected </cfif>><cfoutput>#rsDeptos.Deptocodigo# - #rsDeptos.Ddescripcion#</cfoutput></option>
													</cfloop>
												</select>								
											</td>--->
											<td>
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="BTN_Filtro"
													Default="Filtro"
													returnvariable="BTN_Filtro"/>
	
												<input name="BTNfiltro" type="submit" value="<cfoutput>#BTN_Filtro#</cfoutput>" tabindex="1">
											</td>
										</tr>
									</table>
								</form>
							</td>
						</tr>
								
						<tr>
							<td>
                            	<cfquery name="rsCentros" datasource="#session.DSN#" >
                                	Select  
                                          a.Vid as Vpk
                                        , a.Vcodigo
                                        , a.Vdescripcion
                                        , a.Vpadre
                                        , a.Vctaingreso
                                        , a.Vctagasto
                                        , a.Vctasaldoinicial
                                        , a.Vesproyecto
                                        , a.Ecodigo
                                        , a.Vfinicio
                                        , a.Vffinal
                                        , a.Vestado
                                        , a.Mcodigo
                                        , a.Vmonto
                                        , a.Usucodigo
                                	from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> a
                                    where  a.Ecodigo =  #session.Ecodigo# 
										<cfif isdefined("form.Vcodigof") and len(trim(form.Vcodigof))NEQ 0>
                                            and ltrim(rtrim(upper(a.Vcodigo))) like '%#trim(ucase(form.Vcodigof))#%'
                                        </cfif>
                                                    
                                        <cfif isdefined("form.Vdescripcionf") and len(trim(form.Vdescripcionf))NEQ 0>
                                            and ltrim(rtrim(upper(a.Vdescripcion))) like '%#trim(ucase(form.Vdescripcionf))#%'
                                        </cfif>
                                	order by a.Vcodigo 
                                </cfquery>
                                
                                <cfinvoke Component= "rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaEmpl">
									<cfinvokeargument name="query" value="#rsCentros#"/>
									<cfinvokeargument name="desplegar" value="Vcodigo,Vdescripcion"/>
									<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
									<cfinvokeargument name="formatos" value="V,V"/>
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="irA" value="/cfmx/ftec/catalogos/Vicerrectorias.cfm"/>
									<cfinvokeargument name="keys" value="Vpk"/>
									<cfinvokeargument name="botones" value="#botones#"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
									<cfinvokeargument name="maxrows" value="25"/> 	
								</cfinvoke>
							</td>
						</tr>
					</table>
				</td>	
			</tr>
		</table>	
<cf_web_portlet_end>
<cf_templatefooter>
<!---<script language="JavaScript" type="text/JavaScript">
	function funcImportar(){
		location.href="/cfmx/sif/ad/catalogos/CFuncional.cfm?importa=true";
		return false;
	}
</script>--->