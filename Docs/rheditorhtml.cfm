<cfparam name="Attributes.name" 		default="MyTextArea" type="string" >
<cfparam name="Attributes.toolbarset" 	default="SIF" 		 type="string" >
<cfparam name="Attributes.value" 		default="" 			 type="string" >
<cfparam name="Attributes.indice" 		default="" 			 type="string" >
<cfparam name="Attributes.width"  		default="100%" 		 type="string">
<cfparam name="Attributes.height" 		default="200" 		 type="string">
<cfparam name="Attributes.ControlsE" 	default="" 		 	 type="string"><!---Controles extras, Ejm = "[ 'Save']," --->

<cfset Attributes.value = replace(replace(Attributes.value, chr(13), ' ','all'),chr(10),'','all') >
<cfif not isdefined("Request.editorjs") >
	<cfparam name="Request.editorjs" default="true">
	<script type="text/javascript" src="/cfmx/rh/js/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="/cfmx/rh/js/ckeditor/config.js"></script>
</cfif>


<textarea name="<cfoutput>#Attributes.name##Attributes.indice#</cfoutput>" id="<cfoutput>#Attributes.name##Attributes.indice#</cfoutput>"><cfoutput>#Attributes.value#</cfoutput></textarea>



<script type="text/javascript">

	CKEDITOR.replace( '<cfoutput>#Attributes.name##Attributes.indice#</cfoutput>',{toolbar : [
					<cfoutput>#Attributes.ControlsE#</cfoutput>
            		['Styles', 'Format', 'Font', 'FontSize', 'Table', 'TextColor', 'BGColor', 'PageBreak'],
            		['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', '-', 'About'],
					'/', ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'], 
					['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['Image','Table','HorizontalRule','SpecialChar','PageBreak','Iframe']
        		]
} );
</script>

