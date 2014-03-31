<tr>
     <td  class="fileLabel">Forma de Pago:
        <select name="FPid">
            <option value="">--- Seleccionar ---</option>
            <cfloop query="rsFPagos">
                <option value="#FPid#" <cfif modo EQ 'CAMBIO' and rsFPagos.FPid EQ rsSolicitudProcesos.FPid> selected</cfif>>#FPdescripcion#</option>
            </cfloop>
        </select>
    </td>
</tr>