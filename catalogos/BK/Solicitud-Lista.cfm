
<cfif isdefined("url.Cambio")>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfif not isdefined("url.modo")>    
    	<cfset modo="ALTA">
  	<cfelseif url.modo EQ "CAMBIO">
    	<cfset modo="CAMBIO">
  	<cfelse>
    	<cfset modo="ALTA">
  	</cfif>  
</cfif>
   

<cfquery name="rsFPagos" datasource="#Session.DSN#">
	select 	
        FPid                 
        ,FPcodigo     
        ,FPdescripcion 
	from FTFormaPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by FPdescripcion
</cfquery>

<cfquery name="rsSolicitudProcesos" datasource="#Session.DSN#">
	select 	
        SPid
        TPid
        ,Vid  
        ,FPid                 
        ,LPid                 
        ,Mcodigo              
        ,SPfecha              
        ,SPfechaReg           
        ,Usucodigo            
        ,SPestado             
        ,SPacta  
	from  <cf_dbdatabase table="FTSolicitudProceso " datasource="ftec">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by TPid,Vid,FPid
</cfquery>

<cf_dump var="#rsSolicitudProcesos#">




<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select 	CIid, 
			{fn concat( { fn concat(rtrim(CIcodigo), ' - ') }, CIdescripcion) }  as Descripcion,
			CIcantmin, 
			CIcantmax, 
			CItipo
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and CItipo != 3 
	  and CIcarreracp = 0
	order by Descripcion
</cfquery>

<cfset va_arrayvalues=ArrayNew(1)>

<!---activado en parametros generales--->
<cfquery name="rsCargarCF" datasource="#Session.DSN#">
	select Pvalor
		from RHParametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2105
</cfquery>

<cfif modo NEQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("url.Iid") AND Len(Trim(url.Iid)) GT 0>	
	<cfquery name="rsIncidencia" datasource="#Session.DSN#">
		SELECT a.Iid, 
			   a.DEid, 
			   a.CIid, CIcodigo, CIdescripcion,
			   Ifecha as fecha, 
			   IfechaRebajo, 
			   a.Ivalor, 
			   a.Imonto,
			   a.Usucodigo, a.Ulocalizacion, 
				{fn concat({fn concat({fn concat({ fn concat( b.DEnombre, ' ') }, b.DEapellido1)}, ' ')}, b.DEapellido2) } as 	NombreEmp,
			   b.DEidentificacion,
			   b.DEtarjeta,
			   b.NTIcodigo,
			   a.CFid,
			   a.ts_rversion,
			   RHJid,
			   a.Icpespecial
		FROM CIncidentes c
			inner join  Incidencias a
				on a.CIid = c.CIid		
				inner join DatosEmpleado b
					on a.DEid = b.DEid
			
		WHERE c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Iid#">	
	</cfquery>
	
	<cfif isdefined("rsIncidencia.CIid")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIid)>
	</cfif>
	<cfif isdefined("rsIncidencia.CIcodigo")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIcodigo)>
	</cfif>
	<cfif isdefined("rsIncidencia.CIdescripcion")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIdescripcion)>
	</cfif>
	
	<cfif len(trim(rsIncidencia.CFid)) gt 0><cfset cfid = rsIncidencia.CFid ><cfelse><cfset cfid = -1 ></cfif>

	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFid, CFcodigo, CFdescripcion
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cfid#">
	</cfquery>
	
<cfelseif modo EQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("url.DEid") AND Len(Trim(url.DEid)) NEQ 0>
	<cfquery name="rsEmpleadoDef" datasource="#Session.DSN#">
		select a.DEid, 
			   <cf_dbfunction name="concat" args="a.DEapellido1|' '|a.DEapellido2|', '|a.DEnombre" delimiters="|"> as 	NombreEmp,
		       a.DEidentificacion, 
			   a.NTIcodigo
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>
</cfif>

<!--- Usuarios que han insertado incidencias --->
<cfquery name="rsUsuariosRegistro" datasource="#Session.DSN#">
	select distinct coalesce(a.Usucodigo,-1) as Usucodigo
	from CIncidentes c
		inner join Incidencias a
			on c.CIid = a.CIid 	
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsUsuarios" datasource="asp">
	select 	u.Usucodigo as Codigo,
		  	{fn concat({fn concat({fn concat({ fn concat(d.Pnombre, ' ') }, d.Papellido1)}, ' ')}, d.Papellido2) } as Nombre
	from Usuario u	
		inner join DatosPersonales d
			on u.datos_personales = d.datos_personales
	<cfif rsUsuariosRegistro.recordCount GT 0>
		where u.Usucodigo in ( #ValueList(rsUsuariosRegistro.Usucodigo)# )
	<cfelse>
		where u.Usucodigo = 0
	</cfif>
</cfquery> 

<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!---*****************************************************************************************
<!--- filtro para la lista --->
<cfset navegacion = "" >
<cfset filtro2 = ''>
<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar")><cfset form.btnFiltrar=1></cfif>
<cfif isdefined("form.btnFiltrar")><cfset navegacion="&btnFiltrar=1"></cfif>

<cfset filtro = "b.Ecodigo = " & Session.Ecodigo >
<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo != 3" ><!------and CItipo != 3--->

<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario NEQ "-1">
	<cfset filtro = filtro & " and a.Usucodigo = #form.Usuario#" >
	<cfset filtro2 = filtro2 & " and a.Usucodigo = #form.Usuario#" >
	<cfset navegacion = trim(navegacion) & "&Usuario=#form.Usuario#">	
<cfelseif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1">
	<cfset filtro = "b.Ecodigo = " & #Session.Ecodigo# >
	<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo != 3" ><!---and CItipo != 3--->
	<cfset navegacion = trim(navegacion) & "&Usuario=#form.Usuario#">	
<cfelse>
	<cfset filtro =  filtro & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset filtro2 =  filtro2 & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset Form.Usuario = Session.Usucodigo >	
</cfif>

<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0 and not isdefined("form.DEid")><cfset form.DEid=url.DEid></cfif>
<cfif isdefined("form.DEid") and len(trim(form.DEid)) gt 0 and isdefined("btnFiltrar")>
	<cfset navegacion = trim(navegacion) & "&DEid=#form.DEid#">
	<cfset filtro = filtro & " and a.DEid=" & form.DEid>
	<cfset filtro2 = filtro2 & " and a.DEid=" & form.DEid>
</cfif>

<cfif isdefined("url.CIid") and len(trim(url.CIid)) gt 0 and not isdefined("form.CIid")><cfset form.CIid=url.CIid></cfif>
<cfif isdefined("form.CIid") and len(trim(form.CIid)) gt 0 and isdefined("btnFiltrar")>
	<cfset navegacion = trim(navegacion) & "&CIid=#form.CIid#">
	<cfset filtro = filtro & " and a.CIid=" & form.CIid>
	<cfset filtro2 = filtro2 & " and a.CIid=" & form.CIid>
</cfif>

<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha)) gt 0 ><cfset form.Ffecha=url.Ffecha></cfif>
<cfif isdefined("form.Ffecha") and len(trim(form.Ffecha)) gt 0 and isdefined("btnFiltrar")>
	<cfset navegacion = trim(navegacion) & "&Ffecha=#form.Ffecha#">	
	<cfset filtro = filtro & " and a.Ifecha =" & LSParseDateTime(form.Ffecha) >
	<cfset filtro2 = filtro2 & " and a.Ifecha =" & LSParseDateTime(form.Ffecha)>
