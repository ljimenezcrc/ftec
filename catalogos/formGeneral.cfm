
<cfset lvarEcodigos = session.Ecodigo>
<cfset lvVmonto  = 0.00>


<cfif isdefined("modo") and  modo NEQ "ALTA">

	<cfquery name="rsForm" datasource="#Session.DSN#">
		select   a.Ecodigo
        		, a.Vid
                , <cf_dbfunction name="to_char" args="Vid"> as Vpk	
                , a.Vcodigo, a.Vdescripcion
                , a.Vpadre
                , coalesce(a.Vpadre,0) as Vpkresp
                , a.Vctaingreso, a.Vctagasto, a.Vctasaldoinicial, a.Vesproyecto, a.Vfinicio, a.Vffinal, a.Vestado, a.Mcodigo, a.Vmonto
                , a.CFid
                , b.CFdescripcion
                , b.CFcodigo 
        from FTVicerrectoria a
        left join  CFuncional b
        	on a.CFid = b.CFid
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        	and a.Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Vpk#">	
	</cfquery>
   
    <cfquery name="rsNombreVC" datasource="#Session.DSN#">
        select Vid as Vpkresp, Vcodigo as Vcodigoresp, Vdescripcion as Vdescripcionresp from FTVicerrectoria 
        where Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Vpkresp#">
    </cfquery>
    
	<cfset lvVmonto = rsForm.Vmonto>
</cfif>



<!--- ********************************************************************************** --->




<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SePresentaronLosSiguientesErrores"
	Default="Se presentaron los siguientes errores"
	returnvariable="MSG_SePresentaronLosSiguientesErrores"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDelCentroFuncionalEsRequerido"
	Default="El código del centro funcional es requerido"
	returnvariable="MSG_ElCodigoDelCentroFuncionalEsRequerido"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCentroFuncionalResponsableEsRequerido"
	Default="El centro funcional Responsable es requerido"
	returnvariable="MSG_ElCentroFuncionalResponsableEsRequerido"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaDescripcionDelCentroFuncionalEsRequerida"
	Default="La descripción del centro funcional es requerida"
	returnvariable="MSG_LaDescripcionDelCentroFuncionalEsRequerida"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaOficinaEsRequerida"
	Default="La oficina es requerida"
	returnvariable="MSG_LaOficinaEsRequerida"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElDepartamentoEsRequerido"
	Default="El departamento es requerido"
	returnvariable="MSG_ElDepartamentoEsRequerido"/>
	
	
<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="MSG_EMPLEADO"
    Default="Empleado(a)"
    returnvariable="MSG_EMPLEADO"/>


<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="MSG_ENCARGADONOASIGNADO"
    Default="No hay encargado asignado"
    returnvariable="MSG_ENCARGADONOASIGNADO"/>
				
<script language="JavaScript1.2" >
	function regresa()
		{
			location.href ="/cfmx/ftec/catalogos/Vicerrectorias-lista.cfm";
		}

</script>


