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
    From FTIndicador
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
				<select name="PeriodoInicio"  tabindex="1"> 
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
		<!---<tr>
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
		</tr>--->
		<tr>  
			<td   align="center" colspan="4">
				<input type="submit" name="Reporte" value="Procesar" id="Procesar" onClick="" tabindex="1">
				<input type="reset" name="Limpiar"  onClick="javascript: if (window.OcultarCeldas) return OcultarCeldas();"value="Limpiar" tabindex="1">
			</td>
		</tr> 
	</table>

</form>
<cf_qforms form="form1">
	<cf_qformsRequiredField name="Indicador"  description="Tipo de Indicador">
</cf_qforms>
</cfoutput>
