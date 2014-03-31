<cfif isdefined("form.Cambio")>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfif not isdefined("form.modo")>    
    	<cfset modo="ALTA">
  	<cfelseif form.modo EQ "CAMBIO">
    	<cfset modo="CAMBIO">
  	<cfelse>
    	<cfset modo="ALTA">
  	</cfif>  
</cfif>

<cfquery name="rsFPagos" datasource="#Session.DSN#">
	select 	
        FPid                 
        ,FPcodigo     
        ,FPdescripcion 
	from FTFormaPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by FPdescripcion
</cfquery>


<cfquery name="rsLPagos" datasource="#Session.DSN#">
	select 	
        LPid                 
        ,LPcodigo     
        ,LPdescripcion 
	from FTLugarPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by LPdescripcion
</cfquery>

<cfquery name="rsBancos" datasource="#Session.DSN#">
	select 	
        Bid
        ,Bcodigo
        ,Ecodigo
        ,Bdescripcion
	from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Bdescripcion
</cfquery>


<cfif modo NEQ "ALTA" and isdefined('form.SPid') and #form.SPid# GT 0>
    <cfquery name="rsSolicitudProcesos" datasource="#Session.DSN#">
        select 	
            a.SPid
            ,a.TPid
            ,a.Vid
            ,a.FPid                 
            ,a.LPid                 
            ,a.Mcodigo    
            ,a.SNcodigo 
            ,a.Bid       
            ,a.SPfecha              
            ,a.SPfechaReg           
            ,a.Usucodigo            
            ,a.SPestado 
            ,a.SPctacliente            
            ,a.SPacta  
            ,a.SPfechaTrans
            ,a.SPobservacion
            ,b.Vid as Vpkresp
            ,b.Vcodigo as Vcodigoresp
            ,b.Vdescripcion as Vdescripcionresp
            ,d.LPcodigo     
       		,d.LPdescripcion 
            ,e.SNnumero
            ,e.SNnombre
        from FTSolicitudProceso a
        inner join FTVicerrectoria b
	        on a.Vid = b.Vid
            and a.Ecodigo = b.Ecodigo
        inner join FTFormaPago c
        	on a.FPid = c.FPid
            and a.Ecodigo = c.Ecodigo
        left outer join FTLugarPago d
        	on a.LPid = d.LPid
            and a.Ecodigo = d.Ecodigo
        left outer join SNegocios e
        	on a.SNcodigo = e.SNcodigo
            and a.Ecodigo = e.Ecodigo
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        <cfif isdefined('form.SPid') and #form.SPid# GT 0>
            and a.SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
        </cfif>
        order by a.TPid,a.Vid,a.FPid
    </cfquery>
    
	
<!---<cfelseif modo EQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("url.DEid") AND Len(Trim(url.DEid)) NEQ 0>
	<cfquery name="rsEmpleadoDef" datasource="#Session.DSN#">
		select a.DEid, 
			   <cf_dbfunction name="concat" args="a.DEapellido1|' '|a.DEapellido2|', '|a.DEnombre" delimiters="|"> as 	NombreEmp,
		       a.DEidentificacion, 
			   a.NTIcodigo
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>--->
</cfif>


<cfset navegacion = "" > 
<cfoutput>