</cfif>

<cfif isdefined("url.CFid") and len(trim(url.CFid)) gt 0 and not isdefined("form.CFid")><cfset form.CFid=url.CFid></cfif>
<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0 and isdefined("btnFiltrar")>
	<cfset navegacion = trim(navegacion) & "&CFid=#form.CFid#">
	<cfset filtro = filtro & " and CFid=" & form.CFid>
	<cfset filtro2 = filtro2 & " and CFid=" & form.CFid>
</cfif>

<cfif isdefined("url.FIcpespecial") and not isdefined("form.FIcpespecial")><cfset form.FIcpespecial=url.FIcpespecial></cfif>
<cfif isdefined("form.FIcpespecial") and isdefined("btnFiltrar") and isdefined("btnFiltrar")>
	<cfset navegacion = trim(navegacion) & "&FIcpespecial=#form.FIcpespecial#">
	<cfset filtro = filtro & " and a.Icpespecial=1">
	<cfset filtro2 = filtro2 & " and a.Icpespecial=1">
<cfelse>
	<cfset filtro = filtro & " and a.Icpespecial=0">
	<cfset filtro2 = filtro2 & " and a.Icpespecial=0">
</cfif>
**************************************************************************************************---->

<cfset navegacion = "" > 
<cfset filtro2 = ''>
<cfset va_arrayIncidencia=ArrayNew(1)>

<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar") and isdefined("url.pagenum_lista")>
	<cfset form.btnFiltrar=1>
</cfif>
<cfif isdefined("url.btnFiltrar")><cfset navegacion="&btnFiltrar=1"></cfif>

<cfset filtro = "b.Ecodigo = " & Session.Ecodigo >
<cfset filtro2 = "and b.Ecodigo = " & Session.Ecodigo >
<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo <= 3" ><!------and CItipo != 3--->

<cfif isdefined("url.Usuario") and Len(Trim(url.Usuario)) NEQ 0 and url.Usuario NEQ "-1">
	<cfset form.usuario = url.usuario>
	<cfset filtro = filtro & " and a.Usucodigo = #url.Usuario#" >
	<cfset filtro2 = filtro2 & " and a.Usucodigo = #url.Usuario#" >
	<cfset navegacion = trim(navegacion) & "&Usuario=#url.Usuario#">	
<cfelseif isdefined("url.Usuario") and Len(Trim(url.Usuario)) NEQ 0 and url.Usuario EQ "-1">
	<cfset form.usuario = url.usuario>
	<cfset filtro = "b.Ecodigo = " & #Session.Ecodigo# >
	<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo <= 3" ><!---and CItipo != 3--->
	<cfset navegacion = trim(navegacion) & "&Usuario=#url.Usuario#">	
<cfelse>	
	<cfset Form.Usuario = Session.Usucodigo>	
	<cfset filtro =  filtro & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset filtro2 =  filtro2 & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset navegacion = trim(navegacion) & "&Usuario=#form.Usuario#">	
</cfif>

<cfif isdefined("url.DEid1") and len(trim(url.DEid1)) gt 0 and not isdefined("form.DEid1") >
	<cfset form.DEid1=url.DEid1>
</cfif>

<cfif isdefined("url.DEid1") and len(trim(url.DEid1)) gt 0>
	<cfset navegacion = trim(navegacion) & "&DEid1=#url.DEid1#">
	<cfset filtro = filtro & " and a.DEid=" & url.DEid1>
	<cfset filtro2 = filtro2 & " and a.DEid=" & url.DEid1>
	<cfquery name="rsEmpleadoFiltro" datasource="#Session.DSN#">
		select a.DEid as DEid1, 
			   <cf_dbfunction name="concat" args="a.DEapellido1|' '|a.DEapellido2|', '|a.DEnombre" delimiters="|"> as 	NombreEmp1,
		       a.DEidentificacion as DEidentificacion1, 
			   a.NTIcodigo as NTIcodigo1
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid1#">
	</cfquery>
</cfif>

<cfif isdefined("url.CIid_f") and len(trim(url.CIid_f)) gt 0 and not isdefined("form.CIid_f")>
	<cfset form.CIid_f=url.CIid_f>
</cfif>
<cfif isdefined("url.CIid_f") and len(trim(url.CIid_f)) gt 0>
	<cfset navegacion = trim(navegacion) & "&CIid_f=#url.CIid_f#">
	<cfset filtro = filtro & " and a.CIid=" & url.CIid_f>
	<cfset filtro2 = filtro2 & " and a.CIid=" & url.CIid_f>
	<cfquery name="rsCIid" datasource="#session.DSN#">
		select CIid, CIcodigo, CIdescripcion
		from CIncidentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid_f#">			
	</cfquery>
	<cfif isdefined("rsCIid.CIid")>
		<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIid)>
	</cfif>
	<cfif isdefined("rsCIid.CIcodigo")>
		<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIcodigo)>
	</cfif>
	<cfif isdefined("rsCIid.CIdescripcion")>
		<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIdescripcion)>
	</cfif>
</cfif>

<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha)) gt 0 and not isdefined("url.Ffecha")>
	<cfset form.Ffecha=url.Ffecha>
