<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cf_dbfunction name="OP_concat" datasource="#session.dsn#" returnvariable="_Cat">

<cfset lvFTpasoactual = 0>
<cfset lvFTpasoaprueba = 0>
<cfset lvFTpasorechaza = 0>
    
<cfif isDefined("session.Ecodigo") and isDefined("Form.FTid") and len(trim(#Form.FTid#)) NEQ 0>
    <cfquery name="rsFTramites" datasource="#session.dsn#">
        select 
            a.FTid
            , a.TTid
            , a.ETid
            , a.FTpasoactual
            , a.FTpasoaprueba
            , a.FTpasorechaza
            , coalesce(a.FTautoriza,0) as FTautoriza
            , b.ETcodigo #_Cat# ' - ' #_Cat#  b.ETdescripcion as Estado
            , c.TTcodigo #_Cat# ' - ' #_Cat# c.TTdescripcion as Tramite
            <!---, d.TAcodigo #_Cat# ' - ' #_Cat# d.TAdescripcion as Autorizados--->
        from FTFlujoTramite a
            inner join FTEstadoTramite b
                on a.ETid = b.ETid
            inner join FTTipoTramite c
                on a.TTid = c.TTid
           <!--- inner join FTTipoAutorizador d
                on a.TAid = d.TAid--->
       	where a.FTid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FTid#">
        order by c.TTcodigo #_Cat# ' - ' #_Cat# c.TTdescripcion ,  a.FTpasoactual
    </cfquery>  
    
        
    <cfset lvFTpasoactual = rsFTramites.FTpasoactual>
    <cfset lvFTpasoaprueba = rsFTramites.FTpasoaprueba>
    <cfset lvFTpasorechaza = rsFTramites.FTpasorechaza>
    
    <cfif isdefined('form.FTid')>
        <cfquery name="rsAutorizadores" datasource="#session.DSN#">
            select 	a.FTDid
		            ,  a.FTid
                    , a.TAid
                    , b.TAcodigo
                    , b.TAdescripcion
            from FTDFlujoTramite a
            inner join FTTipoAutorizador b
            	on a.TAid = b.TAid
            where FTid = #form.FTid#
        </cfquery>
	</cfif>
</cfif>

<cfquery name="rsTiposTram" datasource="#Session.DSN#" >
    Select *, TTcodigo #_Cat# ' - ' #_Cat# TTdescripcion  as TTdescrip
    from FTTipoTramite
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        order by TTcodigo #_Cat# ' - ' #_Cat# TTdescripcion asc
</cfquery>



<cfquery name="rsEstados" datasource="#Session.DSN#" >
	Select *,  ETcodigo #_Cat# ' - ' #_Cat# ETdescripcion  as ETdescrip
	from FTEstadoTramite
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by ETcodigo #_Cat# ' - ' #_Cat# ETdescripcion asc
</cfquery>


<cfquery name="rsTiposAut" datasource="#session.DSN#">
    select 
        TAid	
        ,TAcodigo	
        ,TAdescripcion	
        ,TAcodigo #_Cat# ' - ' #_Cat# TAdescripcion  as TAdescrip
        ,TAmontomin	
        ,TAmontomax	
        ,Ecodigo	
        ,Usucodigo	   
    from FTTipoAutorizador
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	    order by TAcodigo #_Cat# ' - ' #_Cat# TAdescripcion 
</cfquery>

<cfoutput>
<form action="FlujoTramitesSQL.cfm" method="post" name="form">
	<input name="FTid" type="hidden" value="<cfif isdefined('rsFTramites')> <cfoutput>#rsFTramites.FTid#</cfoutput></cfif>"> 

	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
        <tr> 
            <td align="right" nowrap="nowrap">&nbsp;<strong><cf_translate key="LB_TipoTram">Tipo Tr&aacute;mite</cf_translate>:</strong>&nbsp;</td>
            <td>
                <select name="TTid"  > 
                    <option  title="" value=" "> -- Seleccione un Tipo-- </option>
                    <cfloop query="rsTiposTram">
                        <option  title="#rsTiposTram.TTid#" value="#rsTiposTram.TTid#" <cfif modo neq "ALTA" and isdefined('rsFTramites') and rsFTramites.TTid eq rsTiposTram.TTid>selected<cfelseif modo eq 'ALTA' >selected</cfif>>#rsTiposTram.TTdescrip#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        
        <tr> 
            <td align="right" nowrap="nowrap">&nbsp;<strong><cf_translate key="LB_EstadoTram">Estado Tr&aacute;mite</cf_translate>:</strong>&nbsp;</td>
            <td>
                <select name="ETid"  > 
                    <option  title="" value=" "> -- Seleccione un Tipo-- </option>
                    <cfloop query="rsEstados">
                        <option  title="#rsEstados.ETid#" value="#rsEstados.ETid#" <cfif modo neq "ALTA" and isdefined('rsFTramites') and rsFTramites.ETid eq rsEstados.ETid>selected<cfelseif modo eq 'ALTA' >selected</cfif>>#rsEstados.ETdescrip#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
        	<td align="right" nowrap>&nbsp;<strong><cf_translate key="LB_Orden">Paso Actual</cf_translate>:</strong></td>
        	<td>
				<cf_inputNumber name="FTpasoactual" value="#lvFTpasoactual#" enteros="5" decimales="0" negativos="false" comas="no" >
            </td>
        </tr>
        
        <tr>
        	<td align="right" nowrap>&nbsp;<strong><cf_translate key="LB_Orden">Aprueba Siguiente Paso</cf_translate>:</strong>&nbsp;</td>
        	<td>
				<cf_inputNumber name="FTpasoaprueba" value="#lvFTpasoaprueba#" enteros="5" decimales="0" negativos="false" comas="no" >
            </td>
        </tr>
        
        <tr>
        	<td align="right" nowrap>&nbsp;<strong><cf_translate key="LB_Orden">Rechaza siguiente paso</cf_translate>:</strong>&nbsp;</td>
        	<td>
				<cf_inputNumber name="FTpasorechaza" value="#lvFTpasorechaza#" enteros="5" decimales="0" negativos="false" comas="no" >
            </td>
        </tr>
        
**********************************

        <tr>
            <td align="right">
            
                <input type="checkbox" id="FTautoriza" name="FTautoriza"   onchange="javascript:motrarFTautoriza(this.checked);"  
                    <cfif modo neq 'ALTA_C' and isdefined("rsFTramites") and rsFTramites.FTautoriza eq 1 >checked="checked"</cfif> >
            </td>
            <td>
                &nbsp;&nbsp;&nbsp;
                <label for="CKFTautoriza"><cf_translate key="CKFTautoriza">Autorizadores</cf_translate></label>
            </td>
        </tr>
        
    
        <tr id="TR_Autorizadores" style=" display:'none'">
            <td colspan="3">
                <table align="center" border="0" >
                   <tr> 
                        <td align="right" nowrap="nowrap">&nbsp;<strong><cf_translate key="LB_TiposAut">Tipo Autorizador</cf_translate>:</strong>&nbsp;</td>
                        <td>
                            <select name="TAid"  > 
                                <option  title="" value=" "> -- Seleccione un Tipo-- </option>
                                <cfloop query="rsTiposAut">
                                    <option  title="#rsTiposAut.TAid#" value="#rsTiposAut.TAid#" >#rsTiposAut.TAdescrip#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                   
                    <tr>
                        <td align="center" colspan="3">
                            <cf_botones modo="ALTA" sufijo="DFlujo" exclude= "Baja,Nuevo,Limpiar" functions="javascript: return validaAutorizador();">	
                        </td>
                    </tr>
                    <cfif isdefined('rsAutorizadores') and rsAutorizadores.RecordCount gt 0 >
                    <tr>
                        <td align="center" colspan="2">
                            <!--- Lista --->
                            <table border="0" width="100%" align="center">
                                <tr><td width="10%">C&oacute;digo</td><td width="50%">Descripci&oacute;n</td>
                                </tr>
                                <cfloop query="rsAutorizadores">
                                    <tr <cfif CurrentRow MOD 2> 
                                            class="listaPar"<cfelse>class="listaNon"</cfif>>
                                        <td>#TAcodigo#</td>
                                        <td>
                                            <!---<a href="" onClick="javascript: return false;" 
                                               title="#Vdescripcion#"> </a>--->
                                               <cfif Len(Trim(TAdescripcion)) LT 20>
                                                    #TAdescripcion#<cfelse>#Mid(TAdescripcion,1,18)#...
                                               </cfif>
                                            
                                        </td>
                                        <td colspan="3" align="center">
                                            <input name="btnBorrarAutorizador" type="image" alt="Eliminar elemento" onClick="javascript: return BorrarAutorizador(#FTDid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
                                        </td>
                                    </tr>
                                </cfloop>
                                <input type="hidden" name="FTDid_" value="">
                            </table>
                        </td>
                    </tr>
                    </cfif>
                </table>
            </td> 
        </tr>	
**********************************
		<tr valign="baseline"> 
			<td colspan="5" align="center" nowrap>
				<cfset tabindex=5>
				<cfinclude template="../../rh/portlets/pBotones.cfm">
			</td>
		</tr>

	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">

	function motrarFTautoriza(opcion){
		var TR_Autorizador	 = document.getElementById("TR_Autorizadores");
		
		if (opcion){
			TR_Autorizador.style.display = "";
		}
		else {
			TR_Autorizador.style.display = "none";
		}
	}

	<cfif isdefined('rsFTramites') >
		motrarFTautoriza(<cfoutput>#rsFTramites.FTautoriza#</cfoutput>);
	<cfelse>
		motrarFTautoriza(0);
	</cfif>
	
	
	function BorrarAutorizador(id) 
	{
		if (confirm("Desea borrar Autorizador")) {
			var f = document.form;
			f.FTDid_.value = id;
			f.btnBorrarAutorizador.click()
			f.submit();
			return true;
		}
		return false;
	}
	function validaAutorizador() {
		if (trim(document.form.TAid.value) == "") 
		{
			alert('<cfoutput>Debe seleccionar un Autorizador</cfoutput>');
			return false;
		}
		return true;
	}
    
</script>    
    
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Codigo"/>
<!---<cf_qforms form="form">
	<cf_qformsRequiredField name="ETcodigo"  description="#MSG_Codigo#">
	<cf_qformsRequiredField name="ETdescripcion" description="#MSG_Descripcion#">
</cf_qforms>--->
</cfoutput>