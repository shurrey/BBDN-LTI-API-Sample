<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
/* Copyright (C) 2011, Blackboard Inc.
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  -- Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *  -- Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 *  -- Neither the name of Blackboard Inc. nor the names of its contributors 
 *     may be used to endorse or promote products derived from this 
 *     software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY BLACKBOARD INC ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL BLACKBOARD INC. BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 *	Author: 				Scott Hurrey
 *	Description:			Tool for LTI 1.0 Launcher Building Block
 *	Date Created:			12/03/200
 *	Comments:				
 *	ToDo:					Build bltiLauncher when user clicks on tool link.
 */
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.HashMap,
				 java.util.prefs.Preferences,
				 blackboard.platform.blti.BasicLTILauncher,
				 com.blackboard.developer.PrefUtil
				 "
%>

<%@ taglib uri="/bbNG" prefix="bbNG"%>

<bbNG:learningSystemPage ctxId="ctx" title="LTI 1.0 Launch Tool" entitlement="course.tools.VIEW">


<%

  HashMap<String,String> customParamMap = new HashMap<String,String>();
  
  customParamMap.put("linkType","Blackboard Tool");
  
  PrefUtil pu = new PrefUtil().getProps();
  %>


<bbNG:breadcrumbBar navItem="course">
    <bbNG:breadcrumb title="Launch LTI 1.0 Sample Tool" />
</bbNG:breadcrumbBar>

<bbNG:pageHeader>
  <bbNG:pageTitleBar iconUrl="images/bbapLogo.gif" title="Launch IMS Global Basic LTI Sample Tool" />
</bbNG:pageHeader>

<%
/* 
 *	Instantiate BasicLTILauncher object
 *	BasicLTILauncher(String url, String key, String secret, String resourceLinkID)
 *		.addResourceLinkInformation(String title, String description)
 *		.addCurrentUserInformation(boolean includeRole, boolean includeName, boolean includeEmail)
 *		.addCurrentCourseInformation(void)
 *		.addCustomToolParameters (Map<String, String> params)
 *		.addLaunchPresentationInformation (Map<String,String> params);
 */
	BasicLTILauncher launcher = new BasicLTILauncher( pu.getUrl(), pu.getKey(), pu.getSecret(), "BbTool" )
       .addResourceLinkInformation( "LTI 1.0 Sample Launch Tool", "LTI 1.0 Sample Launch Tool" )
       .addCurrentUserInformation( true, true, true )
       .addCurrentCourseInformation()
       .addCustomToolParameters( customParamMap );

	//Launch BLTI connection 
	//launch(HttpServletRequest request, HttpServletResponse response, boolean showSplashScreen, FormattedText splashMessage)
 	launcher.launch( request, response, false, null );
%>
</bbNG:learningSystemPage>