</cfif>
<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha)) gt 0 >
	<cfset navegacion = trim(navegacion) & "&Ffecha=#url.Ffecha#">	
	<cfset filtro = filtro & " and a.Ifecha =" & LSParseDateTime(url.Ffecha) >
	<cfset filtro2 = filtro2 & " and a.Ifecha =" & LSParseDateTime(url.Ffecha)>
</cfif>

<cfif isdefined("url.IfechaRebajo_f") and len(trim(url.IfechaRebajo_f)) gt 0 and not isdefined("form.IfechaRebajo_f")>
	<cfset form.IfechaRebajo_f=url.IfechaRebajo_f>
</cfif>
<cfif isdefined("url.IfechaRebajo_f") and len(trim(url.IfechaRebajo_f)) gt 0 >
	<cfset navegacion = trim(navegacion) & "&IfechaRebajo_f=#url.IfechaRebajo_f#">	
	<cfset filtro = filtro & " and a.IfechaRebajo  =" & LSParseDateTime(url.IfechaRebajo_f) >
	<cfset filtro2 = filtro2 & " and a.IfechaRebajo  =" & LSParseDateTime(url.IfechaRebajo_f)>
</cfif>

<cfif isdefined("url.CFid_f") and len(trim(url.CFid_f)) gt 0 and not isdefined("url.CFid_f")>
	<cfset form.CFid_f=url.CFid_f>
</cfif>
<cfif isdefined("url.CFid_f") and len(trim(url.CFid_f)) gt 0>
	<cfset navegacion = trim(navegacion) & "&CFid_f=#url.CFid_f#">
	<cfset filtro = filtro & " and CFid=" & url.CFid_f>
	<cfset filtro2 = filtro2 & " and CFid=" & url.CFid_f>
	<cfquery name="rsCfuncionalFiltro" datasource="#session.DSN#">
		select CFid as CFid_f, CFcodigo as CFcodigo_f, CFdescripcion as CFdescripcion_f
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid_f#">
	</cfquery>
</cfif>

<cfif isdefined("url.FIcpespecial_f") and len(trim(url.FIcpespecial_f)) and not isdefined("form.FIcpespecial_f")>
	<cfset form.FIcpespecial_f=url.FIcpespecial_f>
</cfif>
<cfif isdefined("url.FIcpespecial_f") and len(trim(url.FIcpespecial_f)) and url.FIcpespecial_f EQ 1>
	<cfset navegacion = trim(navegacion) & "&FIcpespecial_f=#url.FIcpespecial_f#">
	<cfset filtro = filtro & " and a.Icpespecial=1">
	<cfset filtro2 = filtro2 & " and a.Icpespecial=1">
<cfelse>
	<cfset filtro = filtro & " and a.Icpespecial=0">
	<cfset filtro2 = filtro2 & " and a.Icpespecial=0">
</cfif>

<!---Cargar select :(  vs_select NO SE USA, puede eliminarse ---->
<cfset vs_select = ''>
<cfif isdefined("url.Usuario") and len(trim(url.Usuario))>
	<cfset vs_select = ",#url.Usuario# as Usuario">	
<cfelse>
	<cfset vs_select = ",'' as Usuario">	
</cfif>
<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha))>
	<cfset vs_select = vs_select & ",#url.Ffecha# as Ffecha">	
<cfelse>
	<cfset vs_select = vs_select &  ",'' as Ffecha">	
</cfif>
<cfif isdefined("url.CIid_f") and len(trim(url.CIid_f))>
	<cfset vs_select = vs_select & ",#url.CIid_f# as CIid_f">	
<cfelse>
	<cfset vs_select = vs_select &  ",'' as CIid_f">	
</cfif>
<cfif isdefined("url.DEid1") and len(trim(url.DEid1))>
	<cfset vs_select = vs_select & ",#url.DEid1# as DEid1">	
<cfelse>
	<cfset vs_select = vs_select &  ",'' as DEid1">	
</cfif>
<cfif isdefined("url.FIcpespecial_f") and len(trim(url.FIcpespecial_f))>
	<cfset vs_select = vs_select & ",#url.FIcpespecial_f# as FIcpespecial_f">	
<cfelse>
	<cfset vs_select = vs_select &  ",'' as FIcpespecial_f">	
</cfif>
<cfif isdefined("url.CFid_f") and len(trim(url.CFid_f))>
	<cfset vs_select = vs_select & ",#url.CFid_f# as CFid_f">	
<cfelse>
	<cfset vs_select = vs_select &  ",'' as CFid_f">	
</cfif>
<cfif isdefined("url.Ifecharebajo_f") and len(trim(url.Ifecharebajo_f))>
	<cfset vs_select = vs_select & ",#url.Ifecharebajo_f# as Ifecharebajo_f">	
<cfelse>
	<cfset vs_select = vs_select &  ",'' as Ifecharebajo_f">	
</cfif>

<!--- ============================================= --->
<!--- Traducciones --->
<!--- ============================================= --->
	<!--- Empleado --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Empleado"
		default="Empleado"
		xmlfile="/rh/generales.xml"
		returnvariable="vEmpleado"/>
	<!--- Concepto_Incidente --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="Concepto_Incidente"
		default="Concepto Incidente"
		xmlfile="/rh/generales.xml"
		returnvariable="vConcepto"/>		
	<!--- Fecha --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha"
		default="Fecha"
		xmlfile="/rh/generales.xml"
		returnvariable="vFecha"/>		
	<!--- Boton Importar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Importar"
		default="Importar"
		xmlfile="/rh/generales.xml"
		returnvariable="vImportar"/>	
	<!----Boton Importar Calculo---->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_ImportarCalculo"
		default="Importar Cálculo"
		returnvariable="LB_ImportarCalculo"/>			
	<!--- Boton Filtrar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Filtrar"
		default="Filtrar"
		xmlfile="/rh/generales.xml"
		returnvariable="vFiltrar"/>		
	<!--- Cantidad/Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Monto"
		default="Cantidad/Monto"
		returnvariable="vCantidadMonto"/>
	<!--- Cantidad horas --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Horas"
		default="Cantidad horas"
		returnvariable="vCantidadHoras"/>
	<!--- Cantidad dias --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Dias"
		default="Cantidad Dias"
		returnvariable="vCantidadDias"/>
	<!--- Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Monto"
		default="Monto"
		xmlfile="/rh/generales.xml"
		returnvariable="vMonto"/>
	<!--- Valor --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Valor"
		default="Valor"
		xmlfile="/rh/generales.xml"		
		returnvariable="vValor"/>	
	<!--- Monto Calculado --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_MontoCalculado"
		default="Monto Calculado*"
		xmlfile="/rh/generales.xml"		
		returnvariable="vMontoCalculado"/>		
	<!--- Validacion Cant.digitada fuera de rango --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_La_Cantidad_digitada_se_sale_del_rango_permitido"
		default="La Cantidad digitada se sale del rango permitido"
		returnvariable="vCantidadValidacion"/>
	<!--- No puede ser cero --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_No_puede_ser_cero"
		default="No puede ser cero"
		returnvariable="vNoCero"/>		
	<!--- Icpespecial --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_CP_Especiales"
		default="CP Especiales"
		returnvariable="vIcpespecial"/>
	<!---Lista conlis--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_ListaDeIncidencias"
		default="Lista de Incidencias"
		returnvariable="LB_ListaDeIncidencias"/>		
	<!---Etiqueta descripcion--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Descripcion"
		default="Descripci&oacute;n"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Descripcion"/>
			<!---Etiqueta Monto Calculado--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_NotaMontoCalculado"
		default=" Unicamente para  Incidencias tipo C&aacute;lculo. Representa el monto calculado de la incidencia"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_NotaMontoCalculado"/>