<!---onSubmit="javascript: return validaForm(this);"--->
<form  name="fEncabezado" method="post" action="SolicitudPago-Sql.cfm" >
	<input type="hidden" name="modo" value="#modo#">
    <input type="hidden" name="SPid" value="<cfif isdefined('form.SPid')> #form.SPid# </cfif>">
	<input type="hidden" name="TPid" value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.TPid#</cfif>">
    <input type="hidden" name="SPfp" value="<cfif isdefined('form.FPid')> #form.FPid# </cfif>">
    <input type="hidden" name="Tramite" value="<cfif isdefined('form.Tramite')> #form.Tramite# </cfif>">    
    
    
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">
        <tr>
            <td colspan="5"> 
                <fieldset>
                    <legend><b>&nbsp;Encabezado&nbsp;</b></legend>
                    <table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">
                        <!---************************************* CAMPOS DEL MANTENIMIENTO ***************************************---->	
                        <tr><td>&nbsp;</td></tr>
                        <!--- Línea No. 1 --->
                        <tr> 
                            <td height="76"  class="fileLabel">Proyecto 
                                <cfif isdefined('form.modo') and  modo NEQ 'ALTA'>
                                    <cf_FTvicerrectoria tabindex="1" form="fEncabezado" size="30" id="Vpkresp" name="Vcodigoresp" desc="Vdescripcionresp" 
                                        titulo="Seleccione Proyecto" proyectos="1" query="#rsSolicitudProcesos#" >  
                                <cfelse>
                                    <cf_FTvicerrectoria tabindex="1" form="fEncabezado" size="30" id="Vpkresp" name="Vcodigoresp" desc="Vdescripcionresp" 
                                            titulo="Seleccione Proyecto" proyectos="1">   
                
                                </cfif> 
                                </td>
                          <td  class="fileLabel">Fecha:</td>
                                <td>
                                    <cfif modo NEQ "ALTA">
                                        <cf_sifcalendario form="fEncabezado" name="SPfecha" value="#LSDateFormat(rsSolicitudProcesos.SPfecha,'dd/mm/yyyy')#">
                                    <cfelse>
                                        <cf_sifcalendario form="fEncabezado" name="SPfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                                    </cfif>			
                                </td>
                                
                                
                                <td  class="fileLabel">N°.Acta:</td>
                                <td nowrap>
                                    <input name="SPacta" type="text" id="SPacta" size="18" maxlength="15"  style="text-align: right;" 
                                    value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPacta#</cfif>" >
                                </td>
                                
                                
                      </tr>
                      <tr >
                             <td  class="fileLabel">Forma de Pago:
                                <select name="FPid"  id="FPid" onchange="javascript:Fpago(this);">
                                	<option value="">--- Seleccionar ---</option>
                                    <option value="1" <cfif modo neq 'ALTA' and isdefined("rsSolicitudProcesos") and rsSolicitudProcesos.FPid eq 1 >selected</cfif> >Caja Chica</option>
                                    <option value="2" <cfif modo neq 'ALTA' and isdefined("rsSolicitudProcesos") and rsSolicitudProcesos.FPid eq 2 >selected</cfif> >Cheque</option>
                                    <option value="3" <cfif modo neq 'ALTA' and isdefined("rsSolicitudProcesos") and rsSolicitudProcesos.FPid eq 3 >selected</cfif> >Transferencia</option>
                                </select>
                            </td>
                        </tr>
                        
                        
                        <tr id="divCheque">
                             <td  class="fileLabel">Lugar Entrega:
                                <select name="LPid">
                                    <option value="">--- Seleccionar ---</option>
                                    <cfloop query="rsLPagos">
                                        <option value="#LPid#" <cfif modo EQ 'CAMBIO' and rsLPagos.LPid EQ rsSolicitudProcesos.LPid> selected</cfif>>#LPdescripcion#</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                        
                        
                        <tr>
                        	<table border="0" id="divTransferencia" width="100%">
                                <tr>
                                 <td  class="fileLabel">Banco:
                                <select name="Bid">
                                        <option value="">--- Seleccionar ---</option>
                                        <cfloop query="rsBancos">
                                            <option value="#Bid#" <cfif modo EQ 'CAMBIO' and rsBancos.Bid EQ rsSolicitudProcesos.Bid> selected</cfif>>#Bdescripcion#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td  class="fileLabel">Cuenta Cliente:
                                    <input name="SPctacliente" type="text" id="SPctacliente" size="20" maxlength="20"  style="text-align: right;" 
                                    value="<cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPctacliente#</cfif>" >
                                </td>
                                <td class="fileLabel">Moneda:</td>
                                <td>
                                    <cfif isdefined('modo') and  modo eq 'CAMBIO'>
                                       <cf_sifmonedas Conexion="#session.DSN#" form="fEncabezado" query="#rsSolicitudProcesos#"  Mcodigo="Mcodigo" tabindex="1">
                                    <cfelse>
                                        <cf_sifmonedas Conexion="#session.DSN#" form="fEncabezado" Mcodigo="Mcodigo" tabindex="1">
                                    </cfif>
                                </td>
                                <tr>
                               	  <td class="fileLabel" colspan="4" >Observaci&oacute;n:
                                        <textarea name="SPobservacion" cols="150" id="SPobservacion"><cfif isdefined('rsSolicitudProcesos')> #rsSolicitudProcesos.SPobservacion#</cfif></textarea>
                                   </td>
                                </tr>
                                <tr> <td colspan="4">
                                	<table border="0" width="100%">
                                    <tr>
                                        <td  class="fileLabel">Fecha Transacci&oacute;n:</td>
                                        <td>
                                            <cfif modo NEQ "ALTA">
                                                <cf_sifcalendario form="fEncabezado" name="SPfechaTrans" value="#LSDateFormat(rsSolicitudProcesos.SPfechaTrans,'dd/mm/yyyy')#">
                                            <cfelse>
                                                <cf_sifcalendario form="fEncabezado" name="SPfechaTrans" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                                            </cfif>
                                        </td>  
                                        <td  class="fileLabel">Socio Negocio:</td>
                                        
                                        <td>
                                            <cfif modo NEQ "ALTA">
                                                <cf_rhsociosnegociosFA form="fEncabezado"  query="#rsSolicitudProcesos#"> 
                                            <cfelse>
                                                <cf_rhsociosnegociosFA form="fEncabezado" > 
                                            </cfif>
                                        </td>
                                    	
                                    </tr>
                                    </table>
                                </td>
                                </tr>
                            </table>
                        </tr>

                  <tr align="center"> 
                            <td colspan="5">
                                <br>
                                <cfif isdefined('form.Tramite') and #modo# EQ 'CAMBIO'>
                                	<cf_botones modo="#modo#" exclude= "Nuevo,Alta,Limpiar,Cambio,Baja" formName = "fEncabezado"  sufijo="Enc" include="Aplicar,Rechazar" >
								<cfelseif #modo# EQ 'CAMBIO'>
	                               	<cf_botones modo="#modo#" incluyeForm="true" formName = "fEncabezado"  sufijo="Enc" include="Aplicar" >
                                <cfelse>
                                	<cf_botones modo="#modo#" incluyeForm="true" formName = "fEncabezado"  sufijo="Enc">
                                </cfif>
                                <br>
                            </td>
                        </tr>
                        
                        
                    </table>
                </fieldset>
            </td>
        </tr>
      	
	</table>
