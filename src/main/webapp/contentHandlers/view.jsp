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
 *	Description:			Launch Page for content handlers - Basic LTI Launcher Building Block
 *	Date Created:			12/03/2010
 *	Comments:				
 *	ToDo:					
 */
  -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,
                java.text.*,
                java.util.Map,
                java.io.*,
                java.util.prefs.*,
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
                blackboard.platform.db.*,
                blackboard.platform.blti.*" 
    errorPage="/error.jsp"
%>

<%@ taglib uri="/bbNG" prefix="bbNG"%>

<bbNG:learningSystemPage ctxId="ctx">

<%
  final String BLTI_URL 	= "bltiUrl";
  final String BLTI_KEY 	= "bltiKey";
  final String BLTI_SECRET	= "bltiSecret";

  File _configFile = null;
  String bltiUrl = "";
  String bltiKey = "";
  String bltiSecret = "";
  
  if (!PlugInUtil.authorizeForCourse(request, response))
    return;

  Preferences prefs = Preferences.systemRoot();
  bltiUrl = prefs.get( BLTI_URL,"http://www.imsglobal.org/developers/BLTI/tool.php" );
  bltiKey = prefs.get( BLTI_KEY, "blti_key_default" );
  bltiSecret = prefs.get( BLTI_SECRET, "secret" );
  
  BbPersistenceManager bbPm = PersistenceServiceFactory.getInstance().getDbPersistenceManager();
  Container bbContainer = bbPm.getContainer();

  User user=ctx.getUser();
  Course course=ctx.getCourse();
  
  Id courseId = bbPm.generateId(Course.DATA_TYPE, request.getParameter("course_id"));
  Id userId = user.getId();
  
  CourseMembershipDbLoader cmLoader = (CourseMembershipDbLoader) bbPm.getLoader(CourseMembershipDbLoader.TYPE);
  CourseMembership membership = cmLoader.loadByCourseAndUserId(courseId, userId);
  
  Id contentId = bbPm.generateId(CourseDocument.DATA_TYPE, request.getParameter("content_id") );

  ContentDbLoader courseDocumentLoader = (ContentDbLoader) bbPm.getLoader( ContentDbLoader.TYPE );
  Content courseDoc = courseDocumentLoader.loadById( contentId );

  String contentHandler = courseDoc.getContentHandler();
  String contentType = "";
  
  if (contentHandler == "resource/x-bbap-lti1-sample2")
	  contentType = "Assessment";
  else
	  contentType = "Content";
  // create a map for storing custom Basic LTI Parameters 
  HashMap<String,String> customParamMap = new HashMap<String,String>();
  
  // Add custom BLTI Parameters
  customParamMap.put("contentType",contentType.toString());
  customParamMap.put("customParameter1",courseDoc.getExtendedData().getValue("customParameter1"));
  customParamMap.put("customParameter2",courseDoc.getExtendedData().getValue("customParameter2"));
  customParamMap.put("customParameter3",courseDoc.getExtendedData().getValue("customParameter3"));
  customParamMap.put("customParameter4",courseDoc.getExtendedData().getValue("customParameter4"));
  
  //create a map for storing custom presentation parameters
  HashMap<String,String> customPresentationParams = new HashMap<String,String> ();
  String strReturnUrl = PlugInUtil.getEditableContentReturnURL(courseDoc.getParentId(), courseId);
  
  //add custom presentation parameters
  customPresentationParams.put("PARAM_LAUNCH_PRESENTATION_RETURN_URL",strReturnUrl.toString());

  /* 
   *		Instantiate BasicLTILauncher object
   *		BasicLTILauncher(String url, String key, String secret, String resourceLinkID)
   *			.addResourceLinkInformation(String title, String description)
   *			.addCurrentUserInformation(boolean includeRole, boolean includeName, boolean includeEmail)
   *			.addCurrentCourseInformation(void)
   *			.addCustomToolParameters (Map<String, String> params)
   *			.addLaunchPresentationInformation (Map<String,String> params);
   */
  BasicLTILauncher launcher = new BasicLTILauncher( bltiUrl, bltiKey, bltiSecret, contentHandler.toString() )
   		.addResourceLinkInformation( "IMS Global " + contentType, "Basic LTI Connection to the IMS Global " + contentType )
   		.addCurrentUserInformation( true, true, true )
   		.addCurrentCourseInformation()
   		.addCustomToolParameters( customParamMap )
   		// IF SP14 or earlier, use this one:
   		.addGradingInformation(courseDoc, ctx.getCourseMembership())
   		// IF April Release, Use this one:
   		//.addGradingInformation(request, courseDoc, ctx.getCourseMembership())
   		.addLaunchPresentationInformation(customPresentationParams);
   
   //Launch BLTI connection 
   //launch(HttpServletRequest request, HttpServletResponse response, boolean showSplashScreen, FormattedText splashMessage) 
	launcher.launch( request, response, false, null );
%>
</bbNG:learningSystemPage>
