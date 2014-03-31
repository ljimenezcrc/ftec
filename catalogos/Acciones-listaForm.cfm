<!---
	Cuando el modulo es utilizado por el Administrator (Cuando Session.Params.ModoDespliegue EQ 1)
	Este modulo es incluido desde dos pantallas: desde el expediente del empleado y como pantalla independiente para registro de acciones de personal
	Para saber desde donde se esta llamando se pregunta por una variable que se llama tabChoice la cual únicamente esta presenta cuando se incluye el modulo desde esas pantallas
	Cuando se esta trabajando desde el expediente hay que asegurarse de reenviar los parametros de o, sel y DEid los cuales son necesarios para esa pantalla
--->

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Empleado" default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Tipo_de_accion" default="Tipo de Acci&oacute;n"	 returnvariable="LB_Tipo_de_accion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha_Rige" default="Fecha Rige"	 returnvariable="LB_Fecha_Rige" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha_Vence" default="Fecha Vence" returnvariable="LB_Fecha_Vence" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_VPC" default="VPC"	 returnvariable="LB_VPC" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Vacaciones" default="Vacaciones"	 returnvariable="LB_Vacaciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Aplicar" default="Aplicar"	 returnvariable="BTN_Aplicar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Nuevo" default="Nuevo" returnvariable="BTN_Nuevo"component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>	
<cfinvoke key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" default="Debe seleccionar al menos un registro para relizar esta acción."	 returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/><!--- FIN VARIABLES DE TRADUCCION --->
<!--- Usuarios que han insertado acciones --->
<cfquery name="rsUsuariosRegistro" datasource="#Session.DSN#">
	select distinct Usucodigo
	from RHAcciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsUsuarios" datasource="asp">
	select u.Usucodigo as Codigo,
		   { fn concat(d.Pnombre, { fn concat(' ', { fn concat(d.Papellido1, {fn concat(' ', d.Papellido2)})})})} as Nombre
	from Usuario u, DatosPersonales d
	<cfif rsUsuariosRegistro.recordCount GT 0>
	where u.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="#ValueList(rsUsuariosRegistro.Usucodigo, ',')#">)
	<cfelse>
	where u.Usucodigo = 0
	</cfif>
	and u.datos_personales = d.datos_personales
</cfquery> 

<cfset navegacion = ''>
<!---Carga valores del form----->
<cfif isdefined("url.DEidentificacion") and not isdefined("form.DEidentificacion") >
	<cfset form.DEidentificacion = url.DEidentificacion >
</cfif>
<cfif isdefined("url.Usuario") and not isdefined("form.Usuario") >
	<cfset form.Usuario = url.Usuario >
</cfif>
<cfif isdefined("url.DLfvigencia") and not isdefined("form.DLfvigencia") >
	<cfset form.DLfvigencia = url.DLfvigencia >
</cfif>
<cfif isdefined("url.DLffin") and not isdefined("form.DLffin") >
	<cfset form.DLffin = url.DLffin >
</cfif>
<!---Carga de valores de navegacion----->			
<cfif isdefined("Form.Usuario") and len(trim(form.Usuario)) >
	<cfset navegacion = navegacion & "&Usuario=#form.Usuario#">
</cfif>	
<cfif isdefined("Form.DLfvigencia") and len(trim(form.DLfvigencia)) >
	<cfset navegacion = navegacion & "&DLfvigencia=#form.DLfvigencia#">
</cfif>
<cfif isdefined("Form.DLffin") and len(trim(form.DLffin)) >
	<cfset navegacion = navegacion & "&DLffin=#form.DLffin#">
</cfif>		



