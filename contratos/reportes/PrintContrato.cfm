<style media="screen">
	.LabelRed {
		color:red;
	}
</style>
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
								WHEN 5 THEN 'Separado' 
								WHEN 6 THEN 'Soltera' 
								WHEN 7 THEN 'Casada' 
								WHEN 8 THEN 'Divorciada' 
								WHEN 9 THEN 'Separada' 
								WHEN 10 THEN 'Viudo' 
								WHEN 11 THEN 'Viuda' 
			END AS EstadoCivil
           , Vid
		from FTPContratacion a
			inner join FTContratos b
				on b.Cid = a.Cid
			inner join FTSecciones c
				on c.Cid = b.Cid
	where a.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
</cfquery>

<cf_dbfunction name="op_concat" returnvariable="_cat">


<cfquery name="rsCoordinador" datasource="#session.DSN#">
    select ta.Aid 
        , ta.TAid
        , ta.Vid
        , ta.Usucodigo
        , dp.Pid as Idenificacion
        , dp.Pnombre #_Cat# ' ' #_Cat# dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2  as Nombre
        
        , ta.Afdesde
        , ta.Afhasta
        , ta.Ainactivo
        , ta.TAresponsable
        , z.TAcodigo #_Cat# ' - ' #_Cat# z.TAdescripcion as TipoAutorizador
    from <cf_dbdatabase table="FTAutorizador " datasource="ftec"> ta
        inner join Usuario u
            on u.Usucodigo=ta.Usucodigo
                and u.Uestado = 1 
                and u.Utemporal = 0
                and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
        inner join DatosPersonales dp
            on dp.datos_personales =u.datos_personales
        inner join <cf_dbdatabase table="FTTipoAutorizador " datasource="ftec"> z
            on ta.TAid = z.TAid
            and z.TAid = 1 <!---Coordinador--->
    where ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Vid = #rsContrato.Vid#
</cfquery>



<cfset Seccion = ''>




<!---<cfdocument format="pdf" bookmark="yes">
<cfdocumentsection name="1">--->
<!---Se recorren cada una de las secciones--->
<cfloop query="rsContrato">
	<!---Se Obtienen las variables de las secciones--->
    <cfquery name="rsVariable" datasource="ftec">
        select top 3 a.Variable, a.TVariables, CASE WHEN d.DVtipoDato = 'L' then c.DVLdescripcion else b.PCDValor end as PCDValor
         from FTSeccionesD a
            LEFT OUTER JOIN FTPDContratacion b
                on b.SDid = a.SDid
               and b.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
			 LEFT OUTER JOIN FTListaValores c
			 	on c.DVid       = b.DVid
				and c.DVLcodigo = convert(char(11),b.PCDValor )	
			 LEFT OUTER JOIN FTDatosVariables d
			 	on d.DVid = b.DVid
        where a.Sid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContrato.Sid#">
    </cfquery>

        
		<cfset Seccion = Seccion & rsContrato.STexto>
		<!--- <cfloop query="rsVariable">
			<cfswitch expression="#rsVariable.TVariables#"> 
				<!---Dato Variable--->
				<cfcase value="1"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' & rsVariable.PCDValor & '</font>')></cfcase> 
				<!---Tipo de Identificación--->
				<cfcase value="2">
					<cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.TipoIdentificacion & '</font>')>
				</cfcase> 
				<!---Identificación--->
				<cfcase value="3"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.PCIdentificacion & '</font>')></cfcase>
				<!---Nombre--->
				<cfcase value="4"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.PCNombre & '</font>')></cfcase> 
				<!---Primer Apellido--->
				<cfcase value="5"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.PCApellido1 & '</font>')></cfcase> 
				<!---Segundo Apellido--->
				<cfcase value="6"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.PCApellido2 & '</font>')></cfcase> 
				<!---Sexo--->
				<cfcase value="7"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.Sexo & '</font>')></cfcase> 
				<!---Fecha Nacimiento--->
				<cfcase value="8"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &DateFormat(rsContrato.PCFechaN,'DD/MM/YYYY') & '</font>')></cfcase> 
				Numero Contrato
				<cfcase value="9"><cfset Seccion  = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.PCEnumero & '</font>')></cfcase> 
				<!---Periodo Contratación--->
				<cfcase value="10"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.PCEPeriodo & '</font>')></cfcase> 
				<!---Fecha de Creación--->
				<cfcase value="11"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &DateFormat(rsContrato.PCFechaC,'DD/MM/YYYY') & '</font>')></cfcase> 
				<!---Fecha de Aprobación--->
				<cfcase value="12"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &DateFormat(rsContrato.PCFechaA,'DD/MM/YYYY') & '</font>')></cfcase> 
				<!---Fecha de Firmas--->
				<cfcase value="13"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &DateFormat(rsContrato.PCFechaF,'DD/MM/YYYY') & '</font>')></cfcase> 
				<!---Estado Civil--->
				<cfcase value="14"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsContrato.EstadoCivil & '</font>')></cfcase> 
				<cfcase value="15"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsCoordinador.Nombre& '</font>')></cfcase> 
				<cfcase value="16"><cfset Seccion = replace(Seccion,'##' & rsVariable.Variable & '##','<font class="LabelRed">' &rsCoordinador.Idenificacion& '</font>')></cfcase> 
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
		--->
		
<!--- 			<div class="row">
				<div class="col-xs-12" style="text-align: justify;"><cfoutput>#Replace(Seccion,'DOBLE CLICK PARA EDITAR','','ALL')#</cfoutput></div>
			</div> --->

			<cfset Seccion = Replace(Seccion,'DOBLE CLICK PARA EDITAR','','ALL')>	   

	</cfloop>
<!---	</cfdocumentsection>		
</cfdocument>--->

<!--- <cf_dump var="#Seccion#"> 

<cfset xx='esta es una seccion de prueba'>
--->
<cfreport template="PrintContratos.cfr" format="pdf">
		<cfreportparam name="CuerpoContrato" value="#Seccion#">
</cfreport>