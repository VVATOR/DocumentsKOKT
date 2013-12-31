<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>
<%@ page import="java.io.*"%>
<%@page import="by.gomel.gskb.oracle.PROEUSER.ProeuserSQLRequest"%>
<%
 String DOC_ID= "";
 if (request.getParameter("DOC_ID") != null)
	 DOC_ID = new String(request.getParameter("DOC_ID").getBytes("ISO-8859-1"));
 if(!DOC_ID.equals("")){
    try
    {  
       //объ€вл€ем переменные и создаем объекты дл€ работы с базой данных
       ProeuserSQLRequest ProeuserSQL = new ProeuserSQLRequest(); 
       // get the image from the database
       byte[] imgData = ProeuserSQL.GetImageForDocument(DOC_ID) ;   
       // display the image
       response.setContentType("image/gif");
       OutputStream o = response.getOutputStream();
       o.write(imgData);
       o.flush(); 
       o.close();
       ProeuserSQL.Disconnect();
    }
    catch (Exception e)
    {
      e.printStackTrace();
      throw e;
    }
    finally
    {
    }  
 }
%>