<!--- ============================================= --->
<!--- ============================================= --->

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var tipoConc= new Object();
	var rangoMin = new Object();
	var rangoMax = new Object();
	<cfloop query="rsConceptos">
		tipoConc['<cfoutput>#CIid#</cfoutput>'] = parseInt(<cfoutput>#CItipo#</cfoutput>);
		rangoMin['<cfoutput>#CIid#</cfoutput>'] = parseFloat(<cfoutput>#CIcantmin#</cfoutput>);
		rangoMax['<cfoutput>#CIid#</cfoutput>'] = parseFloat(<cfoutput>#CIcantmax#</cfoutput>);
	</cfloop>

	function validaForm(f) {
		f.obj.Ivalor.value = qf(f.obj.Ivalor.value);
		return true;
	}
	
	function changeValLabel() {
		var id = document.form1.CIid.value;
		var tipo = tipoConc[id];
		var a = document.getElementById("TDValorLabel");
		var t = null; 
		var t2 = null;
		switch (tipo) {
			<cfoutput>
			case 0: t = document.createTextNode("#vCantidadHoras#"); objForm.Ivalor.description = "#vCantidadHoras#"; break;
			case 1: t = document.createTextNode("#vCantidadDias#"); objForm.Ivalor.description = "#vCantidadDias#"; break;
			case 2: t = document.createTextNode("#vMonto#"); objForm.Ivalor.description = "#vMonto#"; break;
			default: t = document.createTextNode("#vValor#"); objForm.Ivalor.description = "#vValor#";
			</cfoutput>
		}
		if (a.hasChildNodes()) a.replaceChild(t,a.firstChild);
		else a.appendChild(t);
		// Habilitar/deshabilitar combo de jornadas
		var vs_trLabelJornada = document.getElementById("TRLabelJornada");
		var vs_trJornada = document.getElementById("TRJornada");
		if (tipo == 0 || tipo == 1){
			vs_trLabelJornada.style.display = '';
			vs_trJornada.style.display = '';
		}
		else{
			vs_trLabelJornada.style.display = 'none';
			vs_trJornada.style.display = 'none';		
		}
	}	
	//-->
</script>
<cfoutput>

<!----********************************************************************************************
<cfif rsUsuarios.recordCount GT 0>    <!---COMENTADO... SE PUEDE ELIMINAR--->
	<form name="formUsuario" method="post" action="Incidencias.cfm">
		<table class="areaFiltro" width="100%" border="1" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<strong><cf_translate key="LB_Usuario" xmlfile="/rh/generales.xml">Usuario</cf_translate></strong><br>
			  		<select name="Usuario" onChange="javascript: this.form.submit();" tabindex="1">
				  		<option value="-1" <cfif Form.Usuario EQ "-1">selected</cfif>>(<cf_translate key="LB_Todos" xmlfile="/rh/generales.xml">Todos</cf_translate>)</option>
						<cfloop query="rsUsuarios">
				  			<option value="#rsUsuarios.Codigo#" <cfif Form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
						</cfloop>
			  		</select>
				</td>
				<td>
					<strong><cf_translate key="LB_Fecha">Fecha</cf_translate> </strong>
					<cfif isdefined("form.Ffecha") and len(trim(form.Ffecha))>
						<cf_sifcalendario form="formUsuario" name="Ffecha" value="#form.Ffecha#">
					<cfelse>
						<cf_sifcalendario form="formUsuario" name="Ffecha" value="">
					</cfif>					
				</td>
				<td>
					<strong><cf_translate key="LB_Concepto_Incidente">Concepto Incidente</cf_translate></strong>
					<!---<cf_rhCIncidentes form="formUsuario" CIid="CIid" CIcodigo="CIcodigo" CIdescripcion="CIdescripcion" index="10" ExcluirTipo="">  <!--- jc ExcluirTipo="3"--->---->					
					<cf_conlis title="#LB_ListaDeIncidencias#"
						campos = "CIid_f,CIcodigo_f,CIdescripcion_f" 
						desplegables = "N,S,S" 
						modificables = "N,S,N" 
						size = "0,10,20"
						asignar="CIid_f,CIcodigo_f,CIdescripcion_f"
						asignarformatos="I,S,S"
						tabla="	CIncidentes a"																	
						columnas="CIid as CIid_f,CIcodigo as CIcodigo_f, CIdescripcion as CIdescripcion_f, CInegativo as CInegativo_f"
						filtro="a.Ecodigo =#session.Ecodigo#
								and coalesce(a.CInomostrar,0) = 0"
						desplegar="CIcodigo_f,CIdescripcion_f"
						etiquetas="	#vConcepto#, 
									#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						showEmptyListMsg="true"
						debug="false"
						form="formUsuario"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="CIcodigo,CIdescripcion">
				</td>
				<td><input type="submit" name="btnFiltrar" value="#vFiltrar#" onClick="filtrar();">	</td>				
		  	</tr>
			<tr>
				<td>
					<strong>#vEmpleado#</strong><br>
					<cf_rhempleado tabindex="1" size = "30" DEid="DEid" index="1" form="formUsuario">
				</td>
				<td colspan="3">
					<input type="checkbox" name="FIcpespecial_f" id="FIcpespecial_f" onClick="javascript:fechaRebajo(this);" value="" <cfif modo EQ "CAMBIO" and rsIncidencia.Icpespecial EQ 1>checked<cfelseif isdefined("form.FIcpespecial")>checked</cfif> > 
					<cf_translate key="LB_Incluir_solo_en_Calendario_de_Pagos_especiales">Incluir solo en Calendario de Pagos especiales</cf_translate>
				</td>
			</tr>
			<tr>
				<td>
					<strong><cf_translate key="LB_Centro_Funcional_de_Servicio">Centro Funcional de Servicio</cf_translate></strong><br>
					<cf_rhcfuncional tabindex="1" id="CFid_f">
				</td>
				<td>
					<strong><cf_translate key="LB_FechaRebajo">Fecha Rebajo</cf_translate></strong><br>
					<cf_sifcalendario form="formUsuario" name="IfechaRebajo_f" >
				</td>
			</tr>
		</table>
		<!---<input type="hidden" name="DEid" value="<cfif isdefined("Form.DEid")>#Form.DEid#</cfif>">--->
	</form>
</cfif>
**********************************************************************************--->

<form  name="form1" method="post" action="SolicitudPago-Sql.cfm" onSubmit="javascript: return validaForm(this);">
	<table width="95%" align="center" border="1" cellspacing="0" cellpadding="1">		
		<!---************************************* FILTROS ***************************************---->
		<!---
		
		<cfif rsUsuarios.recordCount GT 0>
		<tr><td colspan="4"> 
            <table class="areaFiltro" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="37%">
						<cfif session.menues.SMcodigo neq 'AUTO'>
							<strong><cf_translate key="LB_Usuario" xmlfile="/rh/generales.xml">Usuario</cf_translate></strong><br>
							<select name="Usuario" tabindex="1"><!---onChange="javascript: this.form.submit();" --->
								<option value="-1" <cfif isdefined("url.Usuario") and url.Usuario EQ "-1">selected</cfif>>(<cf_translate key="LB_Todos" xmlfile="/rh/generales.xml">Todos</cf_translate>)</option>
								<cfloop query="rsUsuarios">
									<option value="#rsUsuarios.Codigo#" <cfif form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
								</cfloop>
							</select>
						<cfelse>
							<cfquery name="rs_usuario" datasource="#session.DSN#">
								select Pnombre, Papellido1, Papellido2
								from Usuario u, DatosPersonales dp
								where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								 and dp.datos_personales=u.datos_personales
							</cfquery>
							<strong><cf_translate key="LB_Usuario" xmlfile="/rh/generales.xml">Usuario</cf_translate></strong><br>
							#rs_usuario.Papellido1# #rs_usuario.Papellido2# #rs_usuario.Pnombre#
							<input type="hidden" name="Usuario" value="#session.Usucodigo#" />
 						</cfif>
					</td>
					<td width="23%">
						<strong><cf_translate key="LB_Fecha">Fecha</cf_translate> </strong>
						<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha))>
							<cf_sifcalendario form="form1" name="Ffecha" value="#url.Ffecha#">
						<cfelse>
							<cf_sifcalendario form="form1" name="Ffecha" value="">
						</cfif>				
					</td>
					<td width="40%">
						<strong><cf_translate key="LB_Concepto_Incidente">Concepto Incidente</cf_translate></strong>
						<!---<cf_rhCIncidentes form="formUsuario" CIid="CIid" CIcodigo="CIcodigo" CIdescripcion="CIdescripcion" index="10" ExcluirTipo="">  <!--- jc ExcluirTipo="3"--->---->					
						<cf_conlis title="#LB_ListaDeIncidencias#"
							campos = "CIid_f,CIcodigo_f,CIdescripcion_f" 
							desplegables = "N,S,S" 
							modificables = "N,S,N" 
							size = "0,10,20"
							asignar="CIid_f,CIcodigo_f,CIdescripcion_f"
							asignarformatos="I,S,S"
							tabla="	CIncidentes a"																	
							columnas="CIid as CIid_f,CIcodigo as CIcodigo_f, CIdescripcion as CIdescripcion_f, CInegativo as CInegativo_f"
							filtro="a.Ecodigo =#session.Ecodigo#
									and CIcarreracp = 0
									and coalesce(a.CInomostrar,0) = 0
									and CItipo <= 3"
							desplegar="CIcodigo_f,CIdescripcion_f"
							etiquetas="	#vConcepto#, 
										#LB_Descripcion#"
							formatos="S,S"
							align="left,left"
							showEmptyListMsg="true"
							debug="false"
							form="form1"
							width="800"
							height="500"
							left="70"
							top="20"
							filtrar_por="CIcodigo,CIdescripcion"
							valuesarray="#va_arrayIncidencia#">
					</td>
				</tr>
				<tr>
					<td>
						<strong>#vEmpleado#</strong><br>
						<cfif isdefined("rsEmpleadoFiltro") and rsEmpleadoFiltro.RecordCount NEQ 0>
							<cf_rhempleado tabindex="1" size = "30" DEid="DEid" index="1" form="form1" query="#rsEmpleadoFiltro#">
						<cfelse>
							<cf_rhempleado tabindex="1" size = "30" DEid="DEid" index="1" form="form1">
						</cfif>
					</td>
					<td colspan="3">
						<input type="checkbox" name="FIcpespecial_f" id="FIcpespecial_f" value="1" <cfif isdefined("url.FIcpespecial_f") and url.FIcpespecial_f EQ 1>checked</cfif> > 
						<cf_translate key="LB_Incluir_solo_en_Calendario_de_Pagos_especiales">Incluir solo en Calendario de Pagos especiales</cf_translate>
					</td>
				</tr>
				<tr>
					<td>
						<strong><cf_translate key="LB_Centro_Funcional_de_Servicio">Centro Funcional de Servicio</cf_translate></strong><br>
						<cfif isdefined("rsCfuncionalFiltro") and rsCfuncionalFiltro.RecordCount NEQ 0>
							<cf_rhcfuncional tabindex="1" id="CFid_f" name="CFcodigo_f" desc="CFdescripcion_f" query="#rsCfuncionalFiltro#">
						<cfelse>
							<cf_rhcfuncional tabindex="1" id="CFid_f" name="CFcodigo_f" desc="CFdescripcion_f">
						</cfif>
					</td>
					<td>
						<strong><cf_translate key="LB_FechaRebajo">Fecha Rebajo</cf_translate></strong><br>
						<cfif isdefined("url.IfechaRebajo_f") and len(trim(url.IfechaRebajo_f))>
							<cf_sifcalendario form="form1" name="IfechaRebajo_f" value=#url.IfechaRebajo_f#>
						<cfelse>
							<cf_sifcalendario form="form1" name="IfechaRebajo_f" >
						</cfif>
					</td>
					<td align="center">
						<input  type="submit" name="btnFiltrar" value="#vFiltrar#" onClick="filtrar();">
					</td>
				</tr>
			</table>
		</td></tr>
		</cfif>
        --->
		<!---************************************* FIN DE FILTROS ***************************************---->
		<!---************************************* CAMPOS DEL MANTENIMIENTO ***************************************---->	
		<tr><td>&nbsp;</td></tr>
		<!--- Línea No. 1 --->
		<tr> 
            <td  class="fileLabel">Proyecto <!---</td>
            <td  valign="middle" nowrap>  --->  
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="MSG_SeleccioneElCentroFuncionalResponsable"
                    Default="Seleccione el Centro Funcional Responsable"

                    returnvariable="MSG_SeleccioneElCentroFuncionalResponsable"/>
                
                <cfif isdefined('modo') and  modo NEQ 'ALTA'>
                    <cf_FTvicerrectoria tabindex="1" form="form1" size="30" id="Vpkresp" name="Vcodigoresp" desc="Vdescripcionresp" 
                        titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1" query="#rsNombreVC#" >  
                <cfelse>
                    <cf_FTvicerrectoria tabindex="1" form="form1" size="30" id="Vpkresp" name="Vcodigoresp" desc="Vdescripcionresp" 
                            titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1">   

                </cfif> 
                </td>
                <td  class="fileLabel">Fecha:</td>
                <td>
					<cfif modo NEQ "ALTA">
                        <cf_sifcalendario form="form1" name="SPfecha" value="#LSDateFormat(rsIncidencia.SPfecha,'dd/mm/yyyy')#">
                    <cfelse>
                        <cf_sifcalendario form="form1" name="SPfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                    </cfif>			
                </td>
                <td  class="fileLabel">N°.Acta:</td>
                <td nowrap>
                    <input name="SPacta" type="text" id="SPacta" size="18" maxlength="15"  style="text-align: right;" value="" tabindex="1">
                </td>
		</tr>
        <!---<tr id="TR" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>">--->
        <tr>
        	 <td  class="fileLabel">Forma de Pago:
                <select name="FPid">
                    <option value="">--- Seleccionar ---</option>
                    <cfloop query="rsFPagos">
                        <option value="#FPid#" <cfif modo EQ 'CAMBIO' <!---and rsFPagos.FPid EQ rsIncidencia.FPid--->> selected</cfif>>#FPdescripcion#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        
        
       
        
        
        <!---
        <tr>
			<!--- Empleado --->
        	<td  colspan="2" class="fileLabel">Proyecto</td>
			<!--- Concepto --->	
			<td class="fileLabel" nowrap>Fecha</td>
		</tr>		
		<!--- Línea No. 2 --->
     	<tr> 
			<td  colspan="2"> 
				<cfif modo NEQ "ALTA">
					<cf_rhempleado query="#rsIncidencia#" tabindex="1" size = "50" FuncJSalCerrar="CambiaCF();">
				<cfelseif isdefined("rsEmpleadoDef")>
					<cf_rhempleado query="#rsEmpleadoDef#" tabindex="1" size = "50" FuncJSalCerrar="CambiaCF();">
				<cfelse>
					<cf_rhempleado tabindex="1" size = "50" FuncJSalCerrar="CambiaCF();">
				</cfif>
        	</td>		
			<td>
				<cf_conlis title="#LB_ListaDeIncidencias#"
					campos = "CIid,CIcodigo,CIdescripcion" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,10,20"
					asignar="CIid,CIcodigo,CIdescripcion"
					asignarformatos="I,S,S"
					tabla="	CIncidentes a"																	
					columnas="CIid,CIcodigo,CIdescripcion"
					filtro="a.Ecodigo =#session.Ecodigo#
							and coalesce(a.CInomostrar,0) = 0
							and CIcarreracp = 0
							and CItipo < 3"
					desplegar="CIcodigo,CIdescripcion"
					etiquetas="	#vConcepto#, 
								#LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					debug="false"
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="CIcodigo,CIdescripcion"
					valuesarray="#va_arrayvalues#"
					funcion="changeValLabel">
			</td>
		</tr>		
		<!--- Centro de Costos equivalente a Centro Funcional --->
		<cfquery name="centrocosto" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 520
		</cfquery>		
		<!--- Línea No. 3 --->
		<tr>
			<!--- <cfif not centrocosto.Pvalor eq 1 > --->
			<!--- Centro funcional --->
			<td class="fileLabel" nowrap><cf_translate key="LB_Centro_Funcional_de_Servicio">Centro Funcional de Servicio</cf_translate></td>
			<!--- </cfif> --->
			<!--- Concepto --->	
			<td class="fileLabel">#vFecha#</td>
			<!--- Valor --->
			<td id="TDValorLabel" class="fileLabel" nowrap>#vValor#&nbsp;</td>
			<!--- Monto --->
			<cfif modo eq 'CAMBIO'>
			<cfif isdefined('url.Imonto') and isNumeric(url.Imonto)>
			<td id="TDMontoLabel" class="fileLabel" nowrap>#vMonto#&nbsp;</td>
			</cfif>
			</cfif>
		</tr>		
		<!--- Línea No. 4 --->
		<tr>
			<!--- <cfif not centrocosto.Pvalor eq 1 > --->
			<td>
				<cfif modo neq 'ALTA' and rsCFuncional.RecordCount gt 0 >
					<cf_rhcfuncional  query="#rsCFuncional#" tabindex="1">
				<cfelse>
					<cf_rhcfuncional tabindex="1">
				</cfif>
			</td>
			<!--- </cfif> --->
			<!--- Fecha --->	
			<td>
				<cfif modo NEQ "ALTA">
					<cf_sifcalendario form="form1" name="Ifecha" value="#LSDateFormat(rsIncidencia.fecha,'dd/mm/yyyy')#" onChange="CambiaCF();">
				<cfelse>
					<cf_sifcalendario form="form1" name="Ifecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" onChange="CambiaCF();">
				</cfif>			
			</td>
			<!--- Valor --->
			<td id="TDValor" nowrap>
			  	<input name="Ivalor" type="text" id="Ivalor" size="18" maxlength="15" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsIncidencia.Ivalor, 'none')#<cfelse>0.00</cfif>" tabindex="1">
			</td>
			<cfif modo eq 'CAMBIO'>
				<cfif isdefined('url.Imonto') and isNumeric(url.Imonto)>
			<td id="TDMonto" nowrap>
			  	<input name="Imonto" type="text" id="Imonto" size="18" disabled="disabled"  maxlength="15" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsIncidencia.Imonto, 'none')#<cfelse>0.00</cfif>" tabindex="2">
			</td></cfif>
			</cfif>
		</tr>		
		<!--- Línea No. 5 --->
		<tr>
			<td class="fileLabel">
				<input type="checkbox" name="Icpespecial" id="Icpespecial" onClick="javascript:fechaRebajo(this);" value="" <cfif modo EQ "CAMBIO" and rsIncidencia.Icpespecial EQ 1>checked</cfif> > 
				<cf_translate key="LB_Incluir_solo_en_Calendario_de_Pagos_especiales">Incluir solo en Calendario de Pagos especiales</cf_translate>
			</td>
			<td>
				<table id="id_tableFechaRebajo" width="100%" align="center" border="0" cellspacing="0" cellpadding="1">
					<tr>
						<td class="fileLabel"><cf_translate key="LB_FechaRebajo">Fecha Rebajo</cf_translate></td>
					</tr>
					<tr>
						<td>
							<cfif modo NEQ "ALTA">
								<cfset vFechaRebajo = '' >
								<cfif len(trim(rsIncidencia.IfechaRebajo))>
									<cfset vFechaRebajo = LSDateFormat(rsIncidencia.IfechaRebajo,'dd/mm/yyyy') >
								</cfif>
								<cf_sifcalendario form="form1" name="IfechaRebajo" value="#vFechaRebajo#">
							<cfelse>
								<cf_sifcalendario form="form1" name="IfechaRebajo" >
							</cfif>			
						</td>
					</tr>
				</table>
			</td>
			<td>			
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="1">
					<tr id="TRLabelJornada" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>">
						<td class="fileLabel"><cf_translate key="LB_Jornada">Jornada</cf_translate></td>
					</tr>
					<tr id="TRJornada" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>">
						<td>
							<select name="RHJid">
								<option value="">--- Seleccionar ---</option>
								<cfloop query="rsJornadas">
									<option value="#RHJid#" <cfif modo EQ 'CAMBIO' and rsJornadas.RHJid EQ rsIncidencia.RHJid> selected</cfif>>#Descripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>	--->	
		<!--- Línea No. 6 --->
      	<tr align="center"> 
        	<td colspan="4">
				<br>
				<cfset Botones.TabIndex = "1">
				<cfinclude template="/rh/portlets/pBotones.cfm">
				<!---<input type="submit" name="btnImportar" value="#vImportar#" onClick="importar('n');">
				<input type="submit" name="btnImportarCalculo" value="#LB_ImportarCalculo#" onClick="importar('c');">--->
				<!---<input type="submit" name="btnFiltrar" value="#vFiltrar#" onClick="filtrar();">----->
				<input type="hidden" name="cualimportador" value="">
				<br>
			</td>
      	</tr>
		<iframe name="CentroFuncionalx" id="CentroFuncionalx" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
	</table>	
    <cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsIncidencia.ts_rversion#" returnvariable="ts">
		</cfinvoke>
	</cfif>
	<!---
	<cfif isdefined("Form.Usuario")>
		<input type="hidden" name="Usuario" value="#Form.Usuario#">
	</cfif>
	---->
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="Iid" value="#rsIncidencia.Iid#">
	</cfif>
	<!----<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("url.PageNum")>#PageNum#</cfif>">--->
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
	
