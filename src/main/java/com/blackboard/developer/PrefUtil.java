package com.blackboard.developer;

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
 *	Description:			Configuration Class for LTI 1.0 Launcher Building Block
 *	Date Created:			11/11/2013
 *	Comments:
 *	ToDo:
 */

import java.util.prefs.Preferences;
import java.util.prefs.BackingStoreException;

public class PrefUtil {
	private String url = "";
	private String key = "";
	private String secret = "";

	public PrefUtil () {
		url="";
		key="";
		secret="";
	}

	public PrefUtil (String initUrl, String initKey, String initSecret) {
		url=initUrl;
		key=initKey;
		secret=initSecret;
	}

	public boolean saveProps (String initUrl, String initKey, String initSecret) throws BackingStoreException {
		  Preferences prefs = Preferences.systemNodeForPackage(PrefUtil.class);
    	prefs.put( "BLTI_URL", initUrl );
    	prefs.put( "BLTI_KEY", initKey );
    	prefs.put( "BLTI_SECRET", initSecret );
    	try {
    		prefs.flush();
    	}catch(BackingStoreException bse) {
    		throw(bse);
    	}
    	return true;
	}

	public PrefUtil getProps () {
		Preferences prefs = Preferences.systemNodeForPackage(PrefUtil.class);
		this.url = prefs.get("BLTI_URL", "http://54.242.225.150/lti");
		this.key = prefs.get("BLTI_KEY", "12345");
		this.secret = prefs.get("BLTI_SECRET", "secret");

		return this;
	}

    public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getSecret() {
		return secret;
	}

	public void setSecret(String secret) {
		this.secret = secret;
	}

	{
}
}
