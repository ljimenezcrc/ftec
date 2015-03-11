<cf_dbfunction name="op_concat" returnvariable="_cat">

<div class="row">
    <div class="col-sm-12">
        <cfquery name="rsLista" datasource="ftec">
            select a.PCid
                , a.Cid
                ,a.PCTidentificacion
                ,a.PCIdentificacion
                ,a.PCApellido1 #_cat# ' ' #_cat#  a.PCApellido2  #_cat# ' ' #_cat# a.PCNombre as Nombre
                ,case 
                    when a.PCEstado = 'P' then 'Proceso'
                    when a.PCEstado = 'T' then 'Tramite'
                    when a.PCEstado = 'A' then 'Aprobado'
                    when a.PCEstado = 'R' then 'Rechazado'
                    when a.PCEstado = 'F' then 'Finiquito'
                end as PCEstado
                
                ,a.PCEnumero
                ,a.PCEPeriodo
                ,b.Cdescripcion
                 ,{fn concat('<img border=''0''  width= ''30%''  onClick=''Comentario(',{fn concat(<cf_dbfunction name="to_char" args="a.PCid">,');'' src=''/cfmx/ftec/imagenes/ver.gif''>')})}  as ComStr
            from FTPContratacion a
                inner join FTContratos b
                    on b.Cid = a.Cid
            where a.PCEstado in  ('P','R','A')
        </cfquery>

        <cfinvoke component="commons.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
            <cfinvokeargument name="query" value="#rsLista#"/>
            <cfinvokeargument name="desplegar" value=" Cdescripcion,PCIdentificacion, Nombre, PCEstado,ComStr"/>
            <cfinvokeargument name="etiquetas" value="Contrato, Identificación, Nombre, Estado,Comentarios"/>
            <cfinvokeargument name="formatos" value=" S, S, S, S,I"/>
            <cfinvokeargument name="align" value="left, left, left,  left,center"/>
            <cfinvokeargument name="ajustar" value="N"/>
            <cfinvokeargument name="irA" value="Contratacion.cfm"/>
            <cfinvokeargument name="keys" value="PCid"/>
            <cfinvokeargument name="incluyeForm" value="false"/>
            <cfinvokeargument name="formName" 	value="fmContratacion"/>
        </cfinvoke>
        <!---<cfinvokeargument name="cortes" value="NombreC"/>--->
      
	</div>
</div>

<div class="row">
    <div class="col-sm-12" align="center">
		<input type="submit" name="btnNContracion" class="btn btn-info"     value="Nueva Contración" />
    </div>
</div> 


 <script language="JavaScript1.2" type="text/javascript">
 
            function Comentario(PCid) 
            { 
              window.open('/cfmx/ftec/contratos/operacion/PopupComentario.cfm?PCid='+PCid,'popup','width=850,height=400','mywindow');
            }
</script>