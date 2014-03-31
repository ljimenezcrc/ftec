<!---  <cfinclude template="/rh/Utiles/params.cfm">--->
  <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!---  <cfset Session.Params.ModoDespliegue = 1>
  <cfset Session.cache_empresarial = 0>--->
  
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>

	<cfif isdefined("url.Vcodigof") and len(trim(url.Vcodigof))NEQ 0>
		<cfset form.Vcodigof = url.Vcodigof> 
	</cfif>
				
	<cfif isdefined("url.Vdescripcionf") and len(trim(url.Vdescripcionf))NEQ 0>
		<cfset form.Vdescripcionf=url.Vdescripcionf> 
	</cfif>
	
	<cfif isdefined("url.proyectos") and len(trim(url.proyectos))NEQ 0 and url.proyectos neq 0>
		<cfset form.proyectos=url.proyectos> 
	</cfif>
    
    <cfif isdefined("url.usuario") and len(trim(url.usuario))NEQ 0 and url.usuario neq 0>
		<cfset form.usuario=url.usuario> 
	</cfif>

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
	
	<cfif isdefined("form.excluir") and len(trim(form.excluir))NEQ 0 and form.excluir neq -1>
		<cfif len(trim(navegacion)) NEQ 0>	
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "excluir="&form.excluir>
			<cfelse> 	
				<cfset navegacion = navegacion & "excluir="&form.excluir>
		</cfif>
	</cfif>

	
<script type="text/javascript" language="javascript">
	<!--- Recibe conexion, form, name y desc --->
	function Asignar(id,name,desc) { 
		if (window.opener != null) {
			<cfoutput>
			var descAnt = window.opener.document.#Url.form#.#Url.desc#.value;
			window.opener.document.#Url.form#.#Url.id#.value   = id;
			window.opener.document.#Url.form#.#Url.name#.value = name;
			window.opener.document.#Url.form#.#Url.desc#.value = desc;
			if (window.opener.func#trim(Url.name)#) {window.opener.func#trim(Url.name)#();}
			window.opener.document.#Url.form#.#Url.name#.focus();
			</cfoutput>
			window.close();
		}
	}
	
	
	
</script>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
				
			<table width="100%">
				<tr>
					<td class="tituloListas">
						<form name="form1" method="post">
							<table width="100%">
								<tr>
									<td>Código</td>
									<td>Descripción</td>
									<td>Estado</td>
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
									
									<td>
										<select name="Activof" tabindex="1">
											<option value="1">Activo</option>
											<option value="0">Inactivo</option>
											
										</select>								
									</td>
									<td>

										<input name="BTNfiltro" type="submit" value="Filtro" tabindex="1">
									</td>
								</tr>
							</table>
						</form>
					</td>
				</tr>
						
				<tr>
					<td>
						<cf_dbfunction name='OP_concat' returnvariable='concat'>
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
                                	from FTVicerrectoria a
                                    inner join FTAutorizador b
                                    	on a.Vid = b.Vid
                                    where  a.Ecodigo =  #session.Ecodigo# 
										<cfif isdefined("form.Vcodigof") and len(trim(form.Vcodigof))NEQ 0>
                                            and ltrim(rtrim(upper(a.Vcodigo))) like '%#trim(ucase(form.Vcodigof))#%'
                                        </cfif>
                                                    
                                        <cfif isdefined("form.Vdescripcionf") and len(trim(form.Vdescripcionf))NEQ 0>
                                            and ltrim(rtrim(upper(a.Vdescripcion))) like '%#trim(ucase(form.Vdescripcionf))#%'
                                        </cfif>
                                        <cfif isdefined("form.proyectos") and len(trim(form.proyectos))NEQ 0>
                                            and coalesce(a.Vesproyecto,0) =  1
                                        </cfif>
                                        <cfif isdefined("form.usuario") and len(trim(form.usuario))NEQ 0>
                                            and coalesce(b.Usucodigo,0) =  #session.Usucodigo#
                                        </cfif>
                                        
                                	order by a.Vcodigo 
									<!---, order by a.CFpath, a.Vcodigo, a.CFnivel--->
                                    
                                </cfquery>
                       
						<cfinvoke
						Component= "rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsCentros#"/>
							<cfinvokeargument name="desplegar" value="Vcodigo,Vdescripcion,Vestado"/>
							<cfinvokeargument name="etiquetas" value="Codigo,Descripcion,Estado"/>
							<cfinvokeargument name="formatos" value="V,V,IMG"/>
							<cfinvokeargument name="incluyeform" value="true"/>
							<cfinvokeargument name="formname" value="form2"/>
							<cfinvokeargument name="align" value="left,left,Center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="funcion" value="Asignar"/>
							<cfinvokeargument name="fparams" value="Vpk,Vcodigo,Vdescripcion"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="IrA" value="ConlisVicerrectoria.cfm"/>
							<cfinvokeargument name="maxrows" value="15"/>
						</cfinvoke>
					</td>
				</tr>
			</table>
		</td>	
	</tr>
</table>	
