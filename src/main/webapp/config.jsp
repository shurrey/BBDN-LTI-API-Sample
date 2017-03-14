<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--
/* Copyright (C) 2013, Blackboard Inc.
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
 *	Description:			Configuration Page for LTI 1.0 Launcher Building Block
 *	Date Created:			11/11/2013
 *	Comments:
 *	ToDo:
 */
 -->

<%@page import="blackboard.platform.plugin.PlugInUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ page import="java.lang.System,
				 java.util.prefs.Preferences,
				 java.util.prefs.BackingStoreException,
				 blackboard.platform.plugin.PlugInUtil,
				 com.blackboard.developer.PrefUtil"
%>

<%@ taglib uri="/bbNG" prefix="bbNG"%>

<bbNG:genericPage title="Configure Basic LTI Sample Plug-in" entitlement="system.admin.VIEW">
  <bbNG:jspBlock>
    <%
        String bltiUrl = "";
        String bltiKey = "";
        String bltiSecret = "";

        if( request.getMethod().equals( "POST" ) )
        {
        	try{
        		Preferences prefs = Preferences.systemNodeForPackage(PrefUtil.class);
        	  	pu.saveProps(request.getParameter( "BLTI_URL" ),
        			  		request.getParameter( "BLTI_KEY" ),
        			  		request.getParameter( "BLTI_SECRET" ));

          	} catch(BackingStoreException bse) {
            	  System.err.println("Error Saving Properties");
        	}

          	response.sendRedirect(PlugInUtil.getPlugInManagerURL());
        }

        PrefUtil pu = new PrefUtil().getProps();

        pageContext.setAttribute("bltiUrl",pu.getUrl());
        pageContext.setAttribute("bltiKey",pu.getKey());
        pageContext.setAttribute("bltiSecret",pu.getSecret());
    %>
  </bbNG:jspBlock>
  <bbNG:pageHeader>
  	<bbNG:breadcrumbBar environment="SYS_ADMIN" navItem="admin_main">
      <bbNG:breadcrumb>LTI 1.0 Launch Configuration</bbNG:breadcrumb>
    </bbNG:breadcrumbBar>
    <bbNG:pageTitleBar iconUrl="../images/bbapLogo.gif" title="LTI 1.0 Launch Configuration"/>
  </bbNG:pageHeader>
  <bbNG:form action="config.jsp" method="POST">
    <bbNG:dataCollection markUnsavedChanges="true" showSubmitButtons="true" hasRequiredFields="true">
      <bbNG:step title="Set Global Connection Properties">
        <bbNG:dataElement label="Consumer URL" isRequired="true">
          <bbNG:textElement type="string" name="BLTI_URL" value="${bltiUrl}" minLength="1" size="80" title="Consumer URL"/>
        </bbNG:dataElement>
        <bbNG:dataElement label="Consumer Key" isRequired="true">
          <bbNG:textElement name="BLTI_KEY" value="${bltiKey}"/>
        </bbNG:dataElement>
        <bbNG:dataElement label="Shared Secret" isRequired="true">
          <bbNG:textElement name="BLTI_SECRET" value="${bltiSecret}"/>
        </bbNG:dataElement>
      </bbNG:step>
      <bbNG:stepSubmit title="Submit"/>
    </bbNG:dataCollection>
  </bbNG:form>
</bbNG:genericPage>
