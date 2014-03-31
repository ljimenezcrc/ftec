<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" 		Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Vicerrectorias" 		Default="Unidad Operativa" returnvariable="LB_Vicerrectorias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DatosGenerales" 		Default="Datos Generales" returnvariable="LB_DatosGenerales" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Cuentas" 				Default="" returnvariable="LB_Cuentas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Plazas" 				Default="Plazas" returnvariable="LB_Plazas" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke Key="BTN_Autorizar" 			Default="Autorizadores" returnvariable="BTN_Autorizar" component="sif.Componentes.Translate" method="Translate"/>				
<!---<cfinvoke Key="LB_Usuarios" 			Default="Usuarios" returnvariable="LB_Usuarios" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke Key="LB_UsuariosTramites" 	Default="Usuarios para Tramites" returnvariable="LB_UsuariosTramites" component="sif.Componentes.Translate" method="Translate"/>
--->
<cfinvoke Key="LB_CostosProyectos" 	        Default="Costos Administrativos"   returnvariable="LB_CostosProyectos" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="LB_IngresosAuto" 	    Default="Ingresos Automaticos" returnvariable="LB_IngresosAuto" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

<!--- 	JGR [04/01/2006]
		Variable para saber si esta en la empresa corporativa 
--->
<cfset es_corporativo = false >
<cfset vEcodigoCorp = 0 >
<cfquery name="rsCorporativa" datasource="asp">
	select coalesce(e.Ereferencia, 0) as Ecorporativa
	from CuentaEmpresarial c
		join Empresa e
		on e.Ecodigo = c.Ecorporativa
	where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfif rsCorporativa.recordcount gt 0 and len(trim(rsCorporativa.Ecorporativa))>
	<cfset vEcodigoCorp = rsCorporativa.Ecorporativa >
</cfif>

<cfif vEcodigoCorp eq session.Ecodigo >
	<cfset es_corporativo = true >
</cfif>

<cfinclude template="/rh/Utiles/params.cfm">

<cfquery name="validaPresupuesto" datasource="#session.DSN#">
	select Pvalor 
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Pcodigo=540
</cfquery>

<!--- 5700. Parametro para Activar Seguridad de Tabs --->
<!--- Hay un catalogo en Administracion del Sistema llamado "Configurar seguridad del catálogo de Centro Funcionales" --->
<!--- donde se puede configurar los usuarios que pueden acceder a los tabs de CF, en caso de que el parametro este activo. --->
<cfquery name="rsSeguridadTabs" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Pcodigo = 5700
</cfquery>
<cfset seguridadCF = false>
<cfif isdefined("rsSeguridadTabs") and rsSeguridadTabs.Pvalor eq 'S'>
	<cfset seguridadCF = true>
	<cfif isdefined("form.Primero")>
		<cfquery name="rsUsuarioTab" datasource="#session.DSN#">
			select d.DatosGenerales,d.Cuentas,d.Plazas,d.Autorizadores,d.Usuarios,d.UsuariosTramites,
			d.CostosAutomaticos,d.IngresosAutomaticos
			from CFEusuarioS e
			inner join CFDusuarioS d 
			on d.CFEid = e.CFEid
			and d.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Primero#">
			where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
		<cfset ninguno = false>
		<cfif not rsUsuarioTab.DatosGenerales and not rsUsuarioTab.Cuentas and not rsUsuarioTab.Plazas and not rsUsuarioTab.Autorizadores and not rsUsuarioTab.Usuarios and not rsUsuarioTab.UsuariosTramites and not rsUsuarioTab.CostosAutomaticos and not rsUsuarioTab.IngresosAutomaticos>
			<cfset ninguno = true>
		</cfif>
	</cfif>
</cfif>

<!--- ================================================================ --->
<!--- JGR [04/02/2006]
	  Necesito saber si la empresa ya tiene un CF raiz, ya no se puede
	  preguntar si el CFidresp es nulo, pues podria no serlo. Entonces
	  se cambio el query para preguntar por el nivel y el path. 
	  Se SUPONE que el nivel de la raiz es 0 y que su path es RAIZ,
	  entonces el query pregunta por estos campos.
--->
<!---
<cfquery name="rsCFraiz" datasource="#Session.DSN#">
	select CFid 
	from CFuncional 
	where Ecodigo=#session.Ecodigo# 
		and CFnivel = 0
		and ltrim(rtrim(CFpath)) = 'RAIZ'
</cfquery>

<cf_dump var="#rsCFraiz#">

<!--- ================================================================ --->

