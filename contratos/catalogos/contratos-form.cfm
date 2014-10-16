<!---<cfloop query="rsFTSeccionesD">
    <div class="row">
        <div class="col-xs-3"><cfoutput>#rsFTSeccionesD.Variable#</cfoutput></div>
        <div class="col-xs-3">
            <select onchange="SaveDataVar(this,<cfoutput>#rsFTSeccionesD.SDid#</cfoutput>)" name="<cfoutput>#rsFTSeccionesD.SDid#</cfoutput>" id="<cfoutput>#rsFTSeccionesD.SDid#</cfoutput>">
                    <option value="">Seleccione un Valor</option>
                <optgroup label="Datos Personales">
                    <option value="2" <cfif rsFTSeccionesD.TVariables EQ 2> selected="selected"</cfif>>Tipo de Identificación</option>
                    <option value="3" <cfif rsFTSeccionesD.TVariables EQ 3> selected="selected"</cfif>>Identificación</option>
                    <option value="4" <cfif rsFTSeccionesD.TVariables EQ 4> selected="selected"</cfif>>Nombre</option>
                    <option value="5" <cfif rsFTSeccionesD.TVariables EQ 5> selected="selected"</cfif>>Primer Apellido</option>
                    <option value="6" <cfif rsFTSeccionesD.TVariables EQ 6> selected="selected"</cfif>>Segundo Apellido</option>
                    <option value="7" <cfif rsFTSeccionesD.TVariables EQ 7> selected="selected"</cfif>>Sexo</option>
                    <option value="8" <cfif rsFTSeccionesD.TVariables EQ 8> selected="selected"</cfif>>Fecha Nacimiento</option>
                </optgroup>
                <optgroup label="Datos del Contrato">
                    <option value="9"  <cfif rsFTSeccionesD.TVariables EQ 9> selected="selected"</cfif>>Numero Contrato</option>
                    <option value="10" <cfif rsFTSeccionesD.TVariables EQ 10> selected="selected"</cfif>>Periodo Contratación</option>
                    <option value="11" <cfif rsFTSeccionesD.TVariables EQ 11> selected="selected"</cfif>>Fecha de Creación</option>
                    <option value="12" <cfif rsFTSeccionesD.TVariables EQ 12> selected="selected"</cfif>>Fecha de Aprobación</option>
                    <option value="13" <cfif rsFTSeccionesD.TVariables EQ 13> selected="selected"</cfif>>Fecha de Firmas</option>
                </optgroup>
                
                <optgroup label="Datos Variables">
                    <cfif rsFTDatosVariables.RecordCount>
                        <cfloop query="rsFTDatosVariables">
                            <cfoutput>
                                <option value="1,#rsFTDatosVariables.DVid#" <cfif rsFTSeccionesD.TVariables EQ 1 AND rsFTSeccionesD.DVid eq rsFTDatosVariables.DVid> selected="selected"</cfif>>
                                    #rsFTDatosVariables.DVetiqueta#
                                </option>
                            </cfoutput>
                        </cfloop>
                    <cfelse>
                        <option value="" disabled="disabled">No existen Datos Variables</option>	
                    </cfif>
                </optgroup>
            </select>
        </div>
    </div>
