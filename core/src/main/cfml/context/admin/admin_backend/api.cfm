<cfparam name="URL.m" default="">
<cfparam name="URL.c" default="">

<cfif LEN(TRIM(URL.c)) EQ 0 OR LEN(TRIM(URL.m)) EQ 0><cfabort></cfif> 
	
<cfheader name="Access-Control-Allow-Origin" value="http://localhost:5173"/>

<cfinvoke 
    component="cfcs/#URL.c#"
    sForm="#DeserializeJSON(GetHTTPRequestData().content)#"
    method = "#URL.m#"    
    returnvariable="res"
/>


<cfoutput>#res#</cfoutput>
