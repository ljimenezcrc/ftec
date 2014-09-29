<cf_dbfunction name="op_concat" returnvariable="_cat">

<div class="row">
    <div class="col-sm-12">
        <cfquery name="rsLista" datasource="ftec">
            select a.PCid
                , a.Cid
                ,a.PCTidentificacion
                ,a.PCIdentificacion
                ,a.PCApellido1 #_cat# ' ' #_cat#  a.PCApellido2  #_cat# ' ' #_cat# a.PCNombre as Nombre
                ,case 
                    when a.PCEstado = 'P' then 'Proceso'
                    when a.PCEstado = 'T' then 'Tramite'
                    when a.PCEstado = 'A' then 'Aprobado'
                    when a.PCEstado = 'R' then 'Rechazado'
                    when a.PCEstado = 'F' then 'Finiquito'
                end as PCEstado
                
                ,a.PCEnumero
                ,a.PCEPeriodo
                ,b.Cdescripcion
            from FTPContratacion a
                inner join FTContratos b
                    on b.Cid = a.Cid
        </cfquery>

        <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
            <cfinvokeargument name="query" value="#rsLista#"/>
            <cfinvokeargument name="desplegar" value=" Cdescripcion,PCIdentificacion, Nombre, PCEstado"/>
            <cfinvokeargument name="etiquetas" value="Contrato, Identificación, Nombre, Estado"/>
            <cfinvokeargument name="formatos" value=" S, S, S, S"/>
            <cfinvokeargument name="align" value="left, left, left,  left"/>
            <cfinvokeargument name="ajustar" value="N"/>
            <cfinvokeargument name="irA" value="Contratacion.cfm"/>
            <cfinvokeargument name="keys" value="PCid"/>
            <cfinvokeargument name="formName" 	value="fmContratacion"/>
        </cfinvoke>
        <!---<cfinvokeargument name="cortes" value="NombreC"/>--->
        
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
	</div>
</div>

<div class="row">
    <div class="col-sm-12" align="center">
		<input type="submit" name="btnNContracion" class="btn btn-info"     value="Nueva Contración" />
    </div>
</div> 
