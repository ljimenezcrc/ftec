

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="ftec.Componentes.FTVicerectorias" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="Vcodigo" 	value="#form.Vcodigo#">
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTVicerectorias" method="Alta"  returnvariable="Lvar_Iid">
            	<cfinvokeargument name="Vcodigo" 			value="#form.Vcodigo#">
                <cfinvokeargument name="Vdescripcion" 		value="#form.Vdescripcion#">
                <cfif isdefined('form.Vpadre')> 
                	<cfinvokeargument name="Vpadre" 			value="#form.Vpadre#">
                </cfif>
                
                <cfinvokeargument name="Vctaingreso" 		value="#form.Vctaingreso#">
                <cfinvokeargument name="Vctagasto" 			value="#form.Vctagasto#">
                <cfinvokeargument name="Vctasaldoinicial" 	value="#form.Vctasaldoinicial#">
                <cfif isdefined('form.Vesproyecto')> 
                	<cfinvokeargument name="Vesproyecto" value="1">
                <cfelse> 
                	<cfinvokeargument name="Vesproyecto" value="0">
                </cfif>
                <cfinvokeargument name="Vfinicio" 			value="#form.Vfinicio#">
                <cfinvokeargument name="Vffinal" 			value="#form.Vffinal#">
                <cfif isdefined('form.Vestado')> 
                	<cfinvokeargument name="Vestado" value="1">
                <cfelse> 
                	<cfinvokeargument name="Vestado" value="0">
                </cfif>
                <cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#">
                <cfinvokeargument name="Vmonto" 			value="#form.Vmonto#">
                <cfinvokeargument name="Debug"				value="false">
            </cfinvoke>
			<cfset Form.Vpk = #Lvar_Iid#>
            <cfset tab=2>
            <cfset modo="ALTA">
		<cfelse>
			<cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Vicerrectorias/Proyectos'>
            <cfset DetErrs 	 = 'La Unidad Operativa/Proyecto que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
    	<cfinvoke component="ftec.Componentes.FTVicerectorias" method="Baja" returnvariable="rsGet" >

            <cfinvokeargument name="Vcodigo" 		value="#form.Vcodigo#">
            <cfinvokeargument name="Debug"			value="false">
        </cfinvoke>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
    	<cfinvoke component="ftec.Componentes.FTVicerectorias" method="Cambio" >
            <cfinvokeargument name="Vid" 				value="#form.Vpk#">
            <cfinvokeargument name="Vcodigo" 			value="#form.Vcodigo#">
            <cfinvokeargument name="Vdescripcion" 		value="#form.Vdescripcion#">
            <cfif isdefined('form.Vpadre')> 
                <cfinvokeargument name="Vpadre" 			value="#form.Vpadre#">
            </cfif>
            <cfinvokeargument name="Vctaingreso" 		value="#form.Vctaingreso#">
            <cfinvokeargument name="Vctagasto" 			value="#form.Vctagasto#">
            <cfinvokeargument name="Vctasaldoinicial" 	value="#form.Vctasaldoinicial#">
            <cfif isdefined('form.Vesproyecto')> 
                <cfinvokeargument name="Vesproyecto" value="1">
            <cfelse> 
                <cfinvokeargument name="Vesproyecto" value="0">
            </cfif>
            <cfinvokeargument name="Vfinicio" 			value="#form.Vfinicio#">
            <cfinvokeargument name="Vffinal" 			value="#form.Vffinal#">
            <cfif isdefined('form.Vestado')> 
                <cfinvokeargument name="Vestado" value="1">
            <cfelse> 
                <cfinvokeargument name="Vestado" value="0">
            </cfif>
            <cfinvokeargument name="Mcodigo" 			value="#form.Mcodigo#">
            <cfinvokeargument name="Vmonto" 			value="#form.Vmonto#">
            <cfinvokeargument name="Debug"				value="false">
        </cfinvoke>
    
		<cfif isdefined("rsDeptocodigoCambio") and rsDeptocodigoCambio.RecordCount GT 0>
			<cf_errorCode	code = "50021" msg = "El Código que desea modificar ya existe.">
		</cfif>
	</cfif>
</cfif>



<form action="Vicerrectorias.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Vpk" type="hidden" value="<cfif isdefined("Vpk")><cfoutput>#Vpk#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


***************************************************************************


<!---

<!--- 
	SQLCFuncional.cfm (SQL DE Actualización de CFuncional)
	----------------------------------------------------------------------------------------------------------------------------
	Modificación: 29 de novimebre de 2006 - Se corrige modificación del campo RHPid -plaza responsable- porque siempre se borra, 
	aun cuando no este definido el usuario responsable. En cuyo caso si se debe borrar, dado que los conceptos son excluyentes. 
	- Realizado por Dorian Abarca G. - Cambio requerido por Freddy Leiva - Consultado con Marcel de Mezerville L. -
	----------------------------------------------------------------------------------------------------------------------------
--->
<!--- ========================================================================= --->
<!--- Esto solo aplica para la empresa corporativa. 
	  Se puede marcar el CF como corporativo, solo si su padre es corporativo
--->
<cfinvoke key="LB_Existen_plazas_asociadas_a_este_centro_funcional_por_lo_tanto_no_puede_ser_borrado." default="Existen plazas asociadas a este centro funcional, por lo tanto no puede ser borrado. " returnvariable="LB_ErrorCFplazas" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_ErrorCF" 
default="Existe datos asociados a este centro funcional, por lo tanto no puede ser borrado. " 
returnvariable="LB_ErrorCF"  />	

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_Error_Hay_centros_Funcionales_desligados"
Default="Error: Hay centros funcionales desligados"
returnvariable="MG_Error_Hay_centros_Funcionales_desligados"/> 

<cfset es_corporativo 	  = false >
<cfset vEcodigoCorp 	  = 0 >
<cfset marcar_corporativo = false >
<cfparam name="form.ActividadId" 	default="-1">
<cfparam name="form.Actividad" 		default="">
<!---***********************************************************************************************************************************************
                                                   Funciones para CFautoriza                                             
************************************************************************************************************************************************--->
<cfif isdefined("form.CFid")>
	<cfquery name="rsCF" datasource="#session.dsn#">
		select CFcodigo from CFuncional where CFid=#form.CFid# and Ecodigo=#session.Ecodigo#
	</cfquery>
</cfif>
<cfif isdefined("url.CajasNo")>
	<cfset session.cajasNo = (url.CajasNo EQ "1")>
	<cfset modo = "CAMBIO">
	<cfset irA = 'CFuncional.cfm' >
	<cfset tab=2>
