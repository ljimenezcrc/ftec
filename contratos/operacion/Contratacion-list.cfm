<div class="row">
    <div class="col-sm-12">
        <cfquery name="rsLista" datasource="#session.DSN#">
            select 
             '' as RHIECfecha, '' as CentroFuncional, 0 as RHIECmonto,'' as Adelanto,'' as Provision, '' as Carga
            from dual
        </cfquery>

        <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
            <cfinvokeargument name="query" value="#rsLista#"/>
            <cfinvokeargument name="desplegar" value=" RHIECfecha, CentroFuncional, RHIECmonto,Adelanto,Provision, Carga"/>
            <cfinvokeargument name="etiquetas" value="#LB_Fecha#, #LB_CentroFuncional#, #LB_Monto#, #LB_Adelanto#, #LB_Provision#, #LB_CargaProvision# "/>
            <cfinvokeargument name="formatos" value=" D, S, M, S,S,S"/>
            <cfinvokeargument name="align" value="left, left, right, center, center, left"/>
            <cfinvokeargument name="ajustar" value="N"/>
            <cfinvokeargument name="irA" value="RegistroInfCesantiaHist.cfm"/>
            <cfinvokeargument name="keys" value="RHIECmonto"/>
        </cfinvoke>
        
<!---<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
<cfinvokeargument name="query" 		value="#rsContratoAll#"/>
<cfinvokeargument name="desplegar" 	value="Cdescripcion"/>
<cfinvokeargument name="etiquetas" 	value="Contrato"/>
<cfinvokeargument name="formatos" 	value="V"/>
<cfinvokeargument name="align" 		value="left"/>
<cfinvokeargument name="ajustar" 	value="N"/>
<cfinvokeargument name="botones" 	value="Nuevo"/>
<cfinvokeargument name="irA" 		value="contratos.cfm"/>
<cfinvokeargument name="keys" 		value="Cid"/>
<cfinvokeargument name="MaxRows" 	value="100"/>
<cfinvokeargument name="formName" 	value="listaAcciones"/>
</cfinvoke>
--->        
	</div><!---<cfinvokeargument name="cortes" value="NombreC"/>--->
</div>

<div class="row">
    <div class="col-sm-12" align="center">
        <!---<input type="submit" name="btnRegresar" class="btn btn-success"  value="Lista" />
        <input type="submit" name="btnGuardar"  class="btn btn-primary"  value="Guardar Encabezado Contrato" />
        <cfif len(trim(form.Cid))>--->
            <input type="submit" name="btnNContracion" class="btn btn-info"     value="Nueva Contración" />
            <!---<input type="submit" name="btnEliminar" class="btn btn-danger"   value="Eliminar Contrato" />
		</cfif> --->
    </div>
</div> 
