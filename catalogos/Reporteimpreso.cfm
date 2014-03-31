<cfif isdefined("session.tempfile_xls") and  Len(session.tempfile_xls) is 0>
	<cfheader statuscode="304" statustext="Not Modified">
<cfelse>
	<cfset tempfile_xls = session.tempfile_xls>

	<cfdirectory 
		directory="#GetDirectoryFromPath(tempfile_xls)#" 
		name="myDirectory" 
		sort="name ASC, size DESC">
	<!---- Output the contents of the cfdirectory as a cftable -----> 
	<cfloop query="myDirectory" >
		<cfif findnocase(Name, tempfile_xls) GT 0>
			<cfif Size LTE 3145728>
                <script language="javascript1.2" type="text/javascript">
                    function regresar() {
                        document.location = "SaldoCuentaCont.cfm";
                    }
                    function imprimir() {
                        var tablabotones = document.getElementById("tablabotones");
                        tablabotones.style.display = 'none';
                        window.print()	
                        tablabotones.style.display = ''
                    }
                    function SALVAEXCEL(i) {
                        var EXCEL = document.getElementById("EXCEL");
                        EXCEL.style.visibility='hidden';
                        if (i = 1){
                            document.FormExcel.submit();
                        }
                    }
                </script>
                <form name="FormExcel" action="bajar_excel.cfm" method="post">
                </form>
                <table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
                <tr>
                <td align="right" nowrap>
                    <input type="button"  id="EXCEL"    name="EXCEL"    value="Exportar a Excel" onClick="SALVAEXCEL(1);"> 
                    <input type="button"  id="Regresar" name="Regresar" value="Regresar"         onClick="regresar();">
                    <input type="button"  id="Imprimir" name="Imprimir" value="Imprimir"         onClick="imprimir();">
                </td>
                </tr>
                <tr><td><hr></td></tr>
                </table>
                <cfflush interval="32">
				<cffile action="read" file="#tempfile_xls#" variable="archivo">
                <cfoutput>#archivo#</cfoutput>
                <cfbreak>
			<cfelse>
				<!----Borra esta informacion por ser muy grande para desplegar -----> 
                <html><head><title>Reporte</title></head><body>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p align="center">El reporte fue generado existosamente, pero es muy grande para desplegarlo.</p>
                <p align="center">Haga clic <a href="bajar_excel.cfm">aqu&iacute;</a> para descargarlo en formato excel.</p>
                </body></html>
				<cfbreak>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