<cfelse>
	<cfif isdefined ('form.AltaAut')>
		<cfset sbNewCFjefeAutoriza()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=4&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined ('form.BajaAut')>
		<cfquery name="InCFU" datasource="#session.dsn#">
			delete from CFautoriza where CFid=#form.CFid# and Usucodigo=#form.Usucodigo# and Ecodigo=#session.Ecodigo#
		</cfquery>
		<!---- fcastro 14/08/12 a continuacion se crea este query para que se elimine el check de " Aprobación Incidencia Automática " del tab Autorizadores del Centro Funcional 
		para el proceso de aprobacion de Incidencias de Coopelesca---->
		<cfquery name="InCFAIA" datasource="#session.dsn#">
			delete from CFAprobacionIncidenciasAuto where CFid=#form.CFid# and Usucodigo=#form.Usucodigo# and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=4&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined ('form.CambioAut')>
		<cfset sbNewCFjefeAutoriza()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=4&CFcodigo=#rsCF.CFcodigo#&usucodigo=#form.usucodigo#">
	<cfelseif isdefined('form.NuevoAut')>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=4&CFcodigo=#rsCF.CFcodigo#">
	<!---***********************************************************************************************************************************************
													   Funciones para UsuarioCFuncional                                             
	************************************************************************************************************************************************--->
	<cfelseif isdefined ('form.AltaUsu')>
		<cfset sbNewCFjefeAutoriza()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=5&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined ('form.BajaUsu')>
		<cfquery name="InCFU" datasource="#session.dsn#">
			delete from UsuarioCFuncional where CFid=#form.CFid# and Usucodigo=#form.Usucodigo# and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=5&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined ('form.CambioUsu')>
		<cfset sbNewCFjefeAutoriza()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=5&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined('form.NuevoUsu')>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=5&CFcodigo=#rsCF.CFcodigo#">
	</cfif>
	<!---*******************************************************************************************************************************************--->
	
    <!---***********************************************************************************************************************************************
													   Funciones para CFuncionalCostos                                             
	************************************************************************************************************************************************--->
	<cfif isdefined ('form.AltaCos')>
    	<cfset sbNewCostos()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=7&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined ('form.BajaCos')>
    	<cfset sbNewCostos()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=7&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined ('form.CambioCos')>
    	<cfset sbNewCostos()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=7&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined('form.NuevoCos')>
    	<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=7&CFcodigo=#rsCF.CFcodigo#">
	</cfif>
	<!---*******************************************************************************************************************************************--->
    
     <!---***********************************************************************************************************************************************
													   Funciones para CFuncionalIngresos
	************************************************************************************************************************************************--->
	<cfif isdefined ('form.AltaIng')>
    	<cfset sbNewIngresos()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=8&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined ('form.BajaIng')>
    	<cfset sbNewIngresos()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=8&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined ('form.CambioIng')>
    	<cfset sbNewIngresos()>
		<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=8&CFcodigo=#rsCF.CFcodigo#">
	<cfelseif isdefined('form.NuevoIng')>
    	<cflocation url="CFuncional.cfm?CFpk=#form.CFid#&tab=8&CFcodigo=#rsCF.CFcodigo#">
	</cfif>
	<!---*******************************************************************************************************************************************--->
    
	<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
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
	
		<cfif session.Ecodigo eq vEcodigoCorp >
			<cfset es_corporativo = true >
			<cfif isdefined("form.CFcorporativo") and isdefined("Form.CFpkresp") and len(trim(Form.CFpkresp))>
				<cfquery name="rsPadreCorp" datasource="#session.DSN#">
					select CFcorporativo
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpkresp#" >
				</cfquery>
				<cfif rsPadreCorp.CFcorporativo eq 1 >
					<cfset marcar_corporativo = true >
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<!--- ========================================================================= ---> 
	 
	<cfset respPlaza = false >	<!--- la plaza solo existe si el parametro de planilla presupuestaria esta activo --->
	<cfset respUsuario = true > <!--- el usuario siempre existe --->
	<cfif isdefined("form.radioResponsable") and form.radioResponsable eq 'P' >
		<cfset respPlaza = true >
		<cfset respUsuario = false >
	</cfif>
	
	<cfset modo = "ALTA">
	<cfset irA = 'CFuncional.cfm' >
    
    <cf_dump var="#form#">
    
	<cfif not isdefined("Form.Nuevo") and not isDefined("Form.Filtrar") and not isdefined ('form.AltaAut') and not isdefined ('form.BajaAut') and not isdefined ('form.NuevoAut') and not isdefined ('form.AltaUsu') and not isdefined ('form.BajaUsu') and not isdefined ('form.NuevoUsu')>
		<cftry>	
			<cfset existe = false>			
			<cfset tieneSubordinados = false>		
			<cfset puedeSerJefe = true>
	
			<cfquery name="rsExiste" datasource="#Session.DSN#">
				select 1 from CFuncional  
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and CFcodigo = <cfqueryparam value="#Trim(Form.CFcodigo)#" cfsqltype="cf_sql_char">
			</cfquery>				
	
			<cfif isdefined('rsExiste')	and rsExiste.recordCount GT 0 and isdefined("Form.Alta")> 
				<cfset existe = true> 
				<script>alert("Ya existe un centro funcional con ese código");</script> 			
			</cfif>		
	
			<cfif rsExiste.recordCount GT  0 and isdefined("form.CFpk") and len(trim(form.CFpk)) > 
				<cfquery name="rsTieneSubordinados" datasource="#Session.DSN#">
					select 1 
					from CFuncional  
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and ( case CFnivel when 0 then null else CFidresp end ) = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
					  and CFid != ( case CFnivel when 0 then null else CFidresp end )
				</cfquery>				
				
				<cfif isdefined('rsTieneSubordinados') and rsTieneSubordinados.recordCount GT 0 and isdefined("Form.Baja")> 
					<cfset tieneSubordinados = true> 
					<script>alert("El centro funcional no se puede eliminar debido a que tiene centros funcionales dependientes");</script> 			
				</cfif>
			</cfif>		
	
			<cfif isdefined("Form.Cambio")> 
			
				<cfif Form.Cambio EQ "Guardar">
					<cfset tab=2>
				<cfelse>
					<cfset tab=1>
				</cfif>
				
				<cfset CFpk = form.CFpk>		<!--- Id del Centro Funcional a cambiarle su jefe --->
				<cfset NuevoJefe = "">
				<cfset NuevoJefeInicial = "">			
				<cfset n = 0>			
				<cfset Jefe = "">			
				<cfset varPuedeSerJefe = false>			
			
				<cfif len(trim(Form.CFpkresp)) GT 0>
					<cfset NuevoJefe = Form.CFpkresp>		<!--- Id del posible responsable del Centro Funcional --->
				</cfif>		
				<cfset NuevoJefeInicial = NuevoJefe>
	
				<cfloop condition = "n LESS THAN 50">
					<cfset n = n + 1>
	
					<cfquery name="rsJefe" datasource="#Session.DSN#">
						select ( case CFnivel when 0 then null else CFidresp end ) as CFidresp
						from CFuncional
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
						<cfif NuevoJefe NEQ ''>
							and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NuevoJefe#">
						<cfelse>
							and CFid = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">
						</cfif>
					</cfquery>
						
					<cfif isdefined('rsJefe') and rsJefe.recordCount GT 0>
						<cfset Jefe = rsJefe.CFidresp>
					</cfif>
					
					<cfif Jefe EQ CFpk>
						<cfset varPuedeSerJefe = false>
						<cfbreak>
					</cfif>
					
					<cfif NuevoJefeInicial EQ ''>
						<cfif Jefe EQ ''>
							<cfset varPuedeSerJefe = true>
							<cfbreak>
						</cfif>				
					<cfelse>
						<cfif Jefe EQ '' or Jefe EQ NuevoJefeInicial>
							<cfset varPuedeSerJefe = true>
							<cfbreak>
						</cfif>				
					</cfif>
	
					<cfset NuevoJefe = Jefe>
				</cfloop>
	
				<cfif varPuedeSerJefe EQ false> 
					<cfset puedeSerJefe = false> 
					<script>alert("No se puede asignar el centro funcional como responsable ya que depende del mismo");</script> 			
				</cfif>
			</cfif>
	
			<cfset CFcuentac = "">
			<cfif isdefined("form.Cmayor") and len(trim(form.Cmayor)) gt 0 and isdefined("form.Cformato") and len(trim(form.Cformato)) gt 0 >
				<cfset CFcuentac = trim(form.Cmayor) & "-" & trim(form.Cformato) >
			</cfif>		
	
			<cfset CFcuentaaf = "">
			<cfif isdefined("form.Cmayor_CFcuentaafform") and len(trim(form.Cmayor_CFcuentaafform)) gt 0 and isdefined("form.CFcuentaafform") and len(trim(form.CFcuentaafform)) gt 0 >
				<cfset CFcuentaaf = trim(form.Cmayor_CFcuentaafform) & "-" & trim(form.CFcuentaafform) >
			</cfif>
	
			<cfset CFcuentainventario = "">
			<cfif isdefined("form.Cmayor_CFCIformato") and len(trim(form.Cmayor_CFCIformato)) gt 0 and isdefined("form.CFCIformato") and len(trim(form.CFCIformato)) gt 0 >
				<cfset CFcuentainventario = trim(form.Cmayor_CFCIformato) & "-" & trim(form.CFCIformato) >
			</cfif>
	
			<cfset CFcuentainversion = "">
			<cfif isdefined("form.Cmayor_CFAFformato") and len(trim(form.Cmayor_CFAFformato)) gt 0 and isdefined("form.CFAFformato") and len(trim(form.CFAFformato)) gt 0 >
				<cfset CFcuentainversion = trim(form.Cmayor_CFAFformato) & "-" & trim(form.CFAFformato) >
			</cfif>
			
			<cfset CFcuentaingreso = "">
			<cfif isdefined("form.Cmayor_CFINformato") and len(trim(form.Cmayor_CFINformato)) gt 0 and isdefined("form.CFINformato") and len(trim(form.CFINformato)) gt 0 >
				<cfset CFcuentaingreso = trim(form.Cmayor_CFINformato) & "-" & trim(form.CFINformato) >
			</cfif>		
	
			<cfif isdefined("Form.Alta")>				
				<cfif not existe>
					<cfset my_path = Trim(form.CFcodigo)>
					<cfset my_nivel = 0>
					<cfif len(trim(Form.CFpkresp))>
						<cfquery name="path_papa" datasource="#session.dsn#">
							select CFpath, CFnivel
							from CFuncional
							where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpkresp#">
						</cfquery>
						<cfif path_papa.RecordCount>
							<cfset my_path = Trim(path_papa.CFpath) & '/' & my_path>
							<cfset my_nivel = path_papa.CFnivel + 1>
						</cfif>
					</cfif>
					
					<cfset fnPeriodoMes()>
						
					<cftransaction>
						<cfquery name="CFuncional" datasource="#Session.DSN#">
							insert into CFuncional( Ecodigo, 
													CFcodigo, 
													Dcodigo, 
													Ocodigo, 
													<!--- RHPid,  --->
													CFdescripcion, 
													CFidresp, 
													CFcuentac, 
													CFuresponsable, 
													CFcomprador, 
													CFautoccontrato, 
													CFpath, 
													CFnivel, 
													CFcuentainventario, 
													CFcuentainversion, 
													CFcorporativo, 
													CFcuentaaf, 
													CFcuentaingreso,
													CFcuentaingresoretaf,
													CFcuentagastoretaf,
													CFcuentaobras,
													CFcuentaPatri,
													CFestado,
                                                    FPAEid,
            										CFComplemento,
                                                    CFACTransitoria,
													CFcuentatransitoria
													)
							values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFdescripcion#">, 
								<cfif isdefined("Form.CFpkresp") and Len(Trim(Form.CFpkresp)) GT 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpkresp#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFcuentac") and len(trim(form.CFcuentac))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentac#"><cfelse>null</cfif>,
								<cfif not respUsuario >null<cfelse><cfif isdefined("form.CFuresponsable") and len(trim(form.CFuresponsable))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFuresponsable#"><cfelse>null</cfif></cfif>,
								<cfif isdefined("form.CFcomprador") and len(trim(form.CFcomprador))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcomprador#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFautoccontrato") and len(trim(form.CFautoccontrato))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFautoccontrato#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#my_path#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#my_nivel#">,
								<cfif isdefined("form.CFcuentainventario") and len(trim(form.CFcuentainventario))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentainventario#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFcuentainversion") and len(trim(form.CFcuentainversion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentainversion#"><cfelse>null</cfif>,
								<cfif isdefined("marcar_corporativo") and marcar_corporativo>1<cfelse>0</cfif>,
								<cfif isdefined("form.CFcuentaaf") and len(trim(form.CFcuentaaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaaf#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFcuentaingreso") and len(trim(form.CFcuentaingreso))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaingreso#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFcuentaingresoretaf") and len(trim(form.CFcuentaingresoretaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaingresoretaf#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFcuentagastoretaf") and len(trim(form.CFcuentagastoretaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentagastoretaf#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFcuentaobras") and len(trim(form.CFcuentaobras))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaobras#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFcuentaPatri") and len(trim(form.CFcuentaPatri))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaPatri#"><cfelse>null</cfif>,
								<cfif isdefined("form.CFestado") and len(trim(form.CFestado))>1<cfelse>0</cfif>,
                                <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ActividadId#" 	voidnull null="#form.ActividadId EQ -1#">, 
                                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.Actividad#" 	voidnull null="#form.Actividad   EQ -1#">,
                                <cfif isdefined("form.CTAtransitoria") and len(trim(form.CTAtransitoria))>1<cfelse>0</cfif>,
                                <cfif isdefined("Form.CFcuenta_CcuentaTransitoria") and Len(Trim(Form.CFcuenta_CcuentaTransitoria)) GT 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta_CcuentaTransitoria#"><cfelse>null</cfif>
							)
						  <cf_dbidentity1 datasource="#Session.DSN#">
						</cfquery>
						<cf_dbidentity2 datasource="#Session.DSN#" name="CFuncional">
	
						<cfquery datasource="#session.DSN#">
							insert into AFBDepartamentos 
								(
									Ecodigo, 
									CFid, 
									Usucodigo, 
									Dcodigo, 
									Ocodigo, 
									AFBDperiodo, 
									AFBDmes, 
									AFBDpermesdesde, 
									AFBDpermeshasta, 
									BMUsucodigo
								)
							values 
								(
									#session.Ecodigo#,
									#CFuncional.identity#,
									#session.Usucodigo#,
									#Form.Dcodigo#,
									#Form.Ocodigo#,
									#LvarPeriodo#,
									#LvarMes#,
									#LvarPeriodoMes#,
									610001,
									#session.Usucodigo#
								)
						</cfquery>
					</cftransaction>
					
					<cfset Form.CFpk = CFuncional.identity>
					<cfset tab=2>
					<cfset modo="ALTA">
				</cfif>
			<cfelseif isdefined ("form.Exportar")>
				<cflocation url="CFExporta.cfm?CFpk=#form.CFpk#&tab=1&CFpath=#form.CFpath#">
			<cfelseif isdefined ("form.Importar")>	
				<cflocation url="CFImporta.cfm">
			<cfelseif isdefined("Form.Baja") and not tieneSubordinados>
				<cftry>
					<cftry>
						<cfquery datasource="#Session.DSN#">
							delete from RHPlazas 
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
						</cfquery>
						<cfcatch type="any">
							<cf_throw message="#LB_ErrorCFplazas#" errorcode="350">
						 </cfcatch>
					</cftry>				 
					
						<cfquery datasource="#Session.DSN#">				  
							delete from CFuncional
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
						</cfquery>
						
					
					
					
					<cf_sifcomplementofinanciero action='delete'
							tabla="CFuncional"
							form = "form1_2"
							llave="#form.CFpk#" />					
					<cfset modo="BAJA">
					<cfset irA = 'CFuncional-lista.cfm' >
				
				<cfcatch type="any">
							<cf_throw message="#LB_ErrorCF#" errorcode="51676">
					</cfcatch>
				</cftry>
	
			<cfelseif isdefined("Form.Cambio") and puedeSerJefe >
				<cftransaction>
					<cfif Form.Cambio EQ "Guardar">
						<cfset tab=2>
					<cfelse>
						<cfset tab=1>
					</cfif>
					
					<cfquery datasource="#session.dsn#" name="valores_anteriores">
						select CFcodigo, CFidresp, Ocodigo, Dcodigo
						from CFuncional
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
					</cfquery>
							
					<cf_dbtimestamp
						datasource="#session.dsn#"
						table="CFuncional"
						redirect="CFuncional.cfm"
						timestamp="#form.ts_rversion#"
						field1="Ecodigo,integer,#session.Ecodigo#"
						field2="CFid,numeric,#form.CFpk#">						
					
					<!--- Si el departamento es diferente al que actualmente se va a actualizar se actualizan las tablas: LineaTiempo,RHPlazas,CFuncional--->
					<cfif Form.Dcodigo NEQ valores_anteriores.Dcodigo>
						<cfquery name="UpLineaTiempo" datasource="#Session.DSN#">
							Update LineaTiempo 
								set Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and RHPid in (	select x.RHPid 
											from RHPlazas x 
											where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
											and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
											) 
						</cfquery>
						
						<cfquery name="UpLineaTiempo" datasource="#Session.DSN#">
							Update LineaTiempoR 
								set Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and RHPid in (	select x.RHPid 
											from RHPlazas x 
											where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
											and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
											) 
						</cfquery>
						
						<cfquery name="UpRHPlazas" datasource="#Session.DSN#">
							Update RHPlazas 
								set Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
						</cfquery>
					</cfif>
					
					<!--- Actualiza el centro funcional--->
					<cfquery name="CFuncional" datasource="#Session.DSN#">
						update CFuncional set
							CFcodigo 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFcodigo#">, 
							Dcodigo 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
							Ocodigo 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
							CFdescripcion 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFdescripcion#">, 
							CFcuentac		 		= <cfif isdefined("form.CFcuentac") and  len(trim(form.CFcuentac))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentac#"><cfelse>null</cfif>,
							CFcuentainventario 		= <cfif isdefined("form.CFcuentainventario") and  len(trim(form.CFcuentainventario))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentainventario#"><cfelse>null</cfif>,
							CFcuentainversion 		= <cfif isdefined("form.CFcuentainversion") and  len(trim(form.CFcuentainversion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentainversion#"><cfelse>null</cfif>,
							<cfif isdefined("form.CFuresponsable") and len(trim(form.CFuresponsable))>RHPid = null,</cfif>
							CFuresponsable 			= <cfif not respUsuario >null<cfelse><cfif isdefined("form.CFuresponsable") and len(trim(form.CFuresponsable))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFuresponsable#"><cfelse>null</cfif></cfif>,
							CFcomprador 			= <cfif isdefined("form.CFcomprador") and len(trim(form.CFcomprador))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcomprador#"><cfelse>null</cfif>,
							CFautoccontrato			= <cfif isdefined("form.CFautoccontrato") and len(trim(form.CFautoccontrato))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFautoccontrato#"><cfelse>null</cfif>,
							CFcuentaaf 				= <cfif isdefined("form.CFcuentaaf") and len(trim(form.CFcuentaaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaaf#"><cfelse>null</cfif>,
							CFcorporativo 			= <cfif isdefined("marcar_corporativo") and marcar_corporativo>1<cfelse>0</cfif>,
							CFcuentaingreso 		= <cfif isdefined("form.CFcuentaingreso") and len(trim(form.CFcuentaingreso))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaingreso#"><cfelse>null</cfif>,
							CFcuentaingresoretaf 	= <cfif isdefined("form.CFcuentaingresoretaf") and len(trim(form.CFcuentaingresoretaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaingresoretaf#"><cfelse>null</cfif>,
							CFcuentagastoretaf		= <cfif isdefined("form.CFcuentagastoretaf") and len(trim(form.CFcuentagastoretaf))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentagastoretaf#"><cfelse>null</cfif>,	
							CFcuentaobras			= <cfif isdefined("form.CFcuentaobras") and len(trim(form.CFcuentaobras))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcuentaobras#"><cfelse>null</cfif>,	
							CFestado				= <cfif isdefined("form.CFestado") and len(trim(form.CFestado))>1<cfelse>0</cfif>,
							CFcuentaPatri 			= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CFcuentaPatri#" null="#NOT ISDEFINED('form.CFcuentaPatri') OR NOT(LEN(TRIM(form.CFcuentaPatri)))#">,
							FPAEid 					= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ActividadId#" voidnull null="#form.ActividadId EQ -1#">, 
							CFComplemento 			= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.Actividad#"	voidnull null="#form.Actividad   EQ -1#">,
							CFACTransitoria         = <cfif isdefined("form.CTAtransitoria") and len(trim(form.CTAtransitoria))>1<cfelse>0</cfif>,
							CFcuentatransitoria     = <cfif isdefined("Form.CFcuenta_CcuentaTransitoria") and Len(Trim(Form.CFcuenta_CcuentaTransitoria)) GT 0 ><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta_CcuentaTransitoria#"><cfelse>null</cfif>,
															
						<!--- si se el jefe a cambiar es él mismo, entonces lo pone en nulo --->
						<cfif isdefined("Form.CFpkresp") and Len(Trim(Form.CFpkresp)) GT 0>									
							<cfif Compare(Trim(Form.CFpkresp),Trim(Form.CFpk)) EQ 0>
								CFidresp = null
							<cfelse>		
								<cfif len(trim(Form.CFpkresp)) GT 0>
								CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpkresp#">
								<cfelse>
								CFidresp = null
								</cfif>				
							</cfif>										
						<cfelse>
							CFidresp = null
						</cfif>
						
		
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
					</cfquery>
	
					<cfset fnPeriodoMes()>
					
					<!--- Verifica si cambió el CFcodigo, Ocodigo o Dcodigo --->
					<cfif valores_anteriores.CFcodigo neq Form.CFcodigo or valores_anteriores.Ocodigo neq Form.Ocodigo or valores_anteriores.Dcodigo neq Form.Dcodigo>
	
						<!--- Obtiene el maximo id para el Centro funcional, empresa  --->
						<cfquery name="rsPeridoMes" datasource="#session.DSN#">
							select max(AFBDid) as AFBDid
							from AFBDepartamentos
							where CFid = #Form.CFpk#
							  and Ecodigo = #session.Ecodigo#
						</cfquery>
						<cfset LvarAFBDid = rsPeridoMes.AFBDid>
						
						<cfif len(trim(LvarAFBDid)) eq 0>
							<cfquery name="rsPerMes" datasource="#session.DSN#">
								select 
									min(Speriodo*100+Smes) as PeriodoMes
								from CGPeriodosProcesados
								where Ecodigo = #session.Ecodigo#
							</cfquery>
							
							<cfif len(trim(rsPerMes.PeriodoMes))>
								<cfset LvarPeriodoMes = rsPerMes.PeriodoMes>
							<cfelse>
								<cfquery name="rsPerActual" datasource="#session.dsn#">
									select Pvalor as Speriodo  from Parametros
										where Pcodigo=30
										and Ecodigo=#session.Ecodigo#
								</cfquery>
								<cfquery name="rsMesActual" datasource="#session.dsn#">
									select Pvalor as Smes from Parametros
										where Pcodigo=40
										and Ecodigo=#session.Ecodigo#
								</cfquery>
								<cfset LvarPeriodo =#rsPerActual.Speriodo#>
								<cfset LvarMes =#rsMesActual.Smes#>
								<cfset LvarPeriodoMes =#rsPerActual.Speriodo#*100+#rsMesActual.Smes#>
							</cfif>	
							<cfquery name="rsPeriodoMes" datasource="#session.DSN#">
								select 
									Speriodo as Periodo, 
									Smes as Mes
								from CGPeriodosProcesados
								where Ecodigo = #session.Ecodigo#
								   and Speriodo*100+Smes = #LvarPeriodoMes#
							</cfquery>
							<cfif len(trim(rsPerMes.PeriodoMes))>
								<cfset LvarPeriodo = rsPeriodoMes.Periodo>
								<cfset LvarMes = rsPeriodoMes.Mes>
							</cfif>	
							
							<cfquery name="rsPeriodoMesIn" datasource="#session.DSN#">
								insert into AFBDepartamentos 
								(
								Ecodigo, 
								CFid, 
								Usucodigo, 
								Dcodigo, 
								Ocodigo, 
								AFBDperiodo, 
								AFBDmes, 
								AFBDpermesdesde, 
								AFBDpermeshasta, 
								BMUsucodigo
								)
								select 
								Ecodigo, 
								CFid, 
								1, 
								Dcodigo, 
								Ocodigo, 
								#LvarPeriodo#,
								#LvarMes#,
								#LvarPeriodoMes#,
								610001,
								1
								from CFuncional
								where CFid = #Form.CFpk#
								and Ecodigo = #session.Ecodigo#
								<cf_dbidentity1 datasource="#Session.DSN#">
							</cfquery>
							<cf_dbidentity2 datasource="#Session.DSN#" name="rsPeriodoMesIn">
							<cfset LvarAFBDid = rsPeriodoMesIn.identity>
						</cfif>
						
						<cfif len(trim(LvarAFBDid)) eq 0>
							<cfthrow message="No se encontró un registro en la bitácora de departamentos para el centro funcional que intenta modificar en la empresa que está autentificado. Verifique que la tabla AFBDepartamentos tenga registros para el centro funcional escogido en esta empresa">
							<cfabort>
						</cfif>
						
						<cfquery name="rsPeridoMes" datasource="#session.DSN#">
							select AFBDpermesdesde
							from AFBDepartamentos
							where AFBDid = #LvarAFBDid#
						</cfquery>
	
						
						<cfif isdefined("rsPeridoMes") and rsPeridoMes.recordcount gt 0>
							<cfset LvarPerMesAFBD = rsPeridoMes.AFBDpermesdesde>
						</cfif>
	
						<!--- si el permes es el actual, actualiza si es otro, inserta  --->
						<cfif LvarPerMesAFBD eq LvarPeriodoMes>
							<cfquery datasource="#session.DSN#">
								update AFBDepartamentos
									set CFid = #Form.CFpk#,
										Ocodigo = #Form.Ocodigo#,
										Dcodigo = #Form.Dcodigo#
								where AFBDid 	= #LvarAFBDid#
							</cfquery>
						<cfelse>
							<!--- Corta Permeshasta --->
							<cfquery datasource="#session.DSN#">
								update AFBDepartamentos
									set AFBDpermeshasta = #LvarPeriodoMes -1#
								where AFBDid = #LvarAFBDid#
							</cfquery>
							<cfquery datasource="#session.DSN#">
								insert into AFBDepartamentos 
									(
										Ecodigo, 
										CFid, 
										Usucodigo, 
										Dcodigo, 
										Ocodigo, 
										AFBDperiodo, 
										AFBDmes, 
										AFBDpermesdesde, 
										AFBDpermeshasta, 
										BMUsucodigo
									)
								values 
									(
										#session.Ecodigo#,
										#Form.CFpk#,
										#session.Usucodigo#,
										#Form.Dcodigo#,
										#Form.Ocodigo#,
										#LvarPeriodo#,
										#LvarMes#,
										#LvarPeriodoMes#,
										610001,
										#session.Usucodigo#
									)
							</cfquery>
						</cfif>
					</cfif>
					
					
					<cf_sifcomplementofinanciero action='update'
							tabla="CFuncional"
							form = "form1_2"
							llave="#form.CFpk#" />			
							
					<!--- Si se quita la marca de corporativo a un CF, le quita la marca de corporativo a todos sus CF's dependiente --->
					<cfif es_corporativo >
						<cfif not marcar_corporativo >
							<cfquery name="rsTieneHijos" datasource="#session.DSN#">
								select 1
								from CFuncional
								where ( case CFnivel when 0 then null else CFidresp end ) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
							</cfquery>
							<cfif rsTieneHijos.recordcount gt 0>
								<cfquery datasource="#session.DSN#">
									update CFuncional 
									set CFcorporativo = 0
									where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and CFpath like '#form.CFpath#%'
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
							
					<cfif Trim(valores_anteriores.CFcodigo) neq Trim(form.CFcodigo) or Trim(valores_anteriores.CFidresp) neq Trim(form.CFpkresp)>
						<!--- reordenar todo el arbol pues ha cambiado la estructura del arbol --->
							
						<cfquery datasource="#session.dsn#">
							update CFuncional
							  set CFpath =  ltrim(rtrim(CFcodigo)),
								  CFnivel = ( case CFnivel when 0 then 0 else -1 end )
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						</cfquery>
		
						<cfset nivel = 0>
						<cfloop from="0" to="100" index="nivel">
							<cfif nivel is 100>
								<cf_throw message="#MG_Error_Hay_centros_Funcionales_desligados#" errorcode="2080">
							</cfif>
							<cf_dbfunction name="OP_concat" datasource="#session.dsn#" returnvariable="_Cat">
							<cfquery name="CFUpdate" datasource="#session.dsn#">
								select Actual.CFid,  #nivel + 1# as CFnivel, Padre.CFpath #_Cat# '/' #_Cat# ltrim(rtrim(Actual.CFcodigo)) as CFpath
									from CFuncional Actual
										inner join CFuncional Padre
											 on Padre.CFid = Actual.CFidresp 
											and Padre.Ecodigo = Actual.Ecodigo
								where Actual.CFnivel = -1 
								  and Actual.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								  and Padre.CFnivel  = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">
							</cfquery>
							<cfloop query="CFUpdate">
								<cfquery datasource="#session.dsn#">
									update CFuncional set 
										CFpath  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#CFUpdate.CFpath#">, 
										CFnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#CFUpdate.CFnivel#">
									 where CFid = #CFUpdate.CFid#
								</cfquery>
							</cfloop>
							
							<cfquery datasource="#session.dsn#" name="hay_mas">
								select count(1) as cuantos
								from CFuncional
							   where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
								 and CFnivel = -1
							</cfquery>
							
							<cfif isdefined('hay_mas') and hay_mas.cuantos is 0><cfbreak></cfif>
						</cfloop>
						
						<!--- OJO: SEGURIDAD DE PRESUPUESTO --->
						<!--- NO SE COMO FUNCIONA ESTO, CUANDO ES EL CF RAIZ, YA QUE EL RESP DE LA RAIZ PUEDE SER NULO --->
						<cfif not len(trim(Form.CFpkresp))>
							<cfset Form.CFpkresp = 0 >
						</cfif>
						<cfset sbActualizaSeguridadPresupuesto(Form.CFpk, Form.CFpkresp)>
			
					</cfif>
				</cftransaction>
				<cfset modo="ALTA">
			</cfif>
		<cfcatch type="database">
			<cfinclude template="/sif/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cfif>
</cfif>

<form action="<cfoutput>#irA#</cfoutput>" method="post" name="sql">
	
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
		
		<cfif isdefined("Form.CFpk") and Len(Trim(Form.CFpk))neq 0>
			<input name="CFpk_papa" type="hidden" value="<cfoutput>#Form.CFpk#</cfoutput>">
		</cfif>
		
		<cfif isdefined("Form.CFpkresp") and Len(Trim(Form.CFpkresp))neq 0>
			<input name="CFpkresp_papa" type="hidden" value="<cfoutput>#Form.CFpkresp#</cfoutput>">
		</cfif>
	
	</cfif>
	
	<cfif isDefined("Form.Filtrar")>
		<cfset tab = 3>	
		<cfset modo = "CAMBIO" >
		<input name="fRHPcodigo" type="hidden" value="<cfif isdefined("Form.fRHPcodigo")><cfoutput>#Form.fRHPcodigo#</cfoutput></cfif>">	
		<input name="fRHPdescripcion" type="hidden" value="<cfif isdefined("Form.fRHPdescripcion")><cfoutput>#Form.fRHPdescripcion#</cfoutput></cfif>">	
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif not isdefined("Form.Nuevo") and isdefined("Form.CFpk") and Len(Trim(Form.CFpk)) and isdefined("modo") and modo NEQ "BAJA">
		<input name="CFpk" type="hidden" value="<cfoutput>#Form.CFpk#</cfoutput>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
	
	<cfif isdefined("tab") and len(trim(tab)) NEQ 0>
        <input name="tab" type="hidden" value="<cfoutput>#tab#</cfoutput>" />
    </cfif>
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

<!--- ACTUALIZA LA SEGURIDAD DE PRESUPUESTO PARA USUARIOS QUE TIENEN CENTROS FUNCIONALES HIJOS Y CAMBIO EL PADRE --->
<cffunction name="sbActualizaSeguridadPresupuesto" output="false">
	<cfargument name="CForigen"	type="numeric" required="yes">
	<cfargument name="CFpadre" 	type="numeric" required="yes">
	
	<cftry>
		<cfquery datasource="#session.dsn#" name="rsSeguridadPresupuesto">
			select count(1) as cantidad
			  from CPSeguridadUsuario su
			 where su.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			   and su.CFid = <cfqueryparam value="#CForigen#" cfsqltype="cf_sql_numeric">
			   and su.Usucodigo is not null
		</cfquery>
	<cfcatch></cfcatch>
	</cftry>
	<cfif isdefined("rsSeguridadPresupuesto")>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CFpath, CFcodigo
			  from CFuncional
			 where CFid = <cfqueryparam value="#CForigen#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset LvarPath 	= trim(rsSQL.CFpath)>
        <cfset LvarCFcodigo = trim(rsSQL.CFcodigo)>

		<!--- Cuando Existe un usuario que tenga asignado el CForigen --->
		<cfif rsSeguridadPresupuesto.cantidad GT 0>
			<!--- 1. Si un usuario tiene asignado el CForigen como hijo y no tiene asignado el CFpadre: 
						Borra la estructura funcional del CForigen --->
			<cfquery datasource="#session.dsn#">
				delete from CPSeguridadUsuario
				 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				   and CFid in
					(	<!--- jerarquia funcional a partir del CForigen --->
						select jo.CFid
						  from CFuncional jo
						 where jo.Ecodigo 	= CPSeguridadUsuario.Ecodigo
						   and <cf_dbfunction name="sPart" args="jo.CFpath,1,#len(LvarPath)#"> = '#LvarPath#'
					)
				   and Usucodigo is not null
				   and not exists 
					(	<!--- NO Tiene asignado el CFpadre --->
						select 1
						  from CPSeguridadUsuario sp
						 where sp.Ecodigo 	= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						   and sp.CFid 		= <cfqueryparam value="#CFpadre#" cfsqltype="cf_sql_numeric">
						   and sp.Usucodigo = CPSeguridadUsuario.Usucodigo
						   and 
								(		<!--- El CFpadre es hijo --->
									sp.CPSUidOrigen is not null 
								OR
									exists
									(	<!--- El CFpadre tiene hijos --->
										select CPSUidOrigen
										  from CPSeguridadUsuario spp
										 where spp.CPSUidOrigen	= sp.CPSUid
									)
								)
					)
                    and NOT (CFid =  #CForigen# and CPSUidOrigen is null)
			</cfquery>

			<!--- 2. Si un usuario tiene asignado el CFpadre como hijo: 
						Actualiza la estructura funcional del CForigen: CPSUidOrigen = CPSUidOrigen del CFpadre --->
			<!--- 3. Si un usuario tiene asignado el CFpadre como raiz: 
						Actualiza la estructura funcional del CForigen: CPSUidOrigen = CPSUid del CFpadre --->
			<!--- 4. Si un usuario no tiene asignado el CFpadre (pero el CForigen no es hijo, puesto que ya se borraron): 
						No actualiza la estructura funcional del CForigen: CPSUidOrigen = CPSUidOrigen --->
			<cfquery datasource="#session.dsn#" name="hay_mas">
				update CPSeguridadUsuario
				   set CPSUidOrigen = 
						coalesce (
							(	<!--- CFpadre --->
								select coalesce(sp.CPSUidOrigen, sp.CPSUid)
								  from CPSeguridadUsuario sp
								 where sp.Ecodigo 	= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
								   and sp.CFid 		= <cfqueryparam value="#CFpadre#" cfsqltype="cf_sql_numeric">
								   and sp.Usucodigo = CPSeguridadUsuario.Usucodigo
							)
						, -1)
				 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				   and CFid in
					(	<!--- jerarquia funcional a partir del CForigen --->
						select jo.CFid
						  from CFuncional jo
						 where jo.Ecodigo 	= CPSeguridadUsuario.Ecodigo
						   and <cf_dbfunction name="sPart" args="jo.CFpath,1,#len(LvarPath)#"> = '#LvarPath#'
					)
				   and Usucodigo is not null
                   and CFid <> #CForigen#
			</cfquery>
		</cfif>

		<!--- 5. Si un usuario no tiene asignado el CForigen pero tiene asignado el CFpadre como hijo: 
					Incluye la Estructura Funcional del CForigen: CPSUidOrigen = CPSUidOrigen del CFpadre --->
		<!--- 6. Si un usuario no tiene asignado el CForigen pero tiene asignado el CFpadre como padre (tiene hijos): 
					Incluye la Estructura Funcional del CForigen: CPSUidOrigen = CPSUid del CFpadre --->

		<cfquery datasource="#session.dsn#">
			insert into CPSeguridadUsuario 
				  (Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion, BMUsucodigo, CPSUidOrigen)
			select jo.Ecodigo, jo.CFid, sp.Usucodigo, sp.CPSUconsultar, sp.CPSUtraslados, sp.CPSUreservas, sp.CPSUformulacion, sp.CPSUaprobacion, sp.BMUsucodigo, 
					coalesce(sp.CPSUidOrigen, sp.CPSUid)
			  from CPSeguridadUsuario sp
				inner join CFuncional jo	<!--- jerarquia funcional a partir del CForigen --->
					 on jo.Ecodigo 	= sp.Ecodigo
					and <cf_dbfunction name="sPart" args="jo.CFpath,1,#len(LvarPath)#"> = '#LvarPath#'
			 where sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   and sp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFpadre#">
			   and sp.Usucodigo is not null		<!--- Un Usuario tiene asignado el CFpadre --->
			   and 
			   		(		<!--- El CFpadre es hijo --->
						sp.CPSUidOrigen is not null 
					OR
						exists
						(	<!--- El CFpadre tiene hijos --->
							select CPSUidOrigen
							  from CPSeguridadUsuario spp
							 where spp.CPSUidOrigen	= sp.CPSUid
						)
					)
			   and not exists
					(		<!--- No tiene asignado el CForigen --->
						select 1
						  from CPSeguridadUsuario so
						 where so.Ecodigo 	= jo.Ecodigo
						   and so.CFid		= jo.CFid
						   and so.Usucodigo = sp.Usucodigo
					)
                and sp.CFid <> #CForigen#
		</cfquery>
        
       <cfquery datasource="#session.dsn#">
			insert into CPSeguridadUsuario 
				  (Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion, BMUsucodigo, CPSUidOrigen)
			select jo.Ecodigo, jo.CFid, sp.Usucodigo, sp.CPSUconsultar, sp.CPSUtraslados, sp.CPSUreservas, sp.CPSUformulacion, sp.CPSUaprobacion, sp.BMUsucodigo, 
					coalesce(sp.CPSUidOrigen, sp.CPSUid)
			  from CPSeguridadUsuario sp
				inner join CFuncional jo	<!--- jerarquia funcional a partir del CForigen --->
					 on jo.Ecodigo 	= sp.Ecodigo
					and <cf_dbfunction name="like" args="jo.CFpath,'%#LvarCFcodigo#/%'">
			 where sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   and sp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CForigen#">
			   and sp.Usucodigo is not null		<!--- Un Usuario tiene asignado el CFpadre --->
			 
			   and not exists
					(		<!--- No tiene asignado el CForigen --->
						select 1
						  from CPSeguridadUsuario so
						 where so.Ecodigo 	= jo.Ecodigo
						   and so.CFid		= jo.CFid
						   and so.Usucodigo = sp.Usucodigo
					)
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="fnPeriodoMes" access="private" output="no" returntype="void">
	
	<cfquery name="rsPeriodoAux" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
        and Pcodigo = 50
    </cfquery>
    <cfif rsPeriodoAux.recordcount eq 1>
        <cfset LvarPeriodo = rsPeriodoAux.Pvalor>
    <cfelse>
        <cfthrow message="No se ha definido el Parametro Período Auxiliares" detail="Favor definir este parámetro en Administración del Sistema, Período Auxiliares.">
    </cfif>
    
    <cfquery name="rsMesAux" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
        and Pcodigo = 60
    </cfquery>
    <cfif rsMesAux.recordcount eq 1>
        <cfset LvarMes = rsMesAux.Pvalor>
    <cfelse>
        <cfthrow message="No se ha definido el Parametro Mes Auxiliares" detail="Favor definir este parámetro en Administración del Sistema, Mes Auxiliares.">
    </cfif>
    
    <cfset LvarPeriodoMes = LvarPeriodo * 100 + LvarMes>
</cffunction>

<cffunction name="sbNewCFjefeAutoriza" access="private" output="no" returntype="void">
	<cfif isdefined("form.chkResponsable")>
		<cfquery name="CFuncional" datasource="#Session.DSN#">
			update CFuncional set
				RHPid = null,
				CFuresponsable = #form.Usucodigo#
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CFid = <cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	<cfelse>
		<cfquery name="CFuncional" datasource="#Session.DSN#">
			update CFuncional set
				CFuresponsable = null
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CFid = <cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric">
			  and CFuresponsable = #form.Usucodigo#
		</cfquery>

	</cfif>
	<cfif isdefined("form.chkAIA")>
	<!---- fcastro 14/08/12 se crea este query para que se actualice el check de " Aprobación Incidencia Automática " del tab Autorizadores del Centro Funcional 
	para el proceso de aprobacion de Incidencias de Coopelesca---->
		<cfquery  name="verificaInsercionAIA" datasource="#session.dsn#">
		select count(1) as valor
		from CFAprobacionIncidenciasAuto
		where Ecodigo=#session.Ecodigo#
		and Usucodigo = #form.Usucodigo#
		and CFid =#form.CFid#
		</cfquery>
		<cfif trim(verificaInsercionAIA.valor) eq 0>
			<cfquery name="CFAprobacionIncidencias" datasource="#Session.DSN#">
					insert into CFAprobacionIncidenciasAuto
					(
						Ecodigo,
						Usucodigo,
						CFid,
						BMUsucodigo,
						BMfalta
					)
					values (
						#session.Ecodigo#,
						#form.Usucodigo#,
						#form.CFid#,
						#session.Usucodigo#,
						<cf_dbfunction name="now">
					)
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="CFDeleteAIA" datasource="#Session.DSN#">
				delete from CFAprobacionIncidenciasAuto
				where Ecodigo = #session.Ecodigo#
				and Usucodigo = #form.Usucodigo#
				and CFid = #form.CFid#
		</cfquery>
	</cfif>
	<cfif isdefined ('form.AltaAut') OR isdefined ('form.chkAutoriza')>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			  from CFautoriza
			 where Ecodigo 	 = #session.Ecodigo#
			   and Usucodigo = #form.Usucodigo#
			   and CFid		 = #form.CFid#
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfquery name="InCFU" datasource="#session.dsn#">
				insert into CFautoriza
				(
					Ecodigo,
					Usucodigo,
					CFid,
					BMUsucodigo,
					BMfalta
				)
				values (
					#session.Ecodigo#,
					#form.Usucodigo#,
					#form.CFid#,
					#session.Usucodigo#,
					<cf_dbfunction name="now">
				)
			</cfquery>
		</cfif>
	</cfif>
	<cfset sbNewUsuarioCFuncional()>
</cffunction>

<cffunction name="sbNewUsuarioCFuncional" access="private" output="no" returntype="void">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select cfu.CFid, cf.CFcodigo
		  from UsuarioCFuncional cfu
		  	inner join CFuncional cf
				on cf.CFid = cfu.CFid
		 where cfu.Ecodigo 	 = #session.Ecodigo#
		   and cfu.Usucodigo = #form.Usucodigo#
	</cfquery>
	<cfif rsSQL.CFid EQ "">
		<cfquery datasource="#session.dsn#">
			insert into UsuarioCFuncional(
				Ecodigo,
				Usucodigo,
				CFid,
				BMUsucodigo,
				BMfalta
			)
			values (
					#session.Ecodigo#,
					#form.Usucodigo#,
					#form.CFid#,
					#session.Usucodigo#,
					<cf_dbfunction name="now">
			)
		</cfquery>
	<cfelseif isdefined ('form.AltaUsu')>
		<cfif isdefined ('form.chkAltaUsu')>
			<cfquery datasource="#session.dsn#">
				update UsuarioCFuncional
				   set CFid = #form.CFid#
				 where Ecodigo 	 = #session.Ecodigo#
				   and Usucodigo = #form.Usucodigo#
			</cfquery>
		<cfelse>
			<cfset session.AltaUsu = "Usuario asignado al Centro Funcional #rsSQL.CFcodigo#">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="sbNewCostos" access="private" output="no" returntype="void">
	<cfif isdefined ('form.AltaCos')>
        <cfquery name="InCFCostos" datasource="#session.dsn#">
            insert into CfuncionalConc
            (
                Cid,
                CFid,
                Ecodigo,
                CFCtipo
            )
            values (
                <cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric">,
                <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">,
                <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="0" cfsqltype="cf_sql_bit">
            )
        </cfquery>
    <cfelseif isdefined ('form.CambioCos')>    
    	<cfquery name="UpCFCostos" datasource="#session.dsn#">
            update CfuncionalConc set
            Cid     = <cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric">,
            CFid    = <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">,
            Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        </cfquery>
	<cfelseif isdefined ('form.BajaCos')>    
        <cfquery name="SeCFCostos" datasource="#session.dsn#">
        	select * 
            from CfuncionalConc 
            where CFCid_Costo=#form.CFCid# 
            and Ecodigo=#session.Ecodigo# 
        </cfquery>
        <cfif SeCFCostos.recordcount eq 0>
            <cfquery name="DeCFCostos" datasource="#session.dsn#">
                delete from CfuncionalConc where CFCid=#form.CFCid# and Ecodigo=#session.Ecodigo# and Cid = #form.Cid# and CFid = #form.CFid#
            </cfquery>
        <cfelse>
        	<cf_errorCode code = "90222" msg = "No se puede eliminar el Costo Autom&aacute;tico debido a que esta asociado a un Ingreso Autom&aacute;tico! Proceso Cancelado!">    
        </cfif>
    </cfif>
</cffunction>

<cffunction name="sbNewIngresos" access="private" output="no" returntype="void">
	<cfif isdefined ('form.AltaIng')>
    	<cfset existe = sbComprobacion()>
		<cfif not existe>
            <cfquery name="InCFIngresos" datasource="#session.dsn#">
                insert into CfuncionalConc
                (
                    Cid,
                    CFid,
                    Ecodigo,
                    CFCtipo,
                    CFCporc,
                    CFCid_Costo,
                    CFidD
                )
                values (
                    <cfqueryparam value="#form.Cid2#" cfsqltype="cf_sql_numeric">,
                    <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">,
                    <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
                    <cfif isdefined("form.CFCtipo") or form.CFCtipoR gt 0>1,<cfelse>0,</cfif>
                    <cfqueryparam value="#form.CFCporc#" cfsqltype="cf_sql_double" null="#Len(CFCporc) Is 0#">,
                    <cfqueryparam value="#form.CFCid3#" cfsqltype="cf_sql_numeric" null="#Len(CFCid3) Is 0#">,
                    <cfqueryparam value="#form.CFidD#" cfsqltype="cf_sql_numeric">
                )
            </cfquery>
        </cfif>
    <cfelseif isdefined ('form.CambioIng')> 
    	<cfset existe = sbComprobacion()>
		<cfif not existe>
            <cfquery name="UpCFIngresos" datasource="#session.dsn#">
                update CfuncionalConc set
                Cid         = <cfqueryparam value="#form.Cid2#" cfsqltype="cf_sql_numeric">,
                CFCtipo     = <cfif isdefined("form.CFCtipo") or form.CFCtipoR gt 0>1,<cfelse>0,</cfif>
                CFCporc     = <cfqueryparam value="#form.CFCporc#" cfsqltype="cf_sql_double" null="#Len(CFCporc) Is 0#">,
                CFCid_Costo = <cfqueryparam value="#form.CFCid3#" cfsqltype="cf_sql_numeric" null="#Len(CFCid3) Is 0#">,
                CFidD       = <cfqueryparam value="#form.CFidD#" cfsqltype="cf_sql_numeric" null="#Len(CFidD) Is 0#">
                where CFCid = <cfqueryparam value="#form.CFCid2#" cfsqltype="cf_sql_numeric">
            </cfquery>
        </cfif>		
	<cfelseif isdefined ('form.BajaIng')>    
        <cfquery name="DeCFIngresos" datasource="#session.dsn#">
            delete from CfuncionalConc where CFCid=#form.CFCid2# and Ecodigo=#session.Ecodigo# and Cid = #form.Cid2# and CFid = #form.CFid#
        </cfquery>
    </cfif>
</cffunction>

<cffunction name="sbComprobacion" access="private" output="no" returntype="boolean">
	<cfset existe = false> 
    <cfif len(form.CFCid3) gt 0 and (not isdefined("form.CFCtipo") or form.CFCtipoR eq 0)>
        <cfquery name="rsComp" datasource="#session.dsn#">
            select  sum(cf.CFCporc) as suma, cf.CFCid_Costo, cf.CFid, cf.Ecodigo, c.Cdescripcion
            from CfuncionalConc cf
            inner join Conceptos c
            on c.Ecodigo = cf.Ecodigo
            and c.Cid = (select Cid from CfuncionalConc where CFCid = #form.CFCid3#)
            where cf.Ecodigo = #session.Ecodigo#
            and cf.CFid = #form.CFid#
            and coalesce(cf.CFCporc, 0) > 0
            and cf.CFCid_Costo = #form.CFCid3#
            group by cf.CFCid_Costo, cf.CFid, cf.Ecodigo, c.Cdescripcion
        </cfquery>
        <cfif rsComp.recordcount gt 0>
			<cfif isdefined ('form.CambioIng')> 
            	<cfquery name="rsComp2" datasource="#session.dsn#">
	                select CFCporc from CfuncionalConc where CFCid = <cfqueryparam value="#form.CFCid2#" cfsqltype="cf_sql_numeric">
    			</cfquery>
            	<cfset rsComp.suma = (rsComp.suma - rsComp2.CFCporc)>
            </cfif>
			<cfset total = (rsComp.suma + form.CFCporc)>
			<cfif total gt 100> 
                <cfset existe = true> 
                <cfset tot2 = (100 - rsComp.suma)>
                <cf_errorCode code = "90222" msg = "Tienes #tot2# para distribuir al costo #rsComp.Cdescripcion#, no se puede pasar del 100%!">    
            </cfif>
        </cfif>
    </cfif>
    <cfreturn existe>
</cffunction>
--->