<cfset Form.Archivo = 'N'>

<cfquery name="rsAno" datasource="#Session.DSN#">
	SELECT distinct Speriodo 
	FROM CGPeriodosProcesados
	where Ecodigo = #Session.Ecodigo#
	order by Speriodo desc	
</cfquery>

<!---

<cfif  isDefined("url.Archivo")>
	<cfset Form.Archivo = url.Archivo>
</cfif>
<cfif not isDefined("Form.Archivo")>
	
</cfif>

<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Oficodigo, Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = #session.Ecodigo#
	order by Oficodigo, Odescripcion
</cfquery>
<cfquery name="rsGE" datasource="#session.DSN#">
	select ge.GEid, ge.GEnombre
	from AnexoGEmpresa ge
		join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid
	where ge.CEcodigo = #session.CEcodigo#
	  and gd.Ecodigo = #session.Ecodigo#
	order by ge.GEnombre
</cfquery>
<cfquery name="rsGO" datasource="#session.DSN#">
	select GOid, GOnombre
	from AnexoGOficina
	where Ecodigo = #session.Ecodigo#
	order by GOnombre
</cfquery>
--->
<cfquery name="rsMes" datasource="#Session.DSN#">
	select a.Speriodo, a.Smes, b.VSdesc as SmesDes
	from CGPeriodosProcesados a
		inner join VSidioma b on
			<cf_dbfunction name='to_char' args='a.Smes'> = b.VSvalor
		inner join Idiomas c on
			b.Iid = c.Iid
	where a.Ecodigo = #session.Ecodigo#
		and c.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
	order by a.Speriodo, a.Smes
</cfquery>

<!---
<cfset VCEcodigo = #Session.CEcodigo#>

<cfquery name="rsNiveles" datasource="#Session.DSN#">
select Max(A.PCNid) as Nmax
from PCNivelMascara A, PCEMascaras B
where A.PCEMid = B.PCEMid
  and B.CEcodigo = #VCEcodigo#
</cfquery>

<cfset VNmax = rsNiveles.Nmax>
<cfif VNmax LT 3 or len(trim(rsNiveles.Nmax)) EQ 0>
	<cfset VNmax = 6>
</cfif>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select  a.Cconcepto, Cdescripcion
	from ConceptoContableE a
	where a.Ecodigo = #Session.Ecodigo#
	  and   not exists ( select 1 
			     from UsuarioConceptoContableE b 
			     where a.Ecodigo = #Session.Ecodigo#
	  and   a.Cconcepto = b.Cconcepto
	  and   a.Ecodigo   = b.Ecodigo)
	UNION
	select a.Cconcepto, Cdescripcion 
	from ConceptoContableE a,UsuarioConceptoContableE b
	where a.Ecodigo   = #Session.Ecodigo#
	  and a.Cconcepto = b.Cconcepto
	  and a.Ecodigo   = b.Ecodigo
	  and Usucodigo   = #session.CEcodigo#	
       Order by 1
</cfquery>
--->

<cfquery name="rsListaIndicadores" datasource="#session.DSN#">
    Select Iid, Icodigo, Idescripcion,Ecodigo	
    	,Icodigo +' - ' +  <cf_dbfunction name="sPart" args="Idescripcion,1,80"> as descripcion
    From <cf_dbdatabase table="FTIndicador " datasource="ftec">
    Where Ecodigo= #session.Ecodigo# 
    order by Icodigo 
</cfquery>

</script>

