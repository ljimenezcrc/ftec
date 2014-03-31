<cfif isdefined('url.Jefe') and url.Jefe GT 0>
	<cfif isdefined('form.Jefe') and (not LEN(TRIM(form.Jefe)) or form.Jefe EQ 0)>
		<cfset form.Jefe = url.Jefe>
	<cfelseif not isdefined('form.Jefe')>
		<cfset form.Jefe = url.Jefe>
	</cfif>
</cfif>
<cfif isdefined('url.CentroF') and url.Jefe GT 0>
	<cfif isdefined('form.CentroF') and (not LEN(TRIM(form.CentroF)) or form.CentroF EQ 0)>
		<cfset form.CentroF = url.CentroF>
	<cfelseif not isdefined('form.CentroF')>
		<cfset form.CentroF = url.CentroF>
	</cfif>
</cfif>

<cfif Session.Params.ModoDespliegue EQ 1>
	<cfif isdefined("Form.o") and isdefined("Form.sel")>
		<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">		
	<cfelse>

		<cfif isdefined("Form.PosteoAccion")>
			<!---averiguar si el comportamiento es de recargo--->
			<cfquery name="rsCompTipoAccion" datasource="#Session.DSN#">
				select b.RHTcomportam, b.RHTcempresa, b.RHTnoveriplaza, RHAccionRecargo,
					a.DEid, a.DLfvigencia, a.RHPid, a.DLffin, a.RHTid,
					coalesce(b.RHTespecial,0) as RHTespecial, b.RHTpfijo
				from RHAcciones a, RHTipoAccion b
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAlinea#">
				and a.RHTid = b.RHTid
			</cfquery>
				<cfset action = "/cfmx/rh/nomina/operacion/Acciones.cfm">
		<cfelse>
			<cfset action = "/cfmx/rh/nomina/operacion/Acciones-lista.cfm">
		</cfif>
	</cfif>
<cfelseif Session.Params.ModoDespliegue EQ 0>
	<cfif isdefined("form.Jefe")><!--- SI ESTOY EN AUTOGESTION - TRAMITES PARA SUBORDINADOS --->
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm?o=3&Jefe=#form.Jefe#&CentroF=#form.CentroF#">		
	<cfelse>
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
	</cfif>
</cfif>

<!----====================== TRADUCCION =====================---->
<cfinvoke key="MSG_La_plaza_seleccionada_esta_inactiva_actualmente_Debe_activar_la_plaza_antes_de_continuar" default="La plaza seleccionada est&aacute; inactiva actualmente. Debe activar la plaza antes de continuar."	 returnvariable="MSG_PlazaInactiva" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_El_porcentaje_de_la_plaza_debe_ser_a_lo_mas_de" default="El porcentaje de la plaza por asignar no debe ser mayor a"	 returnvariable="MSG_PorcentajePlaza" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_El_porcentajeOcupcionPlazaFunciona" default="El porcentaje de ocupación de Plazas del funcionario excede lo permitido, debe ser menor o igual a "	 returnvariable="MSG_PorcentajeOcupaPlaza" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Estaasignando" default="está asignando un "	 returnvariable="MSG_Estaasignando" component="sif.Componentes.Translate" method="Translate"/>



