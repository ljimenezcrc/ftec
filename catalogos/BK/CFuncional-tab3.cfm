
<cfif isdefined("form.fRHPcodigo_f")and len(trim(form.fRHPcodigo_f)) gt 0 >
 <cfset form.fRHPcodigo = form.fRHPcodigo_f >
</cfif>
<cfif isdefined("form.fRHPdescripcion_f")and len(trim(form.fRHPdescripcion_f)) gt 0 >
 <cfset form.fRHPdescripcion = form.fRHPdescripcion_f >
</cfif>

<cfif isdefined("url.fRHPcodigo")and len(trim(url.fRHPcodigo))>
	<cfset form.fRHPcodigo = url.fRHPcodigo>
</cfif>
<cfif isdefined("url.fRHPdescripcion")and len(trim(url.fRHPdescripcion))>
	<cfset form.fRHPdescripcion = url.fRHPdescripcion>
</cfif>

<table width="100%" border="0" cellpadding="1" cellspacing="0">
	
	<tr valign="top">
		<td colspan="2"  class="tituloListas">
		<div align="left" style="background-color:#E5E5E5; font-size:13px;">
			<cfif modo NEQ "ALTA">
				<cfoutput><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>: #trim(rsForm.CFcodigo)#-#rsForm.CFdescripcion#</cfoutput>
			</cfif>
		</div>
		</td>
	</tr>
	<tr>
		<td valign="top">
			 <cfinclude template="formPlazas.cfm">
		</td>
		<td valign="top">
			
			<form style="margin:0;" name="filtro" method="post" action="SQLCFuncional.cfm"><!--- Filtros de plazas --->
				<cfif isdefined("form.tab") and len(trim(form.tab))NEQ 0>
        		<input name="tab" type="hidden" value="<cfoutput>#form.tab#</cfoutput>" />
   				</cfif>
				<table width="100%" class="tituloListas">
					<tr> 
						<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
						<td><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
					</tr>
					<tr> 
						<td>
							<input type="text" name="fRHPcodigo" tabindex="6" 
							 value="<cfif isdefined("form.fRHPcodigo") 
										and len(trim(form.fRHPcodigo)) gt 0 >
										<cfoutput>#form.fRHPcodigo#</cfoutput></cfif>" 
							 size="5" maxlength="5" onFocus="javascript:this.select();" >
						</td>
						<td>
							<input type="text" name="fRHPdescripcion" tabindex="6" 
							 value="<cfif isdefined("form.fRHPdescripcion") 
										and len(trim(form.fRHPdescripcion)) gt 0 >
										<cfoutput>#form.fRHPdescripcion#</cfoutput></cfif>" 
							 size="25" maxlength="25" onFocus="javascript:this.select();" >
						</td>
						<td>
							<input type="submit" name="Filtrar" value="Filtrar" tabindex="6">
							<input type="button" name="Limpiar" value="Limpiar" tabindex="6" 
							 onClick="javascript:limpiar();"><input type="hidden" name="CFpk" 
							 value="<cfoutput>#Form.CFpk#</cfoutput>">
						</td>
					</tr>
				</table>
			</form>
			<!--- Cambia este modo para poner el mantenimiento de plazas --->
			<cfif isDefined("Form.RHPid") and Len(Trim(Form.RHPid)) GT 0 >
				<cfset Form.modoPlazas = "CAMBIO" >
			<cfelse>
				<cfset Form.modoPlazas = "ALTA" >
			</cfif>
			<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) gt 0>
				<cfset form.CFpk = url.CFpk>
			</cfif>				
			<!---====================== CARGAR LA NAVEGACION ===============================----->								  
			<cfset navegacion = "&tab=3">
			<cfif isdefined("form.CFpk") and len(trim(form.CFpk))>
				<cfset navegacion = navegacion & "&CFpk=#form.CFpk#">
			</cfif>
			<cfif isdefined("form.modo") and len(trim(form.modo))>
				<cfset navegacion = navegacion & "&modo=#form.modo#">
			</cfif>
			
			<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo))>
				<cfset navegacion = navegacion & "&fRHPcodigo=#form.fRHPcodigo#">
			</cfif>
			<cfif isdefined("form.fRHPdescripcion") and len(trim(form.fRHPdescripcion))>
				<cfset navegacion = navegacion & "&fRHPdescripcion=#form.fRHPdescripcion#">
			</cfif>
			<!---===========================================================================---->			
			<cfquery name="rsListaCFuncional" datasource="#Session.DSN#">
				Select 
					<cf_dbfunction name="to_char" args="CFid" datasource="#session.dsn#"> as CFpk,
					<cf_dbfunction name="to_char" args="RHPid" datasource="#session.dsn#"> as RHPid,
					RHPcodigo, RHPdescripcion, 'CAMBIO' as modoPlazas,
					3 as tab
					<cfif isdefined("form.fRHPcodigo")and len(trim(form.fRHPcodigo)) gt 0 >
					 ,<cfqueryparam cfsqltype="cf_sql_char" value="#form.fRHPcodigo#">as fRHPcodigo_f
					</cfif>
					<cfif isdefined("form.fRHPdescripcion")and len(trim(form.fRHPdescripcion)) gt 0 >
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fRHPdescripcion#"> as fRHPdescripcion_f
					</cfif>,
					case RHPactiva when 0 then
						'<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
					else
						'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
					end as RHPactiva
				from RHPlazas
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				<cfif isDefined("Form.CFpk") and Len(Trim(Form.CFpk)) GT 0 >
					and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
				</cfif>
				<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0 >
					and rtrim(RHPcodigo) like '%#rtrim(form.fRHPcodigo)#%'
				</cfif>
				<cfif isdefined("form.fRHPdescripcion") and len(trim(form.fRHPdescripcion)) gt 0 >
					and upper(rtrim(RHPdescripcion)) like '%#ucase(rtrim(form.fRHPdescripcion))#%'
				</cfif>
				order by RHPcodigo											
			</cfquery>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Codigo"
				Default="C&oacute;digo"
				returnvariable="LB_Codigo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripción"
				returnvariable="LB_Descripcion"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Activo"
				Default="Activo"
				returnvariable="LB_Activo"/>
			
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsListaCFuncional#"/>
				<cfinvokeargument name="desplegar" value="RHPcodigo, RHPdescripcion,RHPactiva"/>
				<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Activo#"/>
				<cfinvokeargument name="formatos" value="V, V,IMAG"/>
				<cfinvokeargument name="align" value="left, left,center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="CFuncional.cfm"/>
				<cfinvokeargument name="keys" value="CFpk,RHPid"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	</tr>
</table>