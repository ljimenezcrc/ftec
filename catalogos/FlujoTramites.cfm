<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_FTEC"
    Default="FTEC - Administraci&oacute;n del Sistema"
    returnvariable="LB_FTEC"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_CatalogoFlujoTramites"
    Default="Cat&aacute;logo Flujo Tramites"
    returnvariable="LB_CatalogoFlujoTramites"/>

<cf_templateheader title="#LB_FTEC#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoFlujoTramites#'>
		<cfinclude template="../../rh/portlets/pNavegacion.cfm">

        <cf_dbfunction name="OP_concat" datasource="#session.dsn#" returnvariable="_Cat">
               
        <cfquery name="rsFTramitesLista" datasource="#session.dsn#">
            select 
                a.FTid
                , a.TTid
                , a.ETid
                , a.FTpasoactual
                , a.FTpasoaprueba
                , a.FTpasorechaza
                , coalesce(a.FTautoriza,0) as FTautoriza
                , b.ETcodigo #_Cat# ' - ' #_Cat#  b.ETdescripcion as Estado
                , c.TTcodigo #_Cat# ' - ' #_Cat# c.TTdescripcion as Tramite
               <!--- , d.TAcodigo #_Cat# ' - ' #_Cat# d.TAdescripcion as Autorizados--->
            from <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> a
                inner join <cf_dbdatabase table="FTEstadoTramite" datasource="ftec"> b
                    on a.ETid = b.ETid
                inner join <cf_dbdatabase table="FTTipoTramite" datasource="ftec"> c
                    on a.TTid = c.TTid
                <!---inner join FTTipoAutorizador d
                    on a.TAid = d.TAid--->
            order by c.TTcodigo #_Cat# ' - ' #_Cat# c.TTdescripcion ,  a.FTpasoactual
        </cfquery>     
        
        
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                    	<cfinvokeargument name="query" 				value="#rsFTramitesLista#"/>
                        <cfinvokeargument name="columnas"			value=" FTid
                                                                            , TTid
                                                                            , ETid
                                                                            , FTpasoactual
                                                                            , FTpasoaprueba
                                                                            , FTpasorechaza
                                                                            , Estado
                                                                            , Tramite
                                                                            "/>
                        <cfinvokeargument name="desplegar"			value=" Tramite
                                                                            , Estado
                                                                            , FTpasoactual
                                                                            , FTpasoaprueba
                                                                            , FTpasorechaza"/>
                        <cfinvokeargument name="etiquetas"			value="Tramite, Estado, Paso, Aprueba, Rechaza"/>
                        <cfinvokeargument name="formatos"			value="S,S,S,S,S"/>
                        <cfinvokeargument name="align"				value="left, left, center, center, center"/>
                        <cfinvokeargument name="ajustar"			value="N,N,N,N,N"/>
                        <cfinvokeargument name="checkboxes"			value="N"/>
                        <cfinvokeargument name="MaxRows"			value="15"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="filtrar_automatico"	value="true"/>
                        <cfinvokeargument name="mostrar_filtro"		value="true"/>
                        <cfinvokeargument name="keys"				value="FTid"/>
                        <cfinvokeargument name="irA"				value="FlujoTramites.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg"	value="true"/>
					</cfinvoke>
				</td>
				<td  align="left" valign="top" width="50%">
					<cfinclude template="FlujoTramitesForm.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>