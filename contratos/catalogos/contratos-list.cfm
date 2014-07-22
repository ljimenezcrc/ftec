<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
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