<cfif isdefined("Form.btnAplicar")>
	<cfset acciones = ListToArray(Form.chk)>
	<cfloop from="1" to="#ArrayLen(acciones)#" index="i">
        <cftransaction>
             <cfquery name="rsDatos"  datasource="#Session.DSN#">
                select RHA.DLfvigencia, RHA.DLffin, RHA.DEid, RHA.RHAlinea,  RHA.RHTid
                    from RHAcciones RHA
                    where RHA.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
            </cfquery>
            <cfinvoke component="rh.Componentes.RH_RecordatorioAlertas" method="AddAlerta" returnvariable="id">
                <cfinvokeargument name="RHTid" 			value="#rsDatos.RHTid#"/>
                <cfinvokeargument name="fdesdeaccion" 	value="#rsDatos.DLfvigencia#"/>
                <cfinvokeargument name="fhastaaccion" 	value="#rsDatos.DLffin#"/>
                <cfinvokeargument name="DLlinea" 		value="#rsDatos.RHAlinea#"/>
                <cfinvokeargument name="DEid" 			value="#rsDatos.DEid#"/>
                <cfinvokeargument name="Lcache" 		value="#Session.DSN#"/>
                <cfinvokeargument name="empresa" 		value="#Session.Ecodigo#"/>
                <cfinvokeargument name="falerta" 		value="#now()#"/>
            </cfinvoke>
      </cftransaction>
		<!--- Modificado por danim para iniciar un trámite cuando proceda --->
		<cfquery name="rsConsTipoAccion" datasource="#Session.DSN#">
			select 	b.RHTcomportam, b.RHTcempresa, b.RHTnoveriplaza, RHAccionRecargo,
					a.DEid, a.DLfvigencia, a.RHPid, a.DLffin, a.RHTid,
					coalesce(b.RHTespecial,0) as RHTespecial, b.RHTpfijo
			from RHAcciones a, RHTipoAccion b
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
			and a.RHTid = b.RHTid
		</cfquery>
		<cfset RHTespecial =  rsConsTipoAccion.RHTespecial>
		<cfset form.DEid = rsConsTipoAccion.DEid>
		<cfset form.DLfvigencia = LSDateFormat(rsConsTipoAccion.DLfvigencia,'dd/mm/yyyy')>
		<cfset form.RHPid = rsConsTipoAccion.RHPid>
		<cfif len(trim(rsConsTipoAccion.DLffin))>
			<cfset form.DLffin = LSDateFormat(rsConsTipoAccion.DLffin,'dd/mm/yyyy')>
		<cfelse>
			<cfset form.DLffin = '01/01/6100'>
		</cfif>
		<!----==========  Valores para la verificacion del cambio según el tipo de accion ==========------>
		<cfset form.RHAlinea = acciones[i]>
		<cfset form.RHTid = rsConsTipoAccion.RHTid>

		<!---Recalcula Componentes para las acciones de nombramiento. CarolRS--->
		<cfif rsConsTipoAccion.RHTcomportam EQ 1>
			<cfinvoke component="rh.Componentes.RH_AplicaAccion" method="RecalculaComponentes" returnvariable="LvarResult">
				<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/> 
				<cfinvokeargument name="RHAlinea" value="#form.RHAlinea#"/> 
				<cfinvokeargument name="DEid" value="#form.DEid#"/> 
				<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#"/> 
				<cfinvokeargument name="conexion" value="#session.dsn#"/> 
			</cfinvoke>
		</cfif>
		<!-----========== poner como fecha hasta de la accion la fecha hasta maxima de la linea del tiempo del empleado  ==========--->		
		<!-----========== si y solo si el comportamiento de la accion es de cambio y NO es de plazo fijo  				 ==========--->		
		<cfif isdefined("rsConsTipoAccion") and rsConsTipoAccion.RHTcomportam eq 6 and rsConsTipoAccion.RHTpfijo eq 0 >
			<cfquery datasource="#session.DSN#">
				update RHAcciones
				set DLffin =
                        <cfif isdefined("rsConsTipoAccion") and rsConsTipoAccion.RHAccionRecargo GT 0><!---Si el comportamiento es de Recargo de Plaza toma en cuenta la lineaTiempoR para sacar la fecha de corte--->
						(select max(LThasta) from LineaTiempoR where DEid = RHAcciones.DEid and LTRid = RHAcciones.RHAccionRecargo)
						<cfelse>
						(select max(LThasta) from LineaTiempo where DEid = RHAcciones.DEid )
						</cfif>
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
			</cfquery>
		</cfif>

		<!-----========== Verificar que solo se halla modificado lo que se indica en el tipo de accion ==========--->
		<cfif RHTespecial eq  0>
			<cfif isdefined("form.DLfvigencia") and len(trim(form.DLfvigencia)) 
				and isdefined("form.DEid") and len(trim(form.DEid))
				and isdefined("form.RHAlinea") and len(trim(form.RHAlinea))
				and isdefined("form.RHPid") and len(trim(form.RHPid)) 
				and isdefined("form.RHTid") and len(trim(form.RHTid))>
                <cfif isdefined('form.IndicaRecargo') and form.IndicaRecargo GT 0>
					<cfinclude template="/rh/nomina/operacion/AccionesRecargos-VerificaTipoAccion.cfm">
                <cfelse>
					<cfinclude template="/rh/nomina/operacion/Acciones-VerificaTipoAccion.cfm">
                </cfif>
			</cfif>
			<cfquery name="rsPlazaActiva" datasource="#Session.DSN#">
				select b.RHPactiva,DEid,b.RHPid
				from RHAcciones a, RHPlazas b
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
				and a.RHPid = b.RHPid
			</cfquery>
			<cfif rsPlazaActiva.RHPactiva EQ 0>
				<cf_throw message="#MSG_PlazaInactiva#" errorCode="1080">
			</cfif>

			<!---Validar la Plaza guardada para ver si cumple con el maximo permitido en el porcentaje de la plaza --->
			<!---Valida que el porcentaje de la plaza no sobre pase el maximo de porcentaje de plaza permitido para ser usado, 
				toma en cuenta si hay otras personas que posean porsentajes de esa plaza--->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="540" default="100" returnvariable="LvarPP"/>
	<cfif LvarPP eq 1>
			<cfif rsConsTipoAccion.RHTnoveriplaza EQ 0 and len(trim(form.RHPid))>
				<!---Porcentaje asignado a la plaza--->
				<cfquery name="rsPorc" datasource="#session.dsn#">
					select coalesce(RHPporcentaje,100) as RHPporcentaje
					from RHPlazas 
					where RHPid=#form.RHPid#
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfset LvarM=true>
				<!---porcentaje asignado para la plaza--->	
				<cfset LvarPorcP=rsPorc.RHPporcentaje>	
				<cfif session.usulogin eq 'soinrh' and LvarM>
					LvarPorcP<cfdump var="#LvarPorcP#"><br>
				</cfif> 
                <!---Todas las acciones registradas a una persona que no sea la de la AP--->
				<cfquery name="rsPorcPlaza" datasource="#Session.DSN#">
					   select rtrim(b.RHPcodigo) as RHPcodigo, 
								RHPdescripcion, a.RHPid, RHPpuesto, a.Dcodigo, a.Ocodigo, coalesce(sum(a.LTporcplaza), 0) as ocupado
					   from LineaTiempo a
					   inner join RHPlazas b
						on b.RHPid = a.RHPid
						and b.Ecodigo = a.Ecodigo
					   where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						 and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPid#">						 
                         and a.DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaActiva.DEid#">
							and b.RHPactiva = 1
							and (
								 (<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.DLfvigencia)#"> between a.LTdesde and a.LThasta)
									or  
								 (<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.DLffin)#"> between a.LTdesde and a.LThasta) 			
								)
						 group by rtrim(b.RHPcodigo), 
								RHPdescripcion, a.RHPid, RHPpuesto, a.Dcodigo, a.Ocodigo,a.DEid
				</cfquery>
				<!--- Toma en cuenta para la validación los recargos de plaza--->
				<cfquery name="rsPorcPlazaR" datasource="#Session.DSN#">
					select rtrim(b.RHPcodigo) as RHPcodigo, a.DEid,
								RHPdescripcion, a.RHPid, RHPpuesto, a.Dcodigo, a.Ocodigo, coalesce(sum(a.LTporcplaza), 0) as ocupado
					   from LineaTiempoR a
					   inner join RHPlazas b
						on b.RHPid = a.RHPid
						and b.Ecodigo = a.Ecodigo
					   where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						 and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPid#">
						  <cfif rsConsTipoAccion.RHTcomportam EQ 12>
                         and a.DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaActiva.DEid#">
                         </cfif>
							and b.RHPactiva = 1
							and (
								 (<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.DLfvigencia)#"> between a.LTdesde and a.LThasta)
									or  
								 (<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.DLffin)#"> between a.LTdesde and a.LThasta) 			
								)
						 group by rtrim(b.RHPcodigo), 
								RHPdescripcion, a.RHPid, RHPpuesto, a.Dcodigo, a.Ocodigo,a.DEid
				</cfquery>
				<cfset disponible = 0>
				<cfset ocupado = 0>
				<cfif rsPorcPlaza.recordCount and rsPorcPlaza.ocupado>
					<cfset ocupado = rsPorcPlaza.ocupado>
				</cfif>
				<cfif rsPorcPlazaR.recordCount and rsPorcPlazaR.ocupado>
					<cfset ocupado = ocupado + rsPorcPlazaR.ocupado>
				</cfif>
			
				<cfset disponible = LvarPorcP - ocupado>
				<cfif disponible LT 0>
					<cf_throw message="#MSG_PorcentajePlaza# #LSNumberFormat(Form.LTporcplaza, ',9.00')#%" errorCode="1090">
				</cfif>
			</cfif>

			<!--- VALIDACION DEL PORCENTAJE MÁXIMO DE OCUPCION EN PLAZAS PARA UN FUNCIONARIO --->
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" 
				ecodigo="#session.Ecodigo#" pvalor="2102" default="100" returnvariable="PorcMaxOcupa"/>
					
			<cfif isdefined('PorcMaxOcupa') and LEN(TRIM(PorcMaxOcupa))>
				<!--- PORCENTAJE TOTAL DE RECARGOS SELECCIONANDO LA LINEA MAXIMA POR PLAZA --->
				<cfquery name="SumPorPR" datasource="#session.DsN#">
                    select coalesce(sum(LTporcplaza),0) as recargos
					from RHAcciones a
                    inner join LineaTiempoR b  
                        on b.DEid = a.DEid
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta
                      and LTRid = (select max(LTRid) from LineaTiempoR lt where <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta and lt.RHPid = b.RHPid)
                      and b.RHPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPlazaActiva.RHPid#">
				</cfquery>
				<!--- PORCENTAJE DE PLAZA TITULAR --->
				<cfif rsConsTipoAccion.RHTcomportam EQ 12><!--- si es un recargo debe de sumar la titular --->
					<cfquery name="PorcPLT" datasource="#session.DSN#">
						select coalesce(LTporcplaza,0) as Titular
						from RHAcciones, LineaTiempo
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
						  and RHAcciones.DEid = LineaTiempo.DEid
						  and LineaTiempo.RHPid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPid#">
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta
					</cfquery>
				</cfif>
				<cfif LEN(TRIM(form.LTporcplaza)) EQ 0 or not isdefined('form.LTporcplaza')>
					<cfquery name="LTporcplaza" datasource="#session.DSN#">
						select RHAporcsal
						from RHAcciones
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
					</cfquery>
					<cfset form.LTporcplaza = LTporcplaza.RHAporcsal>
				</cfif>
				<cfif isdefined('PorcPLT') and PorcPLT.recordcount GT 0>
					<cfset Lvar_PorcPLT = PorcPLT.Titular>
				<cfelse>
					<cfset Lvar_PorcPLT = 0>
				</cfif>
				<cfif isdefined('SumPorPR') and SumPorPR.recordcount GT 0>
					<cfset Lvar_SumPorPR = SumPorPR.recargos>
				<cfelse>
					<cfset Lvar_SumPorPR = 0>
				</cfif>
				<cfset PorcOcupaPlaza= Lvar_PorcPLT+ Lvar_SumPorPR + Form.LTporcplaza>
				<cfif PorcOcupaPlaza GT PorcMaxOcupa>
					<cf_throw message="#MSG_PorcentajeOcupaPlaza# #LSNumberFormat(PorcMaxOcupa, ',9.00')#% #MSG_Estaasignando# #LSNumberFormat(PorcOcupaPlaza, ',9.00')#%" errorCode="1100">
				</cfif>
			</cfif>
		</cfif>
	</cfif>
		<cfquery name="info_tramite" datasource="#Session.DSN#">
			select 	a.RHTcomportam,
					a.RHTidtramite, 
					b.RHAidtramite, 
					b.DEid, 
					{fn concat({fn concat({fn concat({fn concat(c.DEnombre , ' ' )}, c.DEapellido1 )}, ' ' )}, c.DEapellido2 )}  as NombreCompleto, 
					b.DLobs,
					b.RHPid,
					b.DLfvigencia,
					coalesce(RHAccionRecargo,0) as RHAccionRecargo ,
                    a.RHTAplicaCate,
                    a.RHTrespetarLT
			from RHTipoAccion a, RHAcciones b, DatosEmpleado c
			where a.RHTid = b.RHTid
			  and b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
			  and c.DEid = b.DEid
		</cfquery>

		<!--- Verifica la parametrización de Tramite:  RHTidtramite = ProcessId --->
		<cfif IsDefined("info_tramite.RHTidtramite") AND Len(info_tramite.RHTidtramite) GT 0>
			<!--- Sólo Validar acción y enviar a trámite --->
			<cftransaction>
				<!---<cfif info_tramite.RHAccionRecargo GT 0 or info_tramite.RHTcomportam EQ 12> --->
				<!---Si el comportamiento es de recargo utiliza una copia del componente adaptada para este tipo de accion--->
				<cfif info_tramite.RHAccionRecargo GT 0 or info_tramite.RHTcomportam EQ 12 or (info_tramite.RHTcomportam EQ 15 and info_tramite.RHAccionRecargo GT 0)> 
                	<cfinvoke component="rh.Componentes.RH_AplicaAccionRecargo" method="AplicaAccion" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/> 
						<cfinvokeargument name="RHAlinea" value="#acciones[i]#"/> 
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/> 
						<cfinvokeargument name="conexion" value="#Session.DSN#"/> 
						<cfinvokeargument name="validar" value="true"/> 
						<cfinvokeargument name="debug" value="false"/> 
					</cfinvoke>
				<cfelse>
					<cfinvoke component="rh.Componentes.RH_AplicaAccion" method="AplicaAccion" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/> 
						<cfinvokeargument name="RHAlinea" value="#acciones[i]#"/> 
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/> 
						<cfinvokeargument name="conexion" value="#Session.DSN#"/> 
						<cfinvokeargument name="validar" value="true"/> 
						<cfinvokeargument name="debug" value="false"/> 
					</cfinvoke>
				</cfif>
			</cftransaction>

			<!--- Iniciar trámite solamente si no ha sido iniciado RHAidtramite = processInstanceId--->
			<cfif Len(info_tramite.RHAidtramite) EQ 0>
				<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />
				<cfset datos_sujeto = sec.getUsuarioByRef(info_tramite.DEid, Session.EcodigoSDC, 'DatosEmpleado')>
				<!--- a quien le vamos a notificar, si es necesario, sobre el avance del trámite, en su rol de empleado interesado --->
				<cfif IsDefined('datos_sujeto.Usucodigo') and Len(datos_sujeto.Usucodigo)>
					<cfset SubjectId = datos_sujeto.Usucodigo>
				<cfelse>
					<cfset SubjectId = 0>
				</cfif>

 				<!--- CForigenID = CF de Plaza actual en Linea Tiempo --->
				<cfset CForigenID = "">
				<cfif info_tramite.DLfvigencia NEQ "">
					<cfquery name="rsCForigen" datasource="#Session.DSN#">
						select p.CFid
						  from LineaTiempo lt
						  	inner join RHPlazas p on p.RHPid = lt.RHPid
						 where lt.DEid = #info_tramite.RHPid#
						   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#info_tramite.DLfvigencia#"> between lt.LTdesde and lt.LThasta
					</cfquery>
                    
					<cfset CForigenId = rsCForigen.CFid>
				</cfif>

				<!--- CFdestinoID = CF de Plaza propuesta en Accion Personal --->
				<cfset CFdestinoID = "">
				<cfif info_tramite.RHPid NEQ "">
					<cfquery name="rsCFdestino" datasource="#Session.DSN#">
						select CFid
						  from RHPlazas
						 where RHPid = #info_tramite.RHPid#
					</cfquery>
					<cfset CFdestinoId = rsCFdestino.CFid>
				</cfif>

				<cfset dataItems = StructNew()>
				<cfset dataItems.DEid          = info_tramite.DEid>
				<cfset dataItems.DEnombre      = info_tramite.NombreCompleto>
				<cfset dataItems.Ecodigo       = session.Ecodigo>
				<cfset dataItems.RHAlinea      = acciones[i]>
				<cfset dataItems.Usucodigo     = SubjectId>
				<cfset descripcion_tramite     = info_tramite.NombreCompleto>
				<cfif Len(Trim(info_tramite.DLobs))>
					<cfset descripcion_tramite = descripcion_tramite & ' - ' & info_tramite.DLobs>
				</cfif>
				<cfset descripcion_tramite = ' de '& descripcion_tramite>

				<cftransaction>
					<!--- estas dos acciones tienen que estar en una transaccion --->
					<cfinvoke component="sif.Componentes.Workflow.Management" method="startProcess" returnvariable="processInstanceId">
						<cfinvokeargument name="ProcessId"			value="#info_tramite.RHTidtramite#">
						<cfinvokeargument name="RequesterId" 		value="#session.usucodigo#">
						<cfinvokeargument name="SubjectId"   		value="#SubjectId#">
						<cfinvokeargument name="Description" 		value="#descripcion_tramite#">
						<cfinvokeargument name="DataItems"   		value="#dataItems#">
						<cfinvokeargument name="transaccionactiva"	value="yes">
						<cfif CForigenID NEQ "">
							<cfinvokeargument name="CForigenID"			value="#CForigenID#">
						<cfelseif CFdestinoID NEQ "">
							<cfinvokeargument name="CForigenID"			value="#CFdestinoID#">
						</cfif>
						<cfif CFdestinoID NEQ "">
							<cfinvokeargument name="CFdestinoID"		value="#CFdestinoID#">
						<cfelseif CForigenID NEQ "">
							<cfinvokeargument name="CFdestinoID"		value="#CForigenID#">
						</cfif>
					</cfinvoke>
	
					<cfif isdefined('processInstanceId') and processInstanceId GT 0>
						<cfquery datasource="#session.dsn#" name="guardar_idtramite">
							update RHAcciones
							set RHAidtramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#processInstanceId#">
							where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#acciones[i]#">
						</cfquery>
					</cfif>
				</cftransaction>
			</cfif>
		<cfelse>
			<!--- No hay trámite, Postear acción --->
			<cfif info_tramite.RHAccionRecargo GT 0 or info_tramite.RHTcomportam EQ 12 or (info_tramite.RHTcomportam EQ 15 and info_tramite.RHAccionRecargo GT 0)> 
				<!---Si el comportamiento es de recargo utiliza una copia del componente adaptada para este tipo de accion--->
				<!--- Validar acción --->
				<cftransaction>
					<cfinvoke component="rh.Componentes.RH_AplicaAccionRecargo" method="AplicaAccion" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/> 
						<cfinvokeargument name="RHAlinea" value="#acciones[i]#"/> 
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/> 
						<cfinvokeargument name="conexion" value="#Session.DSN#"/> 
						<cfinvokeargument name="validar" value="true"/> 
						<cfinvokeargument name="debug" value="false"/> 
					</cfinvoke>
				</cftransaction>
				<!--- Postear acción --->
				<cftransaction>
					<cfinvoke component="rh.Componentes.RH_AplicaAccionRecargo" method="AplicaAccion" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/> 
						<cfinvokeargument name="RHAlinea" value="#acciones[i]#"/> 
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/> 
						<cfinvokeargument name="conexion" value="#Session.DSN#"/> 
						<cfinvokeargument name="validar" value="false"/> 
						<cfinvokeargument name="debug" value="false"/> 
                        <cfinvokeargument name="respetarLT" value="#info_tramite.RHTrespetarLT#"/> 
					</cfinvoke>
				</cftransaction>
			<cfelse>
				<!--- Validar acción --->
				<cftransaction>
					<cfinvoke component="rh.Componentes.RH_AplicaAccion" method="AplicaAccion" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/> 
						<cfinvokeargument name="RHAlinea" value="#acciones[i]#"/> 
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/> 
						<cfinvokeargument name="conexion" value="#Session.DSN#"/> 
						<cfinvokeargument name="validar" value="true"/> 
						<cfinvokeargument name="debug" value="false"/> 
                        <cfinvokeargument name="respetarLT" value="#info_tramite.RHTrespetarLT#"/> 
					</cfinvoke>
				</cftransaction>
		
				<!--- Postear acción --->
				<cftransaction>
					<cfinvoke component="rh.Componentes.RH_AplicaAccion" method="AplicaAccion" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/> 
						<cfinvokeargument name="RHAlinea" value="#acciones[i]#"/> 
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/> 
						<cfinvokeargument name="conexion" value="#Session.DSN#"/> 
						<cfinvokeargument name="validar" value="false"/> 
						<cfinvokeargument name="debug" value="false"/> 
                        <cfinvokeargument name="respetarLT" value="#info_tramite.RHTrespetarLT#"/> 
					</cfinvoke>
				</cftransaction>
				
				<!--- Invocación del Componente para la actualización del Usuario --->
                <!--- 2012-11-12. Se traslada la regeneración del Permisos al final de la transacción (se elimina del componente AplicaAccion) 
                pues es un proceso fuera de la aplicación de la Accción y no es dependendiente --->
                <cfif info_tramite.RHTcomportam EQ 1 or info_tramite.RHTcomportam EQ 9>	
					<cfif isdefined("refEmp.Usucodigo") and len(trim(refEmp.Usucodigo)) gt 0>
						<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos" method="actualizar">
							<cfinvokeargument name="Usucodigo" value="#refEmp.Usucodigo#">
							<cfinvokeargument name="SScodigo" value="RH">
						</cfinvoke>
					</cfif>
                </cfif>
			</cfif>
		</cfif>
	</cfloop>
	
