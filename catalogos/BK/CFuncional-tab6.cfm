<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CentroFuncional"
Default="Centro Funcional"
XmlFile="/rh/generales.xml"
returnvariable="LB_CentroFuncional"/>

<cfquery name="rsCF" datasource="#session.dsn#">
	select CFid, CFuresponsable, RHPid, CFcodigo, CFdescripcion, CFidresp, Ocodigo
	  from CFuncional
	 where CFid = #Form.CFpk#
</cfquery>

<cfif isdefined("form.fRHPcodigo_f")and len(trim(form.fRHPcodigo_f)) gt 0 >
 <cfset form.fRHPcodigo = form.fRHPcodigo_f >
</cfif>
<cfif isdefined("form.fRHPdescripcion_f")and len(trim(form.fRHPdescripcion_f)) gt 0 >
 <cfset form.fRHPdescripcion = form.fRHPdescripcion_f >
</cfif>

<cfif isdefined("url.fRHPcodigo")and len(trim(url.fRHPcodigo))>
	<cfset form.fRHPcodigo = url.fRHPcodigo>
</cfif>
<cfif isdefined("url.fRHPdescripcion")and len(trim(url.fRHPdescripcion))>
	<cfset form.fRHPdescripcion = url.fRHPdescripcion>
</cfif>

<cf_dbtemp name="CFusuV1" returnvariable="CFusu" datasource="#session.dsn#">
	<cf_dbtempcol name="CFid" 					type="numeric"	mandatory="yes" >
	<cf_dbtempcol name="Usucodigo" 				type="numeric"	mandatory="yes" >
	<cf_dbtempcol name="Secuencia"				type="integer"	mandatory="yes" default="99">
	<cf_dbtempcol name="RHPid" 					type="numeric"	mandatory="no" >
	<cf_dbtempcol name="DEid" 					type="numeric"	mandatory="no" >
	<cf_dbtempcol name="Jefe"					type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="CFori"					type="varchar(20)"		mandatory="no">
	<cf_dbtempcol name="AutorizadorRH"			type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="EmpleadoRH"				type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="SolicitanteCM"			type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="EncargadoAF"			type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="ResponsableAF"			type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="CPSUaprobacion"			type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="CPSUtraslados"			type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="CPSUreservas"			type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="CPSUformulacion"		type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="TESUSPaprobador"		type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="TESUSPsolicitante"		type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="TESUGEaprobador"		type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="TESUGEsolicitante"		type="bit"		mandatory="yes" default="0">
	<cf_dbtempcol name="FPSUestimar"			type="bit"		mandatory="yes" default="0">
</cf_dbtemp>

<!--- Usuarios por Centro Funcional --->
<cfif LvarTipoUsuCF EQ "USU">
	<cfquery datasource="#session.dsn#">
		insert into #CFusu#
		(CFid, Usucodigo, CFori)
		select CFid, Usucodigo
			 , '#trim(rsCF.CFcodigo)#'
		  from UsuarioCFuncional
		 where CFid = #rsCF.CFid#
	</cfquery>
<!--- Importacion de Empleados por Centro Funcional: Incluye AF --->
<cfelseif LvarTipoUsuCF EQ "EMP">
	<cfquery datasource="#session.dsn#">
		insert into #CFusu#
		(CFid, Usucodigo, DEid, EncargadoAF, ResponsableAF, CFori)
		select eaf.CFid, ue.Usucodigo, eaf.DEid
			 , eaf.ECFencargado, 1
			 , '#trim(rsCF.CFcodigo)#'
		  from EmpleadoCFuncional eaf
			inner join DatosEmpleado e on e.DEid = eaf.DEid 
			inner join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and <cf_dbfunction name="to_number" args="llave"> = e.DEid
		 where eaf.CFid = #rsCF.CFid#
		   and <cf_dbfunction name="today"> between ECFdesde and ECFhasta
	</cfquery>
<!--- Plazas y Empleados de Recursos Humanos --->
<cfelse>
	<cfquery datasource="#session.dsn#">
		insert into #CFusu#
		(CFid, Usucodigo, RHPid, DEid, EmpleadoRH, Jefe, CFori)
		select p.CFid, ue.Usucodigo
			 , p.RHPid, e.DEid, 1,
		<cfif rsCF.RHPid NEQ "">
			case when p.RHPid = #rsCF.RHPid# then 1 else 0 end
		<cfelse>
			0
		</cfif>
			, '#trim(rsCF.CFcodigo)#'
		  from RHPlazas p 
			inner join LineaTiempo lt on lt.RHPid = p.RHPid
			inner join DatosEmpleado e on e.DEid = lt.DEid 
			inner join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and <cf_dbfunction name="to_number" args="llave"> = e.DEid
		 where p.CFid = #rsCF.CFid#
		   and <cf_dbfunction name="today"> between LTdesde and LThasta
	</cfquery>
