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
			<td align="right">Tr�mite:</td>
			<td>
				<select name="CidTramite" id="CidTramite">
					<option value="">Sin contrato</option>
				</select>
			</td>
		</tr>	
		<tr>
			<td align="right">Descripci�n:</td>
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
				<input type="submit" name="btnGSeccion" class="btn btn-info"     value="Agregar Secci�n" />
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
		<cf_tab text="Informaci�n Variable de la Secci�n">
		</cf_tab>
	</cf_tabs>
<cfelse>
	<div class="alert alert-info">
		Pulse el boton "Agregar secci�n" para agregar nuevas clausulas
	</div>
</cfif>
COSAS QUE FALTAN:<br />
-Mensajes de confirmaci�n de las acciones<br />
-Al eliminar los contratos se debe eliminas las secciones y los datos variables asociados a las secciones<br />

<script language="javascript" type="text/javascript">
	function Editar(Sid){
		 $('#Edit_'+Sid).show();
		 $('#Text_'+Sid).hide();
	}
	 $('.Editor').hide();
</script>
<style type="text/css">
	border: 1px solid #b6b6b6;
</style>