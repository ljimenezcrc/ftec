<style>
	#layer1 {
	position: absolute;
	visibility: hidden;
	width: 400px;
	height: 100px;
	left: 150px;
	top: 165px;
	background-color: #ccc;
	border: 1px solid #000;
	padding: 10px;
}
#close {
	float: right;
}
</style>
<cfparam name="Request.jsMask" default="false">

<cfif Request.jsMask EQ false>
	<cfset Request.jsMask = true>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfif>

<script type="text/javascript" src="../../js/popupDiv.js"></script>
<div id="layer1">
  <span id="close"><a href="javascript:setVisible('layer1')" style="text-decoration: none"><strong>Ocultar</strong></a></span>
  <p>Formato de la máscara que se Utilizara para la entrada del Dato Variable.<br /> 
    Utilice 'X' para letras, '?' para números y '*' para letras y números.</p>
  <br>
</div>
<cfif modo EQ 'CAMBIO'>

<cfquery name="DV" datasource="ftec">
	select DVid, DVetiqueta,  DVtipoDato, DVlongitud, DVdecimales, DVmascara, DVobligatorio, <cf_dbfunction name="sPart"	args="DVexplicacion,1,80" > as DVexplicacion
	 from FTDatosVariables
	where DVid = #form.DVid#
</cfquery>

	<cfquery name="DVL" datasource="#session.dsn#">
		select DVid idDVL,rtrim(DVLcodigo) codigoDVL, DVLdescripcion descripcionDVL, coalesce(DVLorden,0) as ordenDVL
		from <cf_dbdatabase table="FTListaValores" datasource="ftec">
  		where DVid = #form.DVid#
	</cfquery>
     
    
 	<cfif isdefined('form.DVLcodigo') and len(trim(form.DVLcodigo)) GT 0>
		<cfquery name="DVLeligido" datasource="#session.dsn#">
			select DVid,rtrim(DVLcodigo) DVLcodigo ,DVLdescripcion, coalesce(DVLorden,0) as DVLorden
			from <cf_dbdatabase table="FTListaValores" datasource="ftec">
			where DVid = #form.DVid#
			and DVLcodigo = '#form.DVLcodigo#'
		</cfquery>

		<cfset modoDet = 'CAMBIO'>
	</cfif>
	<cfset MostrarValoreLista = 'YES'>
</cfif>
<form name="form1" action="DatosVariables-sql.cfm" method="post">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
	<tr><td>
		<input type="hidden" name="MostrarValoreLista" value="<cfoutput>#MostrarValoreLista#</cfoutput>">
		<input type="hidden" name="DVtipoDatoDB" value="<cfoutput>#DV.DVtipoDato#</cfoutput>">
	
	</td><td><cfif modo EQ 'CAMBIO'><input type="hidden" name="DVid" value="<cfoutput>#form.DVid#</cfoutput>"></cfif>
	</td></tr>

	<tr><td>Etiqueta:	</td><td><input name="DVetiqueta" 	 type="text" value="<cfoutput>#DV.DVetiqueta#</cfoutput>" 	 size="30" maxlength="40"> </td></tr>
	
	<tr><td>Tipo de Dato:</td><td>
		    <select name="DVtipoDato" onChange="javascript: showChkbox(this.form);">
		      <option value="C" <cfif DV.DVtipoDato EQ 'C'> selected="true"</cfif>>Texto Corto</option>
		      <option value="V" <cfif DV.DVtipoDato EQ 'V'> selected="true"</cfif>>Texto Largo</option>			  
			  <option value="N" <cfif DV.DVtipoDato EQ 'N'> selected="true"</cfif>>Numérico</option>
			  <option value="L" <cfif DV.DVtipoDato EQ 'L'> selected="true"</cfif>>Lista</option>
			  <option value="F" <cfif DV.DVtipoDato EQ 'F'> selected="true"</cfif>>Fecha</option>
			  <option value="H" <cfif DV.DVtipoDato EQ 'H'> selected="true"</cfif>>Hora</option>
			  <option value="K" <cfif DV.DVtipoDato EQ 'K'> selected="true"</cfif>>Lógico</option>
			</select>
	</td>
	</tr>
	<tr id="TR_DVlongitud"><td>Longitud:</td><td><cf_monto name="DVlongitud" value="#DV.DVlongitud#" size="2" decimales="0">
	<tr id="TR_DVdecimales"><td>Decimales:</td><td><cf_monto name="DVdecimales" value="#DV.DVdecimales#" size="1" decimales="0">
	<tr id="TR_DVmascara">  <td>Mascara:</td><td><input name="DVmascara"  type="text" value="<cfoutput>#DV.DVmascara#</cfoutput>" size="30" maxlength="20">
	<a href="#" onclick="setVisible('layer1');return false" target="_self"><img src="../../imagenes/help_small.gif" width="13" height="13" border="0"/></a>
	</td>
	</tr>
	
	<tr id="TR_DVobligatorio"><td>Obligatorio:</td><td><input type="checkbox" name="DVobligatorio" value="1"<cfif #DV.DVobligatorio# EQ 1>checked="true"</cfif>/></td></tr>
	<tr><td>Explicación:</td><td><textarea name="DVexplicacion" cols="27"><cfoutput>#DV.DVexplicacion#</cfoutput></textarea></td></tr>
	
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="2"><cf_botones modo="#modo#"></td><tr>
</table>

	<table width="100%" border="0" cellspacing="1" cellpadding="1" id="TR_ValorLista">
		<tr><td>Codigo:		</td><td><input name="DVLcodigo" 	  type="text" value="<cfoutput>#DVLeligido.DVLcodigo#</cfoutput>" 	 size="30" maxlength="10"> </td></tr>
		<tr><td>Descripción:</td><td><input name="DVLdescripcion" type="text" value="<cfoutput>#DVLeligido.DVLdescripcion#</cfoutput>" size="30" maxlength="100"></td></tr>
		<tr><td>Orden:</td><td><input name="DVLorden" type="text" value="<cfoutput>#DVLeligido.DVLorden#</cfoutput>" size="10" maxlength="10"></td></tr>
		<tr><td colspan="2">
		<cfif modo EQ 'CAMBIO'>
			
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
				<cfinvokeargument name="query" 				value="#DVL#"/>
				<cfinvokeargument name="desplegar" 			value="codigoDVL,descripcionDVL,ordenDVL"/>
				<cfinvokeargument name="etiquetas" 			value="Codigo,Valor,Orden"/>
				<cfinvokeargument name="formatos" 			value="S,S,I"/>
				<cfinvokeargument name="align" 				value="left,left,left"/>
				<cfinvokeargument name="checkboxes" 		value="N"/>
				<cfinvokeargument name="keys" 				value="idDVL,codigoDVL"/>
				<cfinvokeargument name="MaxRows" 			value="25"/>
				<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
				<cfinvokeargument name="PageIndex" 			value="2"/>
				<cfinvokeargument name="lineaAzul" 		    value="true"/>
				<cfinvokeargument name="formName" 		    value="form1"/>
                <cfinvokeargument name="incluyeform" 		value="false"/>
				<cfinvokeargument name="ira" 				value="DatosVariables.cfm"/>
				<cfinvokeargument name="funcion" 			value="changeFormActionforDetalles"/>
				<cfinvokeargument name="fparams" 			value="idDVL,codigoDVL"/>
				<cfinvokeargument name="PageIndex" 			value="2"/>	
			</cfinvoke>	
		</cfif>	
		</td></tr>
		<tr><td colspan="2" align="center">
		<cfif modoDet EQ 'ALTA'>
			<input type="submit" name="ALTADET" class="btnGuardar"  value="Guardar Valor" onclick="javascript: return otrasValidaciones()"/>
			<input type="reset"  name="LimpiarDET" class="btnLimpiar" value="Limpiar" />
		<cfelse>
			<input type="submit" name="CAMBIODET" class="btnGuardar"  value="Modificar Valor" onclick="javascript: return otrasValidaciones()"/>
			<input type="submit" name="BAJADET"   class="btnEliminar" value="Eliminar Valor" />
			<input type="submit" name="ALTADET"   class="btnNuevo"    value="Nuevo Valor" />
		</cfif>
		
		</td></tr>
	</table>
