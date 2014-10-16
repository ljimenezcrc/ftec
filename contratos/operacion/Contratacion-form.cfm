<style type="text/css">
	input, select {
		display: block;
		width: 100%;
		height: 30px;
		padding: 6px 12px;
		margin:.5%;
		font-size: 13px;
		line-height: 1.428571429;
		color: #555;
		vertical-align: middle;
		background-color: #fff;
		background-image: none;
		border: 1px solid #ccc;
		border-radius: 4px;
		-webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,0.075);
		box-shadow: inset 0 1px 1px rgba(0,0,0,0.075);
		-webkit-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
	}
</style>
<cfif isdefined('form.modo') and form.modo eq 'CAMBIO'>
    <cfquery name="rsForm" datasource="ftec">
        select a.*,b.TCid ,b.Cdescripcion
        from FTPContratacion a
        inner join FTContratos b
			on b.Cid = a.Cid
        where a.PCid = #form.PCid#
    </cfquery>
</cfif>
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

<cfif isdefined('rsForm') and LEN(TRIM(rsForm.PCid))>
	<input type="hidden" name="PCid" id="PCid" value="<cfoutput>#rsForm.PCid#</cfoutput>" />
</cfif>
<div class="row">
	<!---Contrato--->
	<label for="Cdescripcion" class="col-sm-2" style="text-align:right">Contrato:</label>
	<div class="col-sm-4">
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
	</div>
</div>

<div class="row">
	<!---Tipo de Identificacion--->
	<label for="PCTidentificacion" style="text-align:right" class="col-sm-2">Tipo Identificación:</label>
	<div class="col-sm-4">
		 <select name="PCTidentificacion" id="PCTidentificacion" >
			<option value=""> -- Seleccione una opción --</option>
			<option value="F" <cfif isdefined('rsForm') and rsForm.PCTidentificacion  EQ 'F'>selected="selected"</cfif>>Físico</option>
			<option value="J" <cfif isdefined('rsForm') and rsForm.PCTidentificacion EQ 'J'>selected="selected"</cfif>>Jurídico</option>
		</select>	
	</div>
</div>
<div class="row">
	<!---Identificacion--->
	<label for="PCTidentificacion" style="text-align:right" class="col-sm-2">Identificación:</label>
	<div class="col-sm-4">
		 <input name="PCIdentificacion" placeholder="Identificación" type="text" value="<cfif isdefined('rsForm')><cfoutput>#ltrim(rsForm.PCIdentificacion)#</cfoutput></cfif>" />
	</div>
	<div class="col-sm-2"> <input type="submit" name="btnBuscarOferente" value="Buscar Oferente" class="btn btn-success" /></div>
</div>
<cfif isdefined('rsForm')>
	<!---Nombre Aplellido1 Aplellido2 --->
	
		<label for="PCTidentificacion" style="text-align:right" class="col-sm-2">Nombre:</label>
		<div class="col-sm-2">
			<input name="PCNombre"	width="10" placeholder="Nombre" type="text" value="<cfif isdefined('rsForm')><cfoutput>#rsForm.PCNombre#</cfoutput></cfif>" />
		</div>
		<div class="col-sm-2">
				<input name="PCApellido1" width="10" placeholder="1° Apellido" type="text" value="<cfif isdefined('rsForm')><cfoutput>#rsForm.PCApellido1#</cfoutput></cfif>" />
		</div>
		<div class="col-sm-2">
				<input name="PCApellido2" width="10" placeholder="2° Apellido"  type="text" value="<cfif isdefined('rsForm')><cfoutput>#rsForm.PCApellido2#</cfoutput></cfif>" />
		</div>
	</div>  
	
<!---Sexo--->
<div class="row">
	<label for="PCTidentificacion" style="text-align:right" class="col-sm-2">Sexo:</label>
    <div class="col-sm-4">
		<select name="PCSexo" id="PCSexo">
			<option value=""> -- Seleccione una opción --</option>
			<option value="F" <cfif isdefined('rsForm') and rsForm.PCSexo  EQ 'F'>selected="selected"</cfif>>Femenino</option>
			<option value="M" <cfif isdefined('rsForm') and rsForm.PCSexo EQ 'M'>selected="selected"</cfif>>Masculino</option>
		</select>
	</div>
</div>
<div class="row">
                 <!---Fecha Nacimiento>--->
<label for="PCTidentificacion" style="text-align:right" class="col-sm-2">Fecha Nacimiento:</label>
             <div class="col-sm-4">
					<!---<cfif modo neq 'ALTA'>--->
                    
                    <cfif not isdefined('rsForm.btnBuscarOferente')>
                        <cf_sifcalendario form ="fmContratacion" name="PCFechaN" value="#LSDateFormat(rsForm.PCFechaN,'dd/mm/yyyy')#">
                    <cfelse>
                        <cf_sifcalendario   form ="fmContratacion" name="PCFechaN" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                    </cfif>
              </div>
 </div>
 <div class="row">
            <!---Estado Civil--->
<label for="PCTidentificacion" style="text-align:right" class="col-sm-2">Estado Civil:</label>
             <div class="col-sm-4">
                    <select name="PCEstadoCivil" id="PCEstadoCivil">
                        <option value=""> -- Seleccione una opción --</option>
                        <option value="1" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '1'>selected="selected"</cfif>>Soltero</option>
                        <option value="2" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '2'>selected="selected"</cfif>>Casado</option>
                        <option value="3" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '3'>selected="selected"</cfif>>Divorciado</option>
                        <option value="4" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '3'>selected="selected"</cfif>>Union Libre</option>
                        <option value="5" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '5'>selected="selected"</cfif>>Separado</option>
                   </select>
               </div>
</div>

<div class="btn-group" align="center"> 
  	<button type="submit"  name="btnRegresar" class="btn btn-success">Regresar a la Lista</button>
  <cfif LEN(TRIM(form.Cid))>
  	<button type="submit"  name="btnGContrato"  class="btn btn-info">Guardar Contrato</button>
	<cfif isdefined('rsForm') and LEN(TRIM(rsForm.PCid))>
    <button type="button"  name="btnGContrato"  class="btn btn-success" 
			onclick="window.open('/cfmx/ftec/contratos/reportes/PrintContrato.cfm?PCid=<cfoutput>#rsForm.PCid#</cfoutput>','mywindow')">Contrato Preliminar</button>
	</cfif>
  	<button type="submit"  name="btnTramite" class="btn btn-danger">Enviar a Tramite</button>
  	<button type="submit"  name="btnEliminar"  class="btn btn-danger">Eliminar Contrato</button>
   </cfif>
</div>


</cfif>
        


<hr />
<!---Datos Variables--->
<cfif isdefined('rsForm') and LEN(TRIM(rsForm.PCid))>
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="PrintDatoVariable">
		<cfinvokeargument name="ID_Table" value="#rsForm.PCid#">
		<cfinvokeargument name="ID_Tipo"  value="#rsForm.Cid#">
	</cfinvoke>
</cfif>