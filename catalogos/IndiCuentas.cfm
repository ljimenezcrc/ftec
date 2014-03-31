<cf_dbfunction name="to_char" args="CIid" returnvariable="Lvar_IdLinea">
<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif  onclick=BorrarLinea(' | #Lvar_IdLinea# |') style=cursor:pointer />'" delimiters="|"  returnvariable="Lvar_delRegistro">

<cf_dbfunction name="op_concat" returnvariable="_cat">

<cf_dbdatabase table="FTGrupoCuentas" datasource="ftec" returnvariable = "FTGrupoCuentas">



<cfquery name="rsCuentasInd" datasource="#Session.DSN#" >
	Select CIid,Cuenta,Iid, (select b.GCcodigo from #preservesinglequotes(FTGrupoCuentas)# b where b.GCid = a.GCid ) as Grupo
    ,#preservesinglequotes(Lvar_delRegistro)# as borrar
	from  <cf_dbdatabase table="FTCuentasIndicadores" datasource="ftec"> a
	where Iid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Iid#">
    order by Cuenta
</cfquery>

<cfquery name="rsGrupos" datasource="#Session.DSN#" >
	Select GCid,Iid,GCcodigo,GCdescripcion , (GCcodigo #_cat# ' - ' #_cat# GCdescripcion) as Descripcion
	from  <cf_dbdatabase table="FTGrupoCuentas" datasource="ftec">
	where Iid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Iid#">
</cfquery>

<cfset modoCU = 'ALTA'>

<cfquery name="rsIndicador" datasource="#session.dsn#">
	select Icodigo, Idescripcion 
    from  <cf_dbdatabase table="FTIndicador" datasource="ftec">
	where Iid='#form.Iid#' 
</cfquery>

<cfif len(trim(rsIndicador.Idescripcion)) gt 0>
	<cfset Lvardesc= "#trim(rsIndicador.Icodigo)# - #rsIndicador.Idescripcion#">
</cfif>

<cfoutput>
<form action="IndiCuentasSQL.cfm" method="post" name="form1">
    <input name="Iid" type="hidden" value="<cfif isdefined('form.Iid')> <cfoutput>#form.Iid#</cfoutput></cfif>"> 
    
    <input type="hidden" name="CtaFinal" value="">
    <input type="hidden" name="CIid" value="0">
    
    <input type="hidden" name="Agregar" value="">
    <input type="hidden" name="Borrar" value="">
    
    
    
    
	<table width="100%" height="75%" align="center" cellpadding="1" cellspacing="0">
	<tr>
        <td align="left" colspan="2">
            <strong><font size="2">Indicador:</font></strong> 
            <font size="2"><cfoutput>#Lvardesc#</cfoutput></font>
        </td>
    </tr>
    <tr></tr>
    <tr>
			<td  colspan="4"  nowrap="nowrap">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" >
					<tr>
					<td width="14%"  ><strong>Cuenta Contable:</strong></td>

					<td width="3%">
						<input type="text" name="Cmayor" maxlength="4" size="4" onBlur=	"javascript:CargarCajas(this.value)" value="" tabindex="1">				
					</td>
					<td width="48%">	
						<iframe marginheight="0"
                            marginwidth="0" 
                            scrolling="no" 
                            name="cuentasIframe" 
                            id="cuentasIframe" 
                            width="100%" 
                            height="20" 
                            frameborder="0">
                        </iframe>
					</td>
					</tr>
                    <tr>
                        <td ><strong>Agrupar Cuentas:</strong></td>
                        <td colspan="8">
                            <select name="GCid"  id="GCid" tabindex="1"> 
                                <option  title="" value="" ></option>
                                <cfloop query="rsGrupos">
                                    <option  title="#rsGrupos.GCcodigo#" value="#rsGrupos.GCid#">#rsGrupos.Descripcion#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td>
                            <input type="button" name="btn_addCuenta" value="Agregar" class="btnGuardar" onclick="javascript:if (window.fnNuevaCuentaContable) fnNuevaCuentaContable();"/>	
                        </td>
					</tr>                        
				</table>
                <table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr> 
                        <td valign="top">
                            <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="ListaCuentasInd">
                                <cfinvokeargument name="query" value="#rsCuentasInd#"/>
                                 <cfinvokeargument name="columnas"			value="CIid,Cuenta,Iid,Grupo,borrar"/>
                                <cfinvokeargument name="desplegar"			value="Cuenta,Grupo,borrar"/>
                                <cfinvokeargument name="etiquetas"			value="Cuentas, Grupo"/>
                                <cfinvokeargument name="formatos"			value="S,S,S"/>
                                <cfinvokeargument name="align" 				value="left,left,center"/>
                                <cfinvokeargument name="ajustar" 			value="N"/>
                                <cfinvokeargument name="checkboxes" 		value="N"/>
                                <cfinvokeargument name="keys" 				value="CIid,Iid"/>
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

        <tr valign="baseline"> 
		</tr>
	</table>
    </form>
</cfoutput>


<script language="JavaScript1.2">

	function BorrarLinea(id) {
		document.form1.Borrar.value=1;
		document.form1.Agregar.value=0;
		document.form1.CIid.value=id;
		document.form1.submit();
	}

	/*********************************************************************************************************/
	function CargarCajas(Cmayor) {

		if (document.form1.Cmayor.value != '') {
			var a = '0000' + document.form1.Cmayor.value;
			a = a.substr(a.length-4, 4);
			document.form1.Cmayor.value = a;
		}
		var fr = document.getElementById("cuentasIframe");
		fr.src = "/cfmx/sif/Utiles/generacajas2.cfm?Cmayor="+document.form1.Cmayor.value+"&MODO=ALTA&TipoCuenta=C"
	}
	/*********************************************************************************************************/
	function FrameFunction() {
		// RetornaCuenta2() es máscara completa, rellena con comodín
		if(window.parent.cuentasIframe.RetornaCuenta2){
			window.parent.cuentasIframe.RetornaCuenta2();
		}
	}	
	/*********************************************************************************************************/

	/********************************************************************************************************/
	function fnNuevaCuentaContable()	{	
		FrameFunction();
		var cuenta		 = document.form1.CtaFinal.value
		document.form1.Borrar.value=0;
		document.form1.Agregar.value=1;
		document.form1.submit();		
		LimpiaCajas();
	}	
	/*********************************************************************************************************/
	
</script>



