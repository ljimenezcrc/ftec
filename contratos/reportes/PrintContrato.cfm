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
        select a.Variable, a.TVariables, b.PCDValor
         from FTSeccionesD a
            LEFT OUTER JOIN FTPDContratacion b
                on b.SDid = a.SDid
               and b.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
        where a.Sid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContrato.Sid#">
    </cfquery>

        
			<cfset Seccion = rsContrato.STexto>
		<cfloop query="rsVariable">
			<cfswitch expression="#rsVariable.TVariables#"> 
				<!---Dato Variable--->
				<cfcase value="1"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',rsVariable.PCDValor)></cfcase> 
				<!---Tipo de Identificación--->
				<cfcase value="2">
					<cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.TipoIdentificacion)>
				</cfcase> 
				<!---Identificación--->
				<cfcase value="3"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.PCIdentificacion)></cfcase>
				<!---Nombre--->
				<cfcase value="4"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.PCNombre)></cfcase> 
				<!---Primer Apellido--->
				<cfcase value="5"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.PCApellido1)></cfcase> 
				<!---Segundo Apellido--->
				<cfcase value="6"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.PCApellido2)></cfcase> 
				<!---Sexo--->
				<cfcase value="7"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.Sexo)></cfcase> 
				<!---Fecha Nacimiento--->
				<cfcase value="8"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',DateFormat(rsContrato.PCFechaN,'DD/MM/YYYY'))></cfcase> 
				<!---Numero Contrato--->
				<cfcase value="9"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.PCEnumero)></cfcase> 
				<!---Periodo Contratación--->
				<cfcase value="10"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.PCEPeriodo)></cfcase> 
				<!---Fecha de Creación--->
				<cfcase value="11"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##',DateFormat(rsContrato.PCFechaC,'DD/MM/YYYY'))></cfcase> 
				<!---Fecha de Aprobación--->
				<cfcase value="12"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##',DateFormat(rsContrato.PCFechaA,'DD/MM/YYYY'))></cfcase> 
				<!---Fecha de Firmas--->
				<cfcase value="13"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##',DateFormat(rsContrato.PCFechaF,'DD/MM/YYYY'))></cfcase> 
				<!---Estado Civil--->
				<cfcase value="14"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##',rsContrato.EstadoCivil)></cfcase> 
				<!---Caso no conteplado--->
				<cfdefaultcase></cfdefaultcase>
			</cfswitch>
		</cfloop>
		
		
			<div class="row">
				<div class="col-xs-12"><cfoutput>#Replace(Seccion,'DOBLE CLICK PARA EDITAR','','ALL')#</cfoutput></div>
			</div>

	</cfloop>
	</cfdocumentsection>		
</cfdocument>