</cfif>

<!--- Solicitantes de Compras --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select sc.CFid, ue.Usucodigo
		,CMSestado as SolicitanteCM
	  from CMSolicitantes sc 
		inner join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'CMSolicitantes' and <cf_dbfunction name="to_number" args="llave"> = sc.CMSid
	 where sc.CFid = #rsCF.CFid#
</cfquery>
<cfset sbLlenarCFusu(rsSQL, "SolicitanteCM")>

<!--- Encargados y Responsables de Activos Fijos --->
<cfif LvarTipoUsuCF NEQ "EMP">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select eaf.CFid, ue.Usucodigo
			,eaf.ECFencargado as EncargadoAF, eaf.DEid as ResponsableAF
		  from EmpleadoCFuncional eaf
			inner join DatosEmpleado e on e.DEid = eaf.DEid 
			inner join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and <cf_dbfunction name="to_number" args="llave"> = e.DEid
		 where eaf.CFid = #rsCF.CFid#
		   and <cf_dbfunction name="today"> between ECFdesde and ECFhasta
	</cfquery>
	<cfset sbLlenarCFusu(rsSQL, "EncargadoAF,ResponsableAF")>
</cfif>	

<!--- Responsable del Centro Funcional --->
<cfif rsCF.CFuresponsable NEQ "">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CFid, CFuresponsable as Usucodigo, 1 as Jefe
		  from CFuncional
		 where CFid = #rsCF.CFid#
	</cfquery>
	<cfset sbLlenarCFusu(rsSQL, "Jefe")>
</cfif>

<!--- Autorizadores del Centro Funcional para Recursos Humanos y Compras --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select CFid, Usucodigo, 1 as AutorizadorRH
	  from CFautoriza
	 where CFid = #rsCF.CFid#
</cfquery>
<cfset sbLlenarCFusu(rsSQL, "AutorizadorRH")>

<!--- Seguridad Presupuesto --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select u.CFid, u.Usucodigo, CPSUaprobacion, CPSUtraslados, CPSUreservas, CPSUformulacion
	  from CPSeguridadUsuario u
	 where u.CFid = #rsCF.CFid#
	   and (CPSUaprobacion = 1 OR CPSUtraslados = 1 OR CPSUreservas = 1 OR CPSUformulacion = 1)
</cfquery>
<cfset sbLlenarCFusu(rsSQL, "CPSUaprobacion,CPSUtraslados,CPSUreservas,CPSUformulacion")>

<!--- Seguridad Tesoreria --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select u.CFid, u.Usucodigo, TESUSPaprobador, TESUSPsolicitante
	  from TESusuarioSP u
	 where u.CFid = #rsCF.CFid#
	   and (TESUSPaprobador = 1 OR TESUSPsolicitante=1)
</cfquery>
<cfset sbLlenarCFusu(rsSQL, "TESUSPaprobador,TESUSPsolicitante")>

<!--- Seguridad Gasto Empleados --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select u.CFid, u.Usucodigo, TESUGEaprobador, TESUGEsolicitante
	  from TESusuarioGE u
	 where u.CFid = #rsCF.CFid#
	   and (TESUGEaprobador = 1 OR TESUGEsolicitante=1)
</cfquery>
<cfset sbLlenarCFusu(rsSQL, "TESUGEaprobador,TESUGEsolicitante")>

<!--- Seguridad Plan de Compras Gobierno --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select u.CFid, u.Usucodigo, FPSUestimar
	  from FPSeguridadUsuario u 
	 where u.CFid = #rsCF.CFid#
	   and (FPSUestimar = 1)
</cfquery>
<cfset sbLlenarCFusu(rsSQL, "FPSUestimar")>

<!--- Orden de Visualizacion --->
<cfquery datasource="#session.dsn#">
	update #CFusu#
	   set Secuencia =
	   		case 
				when Jefe=1				then 1
				when AutorizadorRH=1	then 2
				when EmpleadoRH=1		then 3
				when SolicitanteCM=1	then 4
				else 99
			end
	 where CFid = #rsCF.CFid#
