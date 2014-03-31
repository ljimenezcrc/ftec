<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 	default="#Session.DSN#"	type="String"> 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.form"     	default="form1" 		type="String">	<!--- Nombre del form --->
<cfparam name="Attributes.query" 		default="#def#" 		type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="Vcodigo" 		type="string">	<!--- Nombre del Código --->
<cfparam name="Attributes.desc" 		default="Vdescripcion" type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.id"    		default="Vid" 			type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.frame" 		default="frcVicerrectoria"	type="string">	<!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" 	default="" 				type="string">	<!--- número del tabindex --->
<cfparam name="Attributes.size" 		default="40" 			type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.codigosize"	default="10" 			type="string">	<!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.excluir" 		default="-1" 			type="string">	<!--- centro funcional que no debe salir en la lista --->
<cfparam name="Attributes.titulo" 		default="" 			    type="string">	<!--- leyenda para el conlis --->
<cfparam name="Attributes.index" 		default="" 			    type="string">	<!--- indice que se utiliza para tener más de un tag en una misma pantalla --->
<cfparam name="Attributes.Ecodigo" 		default="#session.Ecodigo#" type="numeric">	<!--- indice que se utiliza para tener más de un tag en una misma pantalla --->
<cfparam name="Attributes.EcodigoName" 	default="" 				type="string">	<!--- indice que se utiliza para tener más de un tag en una misma pantalla --->
<cfparam name="Attributes.readonly" 	default="no" 			type="boolean"> <!--- Sólo lectura --->
<cfparam name="Attributes.width" 		default="650" 			type="numeric">
<cfparam name="Attributes.height" 		default="460" 			type="numeric">
<cfparam name="Attributes.contables" 	default="-1" 			type="string">	<!--- centro funcional que posee definido la cuenta de gasto o compra de servicios --->
<cfparam name="Attributes.proyectos" 	default="0" 			type="string">	<!---filtrar los marcado como proyectos--->
<cfparam name="Attributes.usuario" 		default="0" 			type="string">	<!---filtrar por el usuario en session--->
<cfparam name="Attributes.style" 			default="" 			type="string">		<!--- style asociado a la caja de texto --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 			type="string"> 		<!--- función .js después de ejecutar la consulta --->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisVicerrectoria<cfoutput>#Attributes.name##Attributes.index#</cfoutput>(){
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir##Attributes.index#&titulo=#JSStringFormat(Attributes.titulo)#&Ecodigo=#attributes.Ecodigo#&proyectos=#Attributes.proyectos##Attributes.index#&usuario=#Attributes.usuario##Attributes.index#</cfoutput>";

		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow<cfoutput>#Attributes.name##Attributes.index#</cfoutput>("/cfmx/ftec/Utiles/ConlisVicerrectoria.cfm"+params,250,200,<cfoutput>#Attributes.width#,#Attributes.height#</cfoutput>);
	}
	
	function conlis_keyup_<cfoutput>#Attributes.name#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisVicerrectoria<cfoutput>#Attributes.name##Attributes.index#</cfoutput>();
		}
	}
	
	//Obtiene la descripción con base al código
	function TraeVicerrectoria<cfoutput>#Attributes.name##Attributes.index#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&excluir=#Attributes.excluir##Attributes.index#&proyectos=#Attributes.proyectos##Attributes.index#&usuario=#Attributes.usuario##Attributes.index#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/ftec/Utiles/FTvicerrectoriaquery.cfm?dato="+dato+"&formulario="+"<cfoutput>#Attributes.form##Attributes.index#</cfoutput>"+params;
		}
		else{
			document.<cfoutput>#Attributes.form#.#Attributes.id#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.name#</cfoutput>.value = '';
			document.<cfoutput>#Attributes.form#.#Attributes.desc#</cfoutput>.value = '';

			if (window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>) {window.funcExtra<cfoutput>#trim(Attributes.name)#</cfoutput>();}			
		}
		return;
	}	
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>" >
				
			<input type="hidden" name="Ucodigo_#Attributes.name#" id="Ucodigo#Attributes.name#" value="" >

			<input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#trim(Evaluate('#name#'))#</cfif>" 
				onBlur="javascript:TraeVicerrectoria#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); if (window.func#Attributes.name#) {func#Attributes.name#();}" onFocus="this.select()"
				onkeyup="javascript:conlis_keyup_#Attributes.name#(event);"
				size="10" 
				maxlength="10" style="#Attributes.style#"  <cfif Attributes.readonly>readonly</cfif>>
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80" style="#Attributes.style#"  <cfif Attributes.readonly>readonly</cfif>>
		</td>

		<cfif not Attributes.readonly>
		<td>
			<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Conceptos de Servicio" name="img#Attributes.name#" id="img#Attributes.name#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisVicerrectoria#Attributes.name#();'></a>
		</td>
		</cfif>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="display: none;"></iframe>
