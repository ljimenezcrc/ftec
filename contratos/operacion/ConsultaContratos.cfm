
<cf_templateheader title="Consulta Contratos">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Contrato'>
        <cf_importLibs>
        <!---<script src="/cfmx/jquery/librerias/jquery.blockUI2.66.js"></script> --->
        <script language="JavaScript1.2" type="text/javascript">
 
            function Comentario(PCid) 
            { 
              window.open('/cfmx/ftec/contratos/operacion/PopupComentario.cfm?&ver=1&PCid='+PCid,'popup','width=850,height=400','mywindow');
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

                 
        <cfset navegacion = "">
                    
        <cfif isdefined("form.NombreF") and len(trim(form.NombreF))NEQ 0>
            <cfset navegacion = navegacion  &  "NombreF="&form.NombreF>           
        </cfif>
                    
        <cfif isdefined("form.IdentificacionF") and len(trim(form.IdentificacionF))NEQ 0>
            <cfif len(trim(navegacion)) NEQ 0>  
                    <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "IdentificacionF="&form.IdentificacionF>
                <cfelse>    
                    <cfset navegacion = navegacion & "IdentificacionF="&form.IdentificacionF>
            </cfif> 
        </cfif>

        <cfif isdefined("form.ContratoF") and len(trim(form.ContratoF))NEQ 0>
            <cfif len(trim(navegacion)) NEQ 0>  
                    <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "ContratoF="&form.ContratoF>
                <cfelse>    
                    <cfset navegacion = navegacion & "ContratoF="&form.ContratoF>
            </cfif> 
        </cfif>

        <cfif isdefined("form.EstadoF") and len(trim(form.EstadoF))NEQ 0 and form.EstadoF NEQ '-1'>
            <cfif len(trim(navegacion)) NEQ 0>  
                    <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "EstadoF="&form.EstadoF>
                <cfelse>    
                    <cfset navegacion = navegacion & "ContratoF="&form.EstadoF>
            </cfif> 
        </cfif>


        <form name="fmContratacion" class="form-inline"  role="form" action="ConsultaContratos.cfm" method="post">
            <cf_dbfunction name="op_concat" returnvariable="_cat">

            <table width="100%">
            <tr><strong>
                <td>Nombre</td>
                <td>Identificación</td>
                <td>Contraro</td>
                <!--- <td>Estado</td> --->
                </strong>
            </tr>
            <tr>
                <td>
                    <input name="NombreF" type="text" size="40" maxlength="40" tabindex="1"
                        value="<cfif isdefined("form.NombreF") and len(trim(form.NombreF))NEQ 0><cfoutput>#form.NombreF#</cfoutput></cfif>"/>
                </td>
                <td>
                    <input name="IdentificacionF" type="text"  size="20" maxlength="20" tabindex="1"
                        value="<cfif isdefined("form.IdentificacionF") and len(trim(form.IdentificacionF))NEQ 0><cfoutput>#form.IdentificacionF#</cfoutput></cfif>"/>
                </td>
                <td>
                    <input name="ContratoF" type="text"  size="60" maxlength="60" tabindex="1"
                        value="<cfif isdefined("form.ContratoF") and len(trim(form.ContratoF))NEQ 0><cfoutput>#form.ContratoF#</cfoutput></cfif>"/>
                </td>
                <td>
                    <select name="EstadoF">
                        <option value="-1"<cfif isdefined("form.EstadoF") and trim(form.EstadoF) eq '-1'>selected</cfif>>Todos</option>
                        <option value="A" <cfif isdefined("form.EstadoF") and trim(form.EstadoF) eq 'A'>selected</cfif>>Aprobado</option>
                        <option value="F" <cfif isdefined("form.EstadoF") and trim(form.EstadoF) eq 'F'>selected</cfif>>Finiquito</option>
                    </select>
                </td>



<!---                 <td>
                    <input name="EstadoF" type="text"  size="10" maxlength="10" tabindex="1"
                        value="<cfif isdefined("form.EstadoF") and len(trim(form.EstadoF))NEQ 0><cfoutput>#form.EstadoF#</cfoutput></cfif>"/>
                </td> --->

                <td>
                    <cfinvoke component="sif.Componentes.Translate"
                        method="Translate"
                        Key="BTN_Filtro"
                        Default="Filtro"
                        returnvariable="BTN_Filtro"/>

                    <input name="BTNfiltro" type="submit" value="<cfoutput>#BTN_Filtro#</cfoutput>" tabindex="1">
                </td>
            </tr>
        </table>

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
                            
                            <!--- ,{fn concat('<img border=''0''  width= ''40%''  onClick=''NoEjecutado(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/finiquito6.jpg''>')})}  as NoEjecutadoStr --->

                            ,{fn concat('<img border=''0''  width= ''40%''  onClick=''VerContrato(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/Finiquito2.png''>')})}  as VerStr

                            ,{fn concat('<img border=''0''  width= ''40%''  onClick=''Comentario(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/ver.gif''>')})}  as ComStr
                        from FTPContratacion a
                            inner join FTContratos b
                                on b.Cid = a.Cid
                        where a.PCEstado in ('A','F')

                        <cfif isdefined("form.NombreF") and len(trim(form.NombreF))NEQ 0>
                            and ltrim(rtrim(upper(a.PCApellido1 #_cat# ' ' #_cat#  a.PCApellido2  #_cat# ' ' #_cat# a.PCNombre))) like '%#trim(ucase(form.NombreF))#%'
                        </cfif>

                        <cfif isdefined("form.IdentificacionF") and len(trim(form.IdentificacionF))NEQ 0>
                            and ltrim(rtrim(upper(a.PCidentificacion))) like '%#trim(ucase(form.IdentificacionF))#%'
                        </cfif>
                        <cfif isdefined("form.ContratoF") and len(trim(form.ContratoF))NEQ 0>
                            and ltrim(rtrim(upper(b.Cdescripcion))) like '%#trim(ucase(form.ContratoF))#%'
                        </cfif>
                        <cfif isdefined("form.EstadoF") and len(trim(form.EstadoF))NEQ 0 and form.EstadoF NEQ '-1'>
                            and ltrim(rtrim(upper(a.PCEstado))) like '#form.EstadoF#'
                        </cfif>

                        order by a.PCApellido1 #_cat# ' ' #_cat#  a.PCApellido2  #_cat# ' ' #_cat# a.PCNombre
                    </cfquery>

<!--- EstadoF   ---> 


                    <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                        <cfinvokeargument name="query" value="#rsLista#"/>
                        <cfinvokeargument name="desplegar" value=" Nombre, PCIdentificacion, Cdescripcion,  PCEstado,VerStr,ComStr"/>
                        <cfinvokeargument name="etiquetas" value="Nombre,Identificación, Contrato,  Estado, Revisar,Comentario"/>
                        <cfinvokeargument name="formatos" value=" S, S, S, S,I,I"/>
                        <cfinvokeargument name="align" value="left, left, left,  left, center, center"/>
                        <cfinvokeargument name="ajustar" value="true"/>
                        <cfinvokeargument name="keys" value="PCid"/>
                        <cfinvokeargument name="incluyeForm" value="false"/>
                        <cfinvokeargument name="formName" 	value="fmContratacion"/>
                        <cfinvokeargument name="showLink"   value="false"/>
                        <cfinvokeargument name="navegacion" value="#navegacion#"/>
                    </cfinvoke>
                  
            	</div>
            </div>

        </form>

    <cf_web_portlet_end>                                                                            
<cf_templatefooter>

