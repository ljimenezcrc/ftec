 
<cfcomponent name="FTTramitesContratacion">
    <!--- *************************** --->
    <!--- Aplica Tramite  --->
    <!--- *************************** --->

    <cffunction   name="EnviarTramite" access="remote" returnformat="json"  output="true" returntype="query">
        <cfargument name="PCid"             required="true"     type="any">
        <cfargument name="Aprueba"          required="true"     type="any">

        <cftransaction>
            <cfif #Arguments.Aprueba# EQ 1> 
                <cfquery name="rsNex" datasource="#session.dsn#">
                    select coalesce(max(a.PCEnumero),0) + 1 Numero
                    from  <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a
                    inner join <cf_dbdatabase table="FTContratos" datasource="ftec"> b
                        on  b.Cid = a.Cid
                            and b.TCid in (select c.TCid from <cf_dbdatabase table="FTTipoContrato" datasource="ftec"> c
                                            where coalesce(c.TCnoaplicaconsec,0) = 0)
                      where PCEnumero > 0
                        and PCEPeriodo = year(getdate())
                </cfquery>
                <cfquery name="rsUpdate" datasource="#Session.DSN#">
                    update <cf_dbdatabase table="FTPContratacion" datasource="ftec"> set 
                             PCEPeriodo = year(getdate())
                            , PCEnumero = #rsNex.Numero#
                        where PCid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.PCid#">
                            and PCEnumero < 0
                            and exists (select 1 
                                        from <cf_dbdatabase table="FTContratos" datasource="ftec"> b
                                        inner join <cf_dbdatabase table="FTTipoContrato" datasource="ftec"> c
                                            on c.TCid = b.TCid
                                                and coalesce(c.TCnoaplicaconsec,0) = 0)
                                        where b.Cid = <cf_dbdatabase table="FTPContratacion" datasource="ftec">.Cid
                                        )
                </cfquery>
                            
            </cfif>


            <!--- FTTipoContrato  TCid 

            FTContratos TCid Cid

            FTPContratacion  Cid PCid --->
                    
            <cfquery name="rsUpdate" datasource="#Session.DSN#">
                update <cf_dbdatabase table="FTPContratacion" datasource="ftec"> set 
                    PCEstado =   
                        <cfif #Arguments.Aprueba# EQ 0> 'T'
                        <cfelseif  #Arguments.Aprueba# EQ 1> 'A'  
                        <cfelseif  #Arguments.Aprueba# EQ 2> 'R' 
                        <cfelseif  #Arguments.Aprueba# EQ 3> 'F' 
                        <cfelse> 'P'</cfif>
                    where PCid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.PCid#">
            </cfquery>

            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> (Usucodigo
                        ,HTfecha
                        ,ETid
                        ,TPid
                        ,PCid
                        ,HTpasosigue
                        ,DSPid
                        ,HTcompleto
                    )
                values( <cf_jdbcquery_param cfsqltype="cf_sql_numeric"      value="#session.Usucodigo#"     voidnull>
                        ,<cf_dbfunction name="now">
                        , 1
                        , null
                        , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.PCid#"        voidnull>
                        , 0
                        ,null
                        ,1
                       )
            </cfquery>
            
            <!---se envia el correo segun corresponda--->
            
            <!--- <cfquery name="rsCorreos" datasource="#session.dsn#">
                select b.Pemail1 as Email
                from Usuario a
                    inner join DatosPersonales b
                        on a.datos_personales = b.datos_personales
                where a.Usucodigo in ( select a.Usucodigo
                                        from <cf_dbdatabase table="FTAutorizador" datasource="ftec">  a
                                        inner join <cf_dbdatabase table="FTTipoAutorizador" datasource="ftec"> b
                                            on a.TAid = b.TAid
                                        where a.Vid = (select Vid from <cf_dbdatabase table="FTPContratacion" datasource="ftec">   
                                                        where PCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">)
                                            and b.TAid = 3
                                            and coalesce(a.Ainactivo,0) = 0
                                       )
            </cfquery>
            
            <cf_dump var="#rsCorreos#">--->
            
        <cfinvoke component="ftec.Componentes.FTTramitesContratacion" method="getEmail"> 
            <cfinvokeargument  name="Tcorreo" value="#Arguments.Aprueba#" > 
            <cfinvokeargument  name="PCid" value="#Arguments.PCid#" >     
        </cfinvoke>
                
        
        </cftransaction>
        
        
        <cfquery name="rs" datasource="#Session.DSN#">
            select 1 from dual
        </cfquery>
        <cfreturn rs>
    </cffunction>
 


    <cffunction   name="AplicaTramite"  access="remote" returnformat="json"  output="true" returntype="query">
        <cfargument name="PCid"             required="true"     type="any">
        <cfargument name="Aprueba"          required="true"     type="any">

        <cfinvoke component="ftec.Componentes.FTPContratacion" method="Get" returnvariable="rsContrato">
            <cfinvokeargument name="PCid" value="#Arguments.PCid#">
        </cfinvoke>
        
        <cfquery name="rsSiguientePasoH" datasource="#Session.DSN#">
            select Usucodigo,HTfecha ETid,TPid,SPid,HTpasosigue
                from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec">
                where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">
                and  HTfecha = (select max(a.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> a 
                                where SPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCid#"> 
                                    and HTcompleto = 1
                                )
        </cfquery>
        
        
        <cfif isdefined('rsSiguientePasoH') and rsSiguientePasoH.recordCount EQ 0>
            <cfquery name="rsSiguientePaso" datasource="#Session.DSN#">
                select top(1) c.ETid, b.TTid, a.PCid, 
                    <cfif Arguments.Aprueba EQ 1>
                        c.FTpasoaprueba 
                    <cfelse>
                        c.FTpasorechaza 
                    </cfif> as PasoSigue
                    from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a
                        inner join <cf_dbdatabase table="FTContratos" datasource="ftec"> b
                            on b.Cid = a.Cid
                    inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c
                        on c.TTid = b.TTid
                where a.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">
                order by c.FTpasoactual asc
             </cfquery>
        <cfelse>
            <cfquery name="rsSiguientePaso" datasource="#Session.DSN#">
                select c.ETid, a.TTid, a.PCid, 
                    <cfif Arguments.Aprueba EQ 1>
                        c.FTpasoaprueba 
                    <cfelse>
                        c.FTpasorechaza 
                    </cfif> as PasoSigue
                        ,c.*
                    from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a
                        inner join <cf_dbdatabase table="FTContratos" datasource="ftec"> b
                            on b.Cid = a.Cid
                    inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c
                        on c.TTid = b.TTid
                where a.PCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PCid#">
                    and c.FTpasoactual = #rsSiguientePasoH.HTpasosigue#
                order by c.FTpasoactual asc
             </cfquery>
        </cfif>
        
        <cfif isdefined('rsSiguientePaso') and rsSiguientePaso.recordCount EQ 1>
            <cfquery name="rsDetallesAplicar" datasource="#Session.DSN#">
                select  a.PCid
                    from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a
                    where a.PCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSiguientePaso.PCid#">            
                    <cfif isdefined('form.Tramite') and len(#form.Tramite#) GT 0>
                        and a.Vid in (
                                    select e1.Vid
                                    from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> a1
                                        inner join <cf_dbdatabase table="FTTipoProceso" datasource="ftec"> b1
                                            on a1.TPid = b1.TPid
                                        inner join <cf_dbdatabase table="FTFlujoTramite" datasource="ftec"> c1
                                            on b1.TTid = c1.TTid
                                        inner join <cf_dbdatabase table="FTDFlujoTramite" datasource="ftec"> d1
                                            on c1.FTid = d1.FTid
                                        inner join <cf_dbdatabase table="FTAutorizador" datasource="ftec"> e1
                                            on d1.TAid = e1.TAid
                                            and e1.Vid in (select b.Vid
                                                            from <cf_dbdatabase table="FTPContratacion" datasource="ftec"> a2
                                                            where a2.PCid = a.PCid)
                                            and a1.HTpasosigue = c1.FTpasoactual
                                            and e1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
                                    where a1.PCid = a.PCid 
                                        and a1.HTfecha = (select max(b11.HTfecha) from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> b11 
                                                            where b11.PCid = a1.PCid 
                                                                and HTcompleto = 1)
                                    )
                    </cfif>
             </cfquery>


                <cfif isdefined('rsDetallesAplicar') and rsDetallesAplicar.RecordCount >
                    <cfinvoke component="ftec.Componentes.FTTramitesContratacion" method="AltaHTramite" >
                        <cfinvokeargument name="ETid"           value="#rsSiguientePaso.ETid#">
                        <cfinvokeargument name="PCid"           value="#rsSiguientePaso.PCid#">
                        <cfinvokeargument name="HTpasosigue"    value="#rsSiguientePaso.PasoSigue#">
                        <cfinvokeargument name="Debug"          value="false">
                    </cfinvoke>
               </cfif>
        </cfif>
        <cfquery name="rs" datasource="#Session.DSN#">
            select 1 from dual
        </cfquery>
        
        <cfreturn rs>
    </cffunction>    

    <cffunction access="public" name="AltaHTramite" returntype="numeric">
        <cfargument name="Usucodigo"        required="true"     type="numeric" default="#session.Usucodigo#">
        <cfargument name="ETid"             required="true"     type="numeric">
        <cfargument name="TPid"             required="false"    type="any">
        <cfargument name="PCid"             required="true"     type="numeric">
        <cfargument name="HTpasosigue"      required="true"     type="numeric">
        <cfargument name="DSPid"            required="false"    type="numeric"  default="0">
        <cfargument name="HTcompleto"       required="false"    type="numeric" default="0">
        <cfargument name="Debug"            required="false"    type="boolean"  default="true">  
         
        <cftransaction>   
            <cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
                insert into <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec"> (Usucodigo
                                                ,HTfecha
                                                ,ETid
                                                ,TPid
                                                ,PCid
                                                ,HTpasosigue
                                                ,DSPid
                                                ,HTcompleto
                                            )
                                        values( <cf_jdbcquery_param cfsqltype="cf_sql_numeric"      value="#Arguments.Usucodigo#"   voidnull>
                                                ,<cf_dbfunction name="now">
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.ETid#"        voidnull>
                                                , null<!---<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.TPid#"        voidnull>--->
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.PCid#"        voidnull>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.HTpasosigue#"     voidnull>
                                                <cfif #Arguments.DSPid# GT 0>
                                                    , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.DSPid#"       voidnull>
                                                 <cfelse>
                                                    ,null
                                                </cfif>
                                                , <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.HTcompleto#"      voidnull>
                                               )
                <cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
            
            <cfset Lvar_Iid = rsInsert.Identity>
            
            <cfquery name="rsUpdate" datasource="#Session.DSN#">
                update <cf_dbdatabase table="FTPContratacion" datasource="ftec"> set 
                    PCEstado =  <cfif #Arguments.HTpasosigue# EQ 0> 'A' <cfelse> 'T' </cfif>
                    where PCid =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric"    value="#Arguments.PCid#">
            </cfquery>
    
            <cfif Arguments.Debug>
                <cfquery name="rsDebug" datasource="#Session.DSN#">
                    select Usucodigo,HTfecha,ETid,TPid,SPid,HTpasosigue
                    from <cf_dbdatabase table="FTHistoriaTramite" datasource="ftec">
                    where HTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
                </cfquery>
                <cfdump var="#Arguments#">
                <cfdump var="#rsDebug#">
                <cfabort>
            </cfif>
        </cftransaction>
        <cfreturn Lvar_Iid>
    </cffunction>
    

 
    
    <cffunction access="public" name="getEmail" output="false"  >
        <cfargument name="Tcorreo" required="yes" type="any">
        <cfargument name="PCid" required="yes" type="any">
        
        
        <cf_dbfunction name="op_concat" returnvariable="_cat">
        <cfquery name="ParaElCorreo" datasource="#session.dsn#">
               
            select d.DEemail, d.DEnombre #_cat# ' '#_cat# d.DEapellido1 #_cat# ' '#_cat# d.DEapellido2 as empleado, d.DEsexo
            , (select Cdescripcion
                from <cf_dbdatabase table="FTContratos" datasource="ftec">
                where Cid = (select Cid from <cf_dbdatabase table="FTPContratacion" datasource="ftec">   
                                                    where PCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">)) as Contrato
            , coalesce((select d.DEnombre #_cat# ' '#_cat# d.DEapellido1 #_cat# ' '#_cat# d.DEapellido2
                from Usuario a
                    inner join DatosPersonales b
                        on a.datos_personales = b.datos_personales
                    inner join UsuarioReferencia c
                    on c.Usucodigo = a.Usucodigo
                    and c.STabla='DatosEmpleado'
                    inner join DatosEmpleado d
                    on d.DEid = c.llave
                where a.Usucodigo = #session.Usucodigo#),'NDF') as Solicita
            , (select case 
                                when PCEstado = 'T' then 'Trámite'
                                when PCEstado = 'A' then 'Aprobado'
                                when PCEstado = 'R' then 'Rechazado'
                                when PCEstado = 'F' then 'No Ejecutado'
                                else 'NDF'
                             end 
                    from  <cf_dbdatabase table="FTPContratacion" datasource="ftec">
                    where PCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#"> ) as Estado                    
            , (select FTPCOcomentario
                    from  <cf_dbdatabase table="FTPContratacionObserv" datasource="ftec">
                    where PCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#"> ) as Observacion                    

            from Usuario a
                inner join DatosPersonales b
                    on a.datos_personales = b.datos_personales
                inner join UsuarioReferencia c
                on c.Usucodigo = a.Usucodigo
                and c.STabla='DatosEmpleado'
                inner join DatosEmpleado d
                on d.DEid = c.llave
            where a.Usucodigo in ( select a.Usucodigo
                                    from <cf_dbdatabase table="FTAutorizador" datasource="ftec">  a
                                    inner join <cf_dbdatabase table="FTTipoAutorizador" datasource="ftec"> b
                                        on a.TAid = b.TAid
                                    where a.Vid = (select Vid from <cf_dbdatabase table="FTPContratacion" datasource="ftec">   
                                                    where PCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">)
                                        and b.TAid = <cfif #arguments.Tcorreo# EQ 0> 
                                                        6
                                                     <cfelseif #arguments.Tcorreo# EQ 1 or #arguments.Tcorreo# EQ 2 >
                                                        3
                                                     <cfelse>
                                                        -1
                                                     </cfif>
                                        and coalesce(a.Ainactivo,0) = 0
                                   )
        </cfquery>
        
       <cfif ParaElCorreo.RecordCount gt 0 and #arguments.Tcorreo# EQ 0>
        
            <cfset FromEmail = "xxxxx@xx.co.cr">
            <cfquery name="CuentaPortal"   datasource="#session.dsn#">
                Select valor
                from  <cf_dbdatabase table="PGlobal" datasource="asp">
                Where parametro='correo.cuenta'
            </cfquery>
            <cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
                <cfset FromEmail = CuentaPortal.valor>
            </cfif> 
            
            <cfquery name="rsContrato" datasource="#session.dsn#">
                select Cdescripcion
                from <cf_dbdatabase table="FTContratos" datasource="ftec">
                where Cid = (select Cid from <cf_dbdatabase table="FTPContratacion" datasource="ftec">   
                                                    where PCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">)
            </cfquery>
            
            <cfset Ruta = "<a href='http://#session.sitio.host#/cfmx/ftec/contratos/operacion/TramitesContratacion-list.cfm'>Aprobación de Trámites</a>">
            
            <cfloop query="ParaElCorreo">
                
                <cfsavecontent variable="_mail_body">
                    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
                    <html>
                    <head><title>Trámites para Contratos</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">
                    .style1 {font-size: 10px;font-family: "Times New Roman", Times, serif;}
                    .style2 {font-family: Verdana, Arial, Helvetica, sans-serif;font-weight: bold;font-size: 14;}
                    .style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
                    .style8 {font-size: 14}
                    </style>
                    </head>
                    <body>
                    <cfoutput>
                          <table border="1" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; "><tr bgcolor="##999999"><td colspan="2" height="8"></td></tr><tr bgcolor="##003399"><td colspan="2" height="24"></td></tr><tr bgcolor="##999999">
                            <td colspan="2"><strong>Trámite de Contratos </strong> </td>
                            </tr><tr><td width="70">&nbsp;</td><td width="559">&nbsp;</td></tr>
                            <tr><td><span class="style2"><cf_translate key="LB_De">De</cf_translate></span></td><td><span class="style7"> #Session.Enombre# </span></td></tr>
                            <tr>
                              <td><span class="style7"><strong><cf_translate key="LB_Para">Para</cf_translate></strong></span></td>
                              <td><span class="style7"><cfif #ParaElCorreo.DEsexo# eq 'M'>
                                  Sr
                                  <cfelse>
                                  (a)/ Srta
                                </cfif>
                                : #ParaElCorreo.empleado# </span></td>
                            </tr><tr><td><span class="style8"></span></td><td><span class="style8"></span></td>
                            </tr><tr><td>&nbsp;</td>
                            <td><span class="style7">Información sobre Trámite de Contrato</span></td></tr>
                            <tr><td colspan="2">&nbsp;</td></tr>
                            <cfif not IsDefined("Request.MailArguments.Transition")>
                              <tr><td><span class="style8"></span></td><td><span class="style7"> </span></td></tr>
                              <cfelse>
                              <tr><td><span class="style8"></span></td><td><span class="style7">#Request.MailArguments.info#</span></td></tr>
                            </cfif>
                                <tr><td><span class="style8"></span></td>
                              <td><p class="style8">
                                <cfif #ParaElCorreo.DEsexo# eq 'M'>
                                  Sr
                                  <cfelse>
                                  (a)/ Srta
                                </cfif>
                                : #ParaElCorreo.empleado# <br>
                                Estado del Trámite  de Contrato (#ParaElCorreo.Contrato#),<br>
                                para revisión y aprobación de Contrato </p>
                                <p class="style8"><br>
                                    INICIO TRAMITE Solicitada por: (#ParaElCorreo.Solicita#) <br>
                                </p>
                                <p class="style8"><br>
                                    Observaciones: #ParaElCorreo.Observacion# <br>
                                </p>
                                Ingrese a: #Ruta#  para revisarla.
                            </tr>
                          </table>
                        </cfoutput>
                     </body>
                    </html>
                </cfsavecontent>
                
                <cfquery datasource="#session.DSN#">
                    insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                    values (
                        '#trim(FromEmail)#', 
                        '#ParaElCorreo.DEemail#',
                        'Información sobre Trámites',
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#_mail_body#">,
                        1
                    )
                </cfquery>
            </cfloop>        
        
        
       <!--- <cfelseif  ParaElCorreo.RecordCount gt 0 and (#arguments.Tcorreo# EQ 1 or #arguments.Tcorreo# EQ 2) >--->
        <cfelse>    
            <cfset FromEmail = "xxxxx@xx.co.cr">
            <cfquery name="CuentaPortal"   datasource="#session.dsn#">
                Select valor
                from  <cf_dbdatabase table="PGlobal" datasource="asp">
                Where parametro='correo.cuenta'
            </cfquery>
            <cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
                <cfset FromEmail = CuentaPortal.valor>
            </cfif> 
            
            <cfquery name="rsContrato" datasource="#session.dsn#">
                select Cdescripcion
                from <cf_dbdatabase table="FTContratos" datasource="ftec">
                where Cid = (select Cid from <cf_dbdatabase table="FTPContratacion" datasource="ftec">   
                                                    where PCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCid#">)
            </cfquery>
            
            <cfset Ruta = "<a href='http://#session.sitio.host#/cfmx/ftec/contratos/operacion/TramitesContratacion-list.cfm'>Aprobación de Trámites</a>">
            
            <cfloop query="ParaElCorreo">
                <cfsavecontent variable="_mail_body">
                    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
                    <html>
                    <head><title>Trámites para Contratos</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">
                    .style1 {font-size: 10px;font-family: "Times New Roman", Times, serif;}
                    .style2 {font-family: Verdana, Arial, Helvetica, sans-serif;font-weight: bold;font-size: 14;}
                    .style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
                    .style8 {font-size: 14}
                    </style>
                    </head>
                    <body>
                    <cfoutput>
                          <table border="1" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; "><tr bgcolor="##999999"><td colspan="2" height="8"></td></tr><tr bgcolor="##003399"><td colspan="2" height="24"></td></tr><tr bgcolor="##999999">
                            <td colspan="2"><strong>Trámite de Contratos </strong> </td>
                            </tr><tr><td width="70">&nbsp;</td><td width="559">&nbsp;</td></tr>
                            <tr><td><span class="style2"><cf_translate key="LB_De">De</cf_translate></span></td><td><span class="style7"> #Session.Enombre# </span></td></tr>
                            <tr>
                              <td><span class="style7"><strong><cf_translate key="LB_Para">Para</cf_translate></strong></span></td>
                              <td><span class="style7"><cfif #ParaElCorreo.DEsexo# eq 'M'>
                                  Sr
                                  <cfelse>
                                  (a)/ Srta
                                </cfif>
                                : #ParaElCorreo.empleado# </span></td>
                            </tr><tr><td><span class="style8"></span></td><td><span class="style8"></span></td>
                            </tr><tr><td>&nbsp;</td>
                            <td><span class="style7">Información sobre Trámite de Contrato</span></td></tr>
                            <tr><td colspan="2">&nbsp;</td></tr>
                            <cfif not IsDefined("Request.MailArguments.Transition")>
                              <tr><td><span class="style8"></span></td><td><span class="style7"> </span></td></tr>
                              <cfelse>
                              <tr><td><span class="style8"></span></td><td><span class="style7">#Request.MailArguments.info#</span></td></tr>
                            </cfif>
                                <tr><td><span class="style8"></span></td>
                              <td><p class="style8">
                                <cfif #ParaElCorreo.DEsexo# eq 'M'>
                                  Sr
                                  <cfelse>
                                  (a)/ Srta
                                </cfif>
                                : #ParaElCorreo.empleado# <br>
                                Estado del Trámite  de Contrato (#ParaElCorreo.Contrato#),<br>
                                ACCION TOMADA: #ParaElCorreo.Estado# </p>
                                <p class="style8"><br>
                                    INICIO TRAMITE Solicitada por: (#ParaElCorreo.Solicita#) <br>
                                </p>
                                <p class="style8"><br>
                                    Observaciones: #ParaElCorreo.Observacion# <br>
                                </p>
                                Ingrese a: #Ruta#  para revisarla.
                            </tr>
                          </table>
                        </cfoutput>
                     </body>
                    </html>
                </cfsavecontent>
                
                <cfquery datasource="#session.DSN#">
                    insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
                    values (
                        '#trim(FromEmail)#', 
                        '#ParaElCorreo.DEemail#',
                        'Información sobre Trámites',
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#_mail_body#">,
                        1
                    )
                </cfquery>
            </cfloop>  
        </cfif>
        
        
        
        
        
        
        <!---        <cfquery name="rs" datasource="#session.dsn#">
            select b.Pemail1 as Email
            from Usuario a
                inner join DatosPersonales b
                    on a.datos_personales = b.datos_personales
            where a.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.rsUsuarios.Usucodigo#" list="yes">)
        </cfquery>--->
        
     
        
        <cfreturn >
    </cffunction>

</cfcomponent>