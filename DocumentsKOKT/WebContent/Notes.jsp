<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="config.jsp"%>
<!-- ���� � ����������� ����������� � ������������ -->

<html>
<head>
<title><%=PROGRAMM_name%> / ��������� � �����������</title>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1251">
<script type="text/javascript" language="JavaScript">
 function changeImg1(source)
 {  
	 document.pict1.src = source + '.PNG';
 };
 
 function cancel_function(){
	 location.href="index.jsp";
 }
 
 function add_function(){
	 document.mainForm.Action.value=1;
	 document.mainForm.submit();
 }
</script>

<%
	ProeuserSQLRequest sql = new ProeuserSQLRequest();

	//�������� ���������� ���������
	String TEXT = "";
	if(request.getParameter("TEXT") != null)
		 TEXT = new String (request.getParameter("TEXT").getBytes("ISO-8859-1"));
	String TYPE = "";
	if(request.getParameter("TYPE") != null)
		 TYPE = new String (request.getParameter("TYPE").getBytes("ISO-8859-1"));
	String Action="";
	if(request.getParameter("Action") != null)
		 Action = new String (request.getParameter("Action").getBytes("ISO-8859-1"));
	
	
	String SessionUser="";
	String FULLNAME="";
	String DEPARTMENT="";
	//--------------------------------------------------------------------------------
	  //                          ��������� �������� ������������
	  //         �����������, ���� �������� �� ���� �������� ������ � ������������
	  //--------------------------------------------------------------------------------
	  if(SessionUser.equals("")){
	   response.setHeader("Cache-Control", "no-cache");
	   String auth = request.getHeader("Authorization");
	   if (auth == null) {
	     	response.setStatus(response.SC_UNAUTHORIZED);
	       	response.setHeader("WWW-Authenticate", "NTLM");
	       	return;
	   }
	   if (auth.startsWith("NTLM ")) { 
	  	 byte[] msg = new sun.misc.BASE64Decoder().decodeBuffer(auth.substring(5));
	     int off = 0, length, offset;
	     String s;
	     if (msg[8] == 1) { 
	       off = 18;
	       byte z = 0;
	       byte[] msg1 =
	                 {(byte)'N', (byte)'T', (byte)'L', (byte)'M', (byte)'S',
	                 (byte)'S', (byte)'P', z,
	                 (byte)2, z, z, z, z, z, z, z,
	                 (byte)40, z, z, z, (byte)1, (byte)130, z, z,
	                 z, (byte)2, (byte)2, (byte)2, z, z, z, z,  
	                 z, z, z, z, z, z, z, z};
	      response.setStatus(response.SC_UNAUTHORIZED);
	      response.setHeader("WWW-Authenticate", "NTLM " 
	      + new sun.misc.BASE64Encoder().encodeBuffer(msg1).trim());
	      return;
	    } 
	    else if (msg[8] == 3) { 
	      off = 30;
	      length = msg[off+17]*256 + msg[off+16];
	      offset = msg[off+19]*256 + msg[off+18];
	      s = new String(msg, offset, length);
	    } 
	    else  return;
	    length = msg[off+1]*256 + msg[off];
	    offset = msg[off+3]*256 + msg[off+2];
	    s = new String(msg, offset, length);
	    length = msg[off+9]*256 + msg[off+8];
	    offset = msg[off+11]*256 + msg[off+10];
	    s = new String(msg, offset, length);
	    //������� ������ �������
	    int i=0;
		String str1="";
		while(i<s.length()){
			str1 += s.charAt(i);
			i=i+2;
		}
		s = str1;
		
	    SessionUser = s;
	    //�������� ��� ����� ������������
	    FULLNAME = "";
	    DEPARTMENT = "";
	    sql.GetUserFioAndDepartmentFromLogin(s);
	    while(sql.oRs.next()) { 
		  FULLNAME = sql.oRs.getString("FULLNAME");
	 	  DEPARTMENT = sql.oRs.getString("DEPARTMENT");
	    }		
	   }
	  }
	
	
	//--------------------------------------
	// Action = 1 - ���������� �����������
	//--------------------------------------
	if(Action.equals("1")){
		 if(!TEXT.equals("") && !FULLNAME.equals("")){
		  		sql.InsertNote(FULLNAME,TYPE,TEXT);
		 }
	}
%>
</head>
<%
//----------------------------------------------------------------------------------------
//  ������� ������ � ������������
//----------------------------------------------------------------------------------------

%>
<body id="dt_example" background="images/background.png">
	<h3 align="center">��������� � �����������</h3>
	<form name=mainForm id=mainForm action="Notes.jsp" method="GET">
		<!-- ������� ���������� -->
		<H4>������� ���� ����������� ��� ����� �� ������ � �������
			'���������':</H4>
		<table align="center">
			<tr>
				<td>��� ��������� � �������������</td>
				<td><select name="TYPE">
						<%
							sql.GetAllNoteTypes();
					    	while(sql.oRs.next()){
					  			out.println("<option>"+sql.oRs.getString("TYPE")+"</option>");  	
					    	}
						%>
				</select></td>

				<td style="width: 120px;" align="center"><input type="button"
					value="���������" onClick="add_function()" /></td>
				<td style="width: 120px;" align="center"><input type="button"
					value="������" onClick="cancel_function()" /></td>
			</tr>
			<tr>
				<td>����� ���������</td>
				<td colspan=3><input type="text" size="90" name="TEXT" /></td>
			</tr>
		</table>
		<%
		    //��������� ����������
		    out.println("<input type=\"text\" value=\"" + SessionUser + "\" name=\"SessionUser\" style=\"display: none;\" />"); 
		    out.println("<input type=\"text\" value=\"" + FULLNAME + "\" name=\"FULLNAME\" style=\"display: none;\" />"); 
		    out.println("<input type=\"text\" value=\"" + DEPARTMENT + "\" name=\"DEPARTMENT\" style=\"display: none;\" />");
		    //��������� �������� - ���������� ���������
		    out.println("<input type=\"text\" name=\"Action\" style=\"display: none;\" />"); 
	   %>
	</form>
	<HR>
	<h4>��� ���������:</h4>
	<table border=1 align="center" width="100%">
		<tr bgcolor="#9ecdd0">
			<td>�� ����</td>
			<td>���</td>
			<td>�����</td>
			<td>����� �������������</td>
		</tr>
		<%
		sql.GetAllNotes();
	  	while(sql.oRs.next()){
			if(sql.oRs.getString("FINISH").equals("0")){
		  		out.println("  <tr bgcolor=\"white\">");
			}
	  		if(sql.oRs.getString("FINISH").equals("1")){
	  			out.println("  <tr bgcolor=\"#BFEFFF\">");
	  		}
	  		if(sql.oRs.getString("FINISH").equals("2")){
	  			out.println("  <tr bgcolor=\"#FF6347\">");
	  		}
	  		out.println("    <td>" + sql.oRs.getString("FULLNAME") + " </td>");
	  		out.println("    <td>" + sql.oRs.getString("TYPE") + " </td>");
	  		out.println("    <td>" + sql.oRs.getString("TEXT") + " </td>");
	  		if(sql.oRs.getString("ANSWER") != null){
	  	 		out.println("    <td>" + sql.oRs.getString("ANSWER") + " </td>");
	  		}
	  		else{
	  	 		out.println("    <td>������� ���������</td>");
	  		}
	  		out.println("  </tr>");
	  	}
	  	sql.Disconnect();
	  %>
	</table>
</body>
</html>