<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Agregar"
Default="Agregar"
returnvariable="BTN_Agregar"/>

<cfinvoke component="sif.Componentes.Translate" 
    method="Translate"
    Key="MSG_DeseaBorrarVicerrectoria" 
    Default="Desea borrar la unidad operativa" 
    returnvariable="MSG_DeseaBorrarVicerrectoria"/>



<cfif not isdefined("Form.modo")>
    <cfset modo="ALTA_C">
<cfelseif form.modo EQ "CAMBIO_C">
    <cfset modo="CAMBIO_C">
<cfelse>
    <cfset modo="ALTA_C">
</cfif>

    
<!--- Consultas --->
<!-- Establecimiento del modo -->
<cfif isdefined("url.usucodigo") and len(trim(url.usucodigo))>
	<cfset form.usucodigo = url.usucodigo>
</cfif>
<cfif isdefined("form.usucodigo")>
	<cfset modo="CAMBIO_C">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA_C">
	<cfelseif form.modo EQ "CAMBIO_C">
		<cfset modo="CAMBIO_C">
	<cfelse>
		<cfset modo="ALTA_C">
	</cfif>
</cfif>


<cfset lvCPporcentaje = 0.00>
<cfset lvCPDporcentaje = 0.00>

<cfif modo neq 'ALTA_C'>
	<!--- Form --->
    <cfquery name="rsFormCost" datasource="#session.DSN#">
        select CPid
                , a.Vid
                , a.CAid
                , a.CPporcentaje
                , a.CPexoneracion
                , a.CPfdesde
                , a.CPfhasta
                , coalesce(a.CPdistribuido,0) as CPdistribuido
                , a.CPvalorcatalogo   
                , a.Usucodigo 
                , b.CAcodigo
                , b.CAdescripcion
        from FTCostoProyecto a
            inner join FTCostoAdmin b
                on a.CAid = b.CAid
                 <cfif isdefined('form.CApk')>
                     and a.CAid = #form.CApk#
                 </cfif>
        where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and a.Vid = (select Vid from FTVicerrectoria where Vcodigo ='#form.Vcodigo#' and Ecodigo=#session.Ecodigo#)
    </cfquery>

	<cfset lvCPporcentaje = rsFormCost.CPporcentaje>

	<cfif isdefined('form.CPpk')>
        <cfquery name="rsFormCostDist" datasource="#session.DSN#">
            select 	  CPDid
                    , a.CPid
                    , a.Vid
                    , a.CPDporcentaje
                    , b.Vcodigo
                    , b.Vdescripcion
            from FTCostoProyectoD a
                inner join FTVicerrectoria b
                on a.Vid = b.Vid
            where CPid = #form.CPpk#
        </cfquery>
	</cfif>
</cfif>

<cfquery name="rsCostos" datasource="#session.DSN#">
		select a.CAid
                , a.CAcodigo
                , a.CAdescripcion
                , a.CAporcentaje
                , a.CAobligatorio
		from FTCostoAdmin a
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
       	order by a.CAdescripcion
</cfquery>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js"></script>

<form name="formCost" method="post" action="VicerrectoriasSQL.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
    	<td align="right" nowrap="nowrap">&nbsp;<strong><cf_translate key="LB_TiposAut">Costos</cf_translate>:</strong>&nbsp;</td>
      	<td>
            <select name="CAid"  > 
                <option  title="" value="">-- Seleccione un Costo--</option>
                <cfloop query="rsCostos">
                    <option  title="#rsCostos.CAid#" value="#rsCostos.CAid#" <cfif modo neq "ALTA_C" and isdefined('rsFormCost') and rsFormCost.CAid eq rsCostos.CAid>selected<cfelseif modo eq 'ALTA_C' >selected</cfif>>#rsCostos.CAdescripcion#</option>
                </cfloop>
            </select>
        </td>
    </tr>
    
    <tr>
		<td align="right">
			<input name="CPvalorcatalogo"  id="CPvalorcatalogo" type="checkbox" tabindex="1" 	value="1" 
				<cfif modo neq 'ALTA_C' and isdefined("rsFormCost") and rsFormCost.CPvalorcatalogo eq 1 >checked="checked"</cfif> >
		</td>
		<td>
			&nbsp;&nbsp;&nbsp;
			<label for="chkResponsable"><cf_translate key="CHK_Valorcatalogo">Toma Valor del Cat&aacute;logo</cf_translate></label>
		</td>
    </tr>
    
    <tr>
        <td align="right" nowrap><cf_translate key="LB_Porcentaje">Porcentaje</cf_translate>:</td>
        <td>
            <cf_inputNumber name="CPporcentaje" value="#lvCPporcentaje#" enteros="5" decimales="2" negativos="false" comas="no" tabIndex = 3>
        </td>
    </tr>
    
    <tr>
		<td align="right">
			<input name="CPexoneracion"  id="CPexoneracion" type="checkbox" tabindex="1" 	value="1" 
				<cfif modo neq 'ALTA_C' and isdefined("rsFormCost") and rsFormCost.CPexoneracion eq 1 >checked="checked"</cfif> >
		</td>
		<td>
			&nbsp;&nbsp;&nbsp;
			<label for="chkResponsable"><cf_translate key="CHK_CPexoneracion">Exonerado</cf_translate></label>
		</td>
    </tr>

    <tr>
        <td align="right" width="25%" valign="top"><cf_translate  key="LB_desde">Desde:</cf_translate></td>
        <td>
            <cfif modo neq 'ALTA_C'>
                <cf_sifcalendario form ="formCost" name="CPfdesde" value="#LSDateFormat(rsFormCost.CPfdesde,'dd/mm/yyyy')#">
            <cfelse>
                <cf_sifcalendario   form ="formCost" name="CPfdesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
            </cfif>
        </td>
        
                                   
     </tr>
     <tr>
        <td align="right" width="25%" valign="top"><cf_translate  key="LB_hasta">Hasta:</cf_translate></td>
        <td>
            <cfif modo neq 'ALTA_C'>
               <cf_sifcalendario form ="formCost" name="CPfhasta" value="#LSDateFormat(rsFormCost.CPfhasta,'dd/mm/yyyy')#">
            <cfelse>
                <cf_sifcalendario form ="formCost" name="CPfhasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
            </cfif>
        </td>
     </tr>
    
    
    <tr>
		<td align="right">
			<input type="checkbox" id="CPdistribuido" name="CPdistribuido"   onchange="javascript:motrarCostoDistribuido(this.checked);"  
				<cfif modo neq 'ALTA_C' and isdefined("rsFormCost") and rsFormCost.CPdistribuido eq 1 >checked="checked"</cfif> >
		</td>
		<td>
			&nbsp;&nbsp;&nbsp;
			<label for="CKCPdistribuido"><cf_translate key="CHK_CPdistribuido">Costo distribuido</cf_translate></label>
		</td>
    </tr>
    
    <tr id="TR_CostoDistribuido" style=" display:'none'">
        <td colspan="3">
            <table align="center" border="0" >
                <tr>
                    <td align="left"><cf_translate key="LB_CentroResponsable">Unidad Operativa</cf_translate>:</td>
                    <td  valign="middle" nowrap>    
                        <cfinvoke component="sif.Componentes.Translate"
                            method="Translate"
                            Key="MSG_SeleccioneElCentroFuncionalResponsable"
                            Default="Seleccione Vicerrectoria"
                            returnvariable="MSG_SeleccioneElCentroFuncionalResponsable"/>
                    
                            <cf_FTvicerrectoria tabindex="1" form="formCost" size="30" id="VidDist" name="VcodigoDist" desc="VdescripcionDist" 
                                titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1">
                    </td>
	            </tr>
                 <tr>
                    <td align="right" nowrap><cf_translate key="LB_Porcentaje">Porcentaje</cf_translate>:</td>
                    <td>
                        <cf_inputNumber name="CPDporcentaje" value="#lvCPDporcentaje#" enteros="5" decimales="2" negativos="false" comas="no" tabIndex = 3>
                    </td>
                </tr>
                
                <tr>
                    <td align="center" colspan="3">
                        <cf_botones modo="ALTA" sufijo="CostDist" exclude= "Baja,Nuevo,Limpiar" functions="javascript: return validaConcepto();">	
                    </td>
                </tr>
                <cfif isdefined('rsFormCostDist') and rsFormCostDist.RecordCount gt 0 >
                <tr>
                    <td align="center" colspan="2">
                        <!--- Lista --->
                        <table border="0" width="100%" align="center">
                        	<tr><td width="10%">C&oacute;digo</td><td width="50%">Descripci&oacute;n</td><td width="15%">Porcentaje</td>
                            </tr>
                            <cfloop query="rsFormCostDist">
                                <tr <cfif CurrentRow MOD 2> 
                                        class="listaPar"<cfelse>class="listaNon"</cfif>>
                                    <td>#Vcodigo#</td>
                                    <td>
                                        <a href="" onClick="javascript: return false;" 
                                           title="#Vdescripcion#">
                                           <cfif Len(Trim(Vdescripcion)) LT 20>
                                                #Vdescripcion#<cfelse>#Mid(Vdescripcion,1,18)#...
                                           </cfif>
                                         </a>
                                    </td>
                                    <td align="right">#CPDporcentaje#%</td>
                                    <td colspan="3" align="center">
                                        <input name="btnBorrarConcepto" type="image" alt="Eliminar elemento" onClick="javascript: return BorrarConcepto(#CPDid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
                                    </td>
                                </tr>
                            </cfloop>
                            <input type="hidden" name="CPDid_" value="">
                        </table>
                    </td>
                </tr>
                </cfif>
            </table>
        </td> 
    </tr>	
    
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
	<cfif isdefined ('form.Vcodigo') and len(trim(form.Vcodigo)) gt 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select Vid from FTVicerrectoria where Vcodigo='#form.Vcodigo#' and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsCFid.recordcount gt 0>
			<input type="hidden" name="Vid" value="#rsCFid.Vid#" />
			<cfif isdefined('form.CPpk')>
            	<input type="hidden" name="CPid" value="#form.CPpk#" />
            </cfif>
			<cfset LvarVid=#rsCFid.Vid#>
		</cfif>
	</cfif>
	
		<cfif modo neq "ALTA_C">
			<cf_botones modo="CAMBIO" sufijo="Cost">
		<cfelse>
			<cf_botones modo="ALTA" sufijo="Cost">
		</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<input type="hidden" name="modo" value="CAMBIO_C" />
     
  </table>  
  </cfoutput>
 </form>


<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR8"
	Default="Usuario"
	returnvariable="LB_MESAJEERROR8"/>
	
	function limpiar() {
		objForm.reset();
	}
	
	function funcRegresarDet(id){
		document.location.href = 'Vicerrectorias.cfm?Vcodigo1=' & id;

	}
	
	function motrarCostoDistribuido(opcion){
		var TR_CostoDistribuido	 = document.getElementById("TR_CostoDistribuido");
		
		if (opcion){
			TR_CostoDistribuido.style.display = "";
		}
		else {
			TR_CostoDistribuido.style.display = "none";
		}
	}


	<cfif isdefined('rsFormCost') >
		motrarCostoDistribuido(<cfoutput>#rsFormCost.CPdistribuido#</cfoutput>);
	<cfelse>
		motrarCostoDistribuido(0);
	</cfif>
	
	
	function BorrarConcepto(id) 
	{
		if (confirm("<cfoutput>#MSG_DeseaBorrarVicerrectoria#</cfoutput>")) {
			var f = document.formCost;
			f.CPDid_.value = id;
			f.btnBorrarConcepto.click()
			f.submit();
			return true;
		}
		return false;
	}
	
	function validaConcepto() {
		if (trim(document.formCost.VcodigoDist.value) == "") 
		{
			alert('<cfoutput>Debe seleccionar Vicerrectoria</cfoutput>');
			return false;
		}
		return true;
	}

</script> 
