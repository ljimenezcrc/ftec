
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

<cfif isdefined('form.Vid')>
	<cfquery name="rsCF" datasource="#session.dsn#">
		select Vcodigo from <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> where Vid=#form.Vid# and Ecodigo=#session.Ecodigo#
	</cfquery>
</cfif>


<cfif isdefined('url.CajasNo')>
	<cfset session.cajasNo = (url.CajasNo EQ "1")>
	<cfset modo = "CAMBIO">
	<cfset irA = 'CFuncional.cfm' >
	<cfset tab=2>
<cfelse>
	<cfif isdefined ('form.AltaAut')>
        <cfinvoke component="ftec.Componentes.FTAutorizador" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="Vid" 		value="#form.Vid#">
            <cfinvokeargument name="TAid"  value="#form.TAid#">
            <cfinvokeargument name="Usucodigo" 	value="#form.Usucodigo#">

            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>
		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTAutorizador" method="Alta"  returnvariable="Lvar_Iid">
                <cfinvokeargument name="TAid" 		value="#form.TAid#">
                <cfinvokeargument name="Vid" 		value="#form.Vid#">
                <cfinvokeargument name="Usucodigo" 	value="#form.Usucodigo#">
                <cfinvokeargument name="Afdesde" 	value="#form.Afdesde#">
                <cfinvokeargument name="Afhasta" 	value="#form.Afhasta#">
                
                <cfif isdefined('form.Ainactivo')> 
                    <cfinvokeargument name="Ainactivo" value="1">
                <cfelse> 
                    <cfinvokeargument name="Ainactivo" value="0">
                </cfif>
                <cfif isdefined('form.TAresponsable')> 
                    <cfinvokeargument name="TAresponsable" value="1">
                <cfelse> 
                    <cfinvokeargument name="TAresponsable" value="0">
                </cfif>
                <cfinvokeargument name="Debug" value="false">
            </cfinvoke>
        <cfelse>
            <cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Vicerrectorias/Proyectos'>
            <cfset DetErrs 	 = 'El autorizador que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
        </cfif>        
		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=4&Vcodigo=#rsCF.Vcodigo#">
	<cfelseif isdefined ('form.BajaAut')>
        <cfinvoke component="ftec.Componentes.FTAutorizador" method="Baja" returnvariable="rsGet" >
            <cfinvokeargument name="Aid" 		value="#form.Aid#">
            <cfinvokeargument name="TAid" 		value="#form.TAid#">
            <cfinvokeargument name="Vid" 		value="#form.Vid#">
            <cfinvokeargument name="Usucodigo" 	value="#form.Usucodigo#">
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>

		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=4&Vcodigo=#rsCF.Vcodigo#">
	<cfelseif isdefined ('form.CambioAut')>
        <cfinvoke component="ftec.Componentes.FTAutorizador" method="Cambio" >
            <cfinvokeargument name="Aid" 		value="#form.Aid#">
            <cfinvokeargument name="TAid" 		value="#form.TAid#">
            <cfinvokeargument name="Vid" 		value="#form.Vid#">
            <cfinvokeargument name="Usucodigo" 	value="#form.Usucodigo#">
            <cfinvokeargument name="Afdesde" 	value="#form.Afdesde#">
            <cfinvokeargument name="Afhasta" 	value="#form.Afhasta#">
            
            <cfif isdefined('form.Ainactivo')> 
                <cfinvokeargument name="Ainactivo" value="1">
            <cfelse> 
                <cfinvokeargument name="Ainactivo" value="0">
            </cfif>
            <cfif isdefined('form.TAresponsable')> 
                <cfinvokeargument name="TAresponsable" value="1">
            <cfelse> 
                <cfinvokeargument name="TAresponsable" value="0">
            </cfif>
            <cfinvokeargument name="Debug" value="false">
        </cfinvoke>				
		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=4&Vcodigo=#rsCF.Vcodigo#&usucodigo=#form.usucodigo#">
	<cfelseif isdefined('form.NuevoAut')>
		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=4&Vcodigo=#rsCF.Vcodigo#">
    </cfif>
    
    <!--- ========================================================================= ---> 
    
    <cfif isdefined ('form.AltaCost')>
        <cfinvoke component="ftec.Componentes.FTCostosProyecto" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="Vid" 		value="#form.Vid#">
            <cfinvokeargument name="CAid" 		value="#form.CAid#">
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTCostosProyecto" method="Alta"  returnvariable="Lvar_Iid">
                <cfinvokeargument name="Vid" 		value="#form.Vid#">
                <cfinvokeargument name="CAid" 		value="#form.CAid#">
                <cfinvokeargument name="CPporcentaje" 	value="#form.CPporcentaje#">
                <cfif isdefined('form.CPexoneracion')> 
                    <cfinvokeargument name="CPexoneracion" value="1">
                <cfelse> 
                    <cfinvokeargument name="CPexoneracion" value="0">
                </cfif>
                <cfinvokeargument name="CPfdesde" 	value="#form.CPfdesde#">
                <cfinvokeargument name="CPfhasta" 	value="#form.CPfhasta#">
                <cfif isdefined('form.CPDistribuido')> 
                    <cfinvokeargument name="CPDistribuido" value="1">
                <cfelse> 
                    <cfinvokeargument name="CPDistribuido" value="0">
                </cfif>
                <cfif isdefined('form.CPvalorcatalogo')> 
                    <cfinvokeargument name="CPvalorcatalogo" value="1">
                <cfelse> 
                    <cfinvokeargument name="CPvalorcatalogo" value="0">
                </cfif>
                <cfinvokeargument name="Debug" value="false">
            </cfinvoke>
        <cfelse>
            <cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Costos de Proyectos'>
            <cfset DetErrs 	 = 'El costo que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
        </cfif>        
		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=3&Vcodigo=#rsCF.Vcodigo#">
	<cfelseif isdefined ('form.BajaCost')>
        <cfinvoke component="ftec.Componentes.FTCostosProyecto" method="Baja">
            <cfinvokeargument name="CPid" 		value="#form.CPid#">
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>

		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=3&Vcodigo=#rsCF.Vcodigo#">
	<cfelseif isdefined ('form.CambioCost')>
        <cfinvoke component="ftec.Componentes.FTCostosProyecto" method="Cambio" >
            <cfinvokeargument name="CPid" 		value="#form.CPid#">
            <cfinvokeargument name="Vid" 		value="#form.Vid#">
            <cfinvokeargument name="CAid" 		value="#form.CAid#">
            <cfinvokeargument name="CPporcentaje" 	value="#form.CPporcentaje#">
            <cfif isdefined('form.CPexoneracion')> 
                <cfinvokeargument name="CPexoneracion" value="1">
            <cfelse> 
                <cfinvokeargument name="CPexoneracion" value="0">
            </cfif>
            <cfinvokeargument name="CPfdesde" 	value="#form.CPfdesde#">
            <cfinvokeargument name="CPfhasta" 	value="#form.CPfhasta#">
            <cfif isdefined('form.CPdistribuido')> 
                <cfinvokeargument name="CPdistribuido" value="1">
            <cfelse> 
                <cfinvokeargument name="CPdistribuido" value="0">
            </cfif>
            <cfif isdefined('form.CPvalorcatalogo')> 
                <cfinvokeargument name="CPvalorcatalogo" value="1">
            <cfelse> 
                <cfinvokeargument name="CPvalorcatalogo" value="0">
            </cfif>
        </cfinvoke>				
		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=3&Vcodigo=#rsCF.Vcodigo#">
	<cfelseif isdefined('form.NuevoCost')>
		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=3&Vcodigo=#rsCF.Vcodigo#">
    </cfif>
    
    <!--- ========================================================================= ---> 
    
    <cfif isdefined ('form.AltaCostDist')>
        <cfif isdefined ('form.CPid')>
        <cfinvoke component="ftec.Componentes.FTCostosProyectoD" method="Get" returnvariable="rsGet" >
            <cfinvokeargument name="CPid" 		value="#form.CPid#">
            <cfinvokeargument name="Vid" 		value="#form.VidDist#">
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>
        <cfelse>
            <cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr    = 'Parámetros FTEC Costos de Proyectos'>
            <cfset DetErrs   = 'El costo debe ser ingresado y luego la distribución, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
        </cfif>


        
        

		<cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            <cfinvoke component="ftec.Componentes.FTCostosProyectoD" method="Alta"  returnvariable="Lvar_Iid">
                <cfinvokeargument name="CPid" 		value="#form.CPid#">
                <cfinvokeargument name="Vid" 		value="#form.VidDist#">
                <cfinvokeargument name="CPDporcentaje" 	value="#form.CPDporcentaje#">
                
                <cfinvokeargument name="Debug" value="false">
            </cfinvoke>
        <cfelse>
            <cfset TitleErrs = 'Operación Inválida'>
            <cfset MsgErr	 = 'Parámetros FTEC Costos de Proyectos'>
            <cfset DetErrs 	 = 'El costo que intenta agregar ya existe, Verificar.'>
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
        </cfif>        
		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=3&Vcodigo=#rsCF.Vcodigo#">
	<cfelseif isdefined('Form.btnBorrarConcepto.X')>
        <cfinvoke component="ftec.Componentes.FTCostosProyectoD" method="Baja">
            <cfinvokeargument name="CPDid" 		value="#form.CPDid_#">
            <cfinvokeargument name="Debug"		value="false">
        </cfinvoke>

		<cflocation url="Vicerrectorias.cfm?Vpk=#form.Vid#&tab=3&Vcodigo=#rsCF.Vcodigo#">
    </cfif>
    

    
  
	<!--- ========================================================================= ---> 
	 
	<cfset respPlaza = false >	<!--- la plaza solo existe si el parametro de planilla presupuestaria esta activo --->
	<cfset respUsuario = true > <!--- el usuario siempre existe --->
    
	<cfif isdefined("form.radioResponsable") and form.radioResponsable eq 'P' >
		<cfset respPlaza = true >
		<cfset respUsuario = false >
	</cfif>
	
	<cfset modo = "ALTA">
	<cfset irA = 'Vicerrectorias.cfm' >
   
	<cfif not isdefined("Form.Nuevo") and not isDefined("Form.Filtrar") and not isdefined ('form.AltaAut') and not isdefined ('form.BajaAut') and not isdefined ('form.NuevoAut') >
        <cfif isdefined("Form.Alta")>				
            <cfinvoke component="ftec.Componentes.FTVicerectorias" method="Get" returnvariable="rsGet" >
                <cfinvokeargument name="Vcodigo" 	value="#form.Vcodigo#">
                <cfinvokeargument name="Debug"		value="false">
            </cfinvoke>
    
    
    
            <cfif isdefined('rsGet') and rsGet.RecordCount EQ 0>
            
                <cfinvoke component="ftec.Componentes.FTVicerectorias" method="Alta"  returnvariable="Lvar_Iid">
                    <cfinvokeargument name="Vcodigo" 			value="#form.Vcodigo#">
                    <cfinvokeargument name="Vdescripcion" 		value="#form.Vdescripcion#">
                    <cfif isdefined('form.Vpkresp')> 
                        <cfinvokeargument name="Vpadre" 		value="#form.Vpkresp#">
                    </cfif>
                    <cfif isdefined('form.CFid') and len(form.CFid) GT 0> 
                    	<cfinvokeargument name="CFid" 	value="#form.CFid#">
                    </cfif>
                    <!---<cfinvokeargument name="Vctaingreso" 		value="#form.Vctaingreso#">
                    <cfinvokeargument name="Vctagasto" 			value="#form.Vctagasto#">
                    <cfinvokeargument name="Vctasaldoinicial" 	value="#form.Vctasaldoinicial#">
                    --->
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
                
                <!---alta de los costos Administrativos marcados como obligatorios solo si es proyecto--->
                <cfif isdefined('form.Vesproyecto')> 
                    <cfinvoke component="ftec.Componentes.FTCostosProyecto" method="AltaObligatorios">
                        <cfinvokeargument name="Vid" 				value="#Lvar_Iid#">
                        <cfinvokeargument name="CPfdesde" 			value="#form.Vfinicio#">
                        <cfinvokeargument name="CPfhasta" 			value="#form.Vffinal#">
                        <cfinvokeargument name="Debug"				value="false">
                    </cfinvoke>
                </cfif>
                
            <cfelse>
                <cfset TitleErrs = 'Operación Inválida'>
                <cfset MsgErr	 = 'Parámetros FTEC Vicerrectorias/Proyectos'>
                <cfset DetErrs 	 = 'La Unidad Operativa/Proyecto que intenta agregar ya existe, Verificar.'>
                <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
            </cfif>
            
            <cfset Form.Vpk = #Lvar_Iid#>
            <cfset tab=4>

            <cfset modo="ALTA">

        <cfelseif isdefined("Form.Baja")>
            <cfinvoke component="ftec.Componentes.FTVicerectorias" method="Baja" returnvariable="rsGet" >
                <cfinvokeargument name="Vcodigo" 		value="#form.Vcodigo#">
                <cfinvokeargument name="Debug"			value="false">
            </cfinvoke>
            <cfset modo="BAJA">					
            <cfset irA = 'Vicerrectorias-lista.cfm' >

        <cfelseif isdefined("Form.Cambio")>
            <cfinvoke component="ftec.Componentes.FTVicerectorias" method="Cambio" >
                <cfinvokeargument name="Vid" 				value="#form.Vpk#">
                <cfinvokeargument name="Vcodigo" 			value="#form.Vcodigo#">
                <cfinvokeargument name="Vdescripcion" 		value="#form.Vdescripcion#">
                <cfif isdefined('form.Vpkresp')> 
                    <cfinvokeargument name="Vpadre" 			value="#form.Vpkresp#">
                </cfif>
				<cfif isdefined('form.CFid') and len(form.CFid) GT 0> 
                    	<cfinvokeargument name="CFid" 	value="#form.CFid#">
                    </cfif>
                <!---<cfinvokeargument name="Vctaingreso" 		value="#form.Vctaingreso#">
                <cfinvokeargument name="Vctagasto" 			value="#form.Vctagasto#">
                <cfinvokeargument name="Vctasaldoinicial" 	value="#form.Vctasaldoinicial#">--->
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
            <cfset modo="ALTA">
        </cfif>
	</cfif>
</cfif>

<form action="<cfoutput>#irA#</cfoutput>" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
		
		<cfif isdefined("Form.Vpk") and Len(Trim(Form.Vpk))neq 0>
			<input name="Vpk_papa" type="hidden" value="<cfoutput>#Form.Vpk#</cfoutput>">
		</cfif>
	</cfif>

    
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif not isdefined("Form.Nuevo") and isdefined("Form.Vpk") and Len(Trim(Form.Vpk)) and isdefined("modo") and modo NEQ "BAJA">
		<input name="Vpk" type="hidden" value="<cfoutput>#Form.Vpk#</cfoutput>">
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



