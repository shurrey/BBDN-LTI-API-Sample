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
 *	Description:			Processing Page content creation - Basic LTI Launcher Building Block
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
                blackboard.data.blti.*,
                blackboard.data.course.*,
                blackboard.data.user.*,
                blackboard.persist.blti.*,
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
                blackboard.platform.filesystem.*,
                blackboard.servlet.data.*,
                blackboard.platform.db.*,
                blackboard.persist.gradebook.LineitemDbPersister,
                blackboard.data.gradebook.Lineitem,
                blackboard.persist.gradebook.*,
                blackboard.platform.gradebook2.*,
                blackboard.data.gradebook.*,
                blackboard.platform.gradebook2.impl.*"
	errorPage="/error.jsp"%>
	
<%@ taglib uri="/bbNG" prefix="bbNG"%>


<bbNG:learningSystemPage entitlement="course.control_panel.VIEW" ctxId="ctx">

<%
  if (!PlugInUtil.authorizeForCourseControlPanel(request, response))
    return;

   // Create a multi-part request instance
  MultipartRequest mr = FileSystemServiceFactory.getInstance().processUpload( request );

  String course_id = mr.getParameter( "course_id" );
  String folder_id = mr.getParameter( "content_id" );

  Id courseId = Id.generateId( Course.DATA_TYPE, course_id );
  Id folderId = Id.generateId( Content.DATA_TYPE, folder_id );

  ContentDbLoader loader = ContentDbLoader.Default.getInstance();
  ContentDbPersister persister= ContentDbPersister.Default.getInstance();
  
  String contentType = mr.getParameter( "contentType");
  String resourceType = "";
  
  if(contentType == "content")
	  resourceType="resource/x-bbap-lti1-sample1";
  else
	  resourceType="resource/x-bbap-lti1-sample2";
	  
  Content courseDoc = new Content();
  courseDoc.setContentHandler("resource/x-bbap-lti1-sample");
  courseDoc.setCourseId( courseId );
  courseDoc.setParentId( folderId );
  String title = mr.getParameter("title");
  courseDoc.setTitle( title );
  ExtendedData ed = new ExtendedData();
  ed.setValue("contentType", contentType);
  ed.setValue("customParameter1",mr.getParameter( "customParameter1"));
  ed.setValue("customParameter2",mr.getParameter( "customParameter2"));
  ed.setValue("customParameter3",mr.getParameter( "customParameter3"));
  ed.setValue("customParameter4",mr.getParameter( "customParameter4"));
  courseDoc.setExtendedData(ed);
  courseDoc.setIsAvailable(true);
  courseDoc.validate();
  persister.persist( courseDoc );
  
  String bltiLink = PlugInUtil.getUri("bbdn", "lti1.1 Sample", "contentHandlers/view.jsp?content_id=" + courseDoc.getId().getExternalString() + "&course_id=" + course_id);
  FormattedText bltiDescription = new FormattedText("Basic LTI Connection to IMS Global via Blackboard Building Block API. Click <a href=\"" + bltiLink + "\">here</a> to launch.",FormattedText.Type.SMART_TEXT);
  
  courseDoc.setBody( bltiDescription );
  persister.persist( courseDoc );
  
  String strReturnUrl = PlugInUtil.getEditableContentReturnURL( courseDoc.getParentId(), courseId ); 
  
  GradableItem gi = new GradableItem();
  GradableItemManager giManager = GradebookManagerFactory.getGradableItemManager();
  
  gi.setCourseId(courseId);
  gi.setCourseContentId(courseDoc.getId());
  gi.setDisplayTitle(title);
  gi.setPoints(100);
  gi.setTitle(title);
  gi.setVisibleInBook(true);
  gi.setVisibleToStudents(true);
  
  giManager.persistGradebookItem(gi);

  
%>

  <bbNG:breadcrumbBar environment="CTRL_PANEL" isContent="true" >
    <bbNG:breadcrumb>Add IMS Global Basic LTI Sample <%=contentType%></bbNG:breadcrumb>
  </bbNG:breadcrumbBar>
  <bbNG:receipt type="SUCCESS" title="IMS Global Basic LTI Sample <%=contentType%> Added" recallUrl="<%=strReturnUrl%>">IMS Global LTI Sample Content successfully added.</bbNG:receipt>
</bbNG:learningSystemPage>
