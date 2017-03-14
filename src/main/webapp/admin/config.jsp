<!--
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
 *	Description:			Configuration Page for Basic LTI Launcher Building Block
 *	Date Created:			12/03/2010
 *	Comments:
 *	ToDo:
 */
 -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,
java.text.*,
blackboard.data.*,
blackboard.persist.*,
blackboard.db.*,
blackboard.base.*,
blackboard.platform.*,
blackboard.platform.log.*,
blackboard.platform.session.*,
blackboard.platform.persistence.*,
blackboard.platform.plugin.*,
blackboard.platform.db.*,
java.io.*,
java.util.*,
java.util.prefs.*,
javax.servlet.http.HttpServletRequest,
blackboard.platform.vxi.data.VirtualInstallation,
blackboard.platform.vxi.service.VirtualInstallationManagerFactory,
blackboard.data.blti.BasicLTIPlacement,
blackboard.persist.blti.BasicLTIPlacementDAO"

%>

<%@ taglib uri="/bbNG" prefix="bbNG"%>
<%!

  static final String BLTI_URL 		= "bltiUrl";
  static final String BLTI_KEY 		= "bltiKey";
  static final String BLTI_SECRET	= "bltiSecret";

  File _configFile = null;

  private void saveProps( HttpServletRequest request ) throws IOException
  {
	  ContentHandler handler = null;

	    Preferences prefs = Preferences.systemNodeForPackage(PrefUtil.class);
      prefs.put( BLTI_URL, request.getParameter( BLTI_URL ) );
      prefs.put( BLTI_KEY, request.getParameter( BLTI_KEY ) );
      prefs.put( BLTI_SECRET, request.getParameter( BLTI_SECRET ) );

      try{
    	  prefs.flush();
      } catch(BackingStoreException bse) {

      }
%>
<bbNG:genericPage title="Configure Basic LTI Sample Plug-in" entitlement="system.admin.VIEW">
  <bbNG:jspBlock>
    <%
        String bltiUrl = "";
        String bltiKey = "";
        String bltiSecret = "";

        if( request.getMethod().equals( "POST" ) )
        {
          saveProps( request );
          response.sendRedirect("../../blackboard/admin/manage_plugins.jsp");
        }

        Preferences prefs = Preferences.systemNodeForPackage(PrefUtil.class);
        bltiUrl = prefs.get( BLTI_URL,"http://www.imsglobal.org/developers/LTI/test/v1p1/tool.php" );
        bltiKey = prefs.get( BLTI_KEY, "blti_key_default" );
        bltiSecret = prefs.get( BLTI_SECRET, "secret" );

        pageContext.setAttribute("bltiUrl",bltiUrl);
        pageContext.setAttribute("bltiKey",bltiKey);
        pageContext.setAttribute("bltiSecret",bltiSecret);
    %>
  </bbNG:jspBlock>
  <bbNG:pageHeader>
  	<bbNG:breadcrumbBar environment="SYS_ADMIN" navItem="admin_main">
      <bbNG:breadcrumb>IMS Global Basic LTI Sample</bbNG:breadcrumb>
    </bbNG:breadcrumbBar>
    <bbNG:pageTitleBar iconUrl="../images/bbapLogo.gif" title="Configure Basic LTI Sample Plugin"/>
  </bbNG:pageHeader>
  <bbNG:form action="config.jsp" method="POST">
    <bbNG:dataCollection markUnsavedChanges="true" showSubmitButtons="true" hasRequiredFields="true">
      <bbNG:step title="Set Global Connection Properties">
        <bbNG:dataElement label="Consumer URL" isRequired="true">
          <bbNG:textElement type="string" name="<%=BLTI_URL%>" value="${bltiUrl}" minLength="1" size="80" title="Consumer URL"/>
        </bbNG:dataElement>
        <bbNG:dataElement label="Consumer Key" isRequired="true">
          <bbNG:textElement name="<%=BLTI_KEY%>" value="${bltiKey}"/>
        </bbNG:dataElement>
        <bbNG:dataElement label="Shared Secret" isRequired="true">
          <bbNG:textElement name="<%=BLTI_SECRET%>" value="${bltiSecret}"/>
        </bbNG:dataElement>
      </bbNG:step>
      <bbNG:stepSubmit title="Submit"/>
    </bbNG:dataCollection>
  </bbNG:form>
</bbNG:genericPage>
