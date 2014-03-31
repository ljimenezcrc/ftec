<!--- Consultas --->
<!-- Establecimiento del modo -->
<cfif isdefined("url.usucodigo") and len(trim(url.usucodigo))>
	<cfset form.usucodigo = url.usucodigo>
</cfif>
<cfif isdefined("form.usucodigo")>
	<cfset modo="CAMBIO_A">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA_A">
	<cfelseif form.modo EQ "CAMBIO_A">
		<cfset modo="CAMBIO_A">
	<cfelse>
		<cfset modo="ALTA_A">
	</cfif>
</cfif>

<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cfif modo neq 'ALTA_A'>
	<!--- Form --->
	<cfquery name="rsFormAut" datasource="#session.DSN#">
		select ta.Aid 
        	, ta.TAid
        	, ta.Vid
			, ta.Usucodigo
			, dp.Pid
			, dp.Pnombre #_Cat# ' ' #_Cat# dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2  as Nombre
            
            , ta.Afdesde
            , ta.Afhasta
            , ta.Ainactivo
            , ta.TAresponsable
            , z.TAcodigo #_Cat# ' - ' #_Cat# z.TAdescripcion as TipoAutorizador
		from FTAutorizador ta
			inner join Usuario u
				on u.Usucodigo=ta.Usucodigo
					and u.Uestado = 1 
					and u.Utemporal = 0
					and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			inner join DatosPersonales dp
				on dp.datos_personales =u.datos_personales
            inner join FTTipoAutorizador z
            	on ta.TAid = z.TAid
		where ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Vid = (select Vid from FTVicerrectoria where Vcodigo ='#form.Vcodigo#' and Ecodigo=#session.Ecodigo#)
			and ta.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	</cfquery>
</cfif>

<cfquery name="rsTiposAut" datasource="#session.DSN#">
    select 
    TAid	
    ,TAcodigo	
    ,TAdescripcion	
    ,TAmontomin	
    ,TAmontomax	
    ,Ecodigo	
    ,Usucodigo	   
    from FTTipoAutorizador
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    order by TAdescripcion 
</cfquery>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js"></script>

<form name="formAut" method="post" action="VicerrectoriasSQL.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
    	<td align="right" nowrap="nowrap">&nbsp;<strong><cf_translate key="LB_TiposAut">Tipo Autorizador</cf_translate>:</strong>&nbsp;</td>
      	<td>
            <select name="TAid"  > 
                <option  title="" value="">-- Seleccione un Tipo--</option>
                <cfloop query="rsTiposAut">
                    <option  title="#rsTiposAut.TAid#" value="#rsTiposAut.TAid#" <cfif modo neq "ALTA" and isdefined('rsFormAut') and rsFormAut.TAid eq rsTiposAut.TAid>selected<cfelseif modo eq 'ALTA' >selected</cfif>>#rsTiposAut.TAdescripcion#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    
    <tr> 
      <td align="right" nowrap="nowrap">&nbsp;<strong><cf_translate XmlFile="/rh/generales.xml" key="LB_USUARIO">Usuario</cf_translate>:</strong>&nbsp;</td>
      <td>
		<cfset arrValuesCambio = ArrayNew(1)>
		<cfif modo NEQ 'ALTA_A'>
			<cfif len(trim(rsFormAut.Vid))>
				<cfset ArrayAppend(arrValuesCambio, rsFormAut.Usucodigo)>
				<cfset ArrayAppend(arrValuesCambio, rsFormAut.Pid)>
				<cfset ArrayAppend(arrValuesCambio, rsFormAut.Nombre)>							
			</cfif>
			&nbsp;&nbsp;&nbsp;
			<input type="text"  class="cajasinbordeb" name="Pid" size="10" maxlength="10" value="#rsFormAut.Pid#">
			<input type="text"  class="cajasinbordeb" name="Pnombre" size="30" maxlength="60" value="#rsFormAut.Nombre#">
			<input type="hidden" name="Usucodigo" value="#rsFormAut.Usucodigo#">
            <input type="hidden" name="Aid" value="#rsFormAut.Aid#">
		<cfelse>
			<!--- Lista de Usuarios Autorizados --->
			<cfquery name="rsUsuariosAutorizados" datasource="#Session.DSN#">
				select distinct Usucodigo from FTAutorizador 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Vid = (select Vid from FTVicerrectoria where Vcodigo ='#form.Vcodigo#' and Ecodigo=#session.Ecodigo#)
			</cfquery>
	
			<cfset filtroExtra = "">
			<cfif isdefined('rsUsuariosAutorizados') and rsUsuariosAutorizados.recordCount GT 0>
				<cfset filtroExtra = " and a.Usucodigo not in (#ValueList(rsUsuariosAutorizados.Usucodigo, ',')#)">		
			</cfif>
	
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_TITULOCONLIS"
			Default="Lista de Usuarios"
			returnvariable="LB_TITULOCONLIS"/>	

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_IDENTIFICACION"
			Default="Identificaci&oacute;n"
			returnvariable="LB_IDENTIFICACION"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_NOMBRE"
			Default="Nombre"
			returnvariable="LB_NOMBRE"/>	
            
		<cfset select = " distinct a.Usucodigo, Usulogin, 
                      b.Pnombre,
                      b.Pid, 
                      b.Papellido1,
                      b.Papellido2,
                      {fn concat({fn concat({fn concat({fn concat(
                      b.Pnombre , ' ' )}, b.Papellido1 )},  ' '  )},  b.Papellido2 )} as Nombre " >
                      
        <cfset from = "  Usuario a
                    inner join DatosPersonales b
                    on a.datos_personales = b.datos_personales 
                     #filtro#
                    inner join vUsuarioProcesos c
                    on a.Usucodigo = c.Usucodigo 
                       and c.Ecodigo = #session.EcodigoSDC# " >
        <cfset where = "  a.CEcodigo = #session.CEcodigo#
                 and a.Uestado = 1 
                 and a.Utemporal = 0 " >

            <cf_conlis 
				campos="Usucodigo,Pid,Nombre"
				size="0,10,40"
				conexion="asp"
				desplegables="N,S,S"
				modificables="N,N,N"
				valuesArray="#arrValuesCambio#"
				title="#LB_TITULOCONLIS#"
				tabla="#from#"
				columnas="#select#" 
                filtro = "#where# #filtroExtra#"
				filtrar_por="Pid|Usulogin|{fn concat({fn concat({fn concat({fn concat(b.Papellido1 , ' ' )}, b.Papellido2 )},  ' ' )}, b.Pnombre)}"
				filtrar_por_delimiters="|"
				desplegar="Pid,Usulogin,Nombre"
				etiquetas="#LB_IDENTIFICACION#,Login,#LB_NOMBRE#"
				formatos="S,S,S"
				align="left,left,left"
				asignar="Usucodigo,Pid,Nombre"
				asignarFormatos="S,S,S"
				form="formAut"
				showEmptyListMsg="true"
				EmptyListMsg=" --- No se encotraron usuarios --- "/>		
            
            
            
            		
	
<!---			<cf_conlis 
				campos="Usucodigo,Pid,Nombre"
				size="0,10,40"
				conexion="asp"
				desplegables="N,S,S"
				modificables="N,N,N"
				valuesArray="#arrValuesCambio#"
				title="#LB_TITULOCONLIS#"
				tabla="Usuario a, DatosPersonales b"
				columnas="distinct a.Usucodigo, a.Usulogin, a.CEcodigo, b.Pid, {fn concat({fn concat({fn concat({fn concat(b.Pnombre , ' ' )}, b.Papellido1 )}, ' ' )}, b.Papellido2 )} as Nombre,(case when a.Uestado = 0 then 'Inactivo' when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' else '' end) as Estado"
				filtro=" a.datos_personales = b.datos_personales 
					  and a.CEcodigo = #session.CEcodigo#
					  and a.Uestado = 1 
					  and a.Utemporal = 0
						and exists ( select c.Usucodigo
											 from vUsuarioProcesos c
											 where c.Ecodigo = #session.EcodigoSDC#
											   and c.Usucodigo = a.Usucodigo
											   and c.SScodigo='RH'  ) 
					  #filtroExtra#"
				filtrar_por="Pid|Usulogin|{fn concat({fn concat({fn concat({fn concat(b.Papellido1 , ' ' )}, b.Papellido2 )},  ' ' )}, b.Pnombre)}"
				filtrar_por_delimiters="|"
				desplegar="Pid,Usulogin,Nombre"
				etiquetas="#LB_IDENTIFICACION#,Login,#LB_NOMBRE#"
				formatos="S,S,S"
				align="left,left,left"
				asignar="Usucodigo,Pid,Nombre"
				asignarFormatos="S,S,S"
				form="formAut"
				showEmptyListMsg="true"
				EmptyListMsg=" --- No se encotraron usuarios --- "/>	--->		
		</cfif>	  
	  </td>
    </tr>
  
    
    <tr>
        <td align="right" width="25%" valign="top"><cf_translate  key="LB_desde">Desde:</cf_translate></td>
        <td>
            <cfif modo neq 'ALTA_A'>
                <cf_sifcalendario form ="formAut" name="Afdesde" value="#LSDateFormat(rsFormAut.Afdesde,'dd/mm/yyyy')#">
            <cfelse>
                <cf_sifcalendario   form ="formAut" name="Afdesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
            </cfif>
        </td>
        
                                   
     </tr>
     <tr>
        <td align="right" width="25%" valign="top"><cf_translate  key="LB_hasta">Hasta:</cf_translate></td>
        <td>
            <cfif modo neq 'ALTA_A'>
               <cf_sifcalendario form ="formAut" name="Afhasta" value="#LSDateFormat(rsFormAut.Afhasta,'dd/mm/yyyy')#">
            <cfelse>
                <cf_sifcalendario form ="formAut" name="Afhasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
            </cfif>
        </td>
     </tr>
    
    
    <tr>
		<td align="right">
			<input name="TAresponsable"  id="TAresponsable" type="checkbox" tabindex="1" 	value="1" 
				<cfif modo neq 'ALTA_A' and isdefined("rsFormAut") and rsFormAut.TAresponsable eq 1 >checked="checked"</cfif> >
		</td>
		<td>
			&nbsp;&nbsp;&nbsp;
			<label for="chkResponsable"><cf_translate key="CHK_ResponsableDelCentroFuncional">Responsable de Unidad Operativa</cf_translate></label>
		</td>
    </tr>
    
    <tr>
		<td align="right">
			<input name="Ainactivo"  id="Ainactivo" type="checkbox" tabindex="1" 	value="1" 
				<cfif modo neq 'ALTA_A' and isdefined("rsFormAut") and rsFormAut.Ainactivo eq 1 >checked="checked"</cfif> >
		</td>
		<td>
			&nbsp;&nbsp;&nbsp;
			<label for="chkAinactivo"><cf_translate key="CHK_inactivo">Inactivo</cf_translate></label>
		</td>
    </tr>
    <!---<tr>
		<td align="right">
			<input name="chkAIA"  id="chkAIA" type="checkbox" tabindex="1" 	value="1" 
				<cfif modo neq 'ALTA_A' and isdefined("rsFormAut") and len(trim(rsFormAut.UAIA)) gt 0>checked="checked"</cfif> >
		</td>
		<td>
			&nbsp;&nbsp;&nbsp;
			<label for="chkResponsable"><cf_translate key="CHK_AprobacionIA">Aprobaci&oacute;n Incidencia Autom&aacute;tica</cf_translate></label>
		</td>
    </tr>--->
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
	<cfif isdefined ('form.Vcodigo') and len(trim(form.Vcodigo)) gt 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select Vid from FTVicerrectoria where Vcodigo='#form.Vcodigo#' and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsCFid.recordcount gt 0>
			<input type="hidden" name="Vid" value="#rsCFid.Vid#" />
			<cfset LvarVid=#rsCFid.Vid#>
		</cfif>
	</cfif>
	
		<cfif modo neq "ALTA_A">
			<cf_botones modo="CAMBIO" sufijo="Aut">
		<cfelse>
			<cf_botones modo="ALTA" sufijo="Aut">
		</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<input type="hidden" name="modo" value="CAMBIO_A" />

<!---	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA_A'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>--->
  </table>  
  </cfoutput>
 </form>



<!---<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>--->


<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR8"
	Default="Usuario"
	returnvariable="LB_MESAJEERROR8"/>

	<!---	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formAut");
	objForm.Pid.required = true;
	objForm.Pid.description="<cfoutput>#LB_MESAJEERROR8#</cfoutput>";	

	function deshabilitarValidacion(){
		objForm.Pid.required = false;
	}
	function habilitarValidacion(){
		objForm.Pid.required = true;
	}	--->
	function limpiar() {
		objForm.reset();
	}
	
	function funcRegresarDet(id){
		document.location.href = 'Vicerrectorias.cfm?Vcodigo1=' & id;

}

</script> 



























