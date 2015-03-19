<cf_navegacion name="PCid">
<!---Se valida que se envie el Id del contrato--->
<cfif not isdefined('form.PCid')>
	No se envio el ID del proceso de contratación<cfabort>
</cfif>
<!---Se Obtiene la Informacion del contrato y sus secciones--->
<cfquery name="rsContrato" datasource="ftec">
	select c.STexto, c.Sid, a.PCIdentificacion, a.PCNombre,a.PCFechaN,a.PCEnumero,a.PCEPeriodo, a.PCFechaC, a.PCFechaA, a.PCFechaF,
		   a.PCApellido1,PCApellido2,
		   CASE PCTidentificacion WHEN 'F' THEN 'Física' WHEN 'J' THEN 'jurídica' ELSE 'Otra' END AS TipoIdentificacion,
		   CASE a.PCSexo WHEN 'M' then 'Masculino' WHEN 'F' THEN 'Femenino' ELSE 'Desconocido' END AS Sexo,
		   CASE a.PCEstadoCivil WHEN 1 THEN 'Soltero'
								WHEN 2 THEN 'Casado'
								WHEN 3 THEN 'Divorciado'
								WHEN 4 THEN 'Union Libre'
								WHEN 5 THEN 'Separado' END AS EstadoCivil
		from FTPContratacion a
			inner join FTContratos b
				on b.Cid = a.Cid
			inner join FTSecciones c
				on c.Cid = b.Cid
	where a.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
</cfquery>

<cfdocument format="pdf" bookmark="yes">
<cfdocumentsection name="1">
<!---Se recorren cada una de las secciones--->
<cfloop query="rsContrato">
	<!---Se Obtienen las variables de las secciones--->
    <cfquery name="rsVariable" datasource="ftec">
        select a.Variable, a.TVariables, CASE WHEN d.DVtipoDato = 'L' then c.DVLdescripcion else b.PCDValor end as PCDValor
         from FTSeccionesD a
            LEFT OUTER JOIN FTPDContratacion b
                on b.SDid = a.SDid
               and b.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
			 LEFT OUTER JOIN FTListaValores c
			 	on c.DVid       = b.DVid
				and c.DVLcodigo = b.PCDValor	
			 LEFT OUTER JOIN FTDatosVariables d
			 	on d.DVid = b.DVid
        where a.Sid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContrato.Sid#">
    </cfquery>

        
			<cfset Seccion = rsContrato.STexto>
		<cfloop query="rsVariable">
			<cfswitch expression="#rsVariable.TVariables#"> 
				<!---Dato Variable--->
				<cfcase value="1"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' & rsVariable.PCDValor & '</font>')></cfcase> 
				<!---Tipo de Identificación--->
				<cfcase value="2">
					<cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.TipoIdentificacion & '</font>')>
				</cfcase> 
				<!---Identificación--->
				<cfcase value="3"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.PCIdentificacion & '</font>')></cfcase>
				<!---Nombre--->
				<cfcase value="4"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.PCNombre & '</font>')></cfcase> 
				<!---Primer Apellido--->
				<cfcase value="5"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.PCApellido1 & '</font>')></cfcase> 
				<!---Segundo Apellido--->
				<cfcase value="6"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.PCApellido2 & '</font>')></cfcase> 
				<!---Sexo--->
				<cfcase value="7"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.Sexo & '</font>')></cfcase> 
				<!---Fecha Nacimiento--->
				<cfcase value="8"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &DateFormat(rsContrato.PCFechaN,'DD/MM/YYYY') & '</font>')></cfcase> 
				<!---Numero Contrato--->
				<cfcase value="9"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.PCEnumero & '</font>')></cfcase> 
				<!---Periodo Contratación--->
				<cfcase value="10"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.PCEPeriodo & '</font>')></cfcase> 
				<!---Fecha de Creación--->
				<cfcase value="11"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &DateFormat(rsContrato.PCFechaC,'DD/MM/YYYY') & '</font>')></cfcase> 
				<!---Fecha de Aprobación--->
				<cfcase value="12"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &DateFormat(rsContrato.PCFechaA,'DD/MM/YYYY') & '</font>')></cfcase> 
				<!---Fecha de Firmas--->
				<cfcase value="13"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &DateFormat(rsContrato.PCFechaF,'DD/MM/YYYY') & '</font>')></cfcase> 
				<!---Estado Civil--->
				<cfcase value="14"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font color="red">' &rsContrato.EstadoCivil & '</font>')></cfcase> 
				<!---Caso no conteplado--->
				<cfdefaultcase></cfdefaultcase>
			</cfswitch>
		</cfloop>
		<cfif rsContrato.Sexo EQ 'F'>
			<cfset Seccion = Replace(Seccion,'El contratado','La contratada','ALL')>
			<cfset Seccion = Replace(Seccion,'el contratado','la contratada','ALL')>
			<cfset Seccion = Replace(Seccion,'EL CONTRATADO(A)','LA CONTRATADA','ALL')>	
			<cfset Seccion = Replace(Seccion,'El CONTRATADO(A)','La CONTRATADA','ALL')>
			<cfset Seccion = Replace(Seccion,'el CONTRATADO(A)','la CONTRATADA','ALL')>	 
			<cfset Seccion = Replace(Seccion,'al CONTRATADO(A)','a la CONTRATADA','ALL')>	
			<cfset Seccion = Replace(Seccion,'CONTRATADO(A)','CONTRATADA','ALL')>	  
		<cfelse>
			<cfset Seccion = Replace(Seccion,'EL CONTRATADO(A)','EL CONTRATADO','ALL')>
			<cfset Seccion = Replace(Seccion,'el CONTRATADO(A)','el CONTRATADO','ALL')>	
			<cfset Seccion = Replace(Seccion,'al CONTRATADO(A)','al CONTRATADO','ALL')> 
			<cfset Seccion = Replace(Seccion,'El CONTRATADO(A)','El CONTRATADO','ALL')>
			<cfset Seccion = Replace(Seccion,'CONTRATADO(A)','CONTRATADO','ALL')>	   
		</cfif>
		
		
			<div class="row">
				<div class="col-xs-12" style="text-align: justify;"><cfoutput>#Replace(Seccion,'DOBLE CLICK PARA EDITAR','','ALL')#</cfoutput></div>
			</div>

	</cfloop>
	</cfdocumentsection>		
</cfdocument>