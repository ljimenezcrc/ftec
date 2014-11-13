<cfcomponent>
	<!---==================AGREGA UN TIPO DE DATO VARIABLE==================--->
	<cffunction name="ALTA"   access="public" returntype="string" hint="AGREGA UN TIPO DE DATO VARIABLE">
		<cfargument name="Conexion" 	  type="string"  required="false" default="ftec">
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
			insert into FTDatosVariables (
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
	<cffunction name="CAMBIO" access="public" returntype="string" hint="MODIFICAR UN TIPO DE DATO VARIABLE">
		<cfargument name="Conexion" 	  type="string"  required="false" default="ftec">
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
			update FTDatosVariables set 
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
	<cffunction name="BAJA"  access="public" returntype="string" hint="ELIMINAR UN TIPO DE DATO VARIABLE">
		<cfargument name="Conexion" 	type="string"  required="false" default="ftec">
		<cfargument name="DVid" 		type="numeric" required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			delete from FTDatosVariables
			where DVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">
		</cfquery>
	</cffunction>
	<!---==================AGREGAR UN DALOR DE LA LISTA DE DATOS VARIABLES==================--->
	<cffunction name="ALTALISTA"  access="public" returntype="string" hint="AGREGAR UN DALOR DE LA LISTA DE DATOS VARIABLES">
		<cfargument name="Conexion" 	  type="string"  required="false" default="ftec">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="DVid" 		  type="numeric" required="true">
		<cfargument name="DVLcodigo" 	  type="string"  required="true">
		<cfargument name="DVLdescripcion" type="string"  required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			insert into FTListaValores
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
	<cffunction name="BAJALISTA"  access="public" returntype="string" hint="BORRAR UN DALOR DE LA LISTA DE DATOS VARIABLES">
		<cfargument name="Conexion" 	  type="string"  required="false" default="ftec">
		<cfargument name="DVid" 		  type="numeric" required="true">
		<cfargument name="DVLcodigo" 	  type="string"  required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			delete from FTListaValores
			where DVid       = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">
			   and DVLcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DVLcodigo#">
		</cfquery>
	</cffunction>
	<!---==================MODIFICAR UN DALOR DE LA LISTA DE DATOS VARIABLES==================--->
	<cffunction name="CAMBIOLISTA"  access="public" returntype="string" hint="MODIFICAR UN DALOR DE LA LISTA DE DATOS VARIABLES">
		<cfargument name="Conexion" 	  type="string"  required="false" default="ftec">
		<cfargument name="DVid" 		  type="numeric" required="true">
		<cfargument name="DVLcodigo" 	  type="string"  required="true">
		<cfargument name="DVLdescripcion" type="string"  required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			update FTListaValores
			set DVLdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.DVLdescripcion)#">
			where DVid       = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DVid#">
			   and DVLcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DVLcodigo#">
		</cfquery>
	</cffunction>
	
	
	<!---==================PINTA UN DATO VARIABLES==================--->
	<cffunction name="PrintDatoVariable"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	  type="string"   required="false" hint="Nombre del Datasource" default="ftec">
		<cfargument name="Tipo" 		  type="string"   required="true"  hint="C: Contratos" default="C"  >
		<cfargument name="ID_Table"   	  type="numeric"  required="true"  hint="ID del proceso. Contratos: FTPContratacion.PCid">
		<cfargument name="ID_Tipo"   	  type="numeric"  required="true"  hint="ID del Tipo.    Contratos: FTContratos.Cid">
		<cfargument name="NumeroColumas"  type="numeric"  required="false" default="1" hint="Numero de columnas en que se mostran los datos Variables">
		<cfargument name="form" 		  type="string"   required="false" default="form1">
		<cfargument name="Refresh" 		  type="boolean"  required="false" default="true">
		
		<cfargument name="readonly" 	  type="boolean"  required="false" default="false">
		<cfargument name="ContenedorErrores" type="string" required="false" default=""> <!--- En caso de que se utilice parsley, se envia #NombreDiv donde se mostraran los mensajes, si no se indica, se muestran directamente despues del campo con error --->
		
		<!---Valida la cantidad de columnas--->
		<cfif Arguments.NumeroColumas LTE 0>
			Error en la invocacion PrintDatoVariable, el atributo NumeroColumas debe ser mayor a 0<cfreturn>
		</cfif>
		<!---Valida el tipo de contrato--->
		<cfif NOT ListFind('C',Arguments.Tipo)>
			Error en la invocacion PrintDatoVariable, el tipo de Dato variable no esta implementada<cfreturn>
		</cfif>
		<cfif Arguments.Refresh>
		<!---Elimina los Datos Variables que no deben estar--->
			<cfquery name="ValorDatoVariable" datasource="#Arguments.Conexion#">
				delete from FTPDContratacion
				where PCid = #Arguments.ID_Table#
				and (select Count(1)
						from FTContratos a
						  inner join FTSecciones b
							on b.Cid = a.Cid
						  inner join FTSeccionesD c
							on c.Sid = b.Sid
						  inner join FTDatosVariables d 
							on d.DVid = c.DVid
						 where a.Cid = #Arguments.ID_Tipo#
							and c.SDid = FTPDContratacion.SDid
							and c.DVid = FTPDContratacion.DVid 
						) = 0
			</cfquery>
		<!---Se insertan los datos variables que no estaban--->
			<cfquery name="ValorDatoVariable" datasource="#Arguments.Conexion#">
				insert into FTPDContratacion(PCid,SDid,DVid,DVLcodigo,PCDValor)
				select  #Arguments.ID_Table#,c.SDid, c.DVid, null, null
				from FTContratos a
				  inner join FTSecciones b
					on b.Cid = a.Cid
				  inner join FTSeccionesD c
					on c.Sid = b.Sid
				  inner join FTDatosVariables d 
					on d.DVid = c.DVid
				 where a.Cid = #Arguments.ID_Tipo#
				  and (select Count(1) 
						from FTPDContratacion as a 
					  where a.PCid = #Arguments.ID_Table#
						and a.SDid = c.SDid) = 0
			</cfquery>
		</cfif>
		
		<cfset DatoVariable= GETVALOR(Arguments.Conexion, Arguments.Tipo, Arguments.ID_Table, Arguments.ID_Tipo)>
		<cfset CurrentColumn = 1>

	<div class="alert alert-info">
		<cfoutput query="DatoVariable" group="Sid">
			
			<hr>
			<cfoutput>
			<div class="row">
				<cfset name="V#DatoVariable.PCDid#">
				<label  style="text-align:right" class="col-sm-3">#DatoVariable.DVetiqueta#</label>				
			
			  	 <!---Tipo Listas--->
				 <cfif DatoVariable.DVtipoDato EQ 'L'>
				 	<cfquery name="ValorDatoVariable" datasource="#Arguments.Conexion#">	
						select rtrim(DVLcodigo) DVLcodigo, rtrim(DVLdescripcion) DVLdescripcion 
                        	from FTListaValores 
                            	where DVid = #DatoVariable.DVid#
					</cfquery>
					<cfif Arguments.readonly>
                    	<cfloop query="ValorDatoVariable">
							<cfif ValorDatoVariable.DVLcodigo EQ DatoVariable.PCDValor>
                                #ValorDatoVariable.DVLdescripcion#
                            </cfif>
                        </cfloop>
					<cfelse>
						 <div class="col-sm-4"> 
							<select name="#name#" class="datoVariableLista" obligatorio="#DatoVariable.DVobligatorio#">
								<cfif DatoVariable.DVobligatorio EQ 0>
									<option value="">--Ninguno--</option>
								</cfif>
								<cfloop query="ValorDatoVariable">
									<option value="#ValorDatoVariable.DVLcodigo#" <cfif ValorDatoVariable.DVLcodigo EQ DatoVariable.PCDValor>selected="true"</cfif>>#ValorDatoVariable.DVLdescripcion#</option>
								</cfloop>
							</select>
						  </div>
					</cfif>
				 <!---Tipo Calendario--->
				 <cfelseif DatoVariable.DVtipoDato EQ 'F'>
				 	<cfif isnumeric(DatoVariable.PCDValor) or NOT LEN(TRIM(DatoVariable.PCDValor)) EQ 10>
						<cfset DatoVariable.PCDValor = "">
					</cfif>
				 	 <div class="col-sm-4"> 
						<cfif Arguments.readonly>
							<cf_sifcalendario form="#Arguments.form#" value="#DatoVariable.PCDValor#" name="#name#" readOnly="true" class="datoVariableCalendario" obligatorio="#DatoVariable.DVobligatorio#">
						<cfelse>
							<cf_sifcalendario form="#Arguments.form#" value="#DatoVariable.PCDValor#" name="#name#"  class="datoVariableCalendario" obligatorio="#DatoVariable.DVobligatorio#">
						</cfif>
					</div>
				 <!---Tipo Combo--->
				 <cfelseif DatoVariable.DVtipoDato EQ 'K'>
				 	 <div class="col-sm-4"> 
						<cfif Arguments.readonly>
							<cfif DatoVariable.PCDValor EQ 1>
								<img border=0 src=/cfmx/sif/imagenes/checked.gif>
							<cfelse>
								<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>
							</cfif>						
						<cfelse>
							<!--- NO lleva validacion --->
							<input type="checkbox" name="#name#" value="1" <cfif DatoVariable.PCDValor EQ 1>checked="true" </cfif>/>					
						</cfif>
					</div>
				<!---Tipo Caracter--->
				<cfelseif DatoVariable.DVtipoDato EQ 'C'>
					 <div class="col-sm-4"> 
						<cfif Arguments.readonly>
							#DatoVariable.PCDValor#
						<cfelse>
							<input type="text" placeholder="#DatoVariable.DVetiqueta#" class="form-control" size="100" maxlength="100" name="#name#" value="#DatoVariable.PCDValor#"
							 class="datoVariableCaracter" obligatorio="#DatoVariable.DVobligatorio#">					
							<cfif LEN(TRIM(DatoVariable.DVmascara))>
								<script language="JavaScript" type="text/javascript">
										<cfset varMask_= #Replace(DatoVariable.DVmascara,'X','x','ALL')#>
										<cfset varMask_= #Replace(varMask_,'?','##','ALL')#>
										var Mask_1 = new Mask("#varMask_#", "string");
										Mask_1.attach(document.#Arguments.form#.#name#, Mask_1.mask, "string");
								</script>
							</cfif>
						</div>
					</cfif>
				<!---Tipo Caracter--->
				<cfelseif DatoVariable.DVtipoDato EQ 'V'>
					 <div class="col-sm-4"> 
						<cfif Arguments.readonly>
							#DatoVariable.PCDValor#
						<cfelse>
							<textarea placeholder="#DatoVariable.DVetiqueta#" class="form-control datoVariableCaracter" obligatorio="#DatoVariable.DVobligatorio#" name="#name#">#DatoVariable.PCDValor#</textarea>
						</cfif>
					</div>	
				<!---Tipo Numerico--->
				<cfelseif DatoVariable.DVtipoDato EQ 'N'>
					<div class="col-sm-4"> 
						<cfif Arguments.readonly>
							#DatoVariable.PCDValor#
						<cfelse>
							<cfif len(trim(DatoVariable.PCDValor)) eq 0 or NOT isnumeric(DatoVariable.PCDValor)>
								<cfset DatoVariable.PCDValor= 0>
							</cfif>
							<cf_monto name="#name#" decimales="#DatoVariable.DVdecimales#" value="#lsparsenumber(DatoVariable.PCDValor)#" size="#DatoVariable.DVlongitud#" form="#Arguments.form#" class="datoVariableNumerico"  obligatorio="#DatoVariable.DVobligatorio#">
						</cfif>
					</div>
				<!---Tipo Hora--->
				<cfelseif DatoVariable.DVtipoDato EQ 'H'>
					<div class="col-sm-4"> 
						<cfif Arguments.readonly>
							<cf_hora name="#name#"  value="#DatoVariable.PCDValor#" form="#Arguments.form#" readOnly="true" class="datoVariableHora"  obligatorio="#DatoVariable.DVobligatorio#">
						<cfelse>
							<cf_hora name="#name#"  value="#DatoVariable.PCDValor#" form="#Arguments.form#" class="datoVariableHora"  obligatorio="#DatoVariable.DVobligatorio#" size="100">
						</cfif>
					</div>
				 <cfelse>
				 	Error en la invocacion PrintDatoVariable, el Tipo de dato <strong>#DatoVariable.DVtipoDato#</strong> no esta implementado
				 </cfif>
			
			  </div>
			  
			</cfoutput>
		</cfoutput>
		</div>
		
		
		<cfreturn DatoVariable.RecordCount>
	</cffunction>
	<!---QformDatoVariable= valida los campos requeridos. Debe invocarse Fuera del Form--->
	<cffunction name="QformDatoVariable"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"   required="false" default="ftec">
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
		<cfargument name="Conexion" 	  type="string"  required="false" default="ftec">
		<cfargument name="form"    		  type="struct"  required="false">
		
		<cfquery name="valores" datasource="#Arguments.Conexion#">	
			select a.PCDid, a.PCid,a.SDid,a.DVid,a.DVLcodigo,a.PCDValor
			 from FTPDContratacion a
			where a.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.form.PCid#">
		</cfquery>
		
		<cfloop query="valores">
			<cfparam name="Arguments.form['V' & valores.PCDid]" default="">
			<cfquery datasource="#Arguments.Conexion#">	
				update FTPDContratacion
					set PCDValor = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.form['V' & valores.PCDid]#" voidnull>
				where PCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores.PCDid#">
			</cfquery>
		</cfloop>
	</cffunction>
	<!---==================Obteniene todos los campos que correspondientes a estructura enviada==================--->
	<cffunction name="GETVALOR"  access="public" returntype="query">
		<cfargument name="Conexion" 	  type="string"   required="false" hint="Nombre del Datasource" default="ftec">
		<cfargument name="Tipo" 		  type="string"   required="true"  hint="C: Contratos" default="C"  >
		<cfargument name="ID_Table"   	  type="numeric"  required="true"  hint="ID del proceso. Contratos: FTPContratacion.PCid">
		<cfargument name="ID_Tipo"   	  type="numeric"  required="true"  hint="ID del Tipo.    Contratos: FTContratos.Cid">		

		<cfquery name="DatoVariable" datasource="#Arguments.Conexion#">	
			select a.PCDid, a.PCid,c.Sid, a.SDid,a.DVid,a.DVLcodigo,a.PCDValor, b.Ecodigo,b.DVetiqueta,b.DVexplicacion,b.DVtipoDato,
				   b.DVlongitud,b.DVdecimales,b.DVmascara,b.DVobligatorio,b.BMUsucodigo
				from FTPDContratacion a
					inner join FTDatosVariables b
						on b.DVid = a.DVid
					inner join FTSeccionesD c
						on c.SDid = a.SDid
			where a.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID_Table#">
			order by c.Sid
		</cfquery>
		<cfreturn DatoVariable>
	</cffunction>

	<!---==================Elimina todos los valores de V. variables para un tipo de tabla dado y un Identity==================--->
	<cffunction name="BAJAVALOR"  access="public">
		<cfargument name="Conexion" 	  type="string"  required="false" default="ftec">
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

	<!---Funcion que retorna todos los Datos Variables--->
	<cffunction name="getFTDatosVariables"  access="public" returntype="query" hint="Funcion que retorna todos los Datos Variables">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="conexion" 	type="string"  required="no" default="ftec" hint="Nombre del DataSource">
		
		<cfif isdefined('session.Ecodigo') and not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="ListaDV" datasource="#Arguments.conexion#">
			select DVid , DVetiqueta,  DVexplicacion, DVobligatorio,
			case when  DVtipoDato = 'C'  then 'Caracter' 
				 when  DVtipoDato = 'N' then 'Numerico' 
				 when  DVtipoDato = 'L' then 'Lista' 
				 when  DVtipoDato = 'F' then 'Fecha' 
				 when  DVtipoDato = 'H' then 'Hora' 
				 when  DVtipoDato = 'K' then 'Logico' 
				 else 'otro' end as DVtipoDato					
			from FTDatosVariables
		</cfquery>
		<cfreturn ListaDV>
	</cffunction>
</cfcomponent>



<!---==================AGREGAR UN CONFIGURACIÓN DE DATOS VARIABLES
<cffunction name="ALTAConfig"  access="public" returntype="string">
	<cfargument name="Conexion" 	  type="string"   required="false" default="ftec">
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
==================--->


<!---==================ELIMINAR UNA CONFIGURACIÓN DE DATOS VARIABLES
	<cffunction name="BAJAConfig"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"   required="false" default="ftec">
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
==================--->