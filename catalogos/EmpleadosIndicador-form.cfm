<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" 	Default="Periodo" 	returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" 		Default="Mes" 		returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Filtrar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>

<cf_dbfunction name="op_concat" returnvariable="_cat">


<cfif isdefined('form.CHK')>
	<cfquery name="rsDelete" datasource="#session.DSN#">
		delete from <cf_dbdatabase table="FTEmpleadoIndicador" datasource="ftec">  where EIid in (#form.CHK#)
	</cfquery>
</cfif>

<cf_dbfunction name="concat" args="'<img src=/cfmx/ftec/imagenes/check.gif style=cursor:pointer />', ''" returnvariable="imgNoAplica">

<cf_dbdatabase table="FTEmpleadoIndicador" datasource="ftec" returnvariable = "FTEmpleadoIndicador" >


<cfquery name="rsListaEmpleados" datasource="#session.DSN#">
    select  e.EIid, e.DEid, e.CFid, cf.CFcodigo, cf.CFdescripcion, cf.CFcodigo #_cat# ' - ' #_cat# cf.CFdescripcion as CentroFuncional,
    de.DEapellido1 #_cat# ' ' #_cat#  de.DEapellido2  #_cat# ' ' #_cat#  de.DEnombre as Nombre 
    , e.EImes as mes, e.EIperiodo as periodo
    ,cf.CFcodigo #_cat# ' - ' #_cat# cf.CFdescripcion  #_cat# ' - ' #_cat# <cf_dbfunction name="to_char"	args=" e.EIperiodo"  len="4" > 
    #_cat#  ' - '  #_cat# <cf_dbfunction name="to_char"	args=" e.EImes"  len="2" > 
    #_cat#  ' - [ '  #_cat#  
    <cf_dbfunction name="to_char"	args=" (select count(a.DEid) from #preservesinglequotes(FTEmpleadoIndicador)#   a where a.CFid = e.CFid and a.EImes = e.EImes and a.EIperiodo = e.EIperiodo and coalesce(a.EInoaplica,0) = 0 )"  len="4" > 
    #_cat#  ' ] Empleados'  
     as CentroFuncionalPeriodoMes
     ,case when coalesce(e.EInoaplica,0) = 1 then #preservesinglequotes(imgNoAplica)# 
            else
            ''
      end as NoAPlica
      ,(select count(a.DEid) from <cf_dbdatabase table="FTEmpleadoIndicador" datasource="ftec"> a where a.CFid = e.CFid and a.EImes = e.EImes and a.EIperiodo = e.EIperiodo and coalesce(a.EInoaplica,0) = 0 ) as Cantidad
    from <cf_dbdatabase table="FTEmpleadoIndicador" datasource="ftec"> e
    inner join DatosEmpleado de
        on e.DEid  = de.DEid
    inner join CFuncional cf
        on e.CFid = cf.CFid
    where 1=1
		<cfif isdefined('form.BtnFiltrar') and isdefined('form.mes') and #form.mes# GT 0>
            and e.EImes = #form.mes#
        </cfif>
        <cfif isdefined('form.BtnFiltrar') and isdefined('form.periodo')and #form.periodo# GT 0>
            and e.EIperiodo = #form.periodo#
        </cfif>
        <cfif isdefined('form.BtnFiltrar') and isdefined('form.LISTACFUNCIONAL2') and #form.LISTACFUNCIONAL2# GT 0>
             and e.CFid in (#LISTACFUNCIONAL2#)
        </cfif>
    order by e.EIperiodo, e.EImes, cf.CFcodigo,de.DEapellido1 #_cat# ' ' #_cat#  de.DEapellido2  #_cat# ' ' #_cat#  de.DEnombre
</cfquery>      

<cfoutput>

<form name="lista" method="post" action="EmpleadoIndicadoresTabs.cfm?tab=2">
    <table width="100%" cellpadding="3" cellspacing="0" align="center" border="0">
        <tr>		
             <td align="right"><b><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</b></td>
            <td align="left">
                <cf_rhcfuncional index="2" AgregarEnLista = "true" form='lista'>
            </td>
            <td width="272" align="right"><b>#LB_Periodo#:&nbsp;</b></td>
            <td colspan="2">
                <select name="periodo">
                    <option value=""></option>
                    <cfloop index="i" from="-5" to="0">
                        <cfset vn_anno = year(DateAdd("yyyy", i, now()))>
                        <option value="#vn_anno#">#vn_anno#</option>
                    </cfloop>
                </select>
            </td>
          <cfset paso = 1>	
            <td align="right"><b>#LB_Mes#:&nbsp;</b></td>
            <td colspan="2">
                <select name="mes">	<option value=""></option>
                    <cfloop query="rsMeses">
                        <option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
                    </cfloop>
                </select>
             </td>
        </tr>
        <tr>				
            <td colspan="8" align="center">
                <input type="submit" name="btnfiltrar" value="#BTN_Consultar#" class="BTNAplicar">
            </td>
        </tr>
    </table>	
    
    <table width="100%">             
        <tr>
            <td>
            <cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                <cfinvokeargument name="query" value="#rsListaEmpleados#"/>
                <cfinvokeargument name="desplegar" value="Nombre, CentroFuncional, periodo, mes,NoAPlica"/>
                <cfinvokeargument name="etiquetas" value="Empleado,Centro Funcional, Periodo, Mes,No APlica "/>
                <cfinvokeargument name="formatos" value="S,S,S,S,I"/>
                <cfinvokeargument name="align" value=" left, left, center, center,center"/>
                <cfinvokeargument name="ajustar" value="N"/>
                <cfinvokeargument name="cortes" value="CentroFuncionalPeriodoMes"/>
                <cfinvokeargument name="checkboxes" value="S"/>
                <cfinvokeargument name="keys" value="EIid"/>
                <cfinvokeargument name="MaxRows" value="100"/>
                <cfinvokeargument name="formName" value="lista"/> <!------>
                <cfinvokeargument name="debug" value="N"/>
                <cfinvokeargument name="incluyeForm" value="true"/>	
                <cfinvokeargument name="botones" value="Eliminar"/>	
                <cfinvokeargument name="PageIndex" value="2">
                <cfinvokeargument name="showLink" value="false">
                
                </cfinvoke>
            </td>
        </tr>
    </table>
</form>
</cfoutput>
<script language="JavaScript">
<cfoutput>
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
			alert("¡Debe seleccionar al menos un empleado para eliminar!");
			return false;
		}else{
			if ( confirm("Desea cambiar el estado del empleado para ser tomado en cuenta en el indicador?") )	{
				document.lista.action = 'EmpleadosIndicador-SQL.cfm';
				return true;
			}
			return false;
		}		
	}
</cfoutput>	
</script>	