<cfif rsCFraiz.recordCount NEQ 1>
	<cftransaction>
	<cfquery name="rsDpto" datasource="#Session.DSN#">
			select min(Dcodigo) as id from Departamentos where Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfquery name="rsOfic" datasource="#Session.DSN#">
			select min(Ocodigo) as id from Oficinas where Ecodigo=#session.Ecodigo#
	</cfquery>
    <cfif NOT LEN(TRIM(rsDpto.id))>
    	<cfthrow message="Debe crear primero almenos un Departamento">
    </cfif>
     <cfif NOT LEN(TRIM(rsOfic.id))>
    	<cfthrow message="Debe crear primero almenos una Oficina">
    </cfif>

	<cfquery datasource="#Session.DSN#">
		insert into CFuncional (
			Ecodigo,
			CFcodigo,
			Dcodigo,
			Ocodigo,
			CFdescripcion,
			CFpath,
			CFnivel,
			CFcorporativo )
		values (
			#session.Ecodigo#,
			'RAIZ',
			#rsDpto.id#,
			#rsOfic.id#,
			'Centro Funcional Raiz',
			'RAIZ',
			0,
			<cfif es_corporativo >1<cfelse>0</cfif> )
	</cfquery>
	<cfquery name="rsCFraiz" datasource="#Session.DSN#">
		select CFid from CFuncional where Ecodigo=#session.Ecodigo# and CFcodigo='RAIZ'
	</cfquery>
	<cfif rsCFraiz.recordCount NEQ 0>
		<cfquery datasource="#Session.DSN#">
			update CFuncional
			   set CFpath = {fn concat( 'RAIZ/'  , CFpath)},
				   CFnivel = CFnivel + 1,
				   CFidresp = coalesce(CFidresp,#rsCFraiz.CFid#)
			 where Ecodigo=#session.Ecodigo#
			   and CFcodigo <> 'RAIZ'
		</cfquery>
	</cfif>
	</cftransaction>
</cfif>--->

<!--- Puede darse el caso donde cambien la empresa corporativa.
	  Esto puede ocasionar que el CF Raiz de la nueva empresa
	  corporativa no este marcado como corporativo y la idea de estos 
	  cambios es que la raiz del CF corporativo sea SIEMPRE corporativo.
	  Por eso se hace este proceso:
		1. Se pone como corporativo el CF raiz de la empresda corporativa.
		2. Se ponen como no corporativos todos los CF's que no son de la empresa corporativa
 --->
<!---<cfif isdefined("vEcodigoCorp") and len(trim(vEcodigoCorp)) >
	<!--- 1. Se pone como corporativo el CF raiz de la empresda corporativa --->
	<cfquery datasource="#session.DSN#">
		update CFuncional
		set CFcorporativo = 1
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigoCorp#">
	      and CFcodigo = 'RAIZ'
	</cfquery>

	<!--- 2. Se ponen como no corporativos todos los CF's que no son de la empresa corporativa --->
	<cfquery datasource="#session.DSN#">
		update CFuncional
		set CFcorporativo = 0
		where Ecodigo != <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigoCorp#">
		  and CFcorporativo = 1
	</cfquery>
</cfif>--->

	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cfset RequeCf = true>
	<table width="100%" cellpadding="2" cellspacing="0">
      <tr>
        <td valign="top"><script language="JavaScript1.2" type="text/javascript">
					function limpiar(){
						document.filtro.fRHPcodigo.value = "";
						document.filtro.fRHPdescripcion.value   = "";
					}
				</script>

            <cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_Vicerrectorias#">
              <!--- variables para el portlet de navegación --->
              <cfset regresar = "/cfmx/rh/indexEstructura.cfm">
              <!---<cfset navBarItems = ArrayNew(1)>
              <cfset navBarLinks = ArrayNew(1)>
              <cfset navBarStatusText = ArrayNew(1)>
              <cfset navBarItems[1] = "Estructura Organizacional">
              <cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
              <cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">--->
              <cfinclude template="/rh/portlets/pNavegacion.cfm">
              
			 	<!--- ******************************************************************** --->
			  <cfif not isdefined("form.tab") and isdefined("url.tab") and not isdefined("form.tab")>
                <cfset form.tab = url.tab >
              </cfif>
			  <cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8', form.tab) )>
                <cfset form.tab = 1 >
              </cfif>
              <cfif  isdefined("url.Vpk") and len(trim(url.Vpk))NEQ 0>
                <cfset form.Vpk = url.Vpk>
              </cfif>
			  
              <cfif not isdefined("form.nuevo") and not isdefined("form.BTNNUEVO")>
					<cfif  isdefined("form.Vpk") and len(trim(form.Vpk))NEQ 0>
						<cfset modo = "Cambio">
					 </cfif>
			  <cfelse>
                	<cfset modo = "Alta">     
			  </cfif>
			<cfif (isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount eq 0) or (isdefined("ninguno") and ninguno)>
				<cfthrow message="No tienes acceso a este Centro Funcional." detail="Para poder tener acceso, solicite los permisos de ingreso con el Administrador de Centros Funcionales.">
			</cfif>	

			<cf_tabs width="99%">
				
				<cfif (isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount gt 0 and rsUsuarioTab.DatosGenerales eq 1) or not seguridadCF> 
					<cf_tab text="#LB_DatosGenerales#" selected="#form.tab eq 1#">
						<cf_web_portlet_start border="true" titulo="#LB_DatosGenerales#" >
							<cfinclude template="Vicerrectorias-tab1.cfm">
						<cf_web_portlet_end>
					</cf_tab>
                    
					<cfif isdefined('modo')  and  modo NEQ "Alta">
                        <cf_tab text="#BTN_Autorizar#" selected="#form.tab eq 4#">
                            <cf_web_portlet_start border="true" titulo="#LB_Cuentas#">
                                <cfinclude template="Vicerrectorias-tab4.cfm">
                            <cf_web_portlet_end>
                        </cf_tab>
                    </cfif>
                    
	                <cfif isdefined('modo')  and  modo NEQ "Alta">
                        <cf_tab text="#LB_CostosProyectos#" selected="#form.tab eq 3#">
                            <cf_web_portlet_start border="true" titulo="#LB_CostosProyectos#">
                                <cfinclude template="Vicerrectorias-tab3.cfm">
                            <cf_web_portlet_end>
                        </cf_tab>
                    </cfif>
				</cfif>
          
                
                
                
				<!---
				<cfif modo NEQ "Alta">
				
				
				
					<cfif (isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount gt 0 and rsUsuarioTab.Cuentas eq 1) or not seguridadCF> 
						<cf_tab text="#LB_Cuentas#" selected="#form.tab eq 2#">
							<cf_web_portlet_start border="true" titulo="#LB_Cuentas#">
								<cfinclude template="CFuncional-tab2.cfm">
							<cf_web_portlet_end>
						</cf_tab>
					</cfif>
					
					<cfif not (validaPresupuesto.recordcount gt 0 and trim(validaPresupuesto.Pvalor) eq 1) and ((isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount gt 0 and rsUsuarioTab.Plazas eq 1) or not seguridadCF)>
						<cf_tab text="#LB_Plazas#" selected="#form.tab eq 3#">
							<cf_web_portlet_start border="true" titulo="#LB_Plazas#">
								  <cfinclude template="CFuncional-tab3.cfm">
							<cf_web_portlet_end>
						</cf_tab>
					</cfif>

					<cfif (isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount gt 0 and rsUsuarioTab.Autorizadores eq 1) or not seguridadCF>
						<cf_tab text="#BTN_Autorizar#" selected="#form.tab eq 4#">
							<cfinclude template="CFuncional-tab4.cfm">
						</cf_tab>
					</cfif>

					<cfif (isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount gt 0 and rsUsuarioTab.Usuarios eq 1) or not seguridadCF>
						<cf_tab text="#LB_Usuarios#" selected="#form.tab eq 5#">
							<cfinclude template="CFuncional-tab5.cfm">
						</cf_tab>
					</cfif>

					<cfif (isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount gt 0 and rsUsuarioTab.UsuariosTramites eq 1) or not seguridadCF>
						<cf_tab text="#LB_UsuariosTramites#" selected="#form.tab eq 6#">
							<cf_web_portlet_start border="true" titulo="#LB_UsuariosTramites#">
								<cfinclude template="CFuncional-tab6.cfm">
							<cf_web_portlet_end>
						</cf_tab>
					</cfif>
                    
                    <cfif (isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount gt 0 and rsUsuarioTab.CostosAutomaticos eq 1) or not seguridadCF>
	                    <cf_tab text="#LB_CostosAuto#" selected="#form.tab eq 7#">
							<cf_web_portlet_start border="true" titulo="#LB_CostosAuto#">
								<cfinclude template="CFuncional-tab7.cfm">
							<cf_web_portlet_end>
						</cf_tab>
                    </cfif>

                    <cfif (isdefined("rsUsuarioTab") and rsUsuarioTab.recordcount gt 0 and rsUsuarioTab.IngresosAutomaticos eq 1) or not seguridadCF>
	                    <cf_tab text="#LB_IngresosAuto#" selected="#form.tab eq 8#">
							<cf_web_portlet_start border="true" titulo="#LB_IngresosAuto#">
								<cfinclude template="CFuncional-tab8.cfm">
							<cf_web_portlet_end>
						</cf_tab>
					</cfif>
				</cfif>
                --->
			</cf_tabs>
			
              <!--- ******************************************************************** --->
			  
            <cf_web_portlet_end>
        </td>
      </tr>
    </table>
	
<cf_templatefooter>