</form>
</cfoutput>

<table width="90%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
        
<!---select 	a.Iid, 
		b.CIdescripcion, 
		a.Ifecha, 
		case b.CItipo  	when 0 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' hora(s)' ) }
						when 1 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' día(s)' ) }
						else <cf_dbfunction name="to_char" args="Ivalor"> end as Ivalor, 
						
		case b.CItipo  	when 3 then <cf_dbfunction name="to_char" args="Imonto"> 
		else '_'  end as Imonto,			
		{fn concat({fn concat({fn concat({ fn concat( c.DEnombre, ' ') }, c.DEapellido1)}, ' ')}, c.DEapellido2) }  as NombreEmp,
		case when a.Icpespecial = 0 
			then '<img src="/cfmx/rh/imagenes/unchecked.gif">'
			else '<img src="/cfmx/rh/imagenes/checked.gif">' 
		end as Icpespecial
		<!---#vs_select#--->
	
from  Incidencias a, CIncidentes b, DatosEmpleado c
where #preservesinglequotes(filtro)#
	and not exists (select 1 
					from RCalculoNomina x, IncidenciasCalculo z
					where RCestado <> 0
					  and z.RCNid = x.RCNid
					  and z.Iid = a.Iid
					)
order by 5--->        
			<cfquery name="rsLista" datasource="#Session.DSN#">		
                select 
                    a.SPid            
                    ,a.DSPid
                    ,a.DSPdocumento    
                    ,a.DSPdescripcion  
                    ,a.DSPobjeto   
                    ,a.DSPmonto
                from FTDSolicitudProceso a
	                inner join FTDSolicitudProceso b

    		            on a.SPid = b.SPid
                where b.SPid = 1
			</cfquery>	
			
			<cfinvoke component="sif.Componentes.Translate"
			 method="Translate"
			 key="LB_NoSeEncontraronRegistros"
			 default="No se encontraron Registros "
			 returnvariable="LB_NoSeEncontraronRegistros"/> 
	
			<form name="lista" method="get" action="Incidencias.cfm">
				<cfinvoke component="rh.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="DSPdocumento, DSPdescripcion, DSPobjeto, DSPmonto"/>
					<cfinvokeargument name="etiquetas" value="N°.Docuemto,Descripci&oacute;n, Objeto Gasto,Monto"/>
					<cfinvokeargument name="formatos" value="V,V,V,M"/>
					<cfinvokeargument name="align" value="left, left, left,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="SolicitudPago.cfm"/>

					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="EmptyListMsg" value="#LB_NoSeEncontraronRegistros#"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="maxRows" value="30"/>
					<cfif rsLista.recordcount gt 0 >
						<cfinvokeargument name="botones" value="Eliminar"/>
					</cfif>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="checkall" value="S"/>
					<cfinvokeargument name="form_method" value="get"/>
					<cfinvokeargument name="incluyeform" value="false"/>
					<cfinvokeargument name="keys" value="Iid"/>					
				</cfinvoke>
				<cfoutput>
				<cfif isdefined("url.usuario")>
					<input type="hidden" name="usuario" value="#url.usuario#"  />
				</cfif>
				<cfif isdefined("url.Ffecha")>
					<input type="hidden" name="Ffecha" value="#url.Ffecha#"  />
				</cfif>
				<cfif isdefined("url.CIid_f")>
					<input type="hidden" name="CIid_f" value="#url.CIid_f#"  />
				</cfif>
				<cfif isdefined("url.DEid")>
					<input type="hidden" name="DEid" value="#url.DEid#"  />
				</cfif>
				<cfif isdefined("url.FIcespecial_f")>
					<input type="hidden" name="FIcespecial_f" value="#url.FIcespecial_f#"  />
				</cfif>
				<cfif isdefined("url.CFid_f")>
					<input type="hidden" name="CFid_f" value="#url.CFid_f#"  />
				</cfif>
				<cfif isdefined("url.IfechaRebajo_f")>
					<input type="hidden" name="" value="#url.IfechaRebajo_f#"  />
				</cfif>
				</cfoutput>
			</form>
		</td>
	</tr>