<cfelseif isdefined("Form.btnEliminar")>
		<cfloop list="#form.chk#" index="Form.RHAlinea">
			<cftransaction>
				<cfinvoke component="rh.Componentes.RHFormulacionAccion" method="DropData">
					<cfinvokeargument name="RHAlinea" value="#Form.RHAlinea#">
				</cfinvoke>
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					delete from RHConceptosAccion 
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				</cfquery>
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					delete from RHDAcciones
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				</cfquery>
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					delete from RHAcciones
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
				</cfquery>
			</cftransaction>
		</cfloop>

<cfelseif not isdefined("Form.btnAplicar") and not isdefined("Form.btnEliminar") >
	<cfif Session.Params.ModoDespliegue EQ 1>
		<cfif isdefined("Form.o") and isdefined("Form.sel")>
			<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">
		<cfelse>
			
			<!---averiguar si el comportamiento es de recargo--->
			<cfif isdefined('form.RHAlinea') and len(trim(form.RHAlinea))>
				<cfquery name="rsCompTipoAccion" datasource="#Session.DSN#">
					select b.RHTcomportam, b.RHTcempresa, b.RHTnoveriplaza, 
						a.DEid, a.DLfvigencia, a.RHPid, a.DLffin, a.RHTid,
						coalesce(b.RHTespecial,0) as RHTespecial, b.RHTpfijo
					from RHAcciones a, RHTipoAccion b
					where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAlinea#">
					and a.RHTid = b.RHTid
				</cfquery>
			</cfif>
			
			<!--- <cfif isdefined('rsCompTipoAccion.RHTcomportam') and rsCompTipoAccion.RHTcomportam EQ 12>
				<cfset action = "/cfmx/rh/nomina/operacion/AccionesRecargo.cfm">
			<cfelse> --->
				<cfset action = "/cfmx/rh/nomina/operacion/Acciones.cfm">
			<!--- </cfif> --->
			
		</cfif>
	<cfelseif Session.Params.ModoDespliegue EQ 0>
		<cfif isdefined("form.Jefe")><!--- SI ESTOY EN AUTOGESTION - TRAMITES PARA SUBORDINADOS --->
			<cfset action = "/cfmx/rh/autogestion/autogestion.cfm?o=3&Jefe=#form.Jefe#&CentroF=#form.CentroF#&DEidSub=#form.DEidSub#">		
		<cfelse>
			<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
		</cfif>
	</cfif>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<cfif isdefined("Form.o") and isdefined("Form.sel") and isdefined("Form.DEid")>
		<cfoutput>
		<cfparam name="Form.o_1" default="#Form.o#">
		<input type="hidden" name="o" value="#Form.o_1#">
		<cfparam name="Form.sel_1" default="#Form.sel#">
		<input type="hidden" name="sel" value="#Form.sel_1#">
		<cfparam name="Form.DEid_1" default="#Form.DEid#">
		<input type="hidden" name="DEid" value="#Form.DEid_1#">
		</cfoutput>
	<!---agregado por danim, 05/sep/2005 --->
	<cfelseif (Session.Params.ModoDespliegue EQ 0)>
		<!--- para que el clic a un tramite en autogestion sirva --->
		<input type="hidden" name="o" value="3">
	<!---agregado por danim, 05/sep/2005 --->
	</cfif>
	<cfif not isdefined("Form.PosteoAccion")>		
		<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0>
			<input name="Usuario" type="hidden" value="#Form.Usuario#"> 
		</cfif>
		<cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
			<input name="DLffin" type="hidden" value="#Form.DLffin#"> 
		</cfif>
		<cfif isdefined("Form.DLfvigencia") and Len(Trim(Form.DLfvigencia)) NEQ 0>
			<input name="DLfvigencia" type="hidden" value="#Form.DLfvigencia#"> 
		</cfif>
		<cfif isdefined("Form.RHAlinea") and Len(Trim(Form.RHAlinea)) NEQ 0 and not isdefined("form.btnAplicar") and not isdefined("form.btnEliminar")>
			<input name="RHAlinea" type="hidden" value="#Form.RHAlinea#">
			<input name="modo" type="hidden" value="CAMBIO">
		<cfelse>
			<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		</cfif>
	</cfif>
	<cfif isdefined("Form.PosteoAccion")>
		<input name="modo" type="hidden" value="ALTA">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
