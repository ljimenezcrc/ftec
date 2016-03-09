<cf_dbfunction name="op_concat" returnvariable="_cat">



<cf_dbfunction name="op_concat" returnvariable="_cat">

<cfset navegacion = "">
                    
<cfif isdefined("form.NumeroF") and len(trim(form.NumeroF))NEQ 0>
    <cfset navegacion = navegacion  &  "NumeroF="&form.NumeroF>
</cfif>


<cfif isdefined("form.AnnoF") and len(trim(form.AnnoF))NEQ 0>
    <cfif len(trim(navegacion)) NEQ 0>  
            <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "AnnoF="&form.AnnoF>
        <cfelse>    
            <cfset navegacion = navegacion  &  "AnnoF="&form.AnnoF>
    </cfif> 
</cfif>



<cfif isdefined("form.NombreF") and len(trim(form.NombreF))NEQ 0>
    <cfif len(trim(navegacion)) NEQ 0>  
            <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "NombreF="&form.NombreF>
        <cfelse>    
            <cfset navegacion = navegacion  &  "NombreF="&form.NombreF>
    </cfif> 
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

<cfif isdefined("form.UsuarioF") and len(trim(form.UsuarioF))NEQ 0>
    <cfif len(trim(navegacion)) NEQ 0>  
            <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "UsuarioF="&form.UsuarioF>
        <cfelse>    
            <cfset navegacion = navegacion & "UsuarioF="&form.UsuarioF>
    </cfif> 
</cfif>

<cfif isdefined("form.VcodigoF") and len(trim(form.VcodigoF))NEQ 0>
    <cfif len(trim(navegacion)) NEQ 0>  
            <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "VcodigoF="&form.VcodigoF>
        <cfelse>    
            <cfset navegacion = navegacion & "VcodigoF="&form.VcodigoF>
    </cfif> 
</cfif>

<cfif isdefined("form.EstadoF") and len(trim(form.EstadoF))NEQ 0 and form.EstadoF NEQ '-1'>
    <cfif len(trim(navegacion)) NEQ 0>  
            <cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "EstadoF="&form.EstadoF>
        <cfelse>    
            <cfset navegacion = navegacion & "ContratoF="&form.EstadoF>
    </cfif> 
</cfif>


<table width="100%">
    <tr><strong>
        <td>Número</td>
        <td>Año</td>
        <td>Nombre</td>
        <td>Identificación</td>
        <td>Tipo Contrato</td>
        <td>Usuario Registro</td>
        <td>Proyecto</td>
        <!--- <td>Estado</td> --->
        </strong>
    </tr>
    <tr>
    <td>
        <input name="NumeroF" type="text" size="5" maxlength="5" tabindex="1"
            value="<cfif isdefined("form.NumeroF") and len(trim(form.NumeroF))NEQ 0><cfoutput>#form.NumeroF#</cfoutput></cfif>"/>
    </td>

    <td>
        <input name="AnnoF" type="text" size="4" maxlength="4" tabindex="1"
            value="<cfif isdefined("form.AnnoF") and len(trim(form.AnnoF))NEQ 0><cfoutput>#form.AnnoF#</cfoutput></cfif>"/>
    </td>

    <td>
        <input name="NombreF" type="text" size="30" maxlength="30" tabindex="1"
            value="<cfif isdefined("form.NombreF") and len(trim(form.NombreF))NEQ 0><cfoutput>#form.NombreF#</cfoutput></cfif>"/>
    </td>
    <td>
        <input name="IdentificacionF" type="text"  size="20" maxlength="20" tabindex="1"
            value="<cfif isdefined("form.IdentificacionF") and len(trim(form.IdentificacionF))NEQ 0><cfoutput>#form.IdentificacionF#</cfoutput></cfif>"/>
    </td>
    <td>
        <input name="TContratoF" type="text"  size="3" maxlength="3" tabindex="1"
            value="<cfif isdefined("form.TContratoF") and len(trim(form.TContratoF))NEQ 0><cfoutput>#form.TContratoF#</cfoutput></cfif>"/>
    </td>

    <td>
        <input name="UsuarioF" type="text"  size="30" maxlength="30" tabindex="1"
            value="<cfif isdefined("form.UsuarioF") and len(trim(form.UsuarioF))NEQ 0><cfoutput>#form.UsuarioF#</cfoutput></cfif>"/>
    </td>

    <td>
        <input name="VcodigoF" type="text"  size="10" maxlength="10" tabindex="1"
            value="<cfif isdefined("form.VcodigoF") and len(trim(form.VcodigoF))NEQ 0><cfoutput>#form.VcodigoF#</cfoutput></cfif>"/>
    </td>

    <td>
        <select name="EstadoF">
            <option value="-1"<cfif isdefined("form.EstadoF") and trim(form.EstadoF) eq '-1'>selected</cfif>>Todos</option>
            <option value="A" <cfif isdefined("form.EstadoF") and trim(form.EstadoF) eq 'A'>selected</cfif>>Aprobado</option>
            <option value="F" <cfif isdefined("form.EstadoF") and trim(form.EstadoF) eq 'F'>selected</cfif>>Finiquito</option>
        </select>
    </td>

    <td>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Filtro" Default="Filtro" returnvariable="BTN_Filtro"/>
        <input name="BTNfiltro" type="submit" value="<cfoutput>#BTN_Filtro#</cfoutput>" tabindex="1">
    </td>
</tr>
</table>

