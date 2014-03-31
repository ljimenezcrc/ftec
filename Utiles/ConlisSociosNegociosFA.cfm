<!---  
	Modificado por: Ana Villavicencio
	Fecha: 02 de marzo del 2006
	Motivo: Modificado para q al seleccionar el registro regrese al campo SNnumero
--->

<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml" 
	Default="Lista de" Key="LB_ListaDe" returnvariable="LB_ListaDe"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml" 
	Default="Proveedores" Key="LB_Proveedores" returnvariable="LB_Proveedores"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml" 
	Default="Clientes" Key="LB_Clientes" returnvariable="LB_Clientes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml" 
	Default="Socio" Key="LB_Socio" returnvariable="LB_Socio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml" 
	Default="Nombre" Key="LB_Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml" 
	Default="Filtrar" Key="BTN_Filtrar" returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml" 
	Default="Socios de Negocio" Key="LB_Socios_de_Negocio" returnvariable="LB_Socios_de_Negocio"/>

<html>
<head>
<cfoutput>
<title>#LB_ListaDe# <cfif Url.tipo EQ "P">#LB_Proveedores#<cfelseif Url.tipo EQ "C">#LB_Clientes#<cfelse>#LB_Socios_de_Negocio#</cfif></title>
</cfoutput>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<cfquery name="conlis" datasource="#Session.DSN#">	
	select SNcodigo,  SNnombre, SNnumero, coalesce(SNvencompras,0) as SNvencompras
	from SNegocios 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	<cfif isdefined("Url.tipo") and (Len(Trim(Url.tipo)) GT 0)>
		<cfif Url.tipo EQ "P">
		  and SNtiposocio != 'C'
		<cfelseif Url.tipo EQ "C">
		  and SNtiposocio != 'P'
		</cfif>	  
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.SNnumero NEQ "")>
  	  and upper(SNnumero) like '%#Ucase(Form.SNnumero)#%'
	</cfif>
	<cfif isdefined("Form.Filtrar") and (Form.SNnombre NEQ "")>
	  and upper(SNnombre) like '%#Ucase(Form.SNnombre)#%'
	</cfif>	  
	  and SNinactivo = 0
	order by SNnombre, SNnumero 
</cfquery>

<cfif Url.tipo EQ "P">
	<cfset socio = LB_Proveedor>
<cfelseif Url.tipo EQ "C">
	<cfset socio = LB_Clientes>
<cfelse>
	<cfset socio = LB_Socio>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=16>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<script language="JavaScript1.2">
function Asignar(valor1, valor2, valor3, valor4) {
	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#.#url.identificacion#</cfoutput>.value=valor3;
	window.opener.document.<cfoutput>#url.form#.#url.dias#</cfoutput>.value=valor4;
	
	window.close();
	<cfif Len(Trim(url.FuncJSalCerrar)) GT 0><cfoutput>window.opener.#url.FuncJSalCerrar#;</cfoutput></cfif>
	window.opener.document.<cfoutput>#url.form#.#url.identificacion#</cfoutput>.focus();
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellspacing="0">
    <tr> 
      <td width="44%"  class="tituloListas"><div align="left"><cfoutput>#socio#</cfoutput></div></td>
      <td width="28%" class="tituloListas"><div align="left"><cfoutput>#LB_Nombre#</cfoutput></div></td>
      <td width="1%" class="tituloListas"><div align="right">
          <input type="submit" name="Filtrar" class="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
          </div></td>
    </tr>
    <tr> 
      <td><input name="SNnumero" type="text" size="40" maxlength="100"></td>
      <td colspan="2"><input name="SNnombre" type="text" size="40" maxlength="60"></td>
    </tr>
    <cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
      <tr> 
        <td <cfif #conlis.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><input type="hidden" name="SNnumero#conlis.CurrentRow#" value="#conlis.SNnumero#"> 
          <a href="javascript:Asignar('#conlis.SNcodigo#', '#JSStringFormat(conlis.SNnombre)#', '#JSStringFormat(conlis.SNnumero)#', '#conlis.SNvencompras#');">#conlis.SNnumero#</a></td>
        <td colspan="2" <cfif #conlis.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>><a href="javascript:Asignar('#conlis.SNcodigo#', '#JSStringFormat(conlis.SNnombre)#', '#JSStringFormat(conlis.SNnumero)#', '#conlis.SNvencompras#');">#conlis.SNnombre#</a></td>
      </tr>
    </cfoutput> 
    <tr> 
      <td colspan="3">&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="3">&nbsp; <table border="0" width="50%" align="center">
          <cfoutput> 
            <tr> 
              <td width="23%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#"><img src="/cfmx/rh/imagenes/First.gif" width="18" height="13" border=0></a> 
                </cfif> </td>
              <td width="31%" align="center"> <cfif PageNum_conlis GT 1>
                  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Previous.gif" width="14" height="13" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Next.gif" width="14" height="13" border=0></a> 
                </cfif> </td>
              <td width="23%" align="center"> <cfif PageNum_conlis LT TotalPages_conlis>
                  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#"><img src="/cfmx/rh/imagenes/Last.gif" width="18" height="13" border=0></a> 
                </cfif> </td>
            </tr>
          </cfoutput> </table> <div align="center"> </div></td>
    </tr>
  </table>
<p>&nbsp;</p></form>
</body>
</html>