<cfoutput>
<form method="post" action="GenerarReporte.cfm" name="form1"  style="MARGIN:0;">  <!---onSubmit="return validar();"  --->
	<table width="100%" border="0" cellspacing="2" cellpadding="2" >
    	<tr>
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong>Tipo de Indicador</strong></td>
		</tr>
        <tr>
			<td width="14%"><strong>Tipo de Indicador :</strong></td>
            <td  colspan="3">
            <select name="Indicador" id="Indicador" >
                <option  title="" value=""  >-- Seleccione una opción --</option>
                <cfloop query="rsListaIndicadores">
                    <option  title="#rsListaIndicadores.Idescripcion#" value="#rsListaIndicadores.Iid#">#rsListaIndicadores.descripcion# </option>
                </cfloop>
            </select>
				</td>
		</tr>	

		<tr>
			<td width="14%"><strong>Tipo de Reporte :</strong></td>
			<td  colspan="3">
				<select name="ID_REPORTE" >
					<option value="3">Una Lista de Cuentas Contables</option>
				</select>
			</td>
		</tr>
		
		<!---<tr>
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong>Cuenta Contable</strong></td>
        <tr>
        	<td align="center" colspan="4" >
        	<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr> 
                        <td valign="top">
                            <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="ListaCuentasInd">
                                <cfinvokeargument name="query" value="#rsCuentasInd#"/>
                                 <cfinvokeargument name="columnas"			value="CIid,Cuenta,Indicador,borrar"/>
                                <cfinvokeargument name="desplegar"			value="Cuenta,borrar"/>
                                <cfinvokeargument name="etiquetas"			value="Cuentas"/>
                                <cfinvokeargument name="formatos"			value="S,S"/>
                                <cfinvokeargument name="align" 				value="left,center"/>
                                <cfinvokeargument name="ajustar" 			value="N"/>
                                <cfinvokeargument name="checkboxes" 		value="N"/>
                                <cfinvokeargument name="keys" 				value="CIid,Indicador"/>
                                <cfinvokeargument name="showEmptyListMsg" 	value="true"/> 
                                <cfinvokeargument name="incluyeform" 		value="true"/> 
                                <cfinvokeargument name="formName" 			value="FListaCuentas"/> 
                                <cfinvokeargument name="PageIndex" 			value="4">
                            </cfinvoke>
                        </td>
                    </tr>
           </table>
           </td>
        </tr>    
            
		</tr>--->
		<tr>
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong>Criterios para Filtrar</strong></td>
		</tr>			
		<!---<tr>
			<td><strong>Nivel Detalle:</strong></td>
			<td width="24%">
				<select name="nivelDet" size="1" id="nivel" tabindex="1">
				  <cfloop index="i" from="0" to="#VNmax#">
					<option value="#i#">#i#</option>
				  </cfloop>
				</select>			
			</td>

			<cfif Form.Archivo eq 'N'>

				<td width="14%"><strong>Nivel Total:</strong></td>
				<td width="48%" >
					<select name="nivelTot" size="1" id="nivel" tabindex="1">
					  <cfloop index="i" from="0" to="#VNmax#">
					  	<option value="#i#">#i#</option>
					  </cfloop>
					</select>				  
				</td>	
			<cfelse>
				<td colspan="2"><input type="hidden" name="nivelTot" value="0">&nbsp;</td>
			</cfif>

		</tr>--->

		<tr>
			<td ><strong>A&ntilde;o Inicio:</strong></td>
			<td  >
				<select name="PeriodoInicio"  onChange="javascript:cambiar_meses(this);"  tabindex="1"> 
					<cfloop query="rsAno"> 
						<option value="#rsAno.Speriodo#">#rsAno.Speriodo#</option>
					</cfloop>
				</select>		
			</td>
            	
            <td ><strong>A&ntilde;o Final:</strong></td>
			<td  >
				<select name="PeriodoFinal"  tabindex="1">
					<cfloop query="rsAno"> 
						<option value="#rsAno.Speriodo#">#rsAno.Speriodo#</option>
					</cfloop>
				</select>		
			</td>
			<td >&nbsp;</td>
			<td>&nbsp;
				
			</td>			
		</tr>		
		<tr>
			<td>
				<strong>
				<INPUT  tabindex="-1" 
					ONFOCUS="this.blur();" 
					NAME="ETQINI" 
					ID  ="ETQINI" 
					VALUE="Mes Inicial:" 
					size="15"  
					style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
				>	
				</strong>
			</td>
			<td>
				<select name="MesInicial" id="MesInicial" tabindex="1">
					<option value="">-- seleccionar --</option>
				</select>
			</td>
			<td>
				<strong>
				<INPUT  tabindex="-1" 
					ONFOCUS="this.blur();" 
					NAME="ETQFIN" 
					ID  ="ETQFIN" 
					VALUE="Mes Final:" 
					size="15"  
					style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
				>	
				</strong>
			</td>
			<td>
				<select name="MesFinal" id="MesFinal" tabindex="1">
					<option value="">-- seleccionar --</option>
				</select>
			</td>
		</tr>
		<tr>  
			<td   align="center" colspan="4">
				<input type="submit" name="Reporte" value="Procesar" id="Procesar" onClick="" tabindex="1">
				<input type="reset" name="Limpiar"  value="Limpiar" tabindex="1">
			</td><!---onClick="javascript: if (window.OcultarCeldas) return OcultarCeldas();"--->
		</tr> 
	</table>

