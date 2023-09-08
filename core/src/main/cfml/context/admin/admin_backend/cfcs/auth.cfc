<cfcomponent rest="true" restpath="APIroutes">

    <cfscript>
        var response = getPageContext().getResponse();
        response.setHeader("Access-Control-Allow-Origin","*");
    </cfscript>
    <!--- Function to validate token--->
    <cffunction name="authenticate" access="remote" returntype="any">
        
        <cfscript>
            var response = getPageContext().getResponse();
            response.setHeader("Access-Control-Allow-Origin","*");
        </cfscript>
        <cfargument name="login_password#Arguments.adminType#" type="string" required="yes">
        <cfargument name="adminType" type="string" required="yes">
        <cfargument name="lang" type="string" required="yes">
        <cfargument name="captcha" type="string" required="no">
        <cfargument name="rememberMe" type="string" required="no" default="s">
        
        
        <cfset var response = {}>


        <!--- <cfif structKeyExists(form, "login_password" & Arguments.adminType)> ---> 
            <cfadmin 
                action="getLoginSettings"
                type="#Arguments.adminType#"
                returnVariable="loginSettings"
            >

            <cfset loginPause = loginSettings.delay>
            <cfset keyLTL="lastTryToLogin"&":"& Arguments.adminType&":"&(cgi.context_path?:"")>
            <cfif loginPause && structKeyExists(application, keyLTL) && isDate(application[keyLTL]) && DateDiff("s", application[keyLTL], now()) LT loginPause>
                <cfset login_error = "Login disabled until #lsDateFormat(dateAdd("s", loginPause, application[keyLTL]))# #lsTimeFormat(dateAdd("s", loginPause, application[keyLTL]),'hh:mm:ss')#">
            <cfelse>
                <cfset application[keyLTL] = now()>
                <cfparam name="Arguments.captcha" default="">

                <cfif loginSettings.captcha && structKeyExists(session, "cap") && compare(Arguments.captcha,session.cap) != 0>
                    <cfset login_error = "Invalid security code (captcha) definition">
                <cfelse>
                
                    <cfadmin 
                        action="hashPassword"
                        type="#Arguments.adminType#"
                        pw="#Arguments["login_password"&Arguments.adminType]#"+
                        returnVariable="hashedPassword"
                    >

                    <cfset session["password" & Arguments.adminType]=hashedPassword>
                    <cfset session.lucee_admin_lang=Arguments.lang>
                    <!--- Thread operation for update provider --->
                    <cfcookie expires="NEVER" name="lucee_admin_lang" value="#session.lucee_admin_lang#">
                    <cfif Arguments.rememberMe != "s">
                        <cfcookie
                            expires="#dateAdd(Arguments.rememberMe, 1, now())#"
                            name="lucee_admin_pw_#Arguments.adminType#"
                            value="#hashedPassword#">
                    <cfelse>
                        <cfcookie expires="Now" name="lucee_admin_pw_#Arguments.adminType#" value="">
                    </cfif>
                    <cfif isDefined("cookie.lucee_admin_lastpage") && cookie.lucee_admin_lastpage != "logout">
                        <cfset url.action = cookie.lucee_admin_lastpage>
                    </cfif>
                </cfif>
            </cfif>
        <!--- </cfif> --->

        


    
        <cfset var response = {}>
        <cfset requestData = GetHttpRequestData()>
        <cfif StructKeyExists( requestData.Headers, "authorization" )>
            <cfset token = GetHttpRequestData().Headers.authorization>
            <cftry>
                <cfset jwt = new cfc.jwt(Application.jwtkey)>
                <cfset result = jwt.decode(token)>
                <cfset response["success"] = true>
                <cfcatch type="Any">
                <cfset response["success"] = false>
                <cfset response["message"] = cfcatch.message>
                <cfreturn response>
                </cfcatch>
            </cftry>
        <cfelse>
            <cfset response["success"] = false>
            <cfset response["message"] = "Authorization token invalid or not present.">
        </cfif>
        <cfreturn response>
        
    </cffunction>

    <!--- User Login--->
    <cffunction name="login" restpath="login" access="public" returntype="String" returnFormat="JSON" httpmethod="POST" produces="application/json">
    
        <cfargument name="password" type="string" required="yes">
        <cfargument name="adminType" type="string" required="yes">

        <cfset var response = {}>
        <cftry>
            <cfadmin 
                action="connect"
                type="#Arguments.adminType#"
                password="#Arguments.password##Arguments.adminType#"
            >
            
            <cfif Arguments.adminType == "server">
                <cfadmin 
                    action="getDevelopMode"
                    type="#Arguments.adminType#"
                    password="#Arguments.password##Arguments.adminType#"
                    returnVariable="mode" 
                >
                <cfset response.isLoggedIn = true />
                <cfset response.message = "Logged In" />

                <cfif mode.developMode>
                    <cfset response.alwaysNew = true />
                </cfif>
            </cfif>

            <cfcatch>
                <cfset response.isLoggedIn = false />
                <cfset response.alwaysNew = false />
                <cfset response.message = cfcatch.message />
                <cfreturn SerializeJSON(response)>
            </cfcatch>
        </cftry>

        
        <cfreturn SerializeJSON(response)>

    </cffunction>

    <!--- User specific functions --->
    <cffunction name="getuser" restpath="user/{id}" access="remote" returntype="struct" httpmethod="GET" produces="application/json">

        <cfargument name="id" type="any" required="yes" restargsource="path"/>
        <cfset var response = {}>

        <cfset verify = authenticate()>
        <cfif not verify.success>
        <cfset response["success"] = false>
        <cfset response["message"] = verify.message>
        <cfset response["errcode"] = 'no-token'>
        <cfelse>
        <cfset response = objUser.userDetails(arguments.id)>
        </cfif>

        <cfreturn response>

    </cffunction>

</cfcomponent>