</cfloop>
--->
<form name="fmContratos" action="contratos.cfm" method="post">
	<cfif LEN(TRIM(rsContrato.Cid))>
		<input type="hidden" name="Cid" id="Cid" value="<cfoutput>#rsContrato.Cid#</cfoutput>" />
	</cfif>
	<table align="center">
        <tr>
			<td align="right">Tipo Contrato:</td>
			<td>
				<select name="TCid" id="TCid">
					<option value="">Sin tipo</option>
					<cfloop query="rsTipoContrato">
						<cfoutput>
							<option value="#rsTipoContrato.TCid#" <cfif rsContrato.TCid EQ rsTipoContrato.TCid>selected="selected"</cfif>>#rsTipoContrato.TCdescripcion#</option>
						</cfoutput>
					</cfloop>
				</select>
			</td>
			<td align="right">Estado:</td>
			<td>
				<select name="Cestado" id="Cestado">
					<option value="I" <cfif rsContrato.Cestado EQ 'I'>selected="selected"</cfif>>Inactivo</option>
					<option value="A" <cfif rsContrato.Cestado EQ 'A'>selected="selected"</cfif>>Activo</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right">Trámite:</td>
			<td>
				<select name="CidTramite" id="CidTramite">
					<option value="">Sin Trámite</option>
				</select>
			</td>
		</tr>	
		<tr>
			<td align="right">Descripción:</td>
			<td colspan="3">
				<textarea name="Cdescripcion" id="Cdescripcion" cols="50"><cfoutput>#rsContrato.Cdescripcion#</cfoutput></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="4" rowspan="2" valign="middle" align="center"><br/>
				<div class="btn-group">
				<input type="submit" name="btnRegresar" class="btn btn-success"  value="Lista" />
				<input type="submit" name="btnGuardar"  class="btn btn-primary"  value="Guardar Encabezado Contrato" />
				<cfif LEN(TRIM(form.Cid))>
				<input type="submit" name="btnGSeccion" class="btn btn-info"     value="Agregar Sección" />
				<input type="submit" name="btnEliminar" class="btn btn-danger"   value="Eliminar Contrato" />
				</cfif>
				</div>
			</td>
		</tr>
	</table>
</form>

<cfif rsSeccion.RecordCount>
	<cf_tabs width="100%">
		<cf_tab text="Secciones del Contrato">
			<div class="alert alert-info">
				<cfloop query="rsSeccion">
					<div ondblclick="Editar(<cfoutput>#rsSeccion.Sid#</cfoutput>);">
						<form name="formSeccion_<cfoutput>#rsSeccion.Sid#</cfoutput>" action="contratos.cfm" method="post">
							<input type="hidden" name="Sid" 		value="<cfoutput>#rsSeccion.Sid#</cfoutput>">
							<input type="hidden" name="Cid" 		value="<cfoutput>#rsSeccion.Cid#</cfoutput>">
							<input type="hidden" name="btnGSeccion" value="<cfoutput>#rsSeccion.Sid#</cfoutput>">
							<div id="Text_<cfoutput>#rsSeccion.Sid#</cfoutput>"><cfoutput>#rsSeccion.STexto#</cfoutput></div>
							<div class="Editor" id="Edit_<cfoutput>#rsSeccion.Sid#</cfoutput>">
								<div class="cke_inner cke_reset Controles">
									<select name="Cpermisos" id="Cpermisos">
										<option value="M" <cfif rsSeccion.Cpermisos EQ 'M'>selected="selected"</cfif>>Modificable</option>
										<option value="N" <cfif rsSeccion.Cpermisos EQ 'N'>selected="selected"</cfif>>No Modificable</option>
										<option value="E" <cfif rsSeccion.Cpermisos EQ 'E'>selected="selected"</cfif>>Extendible</option>
									</select>
								</div>
								<cf_rheditorhtml ControlsE="[ 'Save']," name="editor_#rsSeccion.Sid#" value="#rsSeccion.STexto#" height="400" toolbarset="Default" type="full">
							</div>
						</form>
					</div>
				</cfloop>
			</div>
		</cf_tab>
		<cf_tab text="Información Variable de la Sección">
			<div class="alert alert-info">
			<cfif rsFTSeccionesD.RecordCount>
				<cfloop query="rsFTSeccionesD">
					<div class="row">
						<div class="col-xs-3"><cfoutput>#rsFTSeccionesD.Variable#</cfoutput></div>
						<div class="col-xs-3">
							<select onchange="SaveDataVar(this,<cfoutput>#rsFTSeccionesD.SDid#</cfoutput>)" name="<cfoutput>#rsFTSeccionesD.SDid#</cfoutput>" id="<cfoutput>#rsFTSeccionesD.SDid#</cfoutput>">
									<option value="">Seleccione un Valor</option>
								<optgroup label="Datos Personales">
									<option value="2"  <cfif rsFTSeccionesD.TVariables EQ 2>  selected="selected"</cfif>>Tipo de Identificación</option>
									<option value="3"  <cfif rsFTSeccionesD.TVariables EQ 3>  selected="selected"</cfif>>Identificación</option>
									<option value="4"  <cfif rsFTSeccionesD.TVariables EQ 4>  selected="selected"</cfif>>Nombre</option>
									<option value="5"  <cfif rsFTSeccionesD.TVariables EQ 5>  selected="selected"</cfif>>Primer Apellido</option>
									<option value="6"  <cfif rsFTSeccionesD.TVariables EQ 6>  selected="selected"</cfif>>Segundo Apellido</option>
									<option value="7"  <cfif rsFTSeccionesD.TVariables EQ 7>  selected="selected"</cfif>>Sexo</option>
									<option value="8"  <cfif rsFTSeccionesD.TVariables EQ 8>  selected="selected"</cfif>>Fecha Nacimiento</option>
									<option value="14" <cfif rsFTSeccionesD.TVariables EQ 14> selected="selected"</cfif>>Estado Civil</option>
								</optgroup>
								<optgroup label="Datos del Contrato">
									<option value="9"  <cfif rsFTSeccionesD.TVariables EQ 9>  selected="selected"</cfif>>Numero Contrato</option>
									<option value="10" <cfif rsFTSeccionesD.TVariables EQ 10> selected="selected"</cfif>>Periodo Contratación</option>
									<option value="11" <cfif rsFTSeccionesD.TVariables EQ 11> selected="selected"</cfif>>Fecha de Creación</option>
									<option value="12" <cfif rsFTSeccionesD.TVariables EQ 12> selected="selected"</cfif>>Fecha de Aprobación</option>
									<option value="13" <cfif rsFTSeccionesD.TVariables EQ 13> selected="selected"</cfif>>Fecha de Firmas</option>
								</optgroup>
								
								<optgroup label="Datos Variables">
									<cfif rsFTDatosVariables.RecordCount>
										<cfloop query="rsFTDatosVariables">
											<cfoutput>
												<option value="1,#rsFTDatosVariables.DVid#" <cfif rsFTSeccionesD.TVariables EQ 1 AND rsFTSeccionesD.DVid eq rsFTDatosVariables.DVid> selected="selected"</cfif>>
													#rsFTDatosVariables.DVetiqueta#
												</option>
											</cfoutput>
										</cfloop>
									<cfelse>
										<option value="" disabled="disabled">No existen Datos Variables</option>	
									</cfif>
								</optgroup>
							</select>
						</div>
					</div>
				</cfloop>
			<cfelse>
				Para crear variables, escriba en las secciones del contrato el nombre de la variable sin espacios y dentro de gatos.</br>
				<strong>Ejemplo:</strong> Portador de la cedula de identifidad #NumeroCedula#.
			</cfif>		
			</div>	
		</cf_tab>
	</cf_tabs>