</form>
<cf_qforms form="form1">
	<cf_qformsRequiredField name="Indicador"  description="Tipo de Indicador">
</cf_qforms>
</cfoutput>

<script language="JavaScript1.2">
function descarga(obj){
	alert(obj);
}

	/*********************************************************************************************************/
 	function cambio_MESINI(obj){
		var form = obj.form;
		var combo = form.MesInicial;
		combo.length = 0;
		var i = 0;
		<cfoutput query="rsMes">
			var tmp = #rsMes.Speriodo# ;
			if ( obj.value != '' && tmp != '' && parseFloat(obj.value) == parseFloat(tmp) ) {
				combo.length++;
				combo.options[i].text = '#rsMes.SmesDes#';
				combo.options[i].value = '#rsMes.Smes#';
				i++;
			}
		</cfoutput>
	}
	/*********************************************************************************************************/
	function cambio_MESFIN(obj){
		var form = obj.form;
		var combo = form.MesFinal;
		combo.length = 0;
		var i = 0;
		<cfoutput query="rsMes">
			var tmp = #rsMes.Speriodo# ;
			if ( obj.value != '' && tmp != '' && parseFloat(obj.value) == parseFloat(tmp) ) {
				combo.length++;
				combo.options[i].text = '#rsMes.SmesDes#';
				combo.options[i].value = '#rsMes.Smes#';
				i++;
			}
		</cfoutput>
	}
	/*********************************************************************************************************/
	function cambiar_meses(obj){
		cambio_MESINI(obj);
		cambio_MESFIN(obj);
	}
	/*********************************************************************************************************/
   
	function validar() {
		var errores = "";
		 

		
		if (document.form1.MesInicial.value.length == 0) {
			errores = errores + '- El campo mes inicial  es requerido.\n';
		}
		if (document.form1.MesFinal.value.length == 0) {
			errores = errores + '- El campo mes final es requerido.\n';
		}
		if (errores != "") {
			alert('Se presentaron los siguientes errores:\n' + errores);
			return false;
		}	
		
		document.form1.Procesar.disabled = true;
		
	}	
	/*********************************************************************************************************/
	function Precarga() {
		cambiar_meses(document.form1.Periodos)
	}
	Precarga() ;
	/*********************************************************************************************************/
	   
	/********************************************************************************************************/
	function fnNuevaCuentaContable()	{	
		var LvarTable 	= document.getElementById("tblcuenta");
		var LvarTbody 	= LvarTable.tBodies[0];
		var LvarTR    	= document.createElement("TR");
		var Lclass 		= document.form1.LastOneCuenta;
		FrameFunction();
		var cuenta		 = document.form1.CtaFinal.value	
		var vectorcuenta = cuenta.split('-');
		var p1 = "";
		for(i=0;i < vectorcuenta.length;i++) {
			if(vectorcuenta[i].length > 0)
				p1 = p1 + vectorcuenta[i] + '-';
		}
		p1 = p1.substring(0,p1.length-1) 

		if (p1=="") {
			return;
		}	

		if (existeCodigoCuenta(p1)) {
			alert('La Cuenta Contable ya fue agregada.');
			return;
		}

		if(document.form1.ID_REPORTE.value == '2' && p1.indexOf('_',0) > -1){
			LimpiaCajas();
			alert('Para este tipo de reporte no se pueden utilizar comodines');
			return;
		}

		sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CuentaidList");
		sbAgregaTdText  (LvarTR, Lclass.value, p1);
		sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
		if (document.all) {
			GvarNewTD.attachEvent ("onclick", sbEliminarTR);
		}
		else {
			GvarNewTD.addEventListener ("click", sbEliminarTR, false);
		}
		LvarTR.name = "XXXXX";
		LvarTbody.appendChild(LvarTR);
		if (Lclass.value=="ListaNon") {
			Lclass.value="ListaPar";
		}
		else {
			Lclass.value="ListaNon";
		}
		var cant = new Number(document.form1.CuentasADD.value);
		cant = cant + 1;
		document.form1.CuentasADD.value = cant;

		if(document.form1.ID_REPORTE.value == '2' && cant >= 2)
		{
			document.form1.AGRE.disabled 	= true;		
		}	
				
		LimpiaCajas();
	}	
	/*********************************************************************************************************/
	function existeCodigoCuenta(v){
		var LvarTable = document.getElementById("tblcuenta");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			if (data[0] == v) {
				return true;
			}
		}
		return false;
	}
	/*********************************************************************************************************/
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
		var LvarTD    = document.createElement("TD");
		var LvarInp   = document.createElement("INPUT");
		LvarInp.type = LprmType;
		if (LprmName != "") {
			LvarInp.name = LprmName;
		}
		
		if (LprmValue != "") {
			LvarInp.value = LprmValue +"|" 
			+ document.form1.nivelDet.value +"|"		 
			+ document.form1.nivelTot.value;

		} 

		LvarTD.appendChild(LvarInp);
		if (LprmClass!="") { 
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LprmTR.appendChild(LvarTD);
	}
	/*********************************************************************************************************/
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
		var LvarTD    = document.createElement("TD");
		var LvarTxt   = document.createTextNode(LprmValue);
		LvarTD.appendChild(LvarTxt);
		if (LprmClass!="") {
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LvarTD.noWrap = true;
		LprmTR.appendChild(LvarTD);
	}
	/*********************************************************************************************************/
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align){
		var LvarTDimg 	= document.createElement("TD");
		var LvarImg 	= document.getElementById(LprmNombre).cloneNode(true);
		LvarImg.style.display="";
		LvarImg.align=align;
		LvarTDimg.appendChild(LvarImg);
		if (LprmClass != "") {
			LvarTDimg.className = LprmClass;
		}
		GvarNewTD = LvarTDimg;
		LprmTR.appendChild(LvarTDimg);
	}
	/*********************************************************************************************************/
	function sbEliminarTR(e){
		var LvarTR;
		if (document.all) {
			LvarTR = e.srcElement;
		}
		else {
			LvarTR = e.currentTarget;
		}
		while (LvarTR.name != "XXXXX") {
			LvarTR = LvarTR.parentNode;
		}
		LvarTR.parentNode.removeChild(LvarTR);
		var cant = new Number(document.form1.CuentasADD.value);
		cant = cant -1;
		document.form1.CuentasADD.value = cant;
        if(document.form1.ID_REPORTE.value == '2' && cant < 2){
			document.form1.AGRE.disabled 	= false;		
		}		
	}
	/*********************************************************************************************************/
	function fnTdValue(LprmNode){
		var LvarNode = LprmNode;
		while (LvarNode.hasChildNodes()) {
			LvarNode = LvarNode.firstChild;
			if (document.all == null) {
				if (!LvarNode.firstChild && LvarNode.nextSibling != null && LvarNode.nextSibling.hasChildNodes()) {
					LvarNode = LvarNode.nextSibling;
				}
			}
		}
		if (LvarNode.value) {
			return LvarNode.value;
		} 
		else {
			return LvarNode.nodeValue;
		}
	}
	/*********************************************************************************************************/
	function ACTIVAMESES(){
		var ETQINI  	= document.getElementById("ETQINI");
		var ETQFIN  	= document.getElementById("ETQFIN");
		var MesInicial  = document.getElementById("MesInicial");
		var MesFinal  	= document.getElementById("MesFinal");
		switch(document.form1.TipoFormato.value) {
			case '1': {
					ETQFIN.style.visibility='hidden';
					MesFinal.style.visibility='hidden';
					MesInicial.style.visibility='visible';
					ETQINI.style.visibility='visible';		
					
					document.form1.ETQINI.value ='Mes:';
				break;
			}
			case '2': {
					ETQINI.style.visibility='hidden';
					ETQFIN.style.visibility='hidden';
					MesInicial.style.visibility='hidden';
					MesFinal.style.visibility='hidden';
				break;
			}
			case '3': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					MesInicial.style.visibility='visible';
					ETQINI.style.visibility='visible';	
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}
			case '4': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					MesInicial.style.visibility='visible';
					ETQINI.style.visibility='visible';	
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}		
			case '5': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					MesInicial.style.visibility='visible';
					ETQINI.style.visibility='visible';	
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}									
		}	
	}
	<cfif Form.Archivo eq 'S'>
		ACTIVAMESES()
	</cfif>	
	
	
</script>
