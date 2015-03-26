<cfif isdefined('url.PCid') and LEN(TRIM(url.PCid))>
	<cfset form.PCid = url.PCid>
</cfif>

<cfif isdefined('url.ver') and LEN(TRIM(url.ver))>
	<cfset form.ver = url.ver>
</cfif>


<cfif isdefined('form.btnGComentario')>
	<cfinvoke component="ftec.Componentes.FTPContratacion" method="setComentario" returnvariable="LvarPCid">
		<cfinvokeargument name="PCid" 			value="#form.PCid#">
        <cfinvokeargument name="comentarios" 	value="#form.comentarios#">
     </cfinvoke>   
</cfif>

<cfquery name="rsComentario" datasource="#session.dsn#">
	select * 
	from  <cf_dbdatabase table="FTPContratacionObserv" datasource="ftec">
	where PCid = #form.PCid#
</cfquery>

<form name="form1" action="PopupComentario.cfm" method="post">
	<cfoutput>
			<input name="PCid" type="hidden" value="#form.PCid#">

	<table width="60%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td> Comentarios:</td>
        </tr>
            
        <tr>
			<td>
	            <textarea name="comentarios" rows="15" cols="100">#rsComentario.FTPCOcomentario#</textarea>
            </td>
		</tr>
        <tr>            
			<td align="center">
				<cfif not isDefined("form.ver")>
					<button  name="btnGComentario"   class="btn btn-info">Guardar</button>	
				</cfif>
                <button  name="btnRComentario"   class="btn btn-info" onclick="funcRegresar()">Regresar</button>
				<!---<cf_botones values="Guardar/salir" names="Regresar">--->
			</td>
		</tr>
	</table>
    
    </cfoutput>	
</form>
<script>
	function funcRegresar(){
		window.close();
	}
</script>		