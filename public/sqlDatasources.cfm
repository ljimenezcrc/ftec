
<!--- initialize the admin API --->
<cfset Administrator = CreateObject("component","cfide.adminapi.administrator")/>

<!--- login is always required --->
<cfset Administrator.login(adminpassword="cfusion",adminuserid="admin")/>

<!--- instantiate the data source object --->
<cfset Datasource = CreateObject("component","CFIDE.adminapi.datasource")/>

<!---lista de bases de datos--->
<cfset myListDataBase 	=  'asp,aspmonitor,minisif,sif_control,sif_interfaces,sif_publica'>
<cfset myDatabase 	= listtoarray(myListDataBase,',')>

<!---lista de nombres para los datasources--->
<cfset myListName 	=  'asp,aspmonitor,minisif,sifcontrol,sifinterfaces,sifpublica'>
<cfset myName		= listtoarray(myListName,',')>
<cfset args = {}/>


<cfif isdefined('form.server') and len(ltrim(#form.server#)) NEQ 0>
	<cfset args.host = "#form.server#"/>
<cfelseif isdefined('form.server1') and #form.server1# NEQ -1>
	<cfset args.host = "#form.server1#"/>
<cfelse>
	Servidor no definido
	<cfabort>
</cfif>

<cfif isdefined('form.user') and len(ltrim(#form.user#)) EQ 0>
	Usuario no definido
	<cfabort>
</cfif>
<cfif isdefined('form.pass') and len(ltrim(#form.pass#)) EQ 0>
	Password no definido
	<cfabort>
</cfif>


<cfset args.username 	= "#form.user#"/>
<cfset args.password 	= "#form.pass#"/>
<cfset args.password 	= "#form.pass#"/>
<cfset args.port	 	= "#form.port#"/>



<cfoutput>
<cfloop from="1" to ="#arraylen(myDatabase)#" index="i">
	<cfset args.name 		= "#myName[i]#"/>
	<cfset args.database	= "#myDatabase[i]#"/>
    
	<!--- create datasource --->
	<cfif #form.Database# EQ 1> <!---sybase--->
		<cfset Datasource.setSybase(argumentCollection=args)/>
    <cfelseif #form.Database# EQ 2> <!---mssql--->
		<cfset Datasource.setMSSQL(argumentCollection=args)/>
    </cfif>
    <!--- verify datasource --->
	<cfset verified = Datasource.verifyDSN(dsn=args.name,returnMsgOnError=true)/>
    
    <!--- if unverified show the error message --->
    <cfif IsBoolean(verified) And verified>
      <h2>Datasource #args.name# verified!</h2> 
    <cfelse>
       <h2>#verified#</h2>
	</cfif>
</cfloop>
</cfoutput>
<form action="Datasources.cfm">
	<input type="submit" name="Regresa" value="Regresar"  />
</form>	