<form action="VicerrectoriasSQL.cfm" method="post" name="form1">
<!--- onSubmit="javascript: return valida(this);"--->
  	<cfoutput>
		<!---<cfif modo neq 'ALTA'>
			<input type="hidden" name="CFpath" value="#trim(rsForm.CFpath)#">
		</cfif>--->

 	<center> 			
	<table border="0" cellspacing="1" cellpadding="0">
			<tr> 
				<td align="left"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:</td>
				<td  valign="middle" nowrap>
					<input name="Vcodigo" type="text" id="Vcodigo" 
						value="<cfif isdefined('modo') and modo NEQ "ALTA">#trim(rsForm.Vcodigo)#</cfif>" 
						size="12" maxlength="10" tabindex="1" onFocus="javascript:this.select();">				
                    <input type="hidden" name="Vpk" value="<cfif isdefined('modo') and  modo NEQ "ALTA">#rsForm.Vpk#</cfif>">	
	                <input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">    
                </td>
                	
			</tr>
			
			<tr> 
				<td align="left"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</td>
				<td  valign="middle">
					<input name="vdescripcion" type="text" id="vdescripcion" size="40" maxlength="60" 
						   value="<cfif isdefined('modo') and  modo NEQ "ALTA">#HTMLEditFormat(rsForm.vdescripcion)#</cfif>" tabindex="1" 
						   onFocus="javascript:this.select();">          
				</td>
			</tr>
			
			<tr> 
				<td align="left"><cf_translate key="LB_CentroResponsable">Unidad Operativa Responsable</cf_translate>:</td>
				<td  valign="middle" nowrap>    
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_SeleccioneElCentroFuncionalResponsable"
						Default="Seleccione el Centro Funcional Responsable"

						returnvariable="MSG_SeleccioneElCentroFuncionalResponsable"/>
					
					<cfif isdefined('modo') and  modo NEQ 'ALTA'>
						<cf_FTvicerrectoria tabindex="1" form="form1" size="30" id="Vpkresp" name="Vcodigoresp" desc="Vdescripcionresp" 
							titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1" query="#rsNombreVC#" >  
                    <cfelse>
    	                <cf_FTvicerrectoria tabindex="1" form="form1" size="30" id="Vpkresp" name="Vcodigoresp" desc="Vdescripcionresp" 
								titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1">   

                    </cfif> 
					</td>
			</tr>
            <tr>
                <td>Centro Funcional Asociado:</td>
                <td>
                    <cfif isdefined("rsForm") and rsForm.RecordCount NEQ 0>
                        <cf_rhcfuncional tabindex="1" id="CFid" name="CFcodigo" desc="CFdescripcion" query="#rsForm#">
                    <cfelse>
                        <cf_rhcfuncional tabindex="1" id="CFid" name="CFcodigo" desc="CFdescripcion">
                    </cfif>
                </td>
            </tr>
            
            <!--- campos de las cuentas se sustituye por centro funcional
			<tr>
            	<td nowrap align="left"><cf_translate key="LB_CtaIngreso">Cta. Ingreso</cf_translate>:</td>
                <td  valign="middle">
					<input name="Vctaingreso" type="text" id="Vctaingreso" size="30" maxlength="30" 
						   value="<cfif isdefined('modo') and  modo NEQ "ALTA">#HTMLEditFormat(rsForm.Vctaingreso)#</cfif>" tabindex="1" 
						   onFocus="javascript:this.select();">          
                </td>
            </tr>
            
            <tr>
            	<td nowrap align="left"><cf_translate key="LB_CtaGasto">Cta. Gasto</cf_translate>:</td>
                <td  valign="middle">
					<input name="Vctagasto" type="text" id="Vctagasto" size="30" maxlength="30" 
						   value="<cfif isdefined('modo') and  modo NEQ "ALTA">#HTMLEditFormat(rsForm.Vctagasto)#</cfif>" tabindex="1" 
						   onFocus="javascript:this.select();">          
                </td>
            </tr>
            
            <tr>
            	<td nowrap align="left"><cf_translate key="LB_CtaSaldoInicial">Cta. Saldo Inicial</cf_translate>:</td>
                <td  valign="middle">
					<input name="Vctasaldoinicial" type="text" id="Vctasaldoinicial" size="30" maxlength="30" 
						   value="<cfif isdefined('modo') and  modo NEQ "ALTA">#HTMLEditFormat(rsForm.Vctasaldoinicial)#</cfif>" tabindex="1" 
						   onFocus="javascript:this.select();">          
                </td>
            </tr>--->
            <tr>
				<td>Proyecto:</td>
				<td><input type="checkbox"  id="Vesproyecto" onchange="javascript:motrarProyecto(this.checked);"  name="Vesproyecto" <cfif isdefined('modo') and  modo EQ "CAMBIO" and rsForm.Vesproyecto EQ 1> checked <cfelse> unchecked   </cfif>>
			</tr>
            
            <tr id="TR_Proyecto" style=" display:'none'">
            	<td colspan="3">
                	<table align="center" border="0" >
                    	 <tr>
                         	<td align="right" width="25%" valign="top"><cf_translate  key="LB_desde">Desde:</cf_translate></td>
                            <td>
                                <cfif isdefined('modo') and  modo eq 'CAMBIO'>
                                    <cf_sifcalendario name="Vfinicio" id = "Vfinicio"  value="#LSDateFormat(rsForm.Vfinicio,'dd/mm/yyyy')#">
                                <cfelse>
                                    <cf_sifcalendario name="Vfinicio" id = "Vfinicio"  value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                                </cfif>
                            </td>
                            
                                                       
                         </tr>
                         <tr>
                         	<td align="right" width="25%" valign="top"><cf_translate  key="LB_hasta">Hasta:</cf_translate></td>
                            <td>
                                <cfif isdefined('modo') and  modo eq 'CAMBIO'>
                                   <cf_sifcalendario name="Vffinal" value="#LSDateFormat(rsForm.Vffinal,'dd/mm/yyyy')#">
                                <cfelse>
                                    <cf_sifcalendario name="Vffinal" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                                </cfif>
                            </td>
                         </tr>
                        <tr>
                            <td align="right"><input type="checkbox"  id="Vestado" name="Vestado" <cfif (isdefined('modo') and  modo EQ "ALTA") or (isdefined('rsForm.Vestado') and rsForm.Vestado eq 1)>checked</cfif>>
                            <td><cf_translate  key="LB_Activo">Activo</cf_translate></td>
                        </tr>
                        <tr> 
                            <td nowrap align="right"><cf_translate key="LB_Moneda">Moneda:</cf_translate></td>
                            <td>
                            	<cfif isdefined('modo') and  modo eq 'CAMBIO'>
                                   <cf_sifmonedas Conexion="#session.DSN#" form="form1" query="#rsForm#"  Mcodigo="Mcodigo" tabindex="1">
                                <cfelse>
                                    <cf_sifmonedas Conexion="#session.DSN#" form="form1" Mcodigo="Mcodigo" tabindex="1">
                                </cfif>
                            
                            </td>		  
                        </tr>
                        <tr>
                            <td align="right" nowrap><cf_translate key="LB_Monto">Monto</cf_translate>:</td>
                            <td>
                                <cf_inputNumber name="Vmonto" value="#lvVmonto#" enteros="18" decimales="4" negativos="false" comas="no" tabIndex = 3>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            
			
            
            
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr> 
				<td colspan="2" align="center" nowrap="nowrap" >
					<cfif isdefined('modo')  and modo EQ "ALTA" or isDefined("Form.Nuevo")>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Agregar"
						Default="Agregar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Agregar"/>
					
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>
						<cf_botones names="Alta,Limpiar" values="#BTN_Agregar#,#BTN_Limpiar#" tabindex="3" functions="javascript: setBtn(this),javascript: setBtn(this)">

					<cfelse>
                    
                    
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Modificar"
						Default="Modificar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Modificar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Eliminar"
						Default="Eliminar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Eliminar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MGS_DeseaEliminarEsteRegistro"
						XmlFile="/rh/generales.xml"
						Default="Desea eliminar este Registro?"
						returnvariable="MGS_DeseaEliminarEsteRegistro"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Nuevo"
						Default="Nuevo"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Nuevo"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Exportar"
						Default="Exportar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Exportar"/>
						

                        
						<script language="JavaScript1.2" >
							function funcCambio(){
								setBtn(this);
							}
							function funcBaja(){
								setBtn(this);
								return confirm('¿<cfoutput>#MGS_DeseaEliminarEsteRegistro#</cfoutput>');
							}
							function funcNuevo() {
								setBtn(this);
							}
							function funcExportar() {
								setBtn(this);
							}
						</script>
                        
						<cf_botones names="Cambio,Baja,Nuevo" 
						values="#BTN_Modificar#,#BTN_Eliminar#,#BTN_Nuevo#" 
						tabindex="3" >
					</cfif>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Regresar"/>
						<!---<cf_botones names="Regresar" values="#BTN_Regresar#" tabindex="3" functions="javascript: regresa();">--->
						<input type="button" name="Regresar" value="#BTN_Regresar#" tabindex="3" onClick="javascript: regresa();">				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	 </center> 
</cfoutput>

<!---<cfif modo EQ 'Alta'>
	</form>
</cfif>	--->
</form>

<cf_qforms form="form1">
	<cf_qformsRequiredField name="Vfinicio"  description="Fecha de inicio">
	<cf_qformsRequiredField name="Vffinal" description="Fecha de finalizacion">
</cf_qforms>
<script language="JavaScript1.2">

	function motrarProyecto(opcion){
		var TR_Proyecto	 = document.getElementById("TR_Proyecto");

		if (opcion){
			TR_Proyecto.style.display = "";
		}
		else {
			TR_Proyecto.style.display = "none";
		}
	}
	<cfif isdefined('modo')  and  modo neq "ALTA">
		motrarProyecto(<cfoutput>#rsForm.Vesproyecto#</cfoutput>);
	<cfelse>
		motrarProyecto(0);
	</cfif>


<!---	try{
	document.form1.Vcodigo.focus();
	} catch(e) {
	}
--->
</script>