</form>



<form  name="fDetalle" method="post" action="SolicitudPago-Sql.cfm">
	<input type="hidden" name="modo" value="#modo#">
    <input type="hidden" name="SPid" value="#form.SPid#">

	<cfif modo EQ 'CAMBIO' and not isdefined('form.Tramite')>
    <table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">
        <tr>
        	<td colspan="5"> 
            	<fieldset>
                <legend><b>&nbsp;Detalle&nbsp;</b></legend>
                    <table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">
                        <!---************************************* detalle solicitud***************************************---->	
                        <tr><td>&nbsp;</td></tr>
                        <tr> 
                            <td  class="fileLabel" align="right">Documento </td>
                            <td>
                                <input name="DSPdocumento" type="text" id="DSPdocumento" size="25" maxlength="25"  style="text-align: left;"  value="" />
                            </td>
                            
                            <td  class="fileLabel" align="right">Descripci&oacute;n</td>
                            <td>
                                <input name="DSPdescripcion" type="text" id="DSPdescripcion" size="60" maxlength="60"  style="text-align: left;"  value="" />
                            </td>
                        </tr>
                        
                        <tr><td>&nbsp;</td></tr>
                        <tr> 
                            <td  class="fileLabel" align="right">Monto</td>
                            <td>
	                            <cf_inputNumber name="DSPmonto"  value="0.00" enteros="15" decimales="2" negativos="false" comas="no">
                            </td>
                            <td  class="fileLabel" align="right">Objeto de Gasto</td>
                            <td>
                                <input name="DSPobjeto" type="text" id="DSPobjeto" size="60" maxlength="60"   value="" />
                            </td>
                        </tr>
                    </table>
         	</td>
        </tr>    
      	<tr align="center"> 
        	<td colspan="4">
				<br>
                   <cf_botones modo="Alta" incluyeForm="true" formName = "fDetalle" sufijo="Det">
				<br>
			</td>
      	</tr>
	</table>	
    </cfif>

