
<cfif isdefined('form.modo') and form.modo eq 'CAMBIO'>
    <cfquery name="rsForm" datasource="ftec">
        select a.*,b.TCid ,b.Cdescripcion
        from FTPContratacion a
        inner join FTContratos b
			on b.Cid = a.Cid
        where a.PCid = #form.PCid#
    </cfquery>
</cfif>


	<cfif isdefined('rsForm') and LEN(TRIM(rsForm.PCid))>
		<input type="hidden" name="PCid" id="PCid" value="<cfoutput>#rsForm.PCid#</cfoutput>" />
	</cfif>
	<table align="center">
    	<!---Contrato--->
        <tr> 
              <td align="right" nowrap="nowrap">&nbsp;<strong>Contrato:</strong>&nbsp;</td>
              <td>
                <cfset arrValuesCambio = ArrayNew(1)>
                <cfif isdefined('modo') and modo NEQ 'ALTA'>
                    <cfif len(trim(rsForm.Cid))>
                        <cfset ArrayAppend(arrValuesCambio, rsForm.Cid)>
                        <cfset ArrayAppend(arrValuesCambio, rsForm.TCid)>
                        <cfset ArrayAppend(arrValuesCambio, rsForm.Cdescripcion)>							
                    </cfif>
                <cfelse>
	                <cfif isdefined('rsForm') and len(trim(rsForm.Cid))>
                        <cfset ArrayAppend(arrValuesCambio, rsForm.Cid)>
                        <cfset ArrayAppend(arrValuesCambio, rsForm.TCid)>
                        <cfset ArrayAppend(arrValuesCambio, rsForm.Cdescripcion)>							
                    </cfif>
                </cfif>
       
                    <cfset filtroExtra = "">
                    <cfset select = " b.TCcodigo, b.TCdescripcion,a.Cid, a.TCid, a.Cdescripcion" >
                    <cfset from = " FTContratos a
                                    inner join FTTipoContrato b
                                    on b.TCid = a.TCid ">
                    <cfset where = " 1 = 1 order by a.TCid " >
        
                    <cf_conlis 
                        campos="Cid, TCid, Cdescripcion"
                        size="0,0,40"
                        conexion="ftec"
                        desplegables="N,N,S"
                        modificables="N,N,N"
                        valuesArray="#arrValuesCambio#"
                        title="#LB_ListaContratos#"
                        tabla="#from#"
                        columnas="#select#" 
                        filtro = "#where# #filtroExtra#"
                        filtrar_por=""
                        filtrar_por_delimiters="|"
                        desplegar="Cdescripcion"
                        etiquetas="Contrato"
                        formatos="S"
                        align="left,left,left"
                        asignar="Cid, TCid,Cdescripcion"
                        asignarFormatos="S,S,S"
                        form="fmContratacion"
                        showEmptyListMsg="true"
                        Cortes="TCdescripcion"
                        EmptyListMsg=" --- No Existen Contratos definidos --- "/>		
              </td>
            </tr>
            
            <!---Tipo de Identificacion--->
            <tr>
                <td align="right">Tipo Identificación:</td>
                <td>
                    <select name="PCTidentificacion" id="PCTidentificacion">
                        <option value=""> -- Seleccione una opción --</option>
                        <option value="F" <cfif isdefined('rsForm') and rsForm.PCTidentificacion  EQ 'F'>selected="selected"</cfif>>Físico</option>
                        <option value="J" <cfif isdefined('rsForm') and rsForm.PCTidentificacion EQ 'J'>selected="selected"</cfif>>Jurídico</option>
                    </select>
                </td>
            </tr>
            
            <!---Identificacion--->
            <tr>
                <td align="right">Identificación:</td>
                <td>
                    <input name="PCIdentificacion" type="text" value="<cfif isdefined('rsForm')><cfoutput>#ltrim(rsForm.PCIdentificacion)#</cfoutput></cfif>" />
                    <input type="submit" name="btnBuscarOferente"     value="Buscar Oferente" />
                </td>
            </tr>
            <cfif isdefined('rsForm')>
            <!---Nombre Aplellido1 Aplellido2 --->
            <tr>
                <td align="right">Nombre:</td>
                <td>
                    <input name="PCNombre" type="text" value="<cfif isdefined('rsForm')><cfoutput>#rsForm.PCNombre#</cfoutput></cfif>" />
                </td>
                <td align="right">Apellido1:</td>
                <td>
                    <input name="PCApellido1" type="text" value="<cfif isdefined('rsForm')><cfoutput>#rsForm.PCApellido1#</cfoutput></cfif>" />
                </td>
                <td align="right">Apellido2:</td>
                <td>
                    <input name="PCApellido2" type="text" value="<cfif isdefined('rsForm')><cfoutput>#rsForm.PCApellido2#</cfoutput></cfif>" />
                </td>
            </tr>
            <!---Sexo--->
            <tr>
                <td align="right">Sexo:</td>
                <td>
                    <select name="PCSexo" id="PCSexo">
                        <option value=""> -- Seleccione una opción --</option>
                        <option value="F" <cfif isdefined('rsForm') and rsForm.PCSexo  EQ 'F'>selected="selected"</cfif>>Femenino</option>
                        <option value="M" <cfif isdefined('rsForm') and rsForm.PCSexo EQ 'M'>selected="selected"</cfif>>Masculino</option>
                    </select>
                </td>
                 <!---Fecha Nacimiento>--->
                 <td align="right">Fecha Nacimiento:</td>
                <td>
					<!---<cfif modo neq 'ALTA'>--->
                    
                    <cfif not isdefined('rsForm.btnBuscarOferente')>
                        <cf_sifcalendario form ="fmContratacion" name="PCFechaN" value="#LSDateFormat(rsForm.PCFechaN,'dd/mm/yyyy')#">
                    <cfelse>
                        <cf_sifcalendario   form ="fmContratacion" name="PCFechaN" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                    </cfif>
                </td>
                      
            <!---Estado Civil--->
                <td align="right">Estado Civil:</td>
                <td>
                    <select name="PCEstadoCivil" id="PCEstadoCivil">
                        <option value=""> -- Seleccione una opción --</option>
                        <option value="1" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '1'>selected="selected"</cfif>>Soltero</option>
                        <option value="2" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '2'>selected="selected"</cfif>>Casado</option>
                        <option value="3" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '3'>selected="selected"</cfif>>Divorciado</option>
                        <option value="4" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '3'>selected="selected"</cfif>>Union Libre</option>
                        <option value="5" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '5'>selected="selected"</cfif>>Separado</option>
                   </select>
                </td>
            </tr>
             
            <tr>
            	<td colspan="6" rowspan="2" valign="middle" align="center"><br/>
                    <div class="btn-group">
                    <input type="submit" name="btnRegresar" class="btn btn-success"  value="Regresar a la Lista" />
                    <cfif LEN(TRIM(form.Cid))>
                        <input type="submit" name="btnGContrato" class="btn btn-info"     value="Guardar Contrato" />
                        <input type="submit" name="btnTramite" class="btn btn-danger"   value="Enviar a Tramite" />
                        <input type="submit" name="btnEliminar" class="btn btn-danger"   value="Eliminar Contrato" />
                    </cfif>
                    </div>
                </td>
            </tr>
            </cfif>
        

		</tr>
	</table>

<style type="text/css">
	border: 1px solid #b6b6b6;
</style>