</cfquery>

<!--- Determina Centro Funcional de Usuarios de Otros Centros Funcionales --->
<cfquery datasource="#session.dsn#">
	update #CFusu#
	   set DEid =
	   	(
			select min(e.DEid)
			  from UsuarioReferencia ue 
				inner join DatosEmpleado e on e.DEid = <cf_dbfunction name="to_number" args="llave">
			 where ue.Ecodigo = #session.EcodigoSDC# 
			   and ue.STabla = 'DatosEmpleado' 
			   and ue.Usucodigo	= #CFusu#.Usucodigo
		)
	     , CFori =
	<cfif LvarTipoUsuCF EQ "USU">
	   	(
			select CFcodigo
			  from UsuarioCFuncional cfu
			  	inner join CFuncional cf
					on cf.CFid = cfu.CFid
			 where cfu.Usucodigo	= #CFusu#.Usucodigo
			   and cfu.Ecodigo		= #session.Ecodigo#
		)
	<cfelseif LvarTipoUsuCF EQ "EMP">
	   	(
			select min(CFcodigo)
			  from EmpleadoCFuncional eaf
				inner join CFuncional cf on cf.CFid = eaf.CFid
				inner join DatosEmpleado e on e.DEid = eaf.DEid 
				inner join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and <cf_dbfunction name="to_number" args="llave"> = e.DEid
			 where ue.Usucodigo	= #CFusu#.Usucodigo
			   and cf.Ecodigo	= #session.Ecodigo#
			   and <cf_dbfunction name="today"> between ECFdesde and ECFhasta
		)
	<cfelse>
	   	(
			select min(CFcodigo)
			  from RHPlazas p 
				inner join CFuncional cf on cf.CFid = p.CFid
				inner join LineaTiempo lt on lt.RHPid = p.RHPid
				inner join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and <cf_dbfunction name="to_number" args="llave"> = lt.DEid
			 where ue.Usucodigo	= #CFusu#.Usucodigo
			   and cf.Ecodigo	= #session.Ecodigo#
			   and <cf_dbfunction name="today"> between LTdesde and LThasta
		)
	     , EmpleadoRH =
		 coalesce(
	   	(
			select 1
			  from RHPlazas p 
				inner join CFuncional cf on cf.CFid = p.CFid
				inner join LineaTiempo lt on lt.RHPid = p.RHPid
				inner join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and <cf_dbfunction name="to_number" args="llave"> = lt.DEid
			 where ue.Usucodigo	= #CFusu#.Usucodigo
			   and cf.Ecodigo	= #session.Ecodigo#
			   and <cf_dbfunction name="today"> between LTdesde and LThasta
		), 0)
	</cfif>
	 where CFid = #rsCF.CFid#
	<cfif LvarTipoUsuCF NEQ "USU">
	   and CFori is null
	</cfif>
</cfquery>

<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT">
<cfquery name="rsSQL" datasource="#session.dsn#">
	select cfu.*, d.*, u.*, e.*
		 , e.DEidentificacion
		 , e.DEnombre #_CAT# ' ' #_CAT# e.DEapellido1 #_CAT# ' ' #_CAT# e.DEapellido2 as DEnombre
	  from #CFusu# cfu
	  	inner join Usuario u 
			on u.Usucodigo = cfu.Usucodigo
		inner join DatosPersonales d 
			on d.datos_personales = u.datos_personales
		left join DatosEmpleado e on e.DEid = cfu.DEid
	where cfu.CFid = #rsCF.CFid#
	order by Secuencia
</cfquery>