</form>
</cfoutput>

<cfif isdefined('form.SPid') and form.SPid GT 0>
    <table width="90%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <cfquery name="rsLista" datasource="#Session.DSN#">		
                    select 
                        a.SPid            
                        ,a.DSPid
                        ,a.DSPdocumento    
                        ,a.DSPdescripcion  
                        ,a.DSPobjeto   

                        ,a.DSPmonto
                    from FTDSolicitudProceso a
                        inner join FTSolicitudProceso b
                            on a.SPid = b.SPid
                    where b.SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
                </cfquery>	
                
                <cfquery name="rsListaTotal" datasource="#Session.DSN#">		
                    select 
                        sum(a.DSPmonto) as Total
                    from FTDSolicitudProceso a
                        inner join FTSolicitudProceso b
                            on a.SPid = b.SPid
                    where b.SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPid#">
                </cfquery>	
                

                <cfinvoke component="sif.Componentes.Translate"
                 method="Translate"
                 key="LB_NoSeEncontraronRegistros"
                 default="No se encontraron Registros "
                 returnvariable="LB_NoSeEncontraronRegistros"/> 

                <form name="lista" method="post" action="SolicitudPago-Sql.cfm">
                    <input type="hidden" name="modo" value="#modo#">
                    <input type="hidden" name="SPidDelete" value="<cfoutput>#form.SPid#</cfoutput>">
                    
                    <cfinvoke component="rh.Componentes.pListas"
                     method="pListaQuery"
                     returnvariable="pListaRet">
                        <cfinvokeargument name="query" value="#rsLista#"/>
                        <cfinvokeargument name="desplegar" value="DSPdocumento, DSPdescripcion, DSPobjeto, DSPmonto"/>
                        <cfinvokeargument name="etiquetas" value="N°.Docuemto,Descripci&oacute;n, Objeto Gasto,Monto"/>
                        <cfinvokeargument name="formatos" value="V,V,V,M,G"/>
                        <cfinvokeargument name="align" value="left, left, left,right,left "/>
                        <cfinvokeargument name="ajustar" value="N"/>
                        <cfinvokeargument name="irA" value="SolicitudPago.cfm"/>

                        <cfinvokeargument name="showEmptyListMsg" value="true"/>
                        <cfinvokeargument name="EmptyListMsg" value="#LB_NoSeEncontraronRegistros#"/>
                        <cfinvokeargument name="navegacion" value="#navegacion#"/>
                        <cfinvokeargument name="maxRows" value="30"/>
                        <cfinvokeargument name="checkboxes" value="S"/>
                        <cfinvokeargument name="checkall" value="S"/>
                        <cfinvokeargument name="form_method" value="post"/>
                        <cfinvokeargument name="incluyeform" value="false"/>
                        <cfinvokeargument name="keys" value="DSPid"/>	
                        <cfinvokeargument name="showLink" value="false"/>	
                    </cfinvoke>
                    
                 <div align="right"><cfoutput><b>Total: </b> #LSnumberFormat(rsListaTotal.Total,'999,999,999.99')#</cfoutput></div>
				 <cfif rsLista.recordcount gt 0 and not isdefined('form.Tramite')>
                    <!---<cf_botones modo="Cambio" exclude= "Nuevo,Alta,Limpiar,Cambio" functions=" funcEliminar();" incluyeForm="true" formName = "lista" sufijo="Det"  >--->
                    <cf_botones incluyeForm="true" form="lista"  values="Eliminar" names="BajaDet" functions="funcEliminar();">
                </cfif>
                </form>
               </td>
            </tr>
		</table>
</cfif>

<cfoutput>