<cfelseif LEN(TRIM(rsContrato.Cid))>
	<div class="alert alert-info">
		Pulse el boton "Agregar sección" para agregar nuevas clausulas
	</div>
<cfelse>
	<div class="alert alert-info">
		Pulse el boton "Guardar Encabezado Contrato" para agregar crear un contrato
	</div>
</cfif>
COSAS QUE FALTAN:<br />
-Mensajes de confirmación de las acciones<br />
-Homologación de Variables del contrato<br />

<script language="javascript" type="text/javascript">
	function Editar(Sid){
		 $('#Edit_'+Sid).show();
		 $('#Text_'+Sid).hide();
	}
	function SaveDataVar(lvarSelect,SDid,DVid){
		//Tipo de variable
		TVariables = $(lvarSelect).val().split(',',2)[0];
		//ID del dato Variable
		if (TVariables == 1) 
			DVid=$(lvarSelect).val().split(',',2)[1]; 
		else 
			DVid = -1;
		//SE HACER EL AJAX PARA GUARDA EL VALOR
  		var dataP = {
			method: "updateDatosVariable",
		 	SDid:  		SDid,
		  	TVariables: TVariables,
			DVid: 		DVid
		}


		try {
			$.ajax ({
				type: "get",
				url: "/cfmx/ftec/Componentes/FTContratos.cfc",
				data: dataP,
				dataType: "json",
				success: function( objResponse ){},
				error:  function( objRequest, strError ){
					alert('ERROR '+objRequest + ' - ' + strError);
					console.log(objRequest);
					console.log(strError);
					}
			});
		} catch(ss){
		 alert('FALLO Inesperado');
		 console.log(ss);
		}
		}
	$('.Editor').hide();
	
</script>
<style type="text/css">
	border: 1px solid #b6b6b6;
</style>