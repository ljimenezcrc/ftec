
<cfif isdefined("Form.chk")>
	<cfset pagos = ListToArray(Form.chk, ',')>
	<cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
		<cfset LvarDetOC 			= ListToArray(LvarLin, "|")>
		<cfset LvarPos1SPid 		= LvarDetOC[1]>
		<cfset LvarPos2DOlinea 		= LvarDetOC[2]>

		<!---Calculo el monto surtido de la OC---->
		<cfquery name="rsMSOC" datasource="#session.dsn#">
			Select 
				case DOcontrolCantidad 
					when 0 then coalesce(DOmontoSurtido,0) 
					else 0 end as DOmontoSurtido 
			  from DOrdenCM 
				where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
		</cfquery> 
		<cfquery name="rsInsert" datasource="#Session.DSN#">			
				select	#LvarPos1SPid# as SPid,
						a.DOlinea,
                        <!---►Se hace de esta manera, ya que si es Corporativas tiene los Conceptos de la corporativa--->
						(select Cid from  Conceptos where Ecodigo = #session.Ecodigo# and Ccodigo = f.Ccodigo) Cid,
						a.Alm_Aid,
						a.Ecodigo,
						dep.Dcodigo,
						a.CFid,
						a.Aid,
						a.DOdescripcion,
						 <cf_dbfunction name="sPart"	args="a.DOalterna,1,255">,
                        case when a.DOcontrolCantidad = 1 
                            then 
                               a.DOpreciou
                            else
                               a.DOtotal -coalesce(a.DOmontoSurtido,0) - a.DOmontodesc
                             end 
                         as DOpreciou,
						a.DOporcdesc,
						00,
						a.CMtipo,
						a.Icodigo,
						e.Ucodigo,
						a.FPAEid, 
						a.CFComplemento, 
						a.PCGDid, 
						a.OBOid,
						a.CFcuenta,
						Coalesce(vft.Vid,-1) Vid
						
						,(a.DOcantidad - a.DOcantsurtida 
						<!---Menos Cantidad en digitacion de CxP--->
						- Coalesce((select sum(dcp.DDcantidad)
								from DDocumentosCxP dcp
							  where dcp.DOlinea = a.DOlinea			
							 ),0)
						<!---Menos Cantidad en Digitacion de SP---> 
						- Coalesce((select Count(1)
							from <cf_dbdatabase table="FTDSolicitudProceso" datasource="ftec"> dsp
						  where dsp.DOlinea = a.DOlinea			
						 ),0))
						as DOSaldocantidad

				from DOrdenCM a
					left outer join Articulos e
						on a.Aid = e.Aid
			
					left outer join Conceptos f
						 on a.Cid = f.Cid
					
					left outer join Unidades u
						 on e.Ucodigo = u.Ucodigo
						and e.Ecodigo = u.Ecodigo	
						
					inner join CFuncional cf
						on cf.CFid = a.CFid
						
					left outer join <cf_dbdatabase table="FTVicerrectoria" datasource="ftec"> vft
						on vft.CFid = cf.CFid
							
					inner join Departamentos dep
						 on dep.Dcodigo = cf.Dcodigo
						and dep.Ecodigo = cf.Ecodigo
				where a.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
				Order by DOconsecutivo			
		</cfquery>

		<cfinvoke component="ftec.Componentes.FTSolicitudProceso" method="AltaDetalle" returnvariable="Lvar_ID" >
            <cfinvokeargument name="SPid" 			value="#rsInsert.SPid#">
            <cfinvokeargument name="Vid" 			value="#rsInsert.Vid#">
            <cfinvokeargument name="Cid" 			value="#rsInsert.Cid#">
			<cfinvokeargument name="CFid" 			value="#rsInsert.CFid#">
            <cfinvokeargument name="Icodigo" 		value="#rsInsert.Icodigo#">
            <cfinvokeargument name="DSPdescripcion"	value="#rsInsert.DOdescripcion#">
            <cfinvokeargument name="DSPmonto"		value="#rsInsert.DOpreciou * rsInsert.DOSaldocantidad#">
            <cfinvokeargument name="Debug"			value="false">
			<cfinvokeargument name="DOlinea"		value="#rsInsert.DOlinea#">
			<cfinvokeargument name="PrecioU"		value="#rsInsert.DOpreciou#">
			<cfinvokeargument name="Cantidad"		value="#rsInsert.DOSaldocantidad#">
        </cfinvoke>

		
	</cfloop>

	<script language="JavaScript" type="text/javascript">
		if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
		window.close();
	</script>
</cfif>