<cf_qforms form="fEncabezado" objForm="objForm">
<cfif modo EQ "CAMBIO">
	<cf_qforms form="fDetalle" objForm="objForm2">
</cfif>


<!---	<cfif modo EQ "CAMBIO">
        <cf_qforms form="fDetalle">
           <!--- <cf_qformsrequiredfield  name="DSPdocumento" 	description="Documento">
            <cf_qformsrequiredfield  name="DSPdescripcion" 	description="Descripci&oacute;n">
            <cf_qformsrequiredfield  name="DSPmonto" 		description="Monto">
            <cf_qformsrequiredfield  name="DSPobjeto" 		description="Objeto Gasto">        
        </cf_qforms>--->
    <cfelse>     
       <cf_qforms form="fDetalle" objForm="objForm2">
   </cfif>--->
    
<script language="JavaScript">
	var _divCheque = document.getElementById("divCheque");
		_divdivTransferencia = document.getElementById("divTransferencia");

		Fpago(document.fEncabezado.FPid);
		
		objForm.Vpkresp.required = true;
		objForm.Vpkresp.description ="Proyecto";
		
		objForm.FPid.required = true;
		objForm.FPid.description ="Forma de pago";
		
		
		objForm2.DSPdocumento.required = true;
		objForm2.DSPdocumento.description ="Documento";
		objForm2.DSPdescripcion.required = true;
		objForm2.DSPdescripcion.description ="DescripciOn";
		objForm2.DSPmonto.required = true;
		objForm2.DSPmonto.description ="Monto";
		objForm2.DSPobjeto.required = true;
		objForm2.DSPobjeto.description ="Objeto Gasto";
		
		function Fpago(obj) {
			switch(obj.value) {
				case '1' :
					_divCheque.style.display = 'none';
					_divdivTransferencia.style.display = 'none';
					objForm.LPid.required = false;
					objForm.Bid.required = false;
					objForm.SPctacliente.required = false;
					objForm.SPfechaTrans.required = false;
					objForm.SNnumero.required = false;
				break;
				case '2' :
					_divCheque.style.display = '';
					_divdivTransferencia.style.display = 'none';

					objForm.LPid.required = true;
					objForm.LPid.description ="Lugar Entrega";
					objForm.SPctacliente.required = false;
					objForm.SPfechaTrans.required = false;
					objForm.SNnumero.required = false;
					
				break;
				case '3' :
					_divCheque.style.display = 'none';
					_divdivTransferencia.style.display = '';
					objForm.LPid.required = false;
					objForm.Bid.required = true;
					objForm.Bid.description ="Banco";
					
					objForm.SPctacliente.required = true;
					objForm.SPctacliente.description ="Cuenta Cliente";
					
					objForm.SPfechaTrans.required = true;
					objForm.SPfechaTrans.description ="Fecha Transaccion";
					
					objForm.SNnumero.required = true;
					objForm.SNnumero.description ="Socio de Negocio";
								
				break;
				default:
					_divCheque.style.display = 'none';
					_divdivTransferencia.style.display = 'none';
					objForm.LPid.required = false;
					objForm.SPctacliente.required = false;
					objForm.SPfechaTrans.required = false;
					objForm.SNnumero.required = false;
					
			}
		}
	
		function validaForm(f) {
			alert(f)
			alert('hola')
			
			
			if (f.obj.LPid.value == 2) {
				objForm.LPid.required = true;
			}
		}


    
        function fnAlgunoMarcadolista(){
            if (document.lista.chk) {
                if (document.lista.chk.value) {
                    return document.lista.chk.checked;
                } else {
                    for (var i=0; i<document.lista.chk.length; i++) {
                        if (document.lista.chk[i].checked) { 
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        function funcEliminar(){
            if (!fnAlgunoMarcadolista()){
                alert("¡Debe seleccionar al menos una detalle para eliminar!");
                return false;
            }else{
                if ( confirm("¿Desea eliminar las detalle marcadas?") )	{
                    document.lista.action = 'SolicitudPago-Sql.cfm';
                    return true;
                }
                return false;
            }		
        }
    
    </script>
</cfoutput>