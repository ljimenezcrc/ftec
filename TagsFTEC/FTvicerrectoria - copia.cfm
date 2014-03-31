<cfset def = QueryNew('Vcodigo')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 	default="#Session.DSN#"	type="String"> 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.form"     	default="form1" 		type="String">	<!--- Nombre del form --->
<cfparam name="Attributes.query" 		default="#def#" 		type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="CFcodigo" 		type="string">	<!--- Nombre del Código --->
<cfparam name="Attributes.desc" 		default="CFdescripcion" type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.id"    		default="CFid" 			type="string"> 	<!--- Nombre de la Descripción --->
<cfparam name="Attributes.frame" 		default="frcfuncional" 	type="string">	<!--- Nombre del frame --->
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



<!----========== TRADUCCION =============----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Vicerrectorias"
	Default="Lista de Unidades Operativas"	
	returnvariable="LB_Lista_de_Vicerrectorias"/>
	
<cfoutput>
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;

	<cfif Attributes.EcodigoName NEQ "">
		<cfif find("document.",Attributes.EcodigoName) EQ 1>
			<cfset LvarEcodigoName = Attributes.EcodigoName>
		<cfelseif find(".",Attributes.EcodigoName) GT 0>
			<cfset LvarEcodigoName = "document.#Attributes.EcodigoName#">
		<cfelse>
			<cfset LvarEcodigoName = "document.#Attributes.form#.#Attributes.EcodigoName#">
		</cfif>
	</cfif>
	
	function popUpWindow#Attributes.name##Attributes.index#(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	
	
	<!---//Llama el conlis
	function doConlisConceptos<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&cuentac=#Attributes.cuentac#&filtroextra=#Attributes.filtroextra#&verClasificacion=#Attributes.verClasificacion#&tipo=#Attributes.tipo#&Ecodigo=#Attributes.Ecodigo#&isCorp=#Attributes.isCorp#&Empresas=#Attributes.Empresas#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/sif/Utiles/ConlisConceptos.cfm"+params,250,200,650,400);
	}--->
	
	

	function doConlisVicerrectoria#Attributes.name##Attributes.index#() {
		var params ="";
	<cfif Attributes.EcodigoName EQ "">
		params = "<cfoutput>?ARBOL_POS="+escape(document.#Attributes.form#.#Attributes.id##Attributes.index#.value)+"&form=#Attributes.form#&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir#&contables=#Attributes.contables#&titulo=#JSStringFormat(Attributes.titulo)#&Ecodigo=#attributes.Ecodigo#&proyectos=#Attributes.proyectos#&usuario=#Attributes.usuario#</cfoutput>";
	<cfelse>
		if (! #LvarEcodigoName#)
		{
			alert("Campo de Empresa '#LvarEcodigoName#' no existe");
			return;
		}
		if (#LvarEcodigoName#.value.replace(/\s*/,"") == "")
		{
			alert("Empresa no puede estar en blanco");
			return;
		}
		params = "?ARBOL_POS="+escape(document.#Attributes.form#.#Attributes.id##Attributes.index#.value)+"&form=#Attributes.form#&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir#&titulo=#JSStringFormat(Attributes.titulo)#&proyectos=#Attributes.proyectos#&usuario=#Attributes.usuario#&Ecodigo=" + #LvarEcodigoName#.value;
	</cfif>
		popUpWindow#Attributes.name##Attributes.index#("/cfmx/ftec/Utiles/ConlisVicerrectoria.cfm"+params,250,200,#Attributes.width#,#Attributes.height#);
		window.onfocus=closePopup;
	}

	function closePopup() {
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
			popUpWin = null;
		}
	}
	
	function conlis_keyup_#Attributes.name##Attributes.index#(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisVicerrectoria#Attributes.name##Attributes.index#();
		}
	}
	
	//Obtiene la descripción con base al código
	function TraeVicerrectoria#Attributes.name##Attributes.index#(dato) {
		window.Vid = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.id#</cfoutput><cfoutput>#Attributes.index#</cfoutput>;
		window.Vcodigo = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput><cfoutput>#Attributes.index#</cfoutput>;
		window.Vdescripcion = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.desc#</cfoutput><cfoutput>#Attributes.index#</cfoutput>;
		var params ="";
	<cfif Attributes.EcodigoName EQ "">
		params = "&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir#&Ecodigo=#attributes.Ecodigo#&proyectos=#Attributes.proyectos#&usuario=#Attributes.usuario#";
	<cfelse>
		if (! #LvarEcodigoName#)
		{
			alert("Campo de Empresa '#LvarEcodigoName#' no existe");
			return;
		}
		if (#LvarEcodigoName#.value.replace(/\s*/,"") == "")
		{
			alert("Empresa no puede estar en blanco");
			return;
		}
		params = "&id=#Attributes.id##Attributes.index#&name=#Attributes.name##Attributes.index#&desc=#Attributes.desc##Attributes.index#&conexion=#Attributes.conexion#&excluir=#Attributes.excluir#&proyectos=#Attributes.proyectos#&usuario=#Attributes.usuario#&Ecodigo=" + #LvarEcodigoName#.value;
	</cfif>
		if (dato != "") {
			<cfoutput>
				var fr = document.getElementById("#Attributes.frame##Attributes.index#");
		/*Aqui se cae*/	fr.src="/cfmx/ftec/Utiles/FTvicerrectoriaquery.cfm?dato="+dato+"&form="+"#Attributes.form#"+params;
			</cfoutput>
		}
		else{
			document.#Attributes.form#.#Attributes.id##Attributes.index#.value   = "";
			document.#Attributes.form#.#Attributes.name##Attributes.index#.value = "";
			document.#Attributes.form#.#Attributes.desc##Attributes.index#.value = "";
		}
		return;
	}	

</script>

<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<!--- <cfset id   = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')##Evaluate('Attributes.index')#')#')"> --->
		<!--- <cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')##Evaluate('Attributes.index')#')#')"> --->
		<!--- <cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')##Evaluate('Attributes.index')#')#')"> --->

		<!--- Se modifican estos dos por que dan problemas cuando se les digita # en el nombre o descripcion --->
		<cfset id   = Trim(Evaluate('Attributes.query.#Attributes.id##Attributes.index#'))>
		<cfset name = Trim(Evaluate('Attributes.query.#Attributes.name##Attributes.index#'))>
		<cfset desc = Trim(Evaluate('Attributes.query.#Attributes.desc##Attributes.index#'))>
	</cfif>

	
	<tr>
		<td>
			<input type="text"
				name="#Attributes.name##Attributes.index#" id="#Attributes.name##Attributes.index#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#name#</cfif>"
				size="#attributes.codigosize#" 
				maxlength="10"
				<cfif Attributes.readOnly>
					tabindex="-1"
					readonly
					style="border:solid 1px ##CCCCCC; background:inherit;"
				<cfelse>
					<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
					onBlur="javascript: TraeVicerrectoria#Attributes.name##Attributes.index#(document.#Attributes.form#.#Attributes.name##Attributes.index#.value); " 
					onkeyup="javascript:conlis_keyup_#Attributes.name##Attributes.index#(event);"
					onFocus="javascript:this.select();">
				</cfif>
		</td>

		<td nowrap>
			<input type="text"
				name="#Attributes.desc##Attributes.index#" id="#Attributes.desc##Attributes.index#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#desc#</cfif>" 
				size="#Attributes.size#" maxlength="80"

				tabindex="-1"
				readonly
				>
		</td>
		<td>
        	<cfif not Attributes.readOnly>
			<a href="##" tabindex="-1">
				<img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_Vicerrectorias#" name="imagen" id="imagen" 
					 width="18" height="14" border="0" align="absmiddle" 
					 onClick='javascript: doConlisVicerrectoria#Attributes.name##Attributes.index#();'>
			</a>
				<input type="hidden" name="#Attributes.id##Attributes.index#" 
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#id#</cfif>" >


<iframe name="#Attributes.frame##Attributes.index#" id="#Attributes.frame##Attributes.index#" 
		marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" 
		style="display:none;"></iframe>
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>