</table>
<div align="left"><cfoutput><b>#vMontoCalculado#</b>: #LB_NotaMontoCalculado#</cfoutput></div>
<cfoutput>
<script language="JavaScript">
	// Valida el rango en caso de que el tipo de concepto de incidencia sea de días y horas
	function __isRangoCantidad() {
		if (document.form1.botonSel.value != 'btnFiltrar' && document.form1.botonSel.value != 'Baja'){
			if ((tipoConc[this.obj.form.CIid.value] == 0 || tipoConc[this.obj.form.CIid.value] == 1) && (parseFloat(qf(this.value)) < rangoMin[this.obj.form.CIid.value] || parseFloat(qf(this.value)) > rangoMax[this.obj.form.CIid.value])) {
				this.error = "#vCantidadValidacion#";
			}
		}	
	}

	function __isNotCero() {
		if (document.form1.botonSel.value != 'btnFiltrar'){
			if ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0)) {
				this.error = this.description + " #vNoCero#";
			}
		}
	}
	
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isRangoCantidad", __isRangoCantidad);
	_addValidator("isNotCero", __isNotCero);

	objForm.Ifecha.required = true;
	objForm.Ifecha.description = "#vFecha#";
	
	objForm.CIid.required = true;
	objForm.CIid.description = "#vConcepto#";
	
	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description = "#vEmpleado#";
	
	objForm.Ivalor.required = true;
	objForm.Ivalor.description = "";
	objForm.Ivalor.validateNotCero();
	objForm.Ivalor.validateRangoCantidad();
	
	// Establecer la etiqueta inicial
	changeValLabel();
	
	// 
	function filtrar(){
		document.form1.action = '';
		document.form1.botonSel.value = 'btnFiltrar';
		objForm.Ifecha.required = false;
		objForm.CIid.required = false;
		objForm.DEidentificacion.required = false;
		objForm.Ivalor.required = false;
	}
	
	function limpiar(){

		document.form1.DEid.value   	       	= '';
		document.form1.DEidentificacion.value  	= '';
		document.form1.NombreEmp.value   	   	= '';
		document.form1.CIid.value   	    	= '';
		document.form1.CIcodigo.value      		= ''; 
		document.form1.CIdescripcion.value	 	= ''; 
		document.form1.Ifecha.value 	   		= ''; 
		
		if(document.form1.CFid) {
			document.form1.CFid.value   	   		= ''; 
			document.form1.CFcodigo.value      		= ''; 
			document.form1.CFdescripcion.value 		= ''; 
		}
	}
	
	function importar(prn_importador) {
		//prn_importador: 'n' --> Importador "normal", 'c' -->Importador de calculadora...
		/*
		var top  = (screen.height - 600) / 2;
		var left = (screen.width - 850)  / 2;
		<cfif modo neq 'ALTA'>
			window.open('importarIncidencias.cfm', 'Importar','menu=no,scrollbars=yes,top='+top+',left='+left+',width=850,height=500');
		</cfif>			
		*/
		objForm._allowSubmitOnError = true;
		objForm._showAlerts = false;
		qFormAPI.errorColor = "##FFFFFF";
		if (prn_importador == 'c'){
			document.form1.cualimportador.value = 'c';
		}
		document.form1.action = 'importarIncidencias.cfm';
		document.form1.submit();
	}
		
	function fechaRebajo( obj ){
		document.getElementById("id_tableFechaRebajo").style.display = (obj.checked) ? '' : 'none';
	}
	
	// segun el check muestra o no la fecha de rtebajo
	fechaRebajo( document.form1.Icpespecial )


	function fnAlgunoMarcadolista(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				return document.lista.chk.checked;
			} else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						return true;
					}
				}
			}
		}
		return false;
	}
	function funcEliminar(){
		if (!fnAlgunoMarcadolista()){
			alert("¡Debe seleccionar al menos una Incidencia para eliminar!");
			return false;
		}else{
			if ( confirm("¿Desea aplicar las Incidencias marcadas?") )	{
				document.lista.action = 'Incidencias-sql.cfm';
				return true;
			}
			return false;
		}		
	}
	
	
	function CambiaCF(){
		<cfif trim(rsCargarCF.Pvalor) eq 1>
			var fecha=document.form1.Ifecha.value;
			var DEid = document.form1.DEid.value;
			
			document.getElementById('CentroFuncionalx').src = 'CambiaCentroFuncional.cfm?Fecha='+fecha+'&DEid='+DEid;
		</cfif>	
	}
	
</script>
</cfoutput>