<cfset def = QueryNew('SNcodigo')>
<cfset newRow = QueryAddRow(def, 1)>
<cfset def.SNcodigo = -1>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.SNcodigo" default="SNcodigo" type="string"> <!--- Nombres del código del socio --->
<cfparam name="Attributes.SNnombre" default="SNnombre" type="string"> <!--- Nombres de la descripción del socio --->
<cfparam name="Attributes.SNnumero" default="SNnumero" type="string"> <!--- Nombres de la identificación del socio Ej: 9-089-679 --->
<cfparam name="Attributes.SNtiposocio" default="" type="string"> <!--- Si es proveedor (no clientes) ó si es cliente (no proveedor) --->
<cfparam name="Attributes.frame" default="frsocios" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" default="" type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar" default="" type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabIndex" default="" type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.SNvencompras" default="SNvencompras" type="string"> 

<!--- consultas --->
<cfquery name="rsSocios" datasource="#Attributes.Conexion#">
	select SNcodigo, SNnumero, SNtiposocio, SNnombre, SNFecha, SNtipo, SNvencompras, SNvenventas, SNinactivo, ts_rversion 
	from SNegocios 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and SNinactivo = 0
	<cfif Attributes.SNtiposocio EQ "P">
	  and SNtiposocio != 'C'
	<cfelseif Attributes.SNtiposocio EQ "C">
	  and SNtiposocio != 'P'
	</cfif>	  
</cfquery>
<cfset longitud = len(Trim(rsSocios.SNnumero))>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Proveedores"
Default="Proveedores"
returnvariable="LB_Proveedores"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Clientes"
Default="Clientes"
returnvariable="LB_Clientes"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Socios"
Default="Socios"
returnvariable="LB_Socios"/>


<cfif Attributes.SNtiposocio EQ "P">
	<cfset socios = #LB_Proveedores# >
<cfelseif Attributes.SNtiposocio EQ "C">
	<cfset socios = #LB_Clientes#>
<cfelse>
	<cfset socios = #LB_Socios#>
</cfif>


<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
	if(!popUpWin.closed) popUpWin.close();
  }
  window
  popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function doConlis<cfoutput>#Attributes.SNcodigo#</cfoutput>() {
	<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
	var params ="";
	params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.SNcodigo#&desc=#Attributes.SNnombre#&identificacion=#Attributes.SNnumero#&tipo=#Attributes.SNtiposocio#&dias=#Attributes.SNvencompras#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	
	popUpWindow("/cfmx/ftec/Utiles/ConlisSociosNegociosFA.cfm"+params,250,200,650,350);
}

function TraeSocio<cfoutput>#Attributes.SNcodigo#</cfoutput>(dato) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.SNcodigo#&desc=#Attributes.SNnombre#&identificacion=#Attributes.SNnumero#&SNtiposocio=#Attributes.SNtiposocio#&dias=#Attributes.SNvencompras#</cfoutput>";
	<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
		params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
	</cfif>	

	if (dato=="") {dato="-1"}
		var frame = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
		frame.src="/cfmx/ftec/Utiles/rhsociosnegociosFAquery.cfm?SNnumero="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	
	return;
}
</script>

  <table width="" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<td nowrap>		
   			<cfset Parametro = createobject("component","sif.Componentes.Parametros")>
            <cfset LvarMaxLength=len(trim(Parametro.get(611,session.Ecodigo,'0')))>	
		<input <cfif Len(Trim(Attributes.tabIndex)) NEQ 0>tabindex="#Attributes.tabIndex#" </cfif>type="text" name="#Attributes.SNnumero#" id="#Attributes.SNnumero#" maxlength="#LvarMaxLength#" size="10" onblur="javascript:TraeSocio#Attributes.SNcodigo#(document.#Attributes.form#.#Evaluate('Attributes.SNnumero')#.value);" onfocus="this.select()"				
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNnumero)#</cfif>" >
	</td>

	<td nowrap>
		<input type="text" <cfif Len(Trim(Attributes.tabIndex)) NEQ 0>tabindex="#Attributes.tabIndex#" </cfif>name="#Attributes.SNnombre#" id="#Attributes.SNnombre#" maxlength="255" size="30" disabled 
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNnombre)#</cfif>">
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de #socios#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlis#Attributes.SNcodigo#();'></a>		
	</td>		
	<input type="hidden" name="#Attributes.SNcodigo#" id="#Attributes.SNcodigo#" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.SNcodigo)#</cfif>">			
	</cfoutput>
  </table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>