</form>
<cf_qforms>
 	<cf_qformsRequiredField name="DVetiqueta" 	 description="Etiqueta">
 	<cf_qformsRequiredField name="DVtipoDato"    description="Tipo de Dato">
 </cf_qforms>
<script language="JavaScript" type="text/javascript">
	function showChkbox(f) {
		var TR_DVlongitud = document.getElementById("TR_DVlongitud");
		var TR_DVdecimales = document.getElementById("TR_DVdecimales");
		var TR_DVmascara = document.getElementById("TR_DVmascara");
		TR_DVlongitud.style.display = "";
		TR_DVdecimales.style.display = "";
		TR_DVmascara.style.display = "";
		TR_ValorLista.style.display = "";
		TR_DVobligatorio.style.display = "";
		
		var Mask_1 = new Mask("**********", "string");
	
		if (f.DVtipoDato.value == 'L' || f.DVtipoDato.value == 'F' || f.DVtipoDato.value == 'H' || f.DVtipoDato.value == 'K') {
			TR_DVlongitud.style.display  = "none";
			TR_DVdecimales.style.display = "none";
			TR_DVmascara.style.display   = "none";
			f.DVlongitud.value="0";
			f.DVdecimales.value="0";
			f.DVmascara.value="";
			
		} else if(f.DVtipoDato.value == 'C') {
			TR_DVlongitud.style.display = "none";
			TR_DVdecimales.style.display = "none";
			f.DVlongitud.value="0";
			f.DVdecimales.value="0";
		} else if(f.DVtipoDato.value == 'V') {
			TR_DVlongitud.style.display = "none";
			TR_DVdecimales.style.display = "none";
			TR_DVmascara.style.display   = "none";
			f.DVlongitud.value="0";
			f.DVdecimales.value="0";
			f.DVmascara.value="";
		} else if(f.DVtipoDato.value == 'N') {
			TR_DVmascara.style.display   = "none";
			f.DVmascara.value="";
		}
		if (f.DVtipoDatoDB.value != 'L' || f.DVtipoDato.value != 'L'|| f.MostrarValoreLista.value == 'FALSE'){
			TR_ValorLista.style.display = "none";
		}
		if (f.DVtipoDato.value == 'K'){
			TR_DVobligatorio.style.display = "none";
		}
	}
	function changeFormActionforDetalles(idDVL,codigoDVL){
	
		document.form1.DVLcodigo.value = codigoDVL;
		document.form1.action = "DatosVariables.cfm";
		document.form1.submit();
	}
	function otrasValidaciones()
	{
		var camposlista = '';
	if (document.form1.DVLcodigo.value =='')
		{
			camposlista = '-El codigo es requerido';
		}
		if (document.form1.DVLdescripcion.value =='')
		{
			camposlista = camposlista+'\n-La descripcion es requerida';
		}
		if(camposlista == '')
			return true;
		else
		{
			alert('Se Presentaron los siguientes Errores:\n'+camposlista);
		return false;
		}
	}
	showChkbox(document.form1);
</script>