<table width="100%" border="0" cellpadding="1" cellspacing="0">
	
	<tr valign="top">
		<td colspan="20"  class="tituloListas">
		<div align="left" style="background-color:#E5E5E5; font-size:13px;">
			<cfif modo NEQ "ALTA">
				<cfoutput>#LB_CentroFuncional# : #trim(rsCF.CFcodigo)#-#rsCF.CFdescripcion#</cfoutput>
			</cfif>
		</div>
		</td>
	</tr>
	<tr>
		<td align="left" colspan="3">
			<strong>POSIBLES USUARIOS PARTICIPANTES</strong>
		</td>
		<td align="center" rowspan="2">
			<strong>REF.<BR>EMPL.</strong>
		</td>
		<td align="center" rowspan="2">
			<strong>JEFE</strong>
		</td>
		<td align="center" rowspan="2">
			<strong>CF<BR>PROPIO</strong>
		</td>
		<td align="center" colspan="2">
			<strong>REC.HUMANOS</strong>
		</td>
		<td align="center" colspan="2">
			<strong>COMPRAS</strong>
		</td>
		<td align="center" colspan="2">
			<strong>TESORERIA</strong>
		</td>
		<td align="center" colspan="2">
			<strong>PRESUPUES</strong>
		</td>
	</tr>
	<tr>
		<!--- Usuario --->
		<td>
			<strong>Identificación</strong>
		</td>
		<td>
			<strong>Login</strong>
		</td>
		<td>
			<strong>Nombre</strong>
		</td>

		<!--- Es Empleado --->
		<!--- Jefe --->
		<!--- Centro Funcional --->

		<!--- Recursos Humanos --->
		<td align="center">
			<strong>Autorz</strong>
		</td>
		<td align="center">
			<strong>Empl.</strong>
		</td>

		<!--- Compras --->
		<td align="center">
			<strong>Autorz</strong>
		</td>
		<td align="center">
			<strong>Solic</strong>
		</td>

		<!--- Tesoreria --->
		<td align="center">
			<strong>Aprob</strong>
		</td>
		<td align="center">
			<strong>Solic</strong>
		</td>

		<!--- Presupuesto --->
		<td align="center">
			<strong>Aprob</strong>
		</td>
		<td align="center">
			<strong>Trasl</strong>
		</td>
	</tr>
	<cfset LvarClass = "listaNon">
	<cfoutput query="rsSQL">
	<cfif LvarClass EQ "listaNon"><cfset LvarClass = "listaPar"><cfelse><cfset LvarClass = "listaNon"></cfif>
	<tr class="#LvarClass#" onmouseover="this.className='listaNonSel';" onmouseout="this.className='#LvarClass#';"> 
			<!--- Usuario --->
			<td>
				#rsSQL.Pid#
			</td>
			<td>
				#rsSQL.Usulogin#
			</td>
			<td>
				#rtrim(rsSQL.Pnombre)# #rtrim(rsSQL.Papellido1)# #rtrim(rsSQL.Papellido2)#
			</td>
	
			<!--- DEid --->
			<cfif rsSQL.DEidentificacion EQ rsSQL.Pid>
				<td align="center">
					<strong>X</strong>
				</td>
			<cfelseif rsSQL.DEidentificacion NEQ "">
				<td align="center" style="cursor:pointer" onclick="alert('#JSStringFormat("EMPLEADO: #trim(rsSQL.DEidentificacion)# - #trim(rsSQL.DEnombre)# #trim(rsSQL.DEapellido1)# #trim(rsSQL.DEapellido2)#")#');">

						<strong>?</strong>
				</td>
			<cfelse>
				<td></td>
			</cfif>

			<!--- Jefe --->
			<td align="center">
				<cfif rsSQL.Jefe EQ 1><strong>X</strong></cfif>
			</td>
			<!--- CFori --->
			<td align="center">
				<strong>#rsSQL.CFori#</strong>
			</td>
	
			<!--- Recursos Humanos --->
			<td align="center">
				<cfif rsSQL.AutorizadorRH EQ 1><strong>X</strong></cfif>
			</td>
			<td align="center">
				<cfif rsSQL.EmpleadoRH EQ 1><strong>X</strong></cfif>
			</td>
	
			<!--- Compras --->
			<td align="center">
				<cfif rsSQL.AutorizadorRH EQ 1><strong>X</strong></cfif>
			</td>
			<td align="center">
				<cfif rsSQL.SolicitanteCM EQ 1><strong>X</strong></cfif>
			</td>
	
			<!--- Tesoreria --->
			<td align="center">
				<cfif rsSQL.TESUSPaprobador EQ 1><strong>X</strong></cfif>
			</td>
			<td align="center">
				<cfif rsSQL.TESUSPsolicitante EQ 1><strong>X</strong></cfif>
			</td>
	
			<!--- Presupuesto --->
			<td align="center">
				<cfif rsSQL.CPSUaprobacion EQ 1><strong>X</strong></cfif>
			</td>
			<td align="center">
				<cfif rsSQL.CPSUtraslados EQ 1><strong>X</strong></cfif>
			</td>
		</tr>
	</cfoutput>
	<tr><td>&nbsp;</td></tr>
	<tr valign="top">
		<td colspan="20"  class="tituloListas">
		<div align="left" style="background-color:#E5E5E5; font-size:13px;">
			RESPONSABLE INMEDIATO DE LA JEFATURA
		</div>
		</td>
	</tr>
	<cfset LvarUresp = "">
	<cfset rsCF.CFidresp = rsCF.CFidresp>
	<cfif rsCF.CFidresp NEQ "">
		<cfloop condition="true">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select CFcodigo, CFdescripcion, CFuresponsable, RHPid, CFidresp
				  from CFuncional
				 where CFid = #rsCF.CFidresp#
			</cfquery>
			<cfset rsCF.CFidresp = rsSQL.CFidresp>
			<cfif LvarClass EQ "listaNon"><cfset LvarClass = "listaPar"><cfelse><cfset LvarClass = "listaNon"></cfif>
			<tr class="<cfoutput>#LvarClass#</cfoutput>" onmouseover="this.className='listaNonSel';" onmouseout="this.className='<cfoutput>#LvarClass#</cfoutput>';"> 
				<td colspan="20">
					<cfoutput>#LB_CentroFuncional# Responsable: #trim(rsSQL.CFcodigo)#-#rsSQL.CFdescripcion#</cfoutput>
				</td>
			</tr>
			<cfif rsSQL.CFuresponsable NEQ "">
				<!--- Usuario Responsable: CFuresponsable --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select u.Usucodigo, d.Pid, u.Usulogin, d.Pnombre, d.Papellido1, d.Papellido2, 0 as RHPid
					  from Usuario u
						inner join DatosPersonales d 
							on d.datos_personales = u.datos_personales
					 where u.Usucodigo = #rsSQL.CFuresponsable#
				</cfquery>
				<cfset LvarUresp = rsSQL.Usucodigo>
			<cfelseif rsSQL.RHPid NEQ "">
				<!--- Plaza Responsable --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select u.Usucodigo, d.Pid, u.Usulogin, d.Pnombre, d.Papellido1, d.Papellido2
						 , p.RHPid
					  from RHPlazas p 
						inner join LineaTiempo lt on lt.RHPid = p.RHPid
						inner join DatosEmpleado e on e.DEid = lt.DEid 
						inner join UsuarioReferencia ue on ue.Ecodigo = #session.EcodigoSDC# and ue.STabla = 'DatosEmpleado' and <cf_dbfunction name="to_number" args="llave"> = e.DEid
						inner join Usuario u on u.Usucodigo = ue.Usucodigo
						inner join DatosPersonales d 
							on d.datos_personales = u.datos_personales
							
					 where p.RHPid = #rsSQL.RHPid#
					 <cfif rsCF.recordcount GT 0 and len(trim(rsCF.CFidresp)) GT 0>
					   and p.CFid = #rsCF.CFidresp#
				   </cfif>
					   and <cf_dbfunction name="today"> between LTdesde and LThasta
				</cfquery>
				<cfset LvarUresp = rsSQL.Usucodigo>
			</cfif>
			<cfif  LvarUresp NEQ "">
				<cfoutput>
				<tr class="#LvarClass#" onmouseover="this.className='listaNonSel';" onmouseout="this.className='#LvarClass#';"> 
					<!--- Usuario --->
					<td>
						#rsSQL.Pid#
					</td>
					<td>
						#rsSQL.Usulogin#
					</td>
					<td>
						#rtrim(rsSQL.Pnombre)# #rtrim(rsSQL.Papellido1)# #rtrim(rsSQL.Papellido2)#
					</td>
					<!--- Jefe --->
					<td align="center">
						<strong>X</strong>
					</td>
			
					<!--- Recursos Humanos --->
					<td align="center">
						
					</td>
					<td align="center">
						<cfif rsSQL.RHPid NEQ 0><strong>X</strong></cfif>
					</td>
					<td colspan="20"></td>
				</tr>
				</cfoutput>
				<cfbreak>
			</cfif>
			<cfif rsCF.CFidresp EQ "">
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
	<cfif LvarUresp EQ "">
		<tr class="#LvarClass#" onmouseover="this.className='listaNonSel';" onmouseout="this.className='#LvarClass#';"> 
			<td colspan="20">
				<cfoutput>
				El #LB_CentroFuncional# no tiene responsable inmediato
				</cfoutput>
			</td>
		</tr>	
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Oficodigo, Odescripcion, SScodigo, SRcodigo
		  from Oficinas
		 where Ecodigo = #session.Ecodigo#
		   and Ocodigo = #rsCF.Ocodigo#
	</cfquery>
	
	<cfif rsSQL.SScodigo NEQ "">
		<tr><td>&nbsp;</td></tr>
		<tr valign="top">
			<td colspan="20"  class="tituloListas">
			<div align="left" style="background-color:#E5E5E5; font-size:13px;">
				<cfoutput>
				OFICINA : #trim(rsSQL.Oficodigo)# - #trim(rsSQL.Odescripcion)#<BR>
				ROL AUTORIZADOR PARA TRAMITES : #trim(rsSQL.SScodigo)#.#trim(rsSQL.SScodigo)#
				</cfoutput>
			</div>
			</td>
		</tr>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select u.Usucodigo, d.Pid, u.Usulogin, d.Pnombre, d.Papellido1, d.Papellido2, 0 as RHPid
			  from UsuarioRol ur
				join Usuario u
					on ur.Usucodigo = u.Usucodigo
				join DatosPersonales d
					on u.datos_personales = d.datos_personales
			 where ur.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.SScodigo#">
			   and ur.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.SRcodigo#">
			   and ur.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		</cfquery>
		<cfoutput query="rsSQL">
			<cfif LvarClass EQ "listaNon"><cfset LvarClass = "listaPar"><cfelse><cfset LvarClass = "listaNon"></cfif>
			<tr class="#LvarClass#" onmouseover="this.className='listaNonSel';" onmouseout="this.className='#LvarClass#';"> 
				<!--- Usuario --->
				<td>
					#rsSQL.Pid#
				</td>
				<td>
					#rsSQL.Usulogin#
				</td>
				<td>
					#rtrim(rsSQL.Pnombre)# #rtrim(rsSQL.Papellido1)# #rtrim(rsSQL.Papellido2)#
				</td>
				<td colspan="20"></td>
			</tr>
		</cfoutput>
	</cfif>
