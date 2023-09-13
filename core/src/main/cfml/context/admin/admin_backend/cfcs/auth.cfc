<cfcomponent displayname="Auth" hint="This component contains functions related to Authentication">
    <!--- rest="true" restpath="APIroutes" --->
    <!---
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
                        pw="#Arguments["login_password"&Arguments.adminType]#"
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
    --->

    <!--- User Login--->
    <cffunction name="login" access="public" returntype="String" returnFormat="JSON"> <!---  httpmethod="POST" produces="application/json" --->
        <cfargument name="sForm" type="struct" required="yes" >

        <cfset var response = {}>

        <cfif !structKeyExists(sForm, "password") OR LEN(TRIM(sForm['password'])) EQ 0>
            <cfset response.success = false />
            <cfset response.message = 'Please enter a valid password' />

        <cfelseif !structKeyExists(sForm, "adminType") OR LEN(TRIM(sForm['adminType'])) EQ 0>
            <cfset response.success = false />
            <cfset response.message = 'No Admin type has been specified' />

        <cfelse>

            <cftry>

                <cfadmin action="getLoginSettings"
                    type="#sForm['adminType']#"
                    returnVariable="loginSettings"
                >

                <cfset loginPause = loginSettings.delay>
                <cfset keyLTL="lastTryToLogin"&":"& sForm['adminType']&":"&(cgi.context_path?:"")>
                <cfif loginPause && structKeyExists(application, keyLTL) && isDate(application[keyLTL]) && DateDiff("s", application[keyLTL], now()) LT loginPause>
                    <cfset login_error = "Login disabled until #lsDateFormat(dateAdd("s", loginPause, application[keyLTL]))# #lsTimeFormat(dateAdd("s", loginPause, application[keyLTL]),'hh:mm:ss')#">

                    <cfset response.login_error = login_error />

                <cfelse>
                    <cfset application[keyLTL] = now()>
                    <cfparam name="sForm['captcha']" default=""> 

                    <cfif loginSettings.captcha && structKeyExists(session, "cap") && compare(sForm['captcha'],session.cap) != 0>
                        <cfset login_error = "Invalid security code (captcha) definition">
                        <cfset response.login_error = login_error />

                    <cfelse>
                        <cfadmin action="hashPassword"
                            type="#sForm['adminType']#"
                            pw="#sForm['password']#"
                            returnVariable="hashedPassword"
                        >
                        
                        <cfset session["password" & sForm['adminType']]=hashedPassword> 
                        <cfset session.lucee_admin_lang=sForm['language']>
                    
                        <!--- Thread operation for update provider --->
                        <cfcookie expires="NEVER" name="lucee_admin_lang" value="#sForm['language']#"> 
                        <cfif sForm['remember'] != "s">
                            <cfcookie
                                expires="#dateAdd(sForm['remember'], 1, now())#"
                                name="lucee_admin_pw_#sForm['adminType']#"
                                value="#hashedPassword#">
                        <cfelse>
                            <cfcookie expires="Now" name="lucee_admin_pw_#sForm['adminType']#" value="">
                        </cfif>
                        <cfif isDefined("cookie.lucee_admin_lastpage") && cookie.lucee_admin_lastpage != "logout">
                            <cfset url.action = cookie.lucee_admin_lastpage>
                        </cfif>
                    </cfif>
                </cfif>          
    

                <cfif isDefined('hashedPassword')>

                    <cfadmin 
                        action="connect"
                        type="#sForm['adminType']#"
                        password="#hashedPassword#" 
                    >

                    <cfset response.isLoggedIn = true />
                    <cfset response.message = "Logged In" />
                    
                    
                    <cfif sForm['adminType'] == "server">
                        <cfadmin 
                            action="getDevelopMode"
                            type="#sForm['adminType']#"
                            <!--- password="#sForm['password']##sForm['adminType']#" --->
                            password="#hashedPassword#"
                            returnVariable="mode" 
                        >
                        

                        <cfif mode.developMode>
                            <cfset response.alwaysNew = true />
                        </cfif>
                    </cfif>

                </cfif>

                <cfcatch>
                    <cfset response.isLoggedIn = false />
                    <cfset response.alwaysNew = false />
                    <cfset response.message = cfcatch.message />
                    <cfreturn SerializeJSON(response)>
                </cfcatch>
            </cftry>

        </cfif>
        

        
        <cfreturn SerializeJSON(response)>
    
    </cffunction>

    <!---
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
    --->

</cfcomponent>