<cfif not isdefined("tabChoice")>
<form name="filtroAcciones" method="post" action="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	<cfoutput>
	<tr>
  		<td class="fileLabel"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
        <td class="fileLabel"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
  	</tr>
	<tr>
   		<td><input name="DEidentificacion" type="text" value="<cfif isdefined('form.DEidentificacion')>#form.DEidentificacion#</cfif>" /></td>
    	<td colspan="3"><input name="DEnombre" type="text" size="40" value="<cfif isdefined('form.DEnombre')>#form.DEnombre#</cfif>"/></td>
    </tr>
    </cfoutput>
  <tr> 
    <td class="fileLabel"><cf_translate key="LB_FechaRige">Fecha Rige</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_FechaVence">Fecha Vence</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_Usuario">Usuario</cf_translate></td>
    <td class="fileLabel">&nbsp;</td>
  </tr>
  <tr>
    <td>
		<cfif isdefined("Form.DLfvigencia")>
            <cfset fecha = Form.DLfvigencia>
            <cfelse>
            <cfset fecha = "">
        </cfif>
		<cf_sifcalendario form="filtroAcciones" value="#fecha#" name="DLfvigencia">	
	</td>
    <td>
		<cfif isdefined("Form.DLffin")>
            <cfset fecha = Form.DLffin>
            <cfelse>
            <cfset fecha = "">
        </cfif>
		<cf_sifcalendario form="filtroAcciones" value="#fecha#" name="DLffin">	
	</td>
    <td>
	  <select name="Usuario">
		  <option value="-1">(<cf_translate key="CMB_Todos">Todos</cf_translate>)</option>
		<cfoutput query="rsUsuarios">
		  <option value="#rsUsuarios.Codigo#" <cfif isdefined("Form.Usuario") and Form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
		</cfoutput>
	  </select>
	</td>
      <td align="center">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="BTN_Filtrar"
			default="Filtrar"
			xmlfile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>			  
		<input name="btnBuscar" type="submit" id="btnBuscar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
      </td>
  </tr>
  <tr>
		<td colspan="4">
			<input type="checkbox" name="chkTodos" value="" onclick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
			<label style="font-style:normal; font-variant:normal; font-weight:normal"><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
		</td>
	</tr>
</table>
</form>
</cfif>

