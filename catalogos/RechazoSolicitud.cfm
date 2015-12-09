<html>
	<head>
		<title>Justificar Rechazo</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cf_templatecss>
	</head>

	<body>
		<form action="" method="post" name="justifica">
			<div id="dialogRechazarDocs" class="dialogTexto">
				<div>
					<label for="dlMotivoRechazo" class="etiqueta" style="display:block">Motivo del Rechazo</label>
					<i class="fa fa-trash-o" style="float:right;cursor:pointer"></i>
					<textarea name="dlMotivoRechazo" id="dlMotivoRechazo"
					style="width:100%;height:75px;"></textarea>
				</div>
				<p>Al rechazar la solicitud, se cambia el estado a digitacion</p>
				<p>
					¿Desea Continuar?
				</p>
				<input type="button" id="btnRechazarSolicitud" name="btnAprobarSolicitud" 
															onClick="RechazarSolicitud();"
															style="margin-top:10px" value="Rechazar Solicitud" class="btn btn-danger">
				
				<input type="button" id="btnRegresar" name="btnRegresar" 
															onClick="Regresar();"
															style="margin-top:10px" value="Regresar" class="btn btn-danger">												
			</div>
		</form>
<!--- --->
<script type="text/javascript">
		function RechazarSolicitud() {
		// limpiar();
		window.opener.document.getElementById("actionJustificacion").value = document.justifica.dlMotivoRechazo.value;
		window.opener.document.getElementById("AccionRechazo").value = 'Rechazo';
		window.opener.document.fEncabezado.submit();
		window.close();
	}


	function Regresar() {
		window.close();
	}
	
</script>



	</body>
</html>