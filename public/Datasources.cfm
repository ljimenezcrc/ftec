<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Documento sin título</title>
</head>

<body>
<cfoutput>
<form name="form1" action="sqlDatasources.cfm" method="post">
	<input type="hidden" id="serverx" name="serverx" value=""/>
    
    <table border="1" >
    <tr>
    	<td>Tipo de Base de datos:</td>
        <td>
            <select name="Database" id="Database">
                <option value="1" >SyBase</option>
                <option value="2" >SQL Server</option>
            </select>
        </td>
    <tr>
    <tr>
    	<td>Servidor</td>
	    <td><input type="text"  name="server"  id="server" value="" /></td>
    <tr>
    <td>Servidores Preconfigurados</td>
    <td>	
        <select name="server1"  id="server1" onchange="javascript:actualizar(this.value);">
        	<option value="-1" ></option>
            <option value="1" >Desarrollo SyBase</option>
            <option value="2" >ITCR - SOIN SQL Server</option>
            <option value="3" >Virtual SQL Server</option>
            <option value="4" >IICA - Pruebas SQL Server</option>
            <option value="5" >IICA - Produccion SQL Server</option>
            <option value="6" >FundaTec - SQL Server - SOIN</option>
            <option value="7" >IICA - Certificacion SQL Server</option>
        </select>
    </td>
    <tr>
    	<td>Puerto:</td>
	    <td><input type="text"  name="port"  value=""  id="port"/></td>
    <tr>
    
    <tr>
    	<td>Usuario:</td>
	    <td><input type="text"  name="user" value=""  id="user"/></td>
    <tr>
    <tr>
    	<td>Password:</td>
	    <td><input type="password" name="pass" value="" id="pass"/></td>
    <tr>
        <td colspan="2" align="center">
            <input type="submit" name="generar" value="Crear Datasources"   />
        </td>
    </tr>
    </table>
</form>

</cfoutput>

<script language="JavaScript">
	function actualizar(pc) {
 
			switch(pc){
				case '1':{
					document.getElementById("Database").value = "1";
					document.getElementById("user").value = "ljimenez";
					document.getElementById("pass").value = "ljimenez123";
					document.getElementById("port").value = "5000";
					document.getElementById("server").value = "172.20.0.53";
				}
				break;
				
				case '2':{
					document.getElementById("Database").value = "2";
					document.getElementById("user").value = "sa";
					document.getElementById("pass").value = "asp128";
					document.getElementById("port").value = "1433";
					document.getElementById("server").value = "172.20.0.67";
				}
				break;
				
				case '3':{
					document.getElementById("Database").value = "2";
					document.getElementById("user").value = "sa";
					document.getElementById("pass").value = "asp128";
					document.getElementById("port").value = "1433";
					document.getElementById("server").value = "vmsqlserver";
				}
				break;
				case '4':{
					document.getElementById("Database").value = "2";
					document.getElementById("user").value = "cfusion5";
					document.getElementById("pass").value = "cfusion5";
					document.getElementById("port").value = "1433";
					document.getElementById("server").value = "23.96.9.46";
				}
				break;
				
				case '5':{
					document.getElementById("Database").value = "2";
					document.getElementById("user").value = "cfusion5";
					document.getElementById("pass").value = "cfusion5";
					document.getElementById("port").value = "1433";
					document.getElementById("server").value = "23.96.9.119";
				}
				break;
				
				case '6':{
					document.getElementById("Database").value = "2";
					document.getElementById("user").value = "cfusion";
					document.getElementById("pass").value = "cfusion5";
					document.getElementById("port").value = "1433";
					document.getElementById("server").value = "sqlserver2008";
				}
				break;
				
				case '7':{
					document.getElementById("Database").value = "2";
					document.getElementById("user").value = "cfusion5";
					document.getElementById("pass").value = "cfusion5";
					document.getElementById("port").value = "5050";
					document.getElementById("server").value = "rhiicabdtest.cloudapp.net";
				}
				break;
			}
 
		}
</script>


</body>
</html>