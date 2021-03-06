﻿
<cf_templateheader title="Aprobación Contratos">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aprobación de Contrato'>
        <cf_importLibs>
        <!---<script src="/cfmx/jquery/librerias/jquery.blockUI2.66.js"></script> --->
        <script language="JavaScript1.2" type="text/javascript">
 
            function Comentario(PCid) 
            { 
              window.open('/cfmx/ftec/contratos/operacion/PopupComentario.cfm?PCid='+PCid,'popup','width=850,height=400','mywindow');
            }


            function VerContrato(PCid) 
            { 
              window.open('/cfmx/ftec/contratos/reportes/PrintContrato.cfm?PCid='+PCid,'mywindow');
            }

			function NoEjecutado(PCid){ 
				var Aprueba = 3
				var dataP = {
					method: "EnviarTramite",
					 PCid:  PCid,
					 Aprueba:  Aprueba     
					}
	
					try {
						$.ajax ({
							type: "get",
							url: "/cfmx/ftec/Componentes/FTTramitesContratacion.cfc",
							data: dataP,
							dataType: "json",
							success: function( objResponse ){
	
							 var lista = objResponse.DATA;
	
									
								},
							error:  function( objRequest, strError ){
								alert('ERROR'+objRequest + ' - ' + strError);
								console.log(objRequest);
								console.log(strError);
								}
						});
					} catch(ss){
					 alert('FALLO Inesperado');
					 console.log(ss);
					}
 
                    $('form[name=fmContratacion]').submit();
				}
            
        </script>
        <form name="fmContratacion" class="form-inline"  role="form" action="FiniquitoContrato.cfm" method="post">
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
                            
                            ,{fn concat('<img border=''0''  width= ''40%''  onClick=''NoEjecutado(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/finiquito6.jpg''>')})}  as NoEjecutadoStr

                            ,{fn concat('<img border=''0''  width= ''40%''  onClick=''VerContrato(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/Finiquito2.png''>')})}  as VerStr

                            ,{fn concat('<img border=''0''  width= ''40%''  onClick=''Comentario(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/ver.gif''>')})}  as ComStr
                        from FTPContratacion a
                            inner join FTContratos b
                                on b.Cid = a.Cid
                        where a.PCEstado in ('A')
                    </cfquery>


                    <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                        <cfinvokeargument name="query" value="#rsLista#"/>
                        <cfinvokeargument name="desplegar" value=" Cdescripcion,PCIdentificacion, Nombre, PCEstado,NoEjecutadoStr,VerStr,ComStr"/>
                        <cfinvokeargument name="etiquetas" value="Contrato, Identificación, Nombre, Estado, No ejecutado,Revisar,Comentario"/>
                        <cfinvokeargument name="formatos" value=" S, S, S, S,I,I,I"/>
                        <cfinvokeargument name="align" value="left, left, left,  left, center, center, center"/>
                        <cfinvokeargument name="ajustar" value="true"/>
                        <cfinvokeargument name="keys" value="PCid"/>
                        <cfinvokeargument name="incluyeForm" value="false"/>
                        <cfinvokeargument name="formName" 	value="fmContratacion"/>
                        <cfinvokeargument name="showLink"   value="false"/>
                            
                    </cfinvoke>
                  
            	</div>
            </div>

        </form>

    <cf_web_portlet_end>                                                                            
<cf_templatefooter>