<div class="row">
    <div class="col-sm-12">
        <cfquery name="rsLista" datasource="ftec">
            select a.PCid
                , a.Cid
                , c.TCcodigo
                ,a.PCTidentificacion
                ,a.PCIdentificacion
                ,a.PCApellido1 #_cat# ' ' #_cat#  a.PCApellido2  #_cat# ' ' #_cat# a.PCNombre as Nombre
                ,dp.Pnombre #_cat# ' ' #_cat# dp.Papellido1 #_cat# ' ' #_cat# dp.Papellido2 as Usuario
                ,case 
                    when a.PCEstado = 'P' then 'Proceso'
                    when a.PCEstado = 'T' then 'Tramite'
                    when a.PCEstado = 'A' then 'Aprobado'
                    when a.PCEstado = 'R' then 'Rechazado'
                    when a.PCEstado = 'F' then 'Finiquito'
                end as PCEstado
                
                , a.PCEnumero
                , a.PCEPeriodo
                , b.Cdescripcion
                , d.Vcodigo
                 ,{fn concat('<img border=''0''  width= ''15%''  onClick=''Comentario(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/ver.gif''>')})}  as ComStr
            from FTPContratacion a
                inner join FTContratos b
                    inner join FTTipoContrato c
                        on c.TCid = b.TCid
                    on b.Cid = a.Cid
                 inner join FTVicerrectoria d
                    on d.Vid = a.Vid
                inner join <cf_dbdatabase table="DatosPersonales" datasource="#session.DSN#"> dp
                    on dp.datos_personales = a.PCUsucodigoC
            where a.PCEstado in  ('P','R','A')
            and a.Vid in (select x.Vid 
                            from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> x
                            inner join <cf_dbdatabase table="FTAutorizador" datasource="ftec">  y
                                on x.Vid = y.Vid
                            where  x.Ecodigo =  #session.Ecodigo# 
                                and coalesce(y.Usucodigo,0) =  #session.Usucodigo# )
            <cfif isdefined("form.NumeroF") and len(trim(form.NumeroF)) NEQ 0>
                            and a.PCEnumero  = #form.NumeroF#
            </cfif>

            <cfif isdefined("form.AnnoF") and len(trim(form.AnnoF)) NEQ 0>
                and a.PCEPeriodo  = #form.AnnoF#
            </cfif>

            <cfif isdefined("form.NombreF") and len(trim(form.NombreF))NEQ 0>
                and ltrim(rtrim(upper(a.PCApellido1 #_cat# ' ' #_cat#  a.PCApellido2  #_cat# ' ' #_cat# a.PCNombre))) like '%#trim(ucase(form.NombreF))#%'
            </cfif>

            <cfif isdefined("form.UsuarioF") and len(trim(form.UsuarioF))NEQ 0>
                and ltrim(rtrim(upper(dp.Pnombre #_cat# ' ' #_cat#  dp.Papellido1  #_cat# ' ' #_cat# dp.Papellido2))) like '%#trim(ucase(form.UsuarioF))#%'
            </cfif>

            <cfif isdefined("form.IdentificacionF") and len(trim(form.IdentificacionF))NEQ 0>
                and ltrim(rtrim(upper(a.PCidentificacion))) like '%#trim(ucase(form.IdentificacionF))#%'
            </cfif>
            <cfif isdefined("form.TContratoF") and len(trim(form.TContratoF))NEQ 0>
                and ltrim(rtrim(upper(c.TCcodigo))) like '%#trim(ucase(form.TContratoF))#%'
            </cfif>
            <cfif isdefined("form.EstadoF") and len(trim(form.EstadoF))NEQ 0 and form.EstadoF NEQ '-1'>
                and ltrim(rtrim(upper(a.PCEstado))) like '#form.EstadoF#'
            </cfif>

            <cfif isdefined("form.VcodigoF") and len(trim(form.VcodigoF))NEQ 0>
                and ltrim(rtrim(upper(d.Vcodigo))) like '#trim(ucase(form.VcodigoF))#'
            </cfif>

            order by a.PCIdentificacion
        </cfquery>

        <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
            <cfinvokeargument name="query" value="#rsLista#"/>
            <cfinvokeargument name="desplegar" value=" PCEnumero, PCEPeriodo, Nombre, PCIdentificacion, TCcodigo, Usuario, Vcodigo, PCEstado,ComStr"/>
            <cfinvokeargument name="etiquetas" value=" Número,Año, Nombre, Identificación, Tipo Contrato, Usuario, Proyecto, Estado,Comentarios"/>
            <cfinvokeargument name="formatos" value=" S,S,S, S, S, S,S, S,I"/>
            <cfinvokeargument name="align" value="left,left,left, left, left,left, left, left,center"/>
            <cfinvokeargument name="ajustar" value="S"/>
            <cfinvokeargument name="irA" value="Contratacion.cfm"/>
            <cfinvokeargument name="keys" value="PCid"/>
            <cfinvokeargument name="incluyeForm" value="false"/>
            <cfinvokeargument name="formName" 	value="fmContratacion"/>
        </cfinvoke>
        <!---<cfinvokeargument name="cortes" value="NombreC"/>--->
      
	</div>
</div>

<div class="row">
    <div class="col-sm-12" align="center">
		<input type="submit" name="btnNContracion" class="btn btn-info"     value="Nueva Contración" />
    </div>
</div> 


 <script language="JavaScript1.2" type="text/javascript">
 
            function Comentario(PCid) 
            { 
              window.open('/cfmx/ftec/contratos/operacion/PopupComentario.cfm?PCid='+PCid,'popup','width=850,height=400','mywindow');
            }
</script>