</table>

<cffunction name="sbLlenarCFusu" output="true" returntype="void">
	<cfargument name="rs" 		type="query">
	<cfargument name="campos" 	type="string">
	<cfloop query="Arguments.rs">
		<cfif Arguments.rs.Usucodigo NEQ "">
			<cfquery name="rsExiste" datasource="#session.dsn#">
				select count(1) as cantidad, count(CFori) as CFori
				  from #CFusu#
				 where CFid		 = #Arguments.rs.CFid#
				   and Usucodigo = #Arguments.rs.Usucodigo#
			</cfquery>

			<cfif rsExiste.cantidad EQ 0>
				<cfquery datasource="#session.dsn#">
					insert into #CFusu#
					(CFid, Usucodigo, #Arguments.Campos#)
					values (
						 #Arguments.rs.CFid#
						,#Arguments.rs.Usucodigo#
						<cfloop list="#Arguments.Campos#" index="LvarCampo">
							<cfset LvarValor = Arguments.rs[LvarCampo]>
							,<cfif LvarValor NEQ 0 and LvarValor NEQ "">1<cfelse>0</cfif>
						</cfloop>
					)
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.dsn#">
					update #CFusu#
					   set Secuencia = Secuencia
					<cfloop list="#Arguments.Campos#" index="LvarCampo">
						<cfset LvarValor = Arguments.rs[LvarCampo]>
						<cfif LvarValor NEQ 0 and LvarValor NEQ "">, #LvarCampo# = 1</cfif>
					</cfloop>
					 where CFid		 = #Arguments.rs.CFid#
					   and Usucodigo = #Arguments.rs.Usucodigo#
				</cfquery>
			</cfif>
			<cfif rsExiste.CFori EQ 0>
				<cfquery name="rsExiste" datasource="#session.dsn#">
					select count(1) as cantidad
					  from UsuarioCFuncional
					 where Ecodigo	 = #session.Ecodigo#
					   and Usucodigo = #Arguments.rs.Usucodigo#
				</cfquery>
				<cfif rsExiste.cantidad EQ 0>
					<cfquery name="rsExiste" datasource="#session.dsn#">
						insert into UsuarioCFuncional (
							CFid, Usucodigo, Ecodigo, BMfalta, BMUsucodigo
						)
						values (
							#Arguments.rs.CFid#,
							#Arguments.rs.Usucodigo#,
							#session.Ecodigo#,
							<cf_dbfunction name="now">,
							#session.Usucodigo#
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
</cffunction>

