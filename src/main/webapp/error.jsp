<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib uri="/bbNG" prefix="bbNG"%>
<%@ page import="java.io.PrintWriter,
				 javax.servlet.jsp.jstl.fmt.*"%>
<%@ page isErrorPage = "true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% 
Object _inside_error_page_already_unique_name = request.getAttribute("_inside_error_page_already_unique_name");
if (_inside_error_page_already_unique_name != null) 
{
  // We're looping in the error page - just render something basic.
  %>
  <fmt:message var="errMsg" key="errorpage.recursive.error" bundle="${bundles.tags}"/>
  <html><head><title>${errMsg}</title></head><body>${errMsg}</body></html>
  <%
}
else 
{
  request.setAttribute("_inside_error_page_already_unique_name", "here");
%>
<%
	String strException = exception.getMessage();
%>		
<bbNG:genericPage>
<bbNG:receipt type="FAIL" title="Error">
<%=strException%>
<p>
<pre>
<%
	// now display a stack trace of the exception
  PrintWriter pw = new PrintWriter( out );
  exception.printStackTrace( pw );
%>
</pre>
</bbNG:receipt>

</bbNG:genericPage>
<%
}
%>