<script language="JavaScript" type="text/javascript">
	function funcAplicar() {
		<cfoutput>
			<cfif isdefined("form.sel") and len(trim(form.sel))>
				document.listaAcciones.SEL.value = '#form.sel#';				
			</cfif>
			<cfif isdefined("form.o") and len(trim(form.o))>
				document.listaAcciones.O.value = '#form.o#';				
			</cfif>
		</cfoutput>
		if (document.listaAcciones.chk) {
			if (document.listaAcciones.chk.value) {
				return (document.listaAcciones.chk.checked);
				
			} else {
				for (var i=0; i<document.listaAcciones.chk.length; i++) {
					if (document.listaAcciones.chk[i].checked) return true;
				}
			}
		}
		return false;
	}

	// Invoca ventana para agregar componentes salariales
	function doConlisVacaciones(acc) {
		var width = 700;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('ConlisVacaciones.cfm?RHAlinea='+acc,<cfoutput>#LB_Vacaciones#</cfoutput>,'menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
	
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
		<cfset additionalCols = "">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="TIT_ModificarVacaciones"
			default="Modificar Vacaciones"
			returnvariable="TIT_ModificarVacaciones"/>
		<cfquery name="rsListaAcciones" datasource="#Session.DSN#">
			select #PreserveSingleQuotes(additionalCols)# a.RHAlinea, 
					{ fn concat('<b>', { fn concat(c.DEidentificacion, { fn concat('</b> ', { fn concat(c.DEapellido1, { fn  concat(' ', { fn concat(c.DEapellido2, { fn concat(' ',c.DEnombre)} )} )} )} )} )} )} as NombreEmp,
				   { fn concat('<b>', { fn concat(rtrim(b.RHTcodigo), { fn concat('</b> - ', b.RHTdesc)} )} )} as TipoAccion,
				   DLfvigencia as FechaRige,
				   DLffin as FechaVence,
				   case when b.RHTcomportam = 2 and 
						(select count(1)
						from DVacacionesEmpleado
						where DEid = a.DEid
						and DVEfecha >= a.DLfvigencia) > 0 then 
						{fn concat('<input type=''image'' onClick=''javascript: doConlisVacaciones(#chr(34)#',{fn concat(<cf_dbfunction name="to_char" args="a.RHAlinea">,'#chr(34)#); return false;'' src=''/cfmx/rh/imagenes/Excl16.gif'' title=''#TIT_ModificarVacaciones#''>')})}
						else '&nbsp;'
				   end as verifAplicar,
				   a.RHAporc as LTPorcPlaza
				   <cfif isdefined("form.Jefe")><!--- SI ESTOY EN AUTOGESTION - TRAMITES PARA SUBORDINADOS --->
					   ,#form.CentroF# as CentroF
				   	   ,'#form.Jefe#' as Jefe
				   	   ,a.DEid as DEidSub
				   </cfif>
			from RHAcciones a, RHTipoAccion b, DatosEmpleado c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.RHAid is null
			and a.RHTid = b.RHTid 
			and a.DEid = c.DEid
			and a.RHAidtramite is null
			and a.Usucodigo > 0
			<cfif isdefined("form.Jefe")><!--- SI ESTOY EN AUTOGESTION - TRAMITES PARA SUBORDINADOS --->
				and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and a.DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Jefe#"> 
			<cfelse>
				<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0>
					<cfif Form.Usuario NEQ "-1">
						and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usuario#">
					</cfif>
				<cfelse>
<!---					and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> LZ 2011-0218 Se Elimina esta condicion para que desde Mant de Empleados se vean todas las Acciones, segun se reviso no afecta autogestion--->
				</cfif>
			</cfif>
			<cfif isdefined("Form.DLfvigencia") and Len(Trim(Form.DLfvigencia)) NEQ 0>
				and a.DLfvigencia = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLfvigencia)#">
			</cfif>
			<cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
				and a.DLffin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLffin)#">
			</cfif>
			<cfif not isdefined('form.Jefe') and isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfif>
			<cfif Session.Params.ModoDespliegue EQ 0>
				and b.RHTautogestion = 1
			</cfif>
			<cfif isdefined('form.DEidentificacion') and LEN(TRIM(form.DEidentificacion))>
				and upper(c.DEidentificacion) like upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.DEidentificacion)#%">)
			</cfif>
            <cfif isdefined('form.DEnombre') and LEN(TRIM(form.DEnombre))>
				and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }) like upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.DEnombre)#%">)
			</cfif>
			order by c.DEidentificacion, DLfvigencia, DLffin		
		</cfquery>
		<form style="margin:0" name="listaAcciones" method="post" action="/cfmx/rh/nomina/operacion/Acciones-listaSql.cfm">
            <cfoutput>
				<cfif isdefined("form.sel") and len(trim(form.sel))>
                    <input type="hidden" name="sel"   	    id="sel"      value="#form.sel#">
                </cfif>
                <cfif isdefined("form.o") and len(trim(form.o))>
                    <input type="hidden" name="o"   	    id="o"      value="#form.o#">
                </cfif>               
			    <cfif isdefined("form.DEid") and len(trim(form.DEid))>
                    <input type="hidden" name="DEid"   	    id="DEid"      value="#form.DEid#">
                </cfif>
                <cfif isdefined("form.CentroF") and len(trim(form.CentroF))>
                    <input type="hidden" name="CentroF"   	    id="CentroF"      value="#form.CentroF#">
                </cfif>
                <cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0>
                    <input type="hidden" name="Usuario"   	    id="Usuario"      value="#form.Usuario#">
                </cfif>
            </cfoutput>
            
            <cfinvoke 
             component="rh.Componentes.pListas"
             method="pListaQuery"
             returnvariable="pListaRet">
                <cfinvokeargument name="query" value="#rsListaAcciones#"/>
                <cfinvokeargument name="desplegar" value="NombreEmp, TipoAccion, FechaRige, FechaVence, verifAplicar"/>
                <cfinvokeargument name="etiquetas" value="#LB_Empleado#,#LB_Tipo_de_accion#,#LB_Fecha_Rige#,#LB_Fecha_Vence#,#LB_VPC#"/>
                <cfinvokeargument name="formatos" value="V,V,D,D,IMG"/>
                <cfinvokeargument name="align" value="left, left, center, center, center"/>
                <cfinvokeargument name="ajustar" value="N"/>
                <cfinvokeargument name="checkboxes" value="S"/>
                <cfif not isdefined("tabChoice")>
                    <cfinvokeargument name="botones" value="Aplicar,Eliminar,Nuevo,Importar"/>
                <cfelse>
                    <cfinvokeargument name="botones" value="Aplicar,Eliminar"/>
                </cfif>
                <cfif isdefined('form.Jefe')>
                    <cfinvokeargument name="irA" value="/cfmx/rh/nomina/operacion/Acciones-listaSql.cfm?Jefe=#form.Jefe#&CentroF=#form.CentroF#"/>
                <cfelse>
                    <cfinvokeargument name="irA" value="/cfmx/rh/nomina/operacion/Acciones-listaSql.cfm"/>
                </cfif>
                <cfinvokeargument name="keys" value="RHAlinea"/>
                <cfinvokeargument name="MaxRows" value="100"/>
                 <cfinvokeargument name="formName" value="listaAcciones"/> <!------>
                <cfinvokeargument name="debug" value="N"/>
                <cfinvokeargument name="navegacion" value="#navegacion#"/>
                <cfinvokeargument name="incluyeForm" value="true"/>	
            </cfinvoke>
        </form>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td class="sectionTitle" style="padding: 10px;">
		<img border="0" src="/cfmx/rh/imagenes/Excl16.gif">
		<cf_translate key="LB_LosRegistrosConEsteIconoIndicanQueExistenVacacionesPosterioresALaFechaDeCeseDeEsaAccion">Los registros con este icono indican que existen Vacaciones posteriores a la fecha de Cese de esa Acci&oacute;n</cf_translate>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<script language="javascript" type="text/javascript">
	
	function fnAlgunoMarcadolistaAcciones(){
		var form = document.listaAcciones;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
			return result;
	}		

	
	
	
	function funcAplicar(){
		if (!fnAlgunoMarcadolistaAcciones()){
			alert("¡Debe seleccionar un trámite por aplicar!");
			return false;
		}else{
			return (confirm("¿Desea aplicar los trámites marcados?"));
		}		
	}

	function funcEliminar(){
		if (!fnAlgunoMarcadolistaAcciones()){
			alert("¡Debe seleccionar al menos una Acción para eliminar!");
			return false;
		}else{
			if ( confirm("¿Desea eliminar las Acciones marcadas?") )	{
				document.listaAcciones.action = '/cfmx/rh/nomina/operacion/Acciones-listaSql.cfm';
				return true;
			}
			return false;
		}		
	}
	
	
	function funcChequeaTodos(){		
		if (document.filtroAcciones.chkTodos.checked){			
			if (document.listaAcciones.chk && document.listaAcciones.chk.type) {
				document.listaAcciones.chk.checked = true
			}
			else{
				if (document.listaAcciones.chk){
					for (var i=0; i<document.listaAcciones.chk.length; i++) {
						document.listaAcciones.chk[i].checked = true					
					}
				}
			}
		}	
		else{
			<cfset url.Todos = 0>
			if (document.listaAcciones.chk && document.listaAcciones.chk.type) {
				document.listaAcciones.chk.checked = false
			}
			else{
				if (document.listaAcciones.chk){
					for (var i=0; i<document.listaAcciones.chk.length; i++) {
						document.listaAcciones.chk[i].checked = false					
					}
				}
			}
		}
	}
	
	function funcImportar() {
		document.listaAcciones.action = 'importarAccionesPersonal.cfm';
		document.listaAcciones.submit();
	}
</script>
