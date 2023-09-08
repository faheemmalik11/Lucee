<cfparam name="URL.m" default="">
<cfparam name="URL.c" default="">

<cfif LEN(TRIM(URL.c)) EQ 0 OR LEN(TRIM(URL.m)) EQ 0><cfabort></cfif> 
<cfdump var="#Application.cfcs#" />
	
<cfinvoke 
    component="#Application.cfcs#/#URL.c#.cfc"
    method = "#URL.m#"    
    returnvariable="res"
/>

<cfoutput>#res#</cfoutput>
