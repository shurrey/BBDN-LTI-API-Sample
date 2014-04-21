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
 *	Description:			Modification Page for content handlers - Basic LTI Launcher Building Block
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
                blackboard.data.course.*,
                blackboard.data.user.*,
                blackboard.persist.course.*,
                blackboard.data.content.*,
                blackboard.persist.content.*,
                blackboard.db.*,
                blackboard.base.*,
                blackboard.platform.*,
                blackboard.platform.log.*,
                blackboard.platform.persistence.*,
                blackboard.platform.plugin.*,
                blackboard.platform.security.*,
                  blackboard.platform.session.*,
                blackboard.servlet.data.*,
                blackboard.platform.db.*"
    errorPage="/error.jsp"
%>

<%@ taglib uri="/bbNG" prefix="bbNG"%>

<bbNG:learningSystemPage ctxId="ctx">

<%
  if (!PlugInUtil.authorizeForCourseEditableContent(request, response))
    return;

  BbPersistenceManager bbPm = PersistenceServiceFactory.getInstance().getDbPersistenceManager();
  Container bbContainer = bbPm.getContainer();

  Id contentId = new PkId( bbContainer, CourseDocument.DATA_TYPE, request.getParameter("content_id") );
  Id courseId = bbPm.generateId( Course.DATA_TYPE, request.getParameter( "course_id" ) );
  String contentType = request.getParameter( "contentType");

  ContentDbLoader courseDocumentLoader = (ContentDbLoader) bbPm.getLoader( ContentDbLoader.TYPE );
  Content courseDoc = courseDocumentLoader.loadById( contentId );

  FileLocation fileLoc = new ContentFileLocation( courseDoc, ctx, request );

  pageContext.setAttribute("contentType",contentType);
%>

  <bbNG:breadcrumbBar environment="CTRL_PANEL" navItem="content" isContent="true" >
    <bbNG:breadcrumb>Modify IMS Global Basic LTI Sample ${contentType}</bbNG:breadcrumb>
  </bbNG:breadcrumbBar>

  <bbNG:pageHeader>
    <bbNG:pageTitleBar title="Modify IMS Global Basic LTI Sample ${contentType}" iconUrl="../images/bbapLogo.gif" />
  </bbNG:pageHeader>

  <bbNG:form action="modify_proc.jsp" method="post" enctype="multipart/form-data" onsubmit="finalizeEditors(); return true;">
    <input type=hidden name=content_id value="${param.content_id}">
    <input type=hidden name=course_id value="${param.course_id}">
    <input type=hidden name=contentType value="${contentType}">
  
	<bbNG:dataCollection>
    <bbNG:step title="Enter IMS Global Basic LTI Sample Content Information">
      <bbNG:dataElement isRequired="true" label="Title">
	     <bbNG:textElement name="title" value="<%=courseDoc.getTitle()%>"/>
	  </bbNG:dataElement>

	 <bbNG:dataElement isRequired="true" label="Basic LTI Custom Parameter 1">
	 	<bbNG:textElement name="customParameter1" value="<%=courseDoc.getExtendedData().getValue(\"customParameter1\")%>" />
	 </bbNG:dataElement>
	 
	 <bbNG:dataElement isRequired="true" label="Basic LTI Custom Parameter 2">
	 	<bbNG:textElement name="customParameter2" value="<%=courseDoc.getExtendedData().getValue(\"customParameter2\")%>" />
	 </bbNG:dataElement>
	 
	 <bbNG:dataElement isRequired="true" label="Basic LTI Custom Parameter 3">
	 	<bbNG:textElement name="customParameter3" value="<%=courseDoc.getExtendedData().getValue(\"customParameter3\")%>" />
	 </bbNG:dataElement>
	 
	 <bbNG:dataElement isRequired="true" label="Basic LTI Custom Parameter 4">
	 	<bbNG:textElement name="customParameter4" value="<%=courseDoc.getExtendedData().getValue(\"customParameter4\")%>" />
	 </bbNG:dataElement>
	 
    </bbNG:step>
    
    <input type=hidden name=title value="${title}">
  	<input type=hidden name=customParameter1 value="${customParameter1}">
  	<input type=hidden name=customParameter2 value="${customParameter2}">
  	<input type=hidden name=customParameter3 value="${customParameter3}">
  	<input type=hidden name=customParameter4 value="${customParameter4}">
  	
  	<bbNG:stepSubmit title="Submit" cancelUrl='${canclURL}' />
   </bbNG:dataCollection>

  </bbNG:form>

</bbNG:learningSystemPage>
