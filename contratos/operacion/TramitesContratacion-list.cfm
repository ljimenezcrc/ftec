<cf_templateheader title="Contratos">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Creación de Contrato'>

        <script language="JavaScript" type="text/JavaScript">
        <!--
        function VerContrato(var) {  //reloads the window if Nav4 resized
          alert(PCid);
          <!---window.open('/cfmx/ftec/contratos/reportes/PrintContrato.cfm?PCid=<cfoutput>#PCid#</cfoutput>','mywindow')"--->
        }


        </script>
        <form name="fmContratacion" class="form-inline"  role="form" action="TramitesContratacion-list.cfm" method="post">
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
                            ,{fn concat('<img border=''0'' width= ''15%'' onClick=''eliminar(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/rechaza.png''>')})}  as RechazaStr

                            ,{fn concat('<img border=''0''  width= ''15%''  onClick=''eliminar(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/aprueba.png''>')})}  as ApruebaStr

                            ,{fn concat('<img border=''0''  width= ''30%''  onClick=''VerContrato(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/ver.gif''>')})}  as VerStr
                        from FTPContratacion a
                            inner join FTContratos b
                                on b.Cid = a.Cid
                        where a.PCEstado = 'T'
                    </cfquery>


                    <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                        <cfinvokeargument name="query" value="#rsLista#"/>
                        <cfinvokeargument name="desplegar" value=" Cdescripcion,PCIdentificacion, Nombre, PCEstado,ApruebaStr,RechazaStr,VerStr"/>
                        <cfinvokeargument name="etiquetas" value="Contrato, Identificación, Nombre, Estado, Aprueba, Rechaza,Revizar"/>
                        <cfinvokeargument name="formatos" value=" S, S, S, S,I,I,I"/>
                        <cfinvokeargument name="align" value="left, left, left,  left, center, center, center"/>
                        <cfinvokeargument name="ajustar" value="true"/>
                        <cfinvokeargument name="keys" value="PCid"/>
                        <cfinvokeargument name="incluyeForm" value="false"/>
                        <cfinvokeargument name="formName" 	value="fmContratacion"/>
                        <cfinvokeargument name="showLink"   value="false"/>
                            
                    </cfinvoke>
                    <!---<cfinvokeargument name="cortes" value="NombreC"/>
                    <cfinvokeargument name="irA" value="Contratacion.cfm"/>--->
                  
            	</div>
            </div>

<!---             <div class="row">
                <div class="col-sm-12" align="center">
            		<input type="submit" name="btnNContracion" class="btn btn-info"     value="Nueva Contración" />
                </div>
            </div>  --->

        </form>

    <cf_web_portlet_end>                                                                            
<cf_templatefooter>

