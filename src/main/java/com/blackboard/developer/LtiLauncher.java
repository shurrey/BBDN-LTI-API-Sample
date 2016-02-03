package com.blackboard.developer;

import java.util.HashMap;
import java.util.prefs.Preferences;

import javax.servlet.http.HttpServletRequest;

import blackboard.data.content.Content;
import blackboard.data.course.CourseMembership;
import blackboard.persist.Id;
import blackboard.persist.content.ContentDbLoader;
import blackboard.persist.course.CourseMembershipDbLoader;
import blackboard.platform.blti.BasicLTILauncher;
import blackboard.platform.plugin.PlugInUtil;

public abstract class LtiLauncher {
	
	final static String BLTI_URL 	= "bltiUrl";
	final static String BLTI_KEY 	= "bltiKey";
	final static String BLTI_SECRET	= "bltiSecret";

	public static BasicLTILauncher buildLauncher (Id courseId, Id contentId, Id userId, HttpServletRequest request) {

		String bltiUrl = "";
		String bltiKey = "";
		String bltiSecret = "";
		
		Content courseDoc = null;
		CourseMembership membership = null;
  
		Preferences prefs = Preferences.systemRoot();
		bltiUrl = prefs.get( BLTI_URL,"http://54.242.225.150/lti" );
		bltiKey = prefs.get( BLTI_KEY, "12345" );
		bltiSecret = prefs.get( BLTI_SECRET, "secret" );
		
		try {
			membership = CourseMembershipDbLoader.Default.getInstance().loadByCourseAndUserId(courseId, userId);
			courseDoc = ContentDbLoader.Default.getInstance().loadById( contentId );
		} catch (Exception e) {
		
		}
		
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
				.addCurrentUserInformation( true, true, true, BasicLTILauncher.IdTypeToSend.UUID )
				.addCurrentCourseInformation(BasicLTILauncher.IdTypeToSend.UUID )
				.addCustomToolParameters( customParamMap )
				.addGradingInformation(request, courseDoc, membership)
		   		.addLaunchPresentationInformation(customPresentationParams);
		   
		   //Launch BLTI connection 
		   //launch(HttpServletRequest request, HttpServletResponse response, boolean showSplashScreen, FormattedText splashMessage) 
		
		return(launcher);
	}
}
