<cfcomponent>
	<!---==================AGREGA UN TIPO DE DATO VARIABLE==================--->
	<cffunction name="ALTA"   access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 		  type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="DVetiqueta"     type="string"  required="true">
		<cfargument name="DVexplicacion"  type="string"  required="false" default="null">
		<cfargument name="DVtipoDato"     type="string"  required="true">
		<cfargument name="DVlongitud"     type="numeric" required="false" default="null">
		<cfargument name="DVdecimales"    type="numeric" required="false" default="null">
		<cfargument name="DVmascara"      type="string"  required="false" default="null">
		<cfargument name="DVobligatorio"  type="numeric" required="false" default="null">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
	
		<cfquery datasource="#Arguments.Conexion#" name="rsDVdatosVariables">
			insert into <cf_dbdatabase table="FTDatosVariables" datasource="ftec"> (
				Ecodigo,DVetiqueta,DVexplicacion,
				DVtipoDato,DVlongitud,DVdecimales,DVmascara,DVobligatorio,BMUsucodigo )
			values(
				#Arguments.Ecodigo#,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#TRIM(Arguments.DVetiqueta)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" 	value="#TRIM(Arguments.DVexplicacion)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#TRIM(Arguments.DVtipoDato)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.DVlongitud#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.DVdecimales#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#TRIM(Arguments.DVmascara)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.DVobligatorio#">,
				 #Arguments.BMUsucodigo#
			   )
			   <cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsDVdatosVariables">
			  <cfreturn #rsDVdatosVariables.identity#>
	</cffunction>
	<!---==================MODIFICAR UN TIPO DE DATO VARIABLE==================--->
	<cffunction name="CAMBIO" access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 		  type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="DVid" 		  type="numeric" required="true">
		<cfargument name="DVetiqueta"     type="string"  required="true">
		<cfargument name="DVtipoDato"     type="string"  required="true">
		<cfargument name="DVlongitud"     type="numeric" required="false" default="null">
		<cfargument name="DVdecimales"    type="numeric" required="false" default="null">
		<cfargument name="DVmascara"      type="string"  required="false" default="null">
		<cfargument name="DVobligatorio"  type="numeric" required="false" default="null">
        <cfargument name="DVexplicacion"  type="string"  required="false" default="null">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">

		<cfquery datasource="#Arguments.Conexion#">	
			update <cf_dbdatabase table="FTDatosVariables" datasource="ftec"> set 
				DVetiqueta	  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#TRIM(Arguments.DVetiqueta)#">,
				DVtipoDato	  = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#TRIM(Arguments.DVtipoDato)#">,
				DVlongitud	  = <cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.DVlongitud#">,   
				DVdecimales   = <cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.DVdecimales#">,
				DVmascara	  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#TRIM(Arguments.DVmascara)#">,
				DVobligatorio = <cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.DVobligatorio#">,
                DVexplicacion = <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" 	value="#TRIM(Arguments.DVexplicacion)#">,
				BMUsucodigo	  = #Arguments.BMUsucodigo#
			where DVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">
		</cfquery>
	</cffunction>
	<!---==================ELIMINAR UN TIPO DE DATO VARIABLE==================--->
	<cffunction name="BAJA"  access="public" returntype="string">
		<cfargument name="Conexion" 	type="string"  required="false" default="#session.dsn#">
		<cfargument name="DVid" 		type="numeric" required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			delete from <cf_dbdatabase table="FTDatosVariables" datasource="ftec"> 
			where DVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">
		</cfquery>
	</cffunction>
	<!---==================AGREGAR UN DALOR DE LA LISTA DE DATOS VARIABLES==================--->
	<cffunction name="ALTALISTA"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="DVid" 		  type="numeric" required="true">
		<cfargument name="DVLcodigo" 	  type="string"  required="true">
		<cfargument name="DVLdescripcion" type="string"  required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			insert into <cf_dbdatabase table="FTListaValores" datasource="ftec">
             (DVid,DVLcodigo,DVLdescripcion,BMUsucodigo)
			values(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVLcodigo)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVLdescripcion)#">,
				#Arguments.BMUsucodigo#
				)
		</cfquery>
	</cffunction>
	<!---==================BORRAR UN DALOR DE LA LISTA DE DATOS VARIABLES==================--->
	<cffunction name="BAJALISTA"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="DVid" 		  type="numeric" required="true">
		<cfargument name="DVLcodigo" 	  type="string"  required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			delete from <cf_dbdatabase table="FTListaValores" datasource="ftec"> 
			where DVid       = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">
			   and DVLcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DVLcodigo#">
		</cfquery>
	</cffunction>
	<!---==================MODIFICAR UN DALOR DE LA LISTA DE DATOS VARIABLES==================--->
	<cffunction name="CAMBIOLISTA"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="DVid" 		  type="numeric" required="true">
		<cfargument name="DVLcodigo" 	  type="string"  required="true">
		<cfargument name="DVLdescripcion" type="string"  required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			update <cf_dbdatabase table="FTListaValores" datasource="ftec"> 
			set DVLdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVLdescripcion)#">
			where DVid       = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">
			   and DVLcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DVLcodigo#">
		</cfquery>
	</cffunction>
	<!---==================AGREGAR UN CONFIGURACIÓN DE DATOS VARIABLES==================--->
	<cffunction name="ALTAConfig"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"   required="false" default="#session.dsn#">
		<cfargument name="BMUsucodigo"    type="numeric"  required="false" default="#Session.Usucodigo#">
		<cfargument name="DVTcodigo" 	  type="string"   required="true">
		<cfargument name="DVid" 	  	  type="numeric"  required="false" default="-1">
		<cfargument name="TEVid" 	  	  type="numeric"  required="false" default="-1">
		<cfargument name="DVCidTablaCnf"  type="numeric"  required="false" default="-1">
		
		<cfif #Arguments.DVCidTablaCnf# EQ -1><cfset Arguments.DVCidTablaCnf = "null"></cfif>
		<cfif #Arguments.DVid# EQ -1><cfset Arguments.DVid = "null"></cfif>
		<cfif #Arguments.TEVid# EQ -1><cfset Arguments.TEVid = "null"></cfif>
		
		<cfquery datasource="#Arguments.Conexion#">	
			insert into DVconfiguracionTipo (DVTcodigoValor,DVTcodigo,DVid,TEVid,DVCidTablaCnf,BMUsucodigo)
			select DVTcodigoValor,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVTcodigo)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVCidTablaCnf#">,
				#Arguments.BMUsucodigo#
			from DVtipificacion
			where DVTcodigo = '#TRIM(Arguments.DVTcodigo)#'
		</cfquery>
	</cffunction>
	<!---==================ELIMINAR UNA CONFIGURACIÓN DE DATOS VARIABLES==================--->
	<cffunction name="BAJAConfig"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"   required="false" default="#session.dsn#">
		<cfargument name="BMUsucodigo"    type="numeric"  required="false" default="#Session.Usucodigo#">
		<cfargument name="DVTcodigo" 	  type="string"   required="true">
		<cfargument name="DVid" 	  	  type="numeric"  required="false" default="-1">
		<cfargument name="TEVid" 	  	  type="numeric"  required="false" default="-1">
		<cfargument name="DVCidTablaCnf"  type="numeric"  required="false" default="-1">
		<cfif (Arguments.DVid EQ -1 AND Arguments.TEVid EQ -1) OR (Arguments.DVid NEQ -1 AND Arguments.TEVid NEQ -1)>
			<cfthrow message="Error en la invocación de DatosVaribles.BAJAConfig, se debe enviar el dato Variable o el Evento">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">	
			Delete from DVconfiguracionTipo 
			 where DVTcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVTcodigo)#">
			 <cfif Arguments.DVid NEQ -1>
			   and DVid      = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">
			<cfelse>
			   and TEVid     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#">
			</cfif>
			 <cfif #Arguments.DVCidTablaCnf# EQ -1>
			   and DVCidTablaCnf  is null
			 <cfelse>
			   and DVCidTablaCnf = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVCidTablaCnf#">
			 </cfif>
		</cfquery>
	</cffunction>
	<!---==================PINTA UN DATO VARIABLES==================--->
	<cffunction name="PrintDatoVariable"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	  type="string"   required="false" default="#session.dsn#">
		<cfargument name="DVTcodigoValor" type="string"   required="true">
		<cfargument name="Tipificacion"   type="struct"   required="true">
		<cfargument name="NumeroColumas"  type="numeric"  required="false" default="1">
		<cfargument name="form" 		  type="string"   required="false" default="form1">
		<cfargument name="DVVidTablaVal"  type="numeric"  required="true">
		<cfargument name="DVVidTablaSec"  type="numeric"  required="false" default="0"><!---0= tabla Final, cualquier otro son tablas de Trabajo--->
		<cfargument name="readonly" 	  type="boolean"  required="false" default="false">
		<cfargument name="ContenedorErrores" type="string" required="false" default=""> <!--- En caso de que se utilice parsley, se envia #NombreDiv donde se mostraran los mensajes, si no se indica, se muestran directamente despues del campo con error --->

		<cfif Arguments.NumeroColumas LTE 0>
			Error en la invocacion PrintDatoVariable, el atributo NumeroColumas debe ser mayor a 0
			<cf_abort errorInterfaz="Error en la invocacion PrintDatoVariable, el atributo NumeroColumas debe ser mayor a 0">
		</cfif>
		
		<cfset DatoVariable= GETVALOR(Arguments.Conexion,Arguments.DVTcodigoValor,Arguments.Tipificacion,Arguments.DVVidTablaVal,Arguments.DVVidTablaSec)>
		<cfset CurrentColumn = 1>
		
		<cfparam name="Request.jsMask" default="false">

		<cfif Request.jsMask EQ false>
			<cfset Request.jsMask = true>
			<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
			<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
			<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
		</cfif>

		<!----------------------------------------------------------------------------------------->
		<!---                          SCRIPT PARA VALIDACIONES ----------------------------------->
		<!----------------------------------------------------------------------------------------->
		<!--- para que las validaciones funcionen correctamente, se debio haber insertado la libreria
		de JQuery y parsley en alguna pagina padre que invoque al componente --->
		<!--- se agregaron atributos class y obligatorio, en documento-form se agregan las validaciones
		con jquery --->
		
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
		   <tr>
		<cfloop query="DatoVariable">
				<cfset name="#DatoVariable.DVTcodigoValor#_#DatoVariable.DVid#">
			  <td><cfoutput><strong><div name="#name#_label" align="right">#DatoVariable.DVetiqueta#</label>:&nbsp;</strong></cfoutput></td>
			  <td>
			  	 <!---Tipo Listas--->
				 <cfif DatoVariable.DVtipoDato EQ 'L'>
				 	<cfquery name="ValorDatoVariable" datasource="#Arguments.Conexion#">	
						select rtrim(DVLcodigo) DVLcodigo, rtrim(DVLdescripcion) DVLdescripcion 
                        	from DVlistaValores 
                            	where DVid = #DatoVariable.DVid#
                                <!---and DVLcodigo = '#DatoVariable.DVVvalor#'--->
					</cfquery>
					<cfif Arguments.readonly>
                    	<cfloop query="ValorDatoVariable">
							<cfif ValorDatoVariable.DVLcodigo EQ DatoVariable.DVVvalor>
                                <cfoutput><!---#DatoVariable.DVVvalor#---->#ValorDatoVariable.DVLdescripcion#</cfoutput>
                            </cfif>
                        </cfloop>
					<cfelse>
						<select name="<cfoutput>#name#</cfoutput>" class="datoVariableLista" obligatorio="<cfoutput>#DatoVariable.DVobligatorio#</cfoutput>">
							<cfif DatoVariable.DVobligatorio EQ 0>
								<option value="">--Ninguno--</option>
							</cfif>
							<cfloop query="ValorDatoVariable">
								<option value="<cfoutput>#ValorDatoVariable.DVLcodigo#</cfoutput>" <cfif ValorDatoVariable.DVLcodigo EQ DatoVariable.DVVvalor>selected="true"</cfif>><cfoutput>#ValorDatoVariable.DVLdescripcion#</cfoutput></option>
							</cfloop>
						</select>
					</cfif>
				 <!---Tipo Calendario--->
				 <cfelseif DatoVariable.DVtipoDato EQ 'F'>
				 	<cfif Arguments.readonly>
						<cf_sifcalendario form="#Arguments.form#" value="#DatoVariable.DVVvalor#" name="#name#" readOnly="true" class="datoVariableCalendario" obligatorio="#DatoVariable.DVobligatorio#">
					<cfelse>
				 		<cf_sifcalendario form="#Arguments.form#" value="#DatoVariable.DVVvalor#" name="#name#"  class="datoVariableCalendario" obligatorio="#DatoVariable.DVobligatorio#">
					</cfif>
				 <!---Tipo Combo--->
				 <cfelseif DatoVariable.DVtipoDato EQ 'K'>
				 	<cfif Arguments.readonly>
						<cfif #DatoVariable.DVVvalor# EQ 1>
							<img border=0 src=/cfmx/sif/imagenes/checked.gif>
						<cfelse>
							<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>
						</cfif>						
					<cfelse>
				 		<input type="checkbox" name="<cfoutput>#name#</cfoutput>" value="1" <cfif #DatoVariable.DVVvalor# EQ 1>checked="true" </cfif>
							<!--- NO lleva validacion --->
						/>					
					</cfif>
				<!---Tipo Caracter--->
				<cfelseif DatoVariable.DVtipoDato EQ 'C'>
					<cfif Arguments.readonly>
						<cfoutput>#DatoVariable.DVVvalor#</cfoutput>
					<cfelse>
						<input type="text" size="100" maxlength="100" name="<cfoutput>#name#</cfoutput>" value="<cfoutput>#DatoVariable.DVVvalor#</cfoutput>"
						 class="datoVariableCaracter"
						 obligatorio="<cfoutput>#DatoVariable.DVobligatorio#</cfoutput>"
						><cfoutput>#DatoVariable.DVmascara#</cfoutput>
						<cfif LEN(TRIM(DatoVariable.DVmascara))>
							<script language="JavaScript" type="text/javascript">
								<cfoutput>
									<cfset varMask_= #Replace(DatoVariable.DVmascara,'X','x','ALL')#>
									<cfset varMask_= #Replace(varMask_,'?','##','ALL')#>
									var Mask_1 = new Mask("#varMask_#", "string");
									Mask_1.attach(document.#Arguments.form#.#name#, Mask_1.mask, "string");
								</cfoutput>
							</script>
						</cfif>
					</cfif>
				<!---Tipo Numerico--->
				<cfelseif DatoVariable.DVtipoDato EQ 'N'>
					<cfif Arguments.readonly>
						<cfoutput>#DatoVariable.DVVvalor#</cfoutput>
					<cfelse>
                    	<cfif len(trim(#DatoVariable.DVVvalor#)) eq 0>
                        	<cfset DatoVariable.DVVvalor= 0>
                        </cfif>
						<cf_monto name="#name#" decimales="#DatoVariable.DVdecimales#" value="#lsparsenumber(DatoVariable.DVVvalor)#" size="#DatoVariable.DVlongitud#" form="#Arguments.form#" class="datoVariableNumerico"  obligatorio="#DatoVariable.DVobligatorio#">
					</cfif>
				<!---Tipo Hora--->
				<cfelseif DatoVariable.DVtipoDato EQ 'H'>
					<cfif Arguments.readonly>
						<cf_hora name="#name#"  value="#DatoVariable.DVVvalor#" form="#Arguments.form#" readOnly="true" class="datoVariableHora"  obligatorio="#DatoVariable.DVobligatorio#">
					<cfelse>
						<cf_hora name="#name#"  value="#DatoVariable.DVVvalor#" form="#Arguments.form#" class="datoVariableHora"  obligatorio="#DatoVariable.DVobligatorio#" size="100">
					</cfif>
				 <cfelse>
				 	Error en la invocacion PrintDatoVariable, el Tipo de dato <cfoutput><strong>#DatoVariable.DVtipoDato#</strong></cfoutput> no esta implementado
				 </cfif>
			  </td>
			
			   <!---<cfif CurrentColumn EQ Arguments.NumeroColumas>
				   <cfset CurrentColumn = 0>--->
				   </tr><tr>
			  <!--- </cfif> 
			   <cfset CurrentColumn = CurrentColumn +1>--->
		</tr></cfloop>
		
		</table>
		<cfreturn DatoVariable.RecordCount>
	</cffunction>
	<!---QformDatoVariable= valida los campos requeridos. Debe invocarse Fuera del Form--->
	<cffunction name="QformDatoVariable"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"   required="false" default="#session.dsn#">
		<cfargument name="DVTcodigoValor" type="string"   required="true">
		<cfargument name="Tipificacion"   type="struct"   required="true">
		<cfargument name="form" 		  type="string"   required="false" default="form1">
		<cfargument name="DVVidTablaVal"  type="numeric"  required="true">
		<cfargument name="DVVidTablaSec"  type="numeric"  required="false" default="0"><!---0= tabla Final, cualquier otro son tablas de Trabajo--->
		<cfargument name="objForm"  	  type="string"   required="false" default="DatosVariables">
	
		<cfset DatoVariable= GETVALOR(Arguments.Conexion,Arguments.DVTcodigoValor,Arguments.Tipificacion,Arguments.DVVidTablaVal, Arguments.DVVidTablaSec)>
			<cf_qforms form ="#Arguments.form#" objForm= '#Arguments.objForm#'>
			<cfloop query="DatoVariable">
				<cfif DatoVariable.DVobligatorio EQ 1>
					<cfset name="#DatoVariable.DVTcodigoValor#_#DatoVariable.DVid#">
					<cf_qformsRequiredField name="#name#" description="#DatoVariable.DVdescripcion#">
				</cfif>
			</cfloop>
			</cf_qforms>
	</cffunction>
	
	<!---==================AGREGAR UN VALOR DEL DATO VARIABLE==================--->
	<cffunction name="SETVALOR"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="DVTcodigoValor" type="string"  required="true">
		<cfargument name="DVid" 	  	  type="numeric" required="true">
		<cfargument name="DVVidTablaVal"  type="numeric" required="true">
		<cfargument name="DVVidTablaSec"  type="numeric" required="false" default="0"><!---0= tabla Final, cualquier otro son tablas de Trabajo--->
		
		<cfquery name="valores" datasource="#Arguments.Conexion#">	
			select count(1) cantidad  from DVvalores 
			 where rtrim(DVTcodigoValor) = '#Arguments.DVTcodigoValor#' 
			   and DVid                  = #Arguments.DVid#
			   and DVVidTablaVal         = #Arguments.DVVidTablaVal#
		 	  and DVVidTablaSec			 = #Arguments.DVVidTablaSec#
		</cfquery>
		<cfif valores.cantidad>
			<cfquery datasource="#Arguments.Conexion#">	
			   update DVvalores set 
				 DVVvalor 	  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVVvalor)#">,
				 BMUsucodigo  = #Arguments.BMUsucodigo#
			  where rtrim(DVTcodigoValor) = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVTcodigoValor)#">
			    and DVid 		          = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#TRIM(Arguments.DVid)#">
			    and DVVidTablaVal         = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#TRIM(Arguments.DVVidTablaVal)#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">	
				insert into DVvalores (DVTcodigoValor,DVid,DVVidTablaVal,DVVidTablaSec,DVVvalor,BMUsucodigo)
				values(
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVTcodigoValor)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#TRIM(Arguments.DVid)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#TRIM(Arguments.DVVidTablaVal)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#TRIM(Arguments.DVVidTablaSec)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVVvalor)#">,
					#Arguments.BMUsucodigo#
					 )
			</cfquery>
		</cfif>
	</cffunction>
	<!---==================Obteniene todos los campos que correspondientes a estructura enviada==================--->
	<cffunction name="GETVALOR"  access="public" returntype="query">
		<cfargument name="Conexion" 	  	 type="string"   required="false" default="#session.dsn#">
		<cfargument name="DVTcodigoValor" type="string"   required="true">
		<cfargument name="Tipificacion"   type="struct"   required="true">
		<cfargument name="DVVidTablaVal"  type="numeric"  required="true">
		<cfargument name="DVVidTablaSec"  type="numeric"  required="false" default="0"><!---0= tabla Final, cualquier otro son tablas de Trabajo--->
		<cfargument name="EsEvento"  	  	 type="boolean"  required="false" default="false">
		<cfargument name="FunctionDelete" type="string"   required="false" default="FunctionDelete">
		<cfargument name="DVidname" 		 type="string"   required="false" default="DVid">
		
		<cfquery name="DVtipificacion" datasource="#Arguments.Conexion#">	
			select rtrim(DVTcodigo) DVTcodigo from DVtipificacion where DVTcodigoValor = '#Arguments.DVTcodigoValor#'
		</cfquery>
		<cfif DVtipificacion.recordCount EQ 0>
			Error en la invocacion del componente DatosVariables.GETVALOR, no se encontrol el parametro Tipificacion '<cfoutput>#Arguments.DVTcodigoValor#</cfoutput>' 
			<cf_abort errorInterfaz="Error en la invocación del componente DatosVariables.GETVALOR, no se encontró el parametro Tipificación '#Arguments.DVTcodigoValor#'">
		</cfif>
		<cfloop query="DVtipificacion">
			<cfif not StructKeyExists(#Arguments.Tipificacion#,#DVtipificacion.DVTcodigo#)>
				Error en la invocacion del componente DatosVariables.GETVALOR, no se envio en el parametro Tipificacion '<cfoutput>#DVtipificacion.DVTcodigo#</cfoutput>' 
				<cf_abort errorInterfaz="Error en la invocación del componente DatosVariables.GETVALOR, no se envio en el parametro Tipificación '#DVtipificacion.DVTcodigo#' ">
			</cfif>
		</cfloop>
		
		<cfset borrar 	 = "<input name=''imageField'' type=''image'' src=''../../imagenes/Borrar01_S.gif' width=''16'' height=''16'' border=''0'' onclick=''javascript:#Arguments.FunctionDelete#();''>">
		
		<cfif not EsEvento>
			<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
			<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >

			<cfset Columns = "DVE.DVetiqueta,DVE.DVtipoDato,rtrim(conf.DVTcodigoValor) DVTcodigoValor,rtrim(conf.DVTcodigo) DVTcodigo, DVE.DVid #Arguments.DVidname#, DVobligatorio, 
			       			  rtrim(val.DVVvalor) DVVvalor, DVlongitud, DVdecimales, DVmascara, DVdescripcion,DVcodigo,
								  case when  DVtipoDato = 'C'  then 'Caracter' 
                 				when  DVtipoDato = 'N' then 'Numerico' 
                         	when  DVtipoDato = 'L' then 'Lista' 
                         	when  DVtipoDato = 'F' then 'Fecha' 
                         	when  DVtipoDato = 'H' then 'Hora' 
                         	when  DVtipoDato = 'K' then 'Logico' 
                         	else 'otro' end as DVtipoDatoLabel,
									case when DVobligatorio = 0 then '#unchecked#' else '#checked#' end as DVobligatorioLabel                                                   
">
			<cfset othertables = "inner join DVdatosVariables DVE
						            on DVE.DVid = conf.DVid
					             left outer join DVvalores val
						            on val.DVTcodigoValor  = conf.DVTcodigoValor
							       and val.DVid            = conf.DVid
						           and val.DVVidTablaVal   = #Arguments.DVVidTablaVal#
						           and val.DVVidTablaSec   = #Arguments.DVVidTablaSec#">
            <cfset orden = "DVE.DVid, conf.DVCid">                       
		<cfelse>
			<cfset Columns = "DVE.TEVid,DVE.TEVcodigo,DVE.TEVDescripcion,DVE.DVobligatorio">
			<cfset othertables  = "inner join TipoEvento DVE
									on conf.TEVid = DVE.TEVid
								  left outer join DVvalores val
						             on val.DVTcodigoValor  = conf.DVTcodigoValor
							        and val.DVid            = conf.DVid
						            and val.DVVidTablaVal   = #Arguments.DVVidTablaVal#
						            and val.DVVidTablaSec   = #Arguments.DVVidTablaSec#">
			<cfset orden = "DVE.TEVid"> 
        </cfif>
		<cfquery name="DatoVariable" datasource="#Arguments.Conexion#">	
			select '#borrar#' borrar,#preservesinglequotes(Columns)# from DVconfiguracionTipo conf #othertables#
			where 
			<cfloop query="DVtipificacion">
				<cfif DVtipificacion.currentrow NEQ 1>
					or
				</cfif>
				(conf.DVTcodigoValor 	= '#Arguments.DVTcodigoValor#'
				and conf.DVTcodigo		= '#DVtipificacion.DVTcodigo#'
				<cfif len(trim(#Arguments.Tipificacion['#DVtipificacion.DVTcodigo#']#))>
					and conf.DVCidTablaCnf	= #Arguments.Tipificacion['#DVtipificacion.DVTcodigo#']#
				<cfelse>
					and conf.DVCidTablaCnf is null
				</cfif>
				)	
			</cfloop>
            order by conf.DVCid
		</cfquery>
		<cfreturn #DatoVariable#>
	</cffunction>
	<!---==================Copiar todos los valores de V. variables y crea nuevos==================--->
	<cffunction name="COPIARVALOR"  access="public">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">		
		<cfargument name="DVTcodigoValor" type="string"   required="true">
		<cfargument name="DVVidTablaVal"  type="numeric" required="true">
		<cfargument name="DVVidTablaSec"  type="numeric" required="false" default="1">
		
		<cfargument name="DVVidTablaVal_new"  type="numeric" required="true">
		<cfargument name="DVVidTablaSec_new"  type="numeric" required="false" default="0">
		
		<cfargument name="delete_OLD" 		  type="boolean" required="false" default="false">
		
		<cfquery datasource="#Arguments.Conexion#">	
			insert into DVvalores(DVTcodigoValor,DVid,DVVidTablaVal,DVVidTablaSec,DVVvalor,BMUsucodigo)
			select 
				DVTcodigoValor,
				DVid,
				#Arguments.DVVidTablaVal_new#,
				#Arguments.DVVidTablaSec_new#,
				DVVvalor,
				#Arguments.BMUsucodigo#
			from DVvalores
			where DVTcodigoValor = '#Arguments.DVTcodigoValor#'
			  and DVVidTablaVal  = #Arguments.DVVidTablaVal#
			  and DVVidTablaSec  = #Arguments.DVVidTablaSec#
		</cfquery>
		<cfif Arguments.delete_OLD>
			<cfset a = BAJAVALOR(#Arguments.Conexion#,#Arguments.BMUsucodigo#,#Arguments.DVTcodigoValor#,#Arguments.DVVidTablaVal#,#Arguments.DVVidTablaSec#)>
		</cfif>
	</cffunction>
	<!---==================Elimina todos los valores de V. variables para un tipo de tabla dado y un Identity==================--->
	<cffunction name="BAJAVALOR"  access="public">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">		
		<cfargument name="DVTcodigoValor" type="string"   required="true">
		<cfargument name="DVVidTablaVal"  type="numeric" required="true">
		<cfargument name="DVVidTablaSec"  type="numeric" required="false" default="1">	
		
		<cfquery datasource="#Arguments.Conexion#">	
			delete from DVvalores
				where DVTcodigoValor = '#Arguments.DVTcodigoValor#'
				  and DVVidTablaVal  = #Arguments.DVVidTablaVal#
				  and DVVidTablaSec  = #Arguments.DVVidTablaSec#
		</cfquery>
	</cffunction>
</cfcomponent>
