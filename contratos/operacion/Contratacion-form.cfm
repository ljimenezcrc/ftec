<style type="text/css">
	input, select {
		display: block;
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
		left join FTVicerrectoria c 
			on c.Vid = a.Vid
        where a.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
    </cfquery>


    <cfquery name="rsProyectos" datasource="#Session.DSN#">
        select a.*, b.Vcodigo as Vcodigoresp, b.Vdescripcion as Vdescripcionresp , b.Vid as Vpkresp
        from  <cf_dbdatabase table="FTPContratacion " datasource="ftec"> a
        inner join <cf_dbdatabase table="FTVicerrectoria " datasource="ftec"> b
	        on a.Vid = b.Vid       
        where a.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
    </cfquery>
</cfif>



<cfif isdefined('rsForm')>
    <cfquery name="rsProyectos" datasource="#Session.DSN#">
        select b.Vcodigo as Vcodigoresp, b.Vdescripcion as Vdescripcionresp , b.Vid as Vpkresp, b.Vid
        from  <cf_dbdatabase table="FTVicerrectoria " datasource="ftec"> b
	    where b.Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Vid#">
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
	<label for="Vcodigoresp" style="text-align:right" class="col-sm-2">Proyecto:</label>
	<div class="col-sm-4">
		<cfif isdefined('rsForm') and isdefined('rsProyectos')>
	        <cf_FTvicerrectoria form="fmContratacion"  size="30"  name="Vcodigoresp" desc="Vdescripcionresp" titulo="Seleccione Proyecto" proyectos="1"  usuario="1" query="#rsProyectos#"> 
	    <cfelse>
	        <cf_FTvicerrectoria tabindex="1" form="fmContratacion" size="30" id="Vid" name="Vcodigoresp" desc="Vdescripcionresp" titulo="Seleccione Proyecto" proyectos="1"  usuario="1">
	    </cfif>
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
<!--- <label for="PCTidentificacion" style="text-align:right" class="col-sm-2">Fecha Nacimiento:</label>
             <div class="col-sm-4">
					<!---<cfif modo neq 'ALTA'>--->
                    
                    <cfif not isdefined('rsForm.btnBuscarOferente')>
                        <cf_sifcalendario form ="fmContratacion" name="PCFechaN" value="#LSDateFormat(rsForm.PCFechaN,'dd/mm/yyyy')#">
                    <cfelse>
                        <cf_sifcalendario   form ="fmContratacion" name="PCFechaN" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                    </cfif>
              </div>
 </div> --->
 <div class="row">
            <!---Estado Civil--->
<label for="PCTidentificacion" style="text-align:right" class="col-sm-2">Estado Civil:</label>
             <div class="col-sm-4">
                    <select name="PCEstadoCivil" id="PCEstadoCivil">
                        <option value=""> -- Seleccione una opción --</option>
                        <option value="1" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '1'>selected="selected"</cfif>>Soltero</option>
                        <option value="6" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '6'>selected="selected"</cfif>>Soltera</option>
                        <option value="2" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '2'>selected="selected"</cfif>>Casado</option>
                        <option value="7" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '7'>selected="selected"</cfif>>Casada</option>
                        <option value="3" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '3'>selected="selected"</cfif>>Divorciado</option>
                        <option value="8" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '8'>selected="selected"</cfif>>Divorciada</option>
                        <option value="5" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '5'>selected="selected"</cfif>>Separado</option>
                        <option value="9" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '9'>selected="selected"</cfif>>Separada</option>
						<option value="10" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '10'>selected="selected"</cfif>>Viudo</option>
                        <option value="11" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '11'>selected="selected"</cfif>>Viuda</option>
                        <option value="4" <cfif isdefined('rsForm') and rsForm.PCEstadoCivil  EQ '4'>selected="selected"</cfif>>Union Libre</option>
                   </select>
               </div>
</div>


<div class="row">
<!---Fecha Aprobacion--->
<label for="PCFechaA" style="text-align:right" class="col-sm-2">Fecha Aprobación:</label>
             <div class="col-sm-4">
					<!---<cfif modo neq 'ALTA'>--->
                    
                    <cfif not isdefined('rsForm.btnBuscarOferente') and  isdefined('rsForm.PCFechaA')>
                        <cf_sifcalendario form ="fmContratacion" name="PCFechaA" value="#LSDateFormat(rsForm.PCFechaA,'dd/mm/yyyy')#">
                    <cfelse>
                        <cf_sifcalendario   form ="fmContratacion" name="PCFechaA" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                    </cfif>
              </div>
 </div>
 <div class="row">



<div class="row">
<!---Fecha Firmas--->
<label for="PCFechaF" style="text-align:right" class="col-sm-2">Fecha Firmas:</label>
             <div class="col-sm-4">
					<!---<cfif modo neq 'ALTA'>--->
                    
                    <cfif not isdefined('rsForm.btnBuscarOferente') and  isdefined('rsForm.PCFechaF')>
                        <cf_sifcalendario form ="fmContratacion" name="PCFechaF" value="#LSDateFormat(rsForm.PCFechaF,'dd/mm/yyyy')#">
                    <cfelse>
                        <cf_sifcalendario   form ="fmContratacion" name="PCFechaF" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                    </cfif>
              </div>
 </div>
 <div class="row">



<div class="btn-group" align="center"> 
  	<button type="submit"  name="btnRegresar" class="btn btn-success">Regresar a la Lista</button>
	<cfif isdefined('form.btnBuscarOferente') >  	
        <button type="submit"  name="btnGContrato"  class="btn btn-info">Guardar Contrato</button>
    </cfif>
   <cfif LEN(TRIM(form.Cid))>
		<cfif isdefined('rsForm') and LEN(TRIM(rsForm.PCid))>
	        <button type="submit"  name="btnGContrato"  class="btn btn-info">Guardar Contrato</button>
	    	<button type="button"  name="btnGContrato"  class="btn btn-success" 
				onclick="window.open('/cfmx/ftec/contratos/reportes/PrintContrato.cfm?PCid=<cfoutput>#rsForm.PCid#</cfoutput>','mywindow')">Contrato Preliminar</button>
        <cfif not isdefined('form.PCestado')>  	    
            <button type="submit"  name="btnEliminar"  class="btn btn-danger">Eliminar Contrato</button>
        </cfif>
		</cfif>
		<cfif isdefined('form.PCestado') and form.PCestado neq 'Aprobado' >  	
			<button type="submit"  name="btnTramite" class="btn btn-danger">Enviar a aprobar</button>
		  	<button type="submit"  name="btnEliminar"  class="btn btn-danger">Eliminar Contrato</button>
		</cfif>
   </cfif>
</div>


</cfif>
        


<hr />
<!---Datos Variables--->
<cfif isdefined('rsForm') and LEN(TRIM(rsForm.PCid))>
	<cfinvoke component="ftec.Componentes.FTDatosVariables" method="PrintDatoVariable">
		<cfinvokeargument name="ID_Table" value="#rsForm.PCid#">
		<cfinvokeargument name="ID_Tipo"  value="#rsForm.Cid#">
        <cfinvokeargument name="form"     value="fmContratacion">
	</cfinvoke>
</cfif>