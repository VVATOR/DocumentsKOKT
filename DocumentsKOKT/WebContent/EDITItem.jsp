<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="config.jsp"%><!-- ���� � ����������� ����������� � ������������ -->
<%@page import="java.util.ArrayList"%>

<html>
<script type="text/javascript" language="JavaScript">
	<%@ include file="../../JSCode/Code_ControlDataEnter.js" %>   // ����������� � �������������� �������� ������
	function EditExecute(){	  
	  error_message = "";
	  var t= AllTrimEdit(); // ���������� ����� � ����������
	  //� �/�
	  if(document.Edit.editNumber.value == ""){
		  if(error_message == "") error_message += "�� ������ ������: ";
		  error_message += " � �/�";
	  }
	  //������
	  if(document.Edit.editProduct.value == ""){
		  if(error_message == "") error_message += "�� ������ ������: ";
		  error_message += " ������";
	  }
	  //�����������
	  if(document.Edit.editOwner.value == ""){
		  if(error_message == "") error_message += "�� ������ ������: ";
		  error_message += " �����������";
	  }
	  //� �������.
	  if(document.Edit.editRegNumber.value == ""){
		  if(error_message == "") error_message += "�� ������ ������: ";
		  error_message += " � �������.";
	  }
	  //� �����.
	  if(document.Edit.editOutNumber.value == ""){
		  if(error_message == "") error_message += "�� ������ ������: ";
		  error_message += " � �����.";
	  }
	  //��� ���������
	  if(document.Edit.editDocType.value == ""){
		  if(error_message == "") error_message += "�� ������ ������: ";
		  error_message += " ��� ���������";
	  }
	  if(error_message == ""){
	  	document.Edit.action.value="1";
	  	Edit.submit();
	  }
	  else alert(error_message);
	}
	function CancelExecute(){
	  	document.Edit.action.value="4";
	  	Edit.submit();
	}
	function AddUserToTable(){
	  document.Edit.action.value="2";
	  Edit.submit();  
	}
	function AddDepartment(){
	  document.Edit.action.value="3";
	  Edit.submit();
	}
	function DeleteExecute(){
	  document.Edit.action.value="5";
	  Edit.submit();	
	}	
</script>

<script type="text/javascript" src="js/jquery-1.4.2.js"></script>
<script type="text/javascript" src="js/jquery.autocomplete.js"></script>
<link rel="stylesheet" href="css/bluedream.css">

<link rel="stylesheet" href="css/AutocompleteStyle.css">
<head>
<title><%=PROGRAMM_name%></title>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1251">

<style>
.cl1 {

}

.cl2 {
	
}
</style>
</head>
<body>
<div style="width: 100%; margin: 0 auto;">

	<form name=Edit>



		<!-- <input type="button" class="cl1" value=" �������������� ������ " onclick="AllTrimEdit();"/> -->
		<%
//----------------------------------------------------------------------------------------
//                               ���������� ����������
//----------------------------------------------------------------------------------------
 //������ � ������������ 
 String TYPESORTING="";           /// ��� ���������� (�� ������ ��� ������������)
 
 String SessionUser = ""; 													//����� ������������
 
 String ADMINISTRATOR = "false"; 											//�������������
 String FULLNAME = ""; 														//���
 String DEPARTMENT = ""; 													//�����
 //���������� �������
 String selOutNumber = "";													//� �����]
 String selDocType = "";													//��� ���������
 String selDescriptionText = "";											//���������� �����
 String selRegNumber = "";													//� �������. ��
 String selAuthor = "";														//�����������
 String selProduct = "";													//������
   String selIdDep="";													       //� �/�
   String selByISPFamily="";												   //������� ����������� ��� ����������
   String selStartDate="";													   //��������� ���� ����������
   String selEndDate="";													   //�������� ���� ����������
   String selOnControler="";                                                   //�� �������� ��� ������ 
 
 
 
 
 
 //���������� ����� ��������������
 String editNumber = "";													//ID
 String editNumberDep = "";													//� �/�
 String editProduct = "";													//������
 String editOwner = "";														//�����������
 String editRegNumber = "";													//� �������.
 String editOutNumber = "";													//� �����.
 String editDocType = "";													//��� ���������
 String editDescription = "";												//������� ����������
 String editNote = "";														//����������
 String editControlStatus = "";												//�� ��������
 String editDatafile = "";													//����
 String editUser = "";														//��� ���������� ������������ � �������
 String editCopyToDepartment = "";											//��� ���������� ������ � �������
 //�����
 String URL = "";
 //�������
 ArrayList<String> lUsers;													//������ �������������
 ArrayList<String> lUsersStatus;											//������ ������������
 ArrayList<String> lUsersExecute;											//���������� ������������
 ArrayList<String> lDepartment;												//������ ������� (���� �������� �����)
 ArrayList<String> lDateOfRead;												//���� ������������
 //������ ����������
 String sUsersCount = "0";													//���������� ������������
 String sDepartmentCount = "0";												//���������� ������� (���� �������� �����)
 String sCurrentUsersCount = "0";											//������� ���������� ������������
 String sCurrentDepartmentCount = "0";										//������� ���������� ������� (���� �������� �����)
 String action = ""; 														//��������
 int i;																		//�������
 String DEFAULT_ELEMENT_WIDTH = "500";										//������ �� ���������
 String DEFAULT_SELECT_ELEMENT_WIDTH = "505";								//������ ������� �� ���������
 String READ_ONLY_FLAG = "";												//������ ������� �� ���������
 //��������� ���������� � ������� ������� ��� ������ � ����� ������
 ProeuserSQLRequest ProeuserSQL = new ProeuserSQLRequest();
 //������������� ��������
 lUsers = new ArrayList<String>(); 
 lUsersStatus = new ArrayList<String>(); 
 lUsersExecute = new ArrayList<String>(); 
 lDepartment = new ArrayList<String>(); 
 lDateOfRead = new ArrayList<String>(); 
//----------------------------------------------------------------------------------------
//                      ��������� ���������� ���������� ��������
//----------------------------------------------------------------------------------------

//�������������
 if (request.getParameter("ADMINISTRATOR") != null) {
	ADMINISTRATOR = new String(request.getParameter("ADMINISTRATOR").getBytes("ISO-8859-1"));
	ADMINISTRATOR = URLDecoder.decode(ADMINISTRATOR, "windows-1251");
	if(ADMINISTRATOR.equals("true")) READ_ONLY_FLAG = "";
	else READ_ONLY_FLAG = "readonly=true";
 } else{
	 ADMINISTRATOR = "false";
	 READ_ONLY_FLAG = "readonly=true";
 }
 

 //��� ����������
 if(request.getParameter("TYPESORTING")!=null){
   TYPESORTING = new String(request.getParameter("TYPESORTING").getBytes("ISO-8859-1"));
	TYPESORTING = URLDecoder.decode(TYPESORTING, "windows-1251");
 }else{	
	TYPESORTING = "i";
	if(ADMINISTRATOR == "false")	TYPESORTING = "all";
 } 

 //��� �������� ������������
 if (request.getParameter("FULLNAME") != null) {
	FULLNAME = new String(request.getParameter("FULLNAME").getBytes("ISO-8859-1"));
	FULLNAME = URLDecoder.decode(FULLNAME, "windows-1251");
 } else FULLNAME = "";
 //����� �������� ������������
 if (request.getParameter("SessionUser") != null)
	SessionUser = new String(request.getParameter("SessionUser").getBytes("ISO-8859-1"));
 else SessionUser = "";
 //����� �������� ������������
 if (request.getParameter("DEPARTMENT") != null) {
 	DEPARTMENT = new String(request.getParameter("DEPARTMENT").getBytes("ISO-8859-1"));
	DEPARTMENT = URLDecoder.decode(DEPARTMENT, "windows-1251");
 } else DEPARTMENT = "";
 //� �����]
 if (request.getParameter("selOutNumber") != null) {
	 selOutNumber = new String(request.getParameter("selOutNumber").getBytes("ISO-8859-1"));
	 selOutNumber = URLDecoder.decode(selOutNumber, "windows-1251");
 }									
 //��� ���������
 if (request.getParameter("selDocType") != null) {
	 selDocType = new String(request.getParameter("selDocType").getBytes("ISO-8859-1"));
	 selDocType = URLDecoder.decode(selDocType, "windows-1251");
 }	
 //���������� �����
 if (request.getParameter("selDescriptionText") != null) {
	 selDescriptionText = new String(request.getParameter("selDescriptionText").getBytes("ISO-8859-1"));
	 selDescriptionText = URLDecoder.decode(selDescriptionText, "windows-1251");
 }	
 //� �������.
 if (request.getParameter("selRegNumber") != null) {
	 selRegNumber = new String(request.getParameter("selRegNumber").getBytes("ISO-8859-1"));
	 selRegNumber = URLDecoder.decode(selRegNumber, "windows-1251");
 }	
 //�����������
 if (request.getParameter("selAuthor") != null) {
	 selAuthor = new String(request.getParameter("selAuthor").getBytes("ISO-8859-1"));
	 selAuthor = URLDecoder.decode(selAuthor, "windows-1251");
 }	
 //������
 if (request.getParameter("selProduct") != null) {
	 selProduct = new String(request.getParameter("selProduct").getBytes("ISO-8859-1"));
	 selProduct = URLDecoder.decode(selProduct, "windows-1251");
 }	
 //ID
 if (request.getParameter("editNumber") != null) {
	 editNumber = new String(request.getParameter("editNumber").getBytes("ISO-8859-1"));
	 editNumber = URLDecoder.decode(editNumber, "windows-1251");
 }	
 //ID
 if (request.getParameter("editNumberDep") != null) {
	 editNumberDep = new String(request.getParameter("editNumberDep").getBytes("ISO-8859-1"));
	 editNumberDep = URLDecoder.decode(editNumberDep, "windows-1251");
 }	
 //������
 if (request.getParameter("editProduct") != null) {
	 editProduct = new String(request.getParameter("editProduct").getBytes("ISO-8859-1"));
	 editProduct = URLDecoder.decode(editProduct, "windows-1251");
 }	
 //�����������
 if (request.getParameter("editOwner") != null) {
	 editOwner = new String(request.getParameter("editOwner").getBytes("ISO-8859-1"));
	 editOwner = URLDecoder.decode(editOwner, "windows-1251");
 }	
 //� �������.
 if (request.getParameter("editRegNumber") != null) {
	 editRegNumber = new String(request.getParameter("editRegNumber").getBytes("ISO-8859-1"));
	 editRegNumber = URLDecoder.decode(editRegNumber, "windows-1251");
 }	
 //� �����.
 if (request.getParameter("editOutNumber") != null) {
	 editOutNumber = new String(request.getParameter("editOutNumber").getBytes("ISO-8859-1"));
	 editOutNumber = URLDecoder.decode(editOutNumber, "windows-1251");
 }	
 //��� ���������
 if (request.getParameter("editDocType") != null) {
	 editDocType = new String(request.getParameter("editDocType").getBytes("ISO-8859-1"));
	 editDocType = URLDecoder.decode(editDocType, "windows-1251");
 }
 //������� ����������
 if (request.getParameter("editDescription") != null) {
	 editDescription = new String(request.getParameter("editDescription").getBytes("ISO-8859-1"));
	 editDescription = URLDecoder.decode(editDescription, "windows-1251");
 }
// System.out.println("EDITItem "+editDescription);
 
 //����������
 if (request.getParameter("editNote") != null) {
	 editNote = new String(request.getParameter("editNote").getBytes("ISO-8859-1"));
	 editNote = URLDecoder.decode(editNote, "windows-1251");
 }
 //�� ��������
 if (request.getParameter("editControlStatus") != null) {
	 editControlStatus = new String(request.getParameter("editControlStatus").getBytes("ISO-8859-1"));
	 editControlStatus = URLDecoder.decode(editControlStatus, "windows-1251");
 }
 //����
 if (request.getParameter("editDatafile") != null) {
	 editDatafile = new String(request.getParameter("editDatafile").getBytes("ISO-8859-1"));
	 editDatafile = URLDecoder.decode(editDatafile, "windows-1251");
 }
 //���������� �������������
 if (request.getParameter("sUsersCount") != null) {
	 sUsersCount = new String(request.getParameter("sUsersCount").getBytes("ISO-8859-1"));
	 sUsersCount = URLDecoder.decode(sUsersCount, "windows-1251");
 }		
 //���������� �������
 if (request.getParameter("sDepartmentCount") != null) {
	 sDepartmentCount = new String(request.getParameter("sDepartmentCount").getBytes("ISO-8859-1"));
	 sDepartmentCount = URLDecoder.decode(sDepartmentCount, "windows-1251");
 }		
 //������� ���������� �������������
 if (request.getParameter("sCurrentUsersCount") != null) {
	 sCurrentUsersCount = new String(request.getParameter("sCurrentUsersCount").getBytes("ISO-8859-1"));
	 sCurrentUsersCount = URLDecoder.decode(sCurrentUsersCount, "windows-1251");
 }		
 //������� ���������� �������
 if (request.getParameter("sCurrentDepartmentCount") != null) {
	 sCurrentDepartmentCount = new String(request.getParameter("sCurrentDepartmentCount").getBytes("ISO-8859-1"));
	 sCurrentDepartmentCount = URLDecoder.decode(sCurrentDepartmentCount, "windows-1251");
 }	
 //��� ���������� ������������ � �������
 if (request.getParameter("editUser") != null) {
	 editUser = new String(request.getParameter("editUser").getBytes("ISO-8859-1"));
	 editUser = URLDecoder.decode(editUser, "windows-1251");
 }		
 //��� ���������� ������ � �������
 if (request.getParameter("editCopyToDepartment") != null) {
	 editCopyToDepartment = new String(request.getParameter("editCopyToDepartment").getBytes("ISO-8859-1"));
	 editCopyToDepartment = URLDecoder.decode(editCopyToDepartment, "windows-1251");
 }		
 //��������
 if (request.getParameter("action") != null) {
	 action = new String(request.getParameter("action").getBytes("ISO-8859-1"));
 }
//----------------------------------------------------------------------------------------
//                         �������� ���������� �������� �������
//----------------------------------------------------------------------------------------

 //�������� ���������� �������
 for(i=0;i<Integer.parseInt(sUsersCount);i++){
	lUsers.add(URLDecoder.decode(new String(request.getParameter("User" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1")), "windows-1251"));													
	lUsersStatus.add( URLDecoder.decode(new String(request.getParameter("Status" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1")), "windows-1251"));
		try{ // �������� 
			lUsersExecute.add(URLDecoder.decode(new String(request.getParameter("Execute" +Integer.valueOf(i).toString()).getBytes("ISO-8859-1")), "windows-1251"));
		}catch(Exception e){
			lUsersExecute.add("");
		}
	lDateOfRead.add(URLDecoder.decode(new String(request.getParameter("DateOfRead" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1")), "windows-1251"));
 }
 for(i=0;i<Integer.parseInt(sDepartmentCount);i++){
	lDepartment.add(URLDecoder.decode(new String(request.getParameter("Department" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1")), "windows-1251"));													
 }
//----------------------------------------------------------------------------------------
//        ���������� �������� � ����������� �� �������� ��������� ACTION
//                   �CTION=1 - ���������� ���������
//                   �CTION=2 - ���������� ������������
//                   �CTION=3 - ���������� ������
//
//----------------------------------------------------------------------------------------
 if(action.equals("1")){
	//��������� ����������
	if(ProeuserSQL.EditDocument(editNumber,editProduct,editOwner,editRegNumber,editOutNumber,editDocType,editDescription,editNote, editControlStatus,editDatafile,lUsers,lUsersStatus,lUsersExecute,lDepartment,lDateOfRead,Integer.parseInt(sUsersCount),Integer.parseInt(sDepartmentCount), Integer.parseInt(sCurrentUsersCount),Integer.parseInt(sCurrentDepartmentCount)) == false)
	{	
		//� ������������ �� ������� ��������
		URL = "index.jsp?" + 
			"SessionUser="+SessionUser+
			"&ADMINISTRATOR="+URLEncoder.encode(ADMINISTRATOR, "windows-1251")+
			"&FULLNAME="+URLEncoder.encode(FULLNAME, "windows-1251")+
			"&DEPARTMENT="+URLEncoder.encode(DEPARTMENT, "windows-1251") +
 			"&selOutNumber="+URLEncoder.encode(selOutNumber, "windows-1251")+
 			"&selDocType="+URLEncoder.encode(selDocType, "windows-1251")+
 			"&selDescriptionText="+URLEncoder.encode(selDescriptionText, "windows-1251")+
 			"&selRegNumber="+URLEncoder.encode(selRegNumber, "windows-1251")+
 			"&selAuthor="+URLEncoder.encode(selAuthor, "windows-1251")+
 			"&selProduct="+URLEncoder.encode(selProduct, "windows-1251")+
			"&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251");
		response.sendRedirect(URL);
	}
 }
 if(action.equals("2")){
	sUsersCount = Integer.valueOf(Integer.parseInt(sUsersCount) + 1).toString();
	lUsers.add(editUser);													
	lUsersStatus.add("�������");
	lUsersExecute.add("");
	lDateOfRead.add("");
 }
 if(action.equals("3")){
	sDepartmentCount = Integer.valueOf(Integer.parseInt(sDepartmentCount) + 1).toString();
	lDepartment.add(editCopyToDepartment);
 }
 if(action.equals("4")){
		//������������ �� ������� ��������
		URL = "index.jsp?" + 
			"SessionUser="+SessionUser+
			"&ADMINISTRATOR="+URLEncoder.encode(ADMINISTRATOR, "windows-1251")+
			"&FULLNAME="+URLEncoder.encode(FULLNAME, "windows-1251")+
			"&DEPARTMENT="+URLEncoder.encode(DEPARTMENT, "windows-1251") +
			"&selOutNumber="+URLEncoder.encode(selOutNumber, "windows-1251")+
			"&selDocType="+URLEncoder.encode(selDocType, "windows-1251")+
			"&selDescriptionText="+URLEncoder.encode(selDescriptionText, "windows-1251")+
			"&selRegNumber="+URLEncoder.encode(selRegNumber, "windows-1251")+
			"&selAuthor="+URLEncoder.encode(selAuthor, "windows-1251")+
			"&selProduct="+URLEncoder.encode(selProduct, "windows-1251")+
			"&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251");
		response.sendRedirect(URL);
}
if(action.equals("5")){
	//��������� ��������
	if(ProeuserSQL.DeleteDocument(editNumber) == false)
	{	
		//� ������������ �� ������� ��������
		URL = "index.jsp?" + 
			"SessionUser="+SessionUser+
			"&ADMINISTRATOR="+URLEncoder.encode(ADMINISTRATOR, "windows-1251")+
			"&FULLNAME="+URLEncoder.encode(FULLNAME, "windows-1251")+
			"&DEPARTMENT="+URLEncoder.encode(DEPARTMENT, "windows-1251") +
 			"&selOutNumber="+URLEncoder.encode(selOutNumber, "windows-1251")+
 			"&selDocType="+URLEncoder.encode(selDocType, "windows-1251")+
 			"&selDescriptionText="+URLEncoder.encode(selDescriptionText, "windows-1251")+
 			"&selRegNumber="+URLEncoder.encode(selRegNumber, "windows-1251")+
 			"&selAuthor="+URLEncoder.encode(selAuthor, "windows-1251")+
 			"&selProduct="+URLEncoder.encode(selProduct, "windows-1251")+
			"&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251");
		response.sendRedirect(URL);
	}
}
//----------------------------------------------------------------------------------------
//                          ��������� �������� ������������
//         �����������, ���� �������� �� ���� �������� ������ � ������������
//----------------------------------------------------------------------------------------
if (SessionUser.equals("")) {
	response.setHeader("Cache-Control", "no-cache");
	String auth = request.getHeader("Authorization");
	if (auth == null) {
		response.setStatus(response.SC_UNAUTHORIZED);
		response.setHeader("WWW-Authenticate", "NTLM");
		return;
	}
	if (auth.startsWith("NTLM ")) {
		byte[] msg = new sun.misc.BASE64Decoder().decodeBuffer(auth
				.substring(5));
		int off = 0, length, offset;
		String s;
		if (msg[8] == 1) {
			off = 18;
			byte z = 0;
			byte[] msg1 = { (byte) 'N', (byte) 'T', (byte) 'L',
					(byte) 'M', (byte) 'S', (byte) 'S', (byte) 'P',
					z, (byte) 2, z, z, z, z, z, z, z, (byte) 40, z,
					z, z, (byte) 1, (byte) 130, z, z, z, (byte) 2,
					(byte) 2, (byte) 2, z, z, z, z, z, z, z, z, z,
					z, z, z };
			response.setStatus(response.SC_UNAUTHORIZED);
			response.setHeader("WWW-Authenticate",
					"NTLM "
							+ new sun.misc.BASE64Encoder()
									.encodeBuffer(msg1).trim());
			return;
		} else if (msg[8] == 3) {
			off = 30;
			length = msg[off + 17] * 256 + msg[off + 16];
			offset = msg[off + 19] * 256 + msg[off + 18];
			s = new String(msg, offset, length);
		} else
			return;
		length = msg[off + 1] * 256 + msg[off];
		offset = msg[off + 3] * 256 + msg[off + 2];
		s = new String(msg, offset, length);
		length = msg[off + 9] * 256 + msg[off + 8];
		offset = msg[off + 11] * 256 + msg[off + 10];
		s = new String(msg, offset, length);
		//������� ������ �������
		i = 0;
		String str1 = "";
		while (i < s.length()) {
			str1 += s.charAt(i);
			i = i + 2;
		}
		s = str1;
		SessionUser = s;
		//�������� ��� ����� ������������
		FULLNAME = "";
		DEPARTMENT = "";
		ProeuserSQL.GetUserFioAndDepartmentFromLogin(s);
		while (ProeuserSQL.oRs.next()) {
			FULLNAME = ProeuserSQL.oRs.getString("FULLNAME");
			DEPARTMENT = ProeuserSQL.oRs.getString("DEPARTMENT_ABB");
			if(ProeuserSQL.oRs.getString("PERMISSION") == "1") ADMINISTRATOR = "true";
		}
	}
}
//----------------------------------------------------------------------------------------
//                           ������� ������ � ������������
//----------------------------------------------------------------------------------------
	if (!FULLNAME.equals("")) {
		out.println("<img src=\"images/personal.png\" width=\"16\" height=\"16\"/>  �� �������������� � ������� ���: ");
		out.println(FULLNAME + "  (" + DEPARTMENT + ")");
	}
%>
		<hr>
		<h4 align=center>������� ��������� � ������� ������ ��������</h4>
		<hr>
		
		<table class="bluedream">
			<tr>
				<td>� �/�</td>
				<td>
					<% out.print(editNumberDep); %> <input type="hidden"
					name="editNumber"
					style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
					value="<% out.print(editNumber); %>" readonly> <input
					type="hidden" name="editNumberDep"
					style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
					value="<% out.print(editNumberDep); %>" readonly>
				</td>
			</tr>
			<tr>
				<td>������</td>
				<%
		out.println("			<td><input type=\"text\" name=editProduct id=editProduct style=\" width: " + DEFAULT_ELEMENT_WIDTH + "px\" value=\""+ editProduct.trim() + "\" " + READ_ONLY_FLAG + "></td>");
		out.println("			<script type=\"text/javascript\">");
		out.println("				$(document).ready(function(){");
		out.println("				function liFormat (row, i, num) {");
		out.println("					var result = row[0] + '</p>';");
		out.println("					return result;");
		out.println("				}");
		out.println("				function selectItem(li) {");
		out.println("					if( li == null ) var sValue = '� ������ �� �������!';");
		out.println("					if( !!li.extra ) var sValue = li.extra[2];");
		out.println("					else var sValue = li.selectValue;");
		out.println("					f();");
		out.println("				}");
		out.println("				$(\"#editProduct\").autocomplete(\"AJAXAutocompleteProduct.jsp\", {");
		out.println("					delay:10,");
		out.println("					minChars:2,");
		out.println("					matchSubset:1,");
		out.println("					autoFill:false,");
		out.println("					matchContains:1,");
		out.println("					cacheLength:10,");
		out.println("					selectFirst:true,");
		out.println("					formatItem:liFormat,");
		out.println("					maxItemsToShow:10,");
		out.println("					onItemSelect:selectItem");
		out.println("				}); ");
		out.println("				});");
		out.println("			</script>");
		%>
			</tr>
			<tr>
				<td>�����������</td>
				<%
		out.println("			<td><input type=\"text\" name=editOwner id=editOwner style=\"width: " + DEFAULT_ELEMENT_WIDTH + "px\" value=\""+ editOwner.trim() + "\" " + READ_ONLY_FLAG + "></td>");
		out.println("			<script type=\"text/javascript\">");
		out.println("				$(document).ready(function(){");
		out.println("				function liFormat (row, i, num) {");
		out.println("					var result = row[0] + '</p>';");
		out.println("					return result;");
		out.println("				}");
		out.println("				function selectItem(li) {");
		out.println("					if( li == null ) var sValue = '� ������ �� �������!';");
		out.println("					if( !!li.extra ) var sValue = li.extra[2];");
		out.println("					else var sValue = li.selectValue;");
		out.println("					f();");
		out.println("				}");
		out.println("				$(\"#editOwner\").autocomplete(\"AJAXAutocompleteOwner.jsp\", {");
		out.println("					delay:10,");
		out.println("					minChars:2,");
		out.println("					matchSubset:1,");
		out.println("					autoFill:false,");
		out.println("					matchContains:1,");
		out.println("					cacheLength:10,");
		out.println("					selectFirst:true,");
		out.println("					formatItem:liFormat,");
		out.println("					maxItemsToShow:10,");
		out.println("					onItemSelect:selectItem");
		out.println("				}); ");
		out.println("				});");
		out.println("			</script>");
		%>
			
			<tr>
				<td>� �������.</td>
				<td><input type="text" name="editRegNumber"
					style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
					value="<% out.print(editRegNumber); %>"
					<%out.println(READ_ONLY_FLAG);%>></td>
			</tr>
			<tr>
				<td>� �����</td>
				<td><input type="text" name="editOutNumber"
					style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
					value="<% out.print(editOutNumber); %>"
					<%out.println(READ_ONLY_FLAG);%>></td>
			</tr>
			<tr>
				<td>��� ���������</td>
				<%
		out.println("			<td><input type=\"text\" name=editDocType id=editDocType style=\" width: " + DEFAULT_ELEMENT_WIDTH + "px\" value=\""+ editDocType.trim() + "\" " + READ_ONLY_FLAG + "></td>");
		out.println("			<script type=\"text/javascript\">");
		out.println("				$(document).ready(function(){");
		out.println("				function liFormat (row, i, num) {");
		out.println("					var result = row[0] + '</p>';");
		out.println("					return result;");
		out.println("				}");
		out.println("				function selectItem(li) {");
		out.println("					if( li == null ) var sValue = '� ������ �� �������!';");
		out.println("					if( !!li.extra ) var sValue = li.extra[2];");
		out.println("					else var sValue = li.selectValue;");
		out.println("					f();");
		out.println("				}");
		out.println("				$(\"#editDocType\").autocomplete(\"AJAXAutocompleteDocType.jsp\", {");
		out.println("					delay:10,");
		out.println("					minChars:2,");
		out.println("					matchSubset:1,");
		out.println("					autoFill:false,");
		out.println("					matchContains:1,");
		out.println("					cacheLength:10,");
		out.println("					selectFirst:true,");
		out.println("					formatItem:liFormat,");
		out.println("					maxItemsToShow:10,");
		out.println("					onItemSelect:selectItem");
		out.println("				}); ");
		out.println("				});");
		out.println("			</script>");
		%>
			</tr>
			<tr>
				<td>������� ����������</td>
				<td><textarea cols="10" rows="4" class="cl1"
						name="editDescription"
						style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
						<%out.println(READ_ONLY_FLAG);%>>
						<% out.print(editDescription.trim()); %>
					</textarea></td>
			</tr>
			<tr>
				<td>����������</td>
				<td><textarea cols="10" rows="4" class="cl1" name="editNote"
						style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
						<%out.println(READ_ONLY_FLAG);%>>						 
						<% out.print(editNote.trim()); %>						
					</textarea></td>
			</tr>
			<tr style="background-color: <%=COLOR_onControl%>;">
				<td> 	
					<div style="width: 110px;"><%=IMG_onControl%>�� ��������</div>				
				 </td>
			<%
		if(ADMINISTRATOR.equals("true")){
			out.println("					<td><select name=\"editControlStatus\" style=\"width: 130px\" value=\"" + editControlStatus + "\" " + READ_ONLY_FLAG + ">");
			if(editControlStatus.equals("���"))
				out.println("						<option selected style=\"background-color: #33CCFF\">���</option>");
			else
				out.println("						<option style=\"background-color: #33CCFF\">���</option>");
			if(editControlStatus.equals("��"))
				out.println("						<option selected style=\"background-color: #FF6699\">��</option>");
			else
				out.println("						<option style=\"background-color: #FF6699\">��</option>");
			out.println("					</select></td>");	
		}
		else{
			if(editControlStatus.equals("���"))
				out.println("			<td><input type=\"text\" style=\"background-color: #33CCFF\" name=editControlStatus id=editControlStatus value=\""+ editControlStatus + "\" " + READ_ONLY_FLAG + "></td>");
			else
				out.println("			<td><input type=\"text\" style=\"background-color: #FF6699\" name=editControlStatus id=editControlStatus value=\""+ editControlStatus + "\" " + READ_ONLY_FLAG + "></td>");
		}
			
		%>
			</tr>
			<tr>
				<td>������ ������������</td>
				<td>
					<%
		if(ADMINISTRATOR.equals("true")){
			out.println("<select name=\"editUser\" style=\"width:" + DEFAULT_ELEMENT_WIDTH + "px\" value=\"" + editUser + "\">");
				ProeuserSQL.GetUsersWorkingInDepartment(DEPARTMENT);
				while(ProeuserSQL.oRs.next()){
					if(editUser.equals(ProeuserSQL.oRs.getString("FULLNAME")))
						out.println("						<option selected>" + ProeuserSQL.oRs.getString("FULLNAME") + "</option>");
					else
						out.println("						<option>" + ProeuserSQL.oRs.getString("FULLNAME") + "</option>");		
				}	
			out.println("</select>");
			out.println("<input type=button value=�������� onClick=AddUserToTable()>");
			out.println("<br>");
		}
		%>

				<table class="bluedream" width="100%">
					<%
					if(Integer.parseInt(sUsersCount)>0){
						out.println("<tr>");		
						out.println("<td width=100>���</td>");		
						out.println("<td width=100>������</td>");		
						out.println("<td width=100>����������</td>");		
						out.println("<td width=100>���� ������������</td>");		
						out.println("</tr>");		
					}
			for(i=0;i<Integer.parseInt(sUsersCount);i++){
				out.println("			<tr>");				
				out.println("				<td><input type=\"text\" name=\"User" + Integer.valueOf(i).toString() + "\" style=\"width: 100 px\" value=\"" + lUsers.get(i) + "\" " + READ_ONLY_FLAG + "></td>");
				out.println("				<td>");
				if(ADMINISTRATOR.equals("true")){
					READ_ONLY_FLAG="";
					out.println("					<select name=\"Status" + Integer.valueOf(i).toString() + "\" style=\"width: 130px\" value=\"" + lUsersStatus.get(i) + "\" " + READ_ONLY_FLAG + ">");
					if(lUsersStatus.get(i).equals("�������"))
						out.println("						<option selected style=\"background-color: #708090\">�������</option>");
					else
						out.println("						<option style=\"background-color: #708090\">�������</option>");
					if(lUsersStatus.get(i).equals("���������������"))
						out.println("						<option selected style=\"background-color: #ff6c36\">���������������</option>");
					else
						out.println("						<option style=\"background-color: #ff6c36\">���������������</option>");
					if(lUsersStatus.get(i).equals("����������"))
						out.println("						<option selected style=\"background-color: #4169E1\">����������</option>");
					else
						out.println("						<option style=\"background-color: #4169E1\">����������</option>");
					if(lUsersStatus.get(i).equals("��������"))
						out.println("						<option selected style=\"background-color: #339933\">��������</option>");
					else
						out.println("						<option style=\"background-color: #339933\">��������</option>");
					out.println("					</select>");
				}
				else{
					if(lUsersStatus.get(i).equals("�������"))
						out.println("				<input type=\"text\" name=\"Status" + Integer.valueOf(i).toString() + "\" style=\"background-color: #708090\" value=\"" + lUsersStatus.get(i) + "\" " + READ_ONLY_FLAG + ">");
					if(lUsersStatus.get(i).equals("���������������"))
						out.println("				<input type=\"text\" name=\"Status" + Integer.valueOf(i).toString() + "\" style=\"background-color: #ff6c36\" value=\"" + lUsersStatus.get(i) + "\" " + READ_ONLY_FLAG + ">");
					if(lUsersStatus.get(i).equals("����������"))
						out.println("				<input type=\"text\" name=\"Status" + Integer.valueOf(i).toString() + "\" style=\"background-color: #4169E1\" value=\"" + lUsersStatus.get(i) + "\" " + READ_ONLY_FLAG + ">");
					if(lUsersStatus.get(i).equals("��������"))
						out.println("				<input type=\"text\" name=\"Status" + Integer.valueOf(i).toString() + "\" style=\"background-color: #339933\" value=\"" + lUsersStatus.get(i) + "\" " + READ_ONLY_FLAG + ">");

				}
				out.println("				</td>");
				if(lUsers.get(i).equals(FULLNAME)) READ_ONLY_FLAG = "";	
				out.println("				<td><input type=\"text\" name=\"Execute" + Integer.valueOf(i).toString() + "\" style=\"width: 100px\" value=\"" + lUsersExecute.get(i) + "\" " + READ_ONLY_FLAG + "></td>");
				if(ADMINISTRATOR.equals("true")) READ_ONLY_FLAG = "";
				else READ_ONLY_FLAG = "readonly=true";
				out.println("				<td><input type=\"text\" name=\"DateOfRead" + Integer.valueOf(i).toString() + "\" style=\"width: 100px\" value=\"" + lDateOfRead.get(i) + "\" " + READ_ONLY_FLAG + "></td>");
				out.println("			</tr>");
				if(ADMINISTRATOR.equals("true")) READ_ONLY_FLAG = "";
				else READ_ONLY_FLAG = "readonly=true";
			}
			%>
					</table> <br>
				</td>
			</tr>
			<tr>
				<td>����� �������� � ������</td>
				<td>
					<%
		if(ADMINISTRATOR.equals("true")){
			out.println("<select name=\"editCopyToDepartment\" style=\"width:\"" + DEFAULT_ELEMENT_WIDTH + "px\" value=\"" + editCopyToDepartment + "\">");
				ProeuserSQL.GetAllDepartment();
				while(ProeuserSQL.oRs.next()){
					if(editCopyToDepartment.equals(ProeuserSQL.oRs.getString("DEPARTMENT")))
						out.println("						<option selected>" + ProeuserSQL.oRs.getString("DEPARTMENT") + "</option>");
					else
						out.println("						<option>" + ProeuserSQL.oRs.getString("DEPARTMENT") + "</option>");		
				}	
			out.println("</select>");
			out.println("<input type=button value=�������� onClick=AddDepartment()>");
			out.println("<br>");
		}
			%>
				<table class='bluedream'  width='100%'>
				<%
					//������� �� ������� ������� � ������� �������� ����� 
					if(Integer.parseInt(sDepartmentCount)>0){								
						out.println("<tr>");	
						out.println("<td width=200>�����</td>");	
						out.println("</tr>");	
					}
			for(i=0;i<Integer.parseInt(sDepartmentCount);i++){
				out.println("			<tr>");
				if(ADMINISTRATOR.equals("true")){
					out.println("					<td><select name=\"Department" + Integer.valueOf(i).toString() + "\" style=\"width: style='width: "+DEFAULT_ELEMENT_WIDTH+ "px'\" value=\"" + lDepartment.get(i) + "\">");
					ProeuserSQL.GetAllDepartment();
					while(ProeuserSQL.oRs.next()){
						if(lDepartment.get(i).equals(ProeuserSQL.oRs.getString("DEPARTMENT")))
							out.println("						<option selected>" + ProeuserSQL.oRs.getString("DEPARTMENT") + "</option>");
						else
							out.println("						<option>" + ProeuserSQL.oRs.getString("DEPARTMENT") + "</option>");			
					}
					out.println("					</td></select>");
				}
				else{
					out.println("			<td><input type=\"text\" name=\"Department" + Integer.valueOf(i).toString() + "\" name=\"Department" + Integer.valueOf(i).toString() + "\" style=\"width: " + DEFAULT_ELEMENT_WIDTH + "px\" value=\""+ lDepartment.get(i) + "\" " + READ_ONLY_FLAG + "></td>");
				}
				out.println("			</tr>");
			}
			%>
					</table>
				</td>
				<%			
		if(editDatafile.equals("")){
			out.println("	</tr> ");
			out.println("	<tr>");
			out.println("		<td>����</td>");
			out.println("		<td><input type=\"file\" name=\"editDatafile\" style=\"width: 100%;\" value=\"" + editDatafile+ "\"></td>");
			out.println("	</tr>");
		}
%>
			
		</table>
		<hr>
		<input type=hidden name=action> 
		<input type=hidden	name=SessionUser value="<% out.print(SessionUser);%>"> 
		<input type=hidden name=ADMINISTRATOR value="<% out.print(ADMINISTRATOR);%>">
		<input type=hidden name=FULLNAME value="<% out.print(FULLNAME);%>">
		<input type=hidden name=DEPARTMENT value="<% out.print(DEPARTMENT);%>">
		<input type=hidden name=sUsersCount	value="<% out.print(sUsersCount);%>"> 
		<input type=hidden	name=sDepartmentCount value="<% out.print(sDepartmentCount);%>">
		<input type=hidden name=sCurrentUsersCount	value="<% out.print(sCurrentUsersCount);%>"> 
		<input type=hidden name=sCurrentDepartmentCount	value="<% out.print(sCurrentDepartmentCount);%>"> 
		<input type=hidden name=selOutNumber value="<% out.print(selOutNumber);%>">
		<input type=hidden name=selDocType value="<% out.print(selDocType);%>">
		<input type=hidden name=selDescriptionText	value="<% out.print(selDescriptionText);%>"> 
		<input type=hidden name=selRegNumberBefore value="<% out.print(selRegNumber);%>"> 
		<input type=hidden name=selAuthor value="<% out.print(selAuthor);%>"> 
		<input type=hidden name=selProduct value="<% out.print(selProduct);%>">
	    <input type=hidden name=TYPESORTING	value="<% out.print(TYPESORTING);%>">

		<!-- 1 - ���������� ������ � ������� � ������ �� ������� �������� -->
		<!-- 2 - ���������� ������������ -->
		<!-- 3 - ���������� ������ -->
		<!-- 4 - ������ -->
		<!-- 5 - �������� -->
		<input type=button value=�������� onClick="EditExecute();">
<%
	if(ADMINISTRATOR.equals("true"))
		out.println("<input type=button value=������� onClick=DeleteExecute()>");
	ProeuserSQL.Disconnect();
%>
		<input type=button value=������ onClick="CancelExecute()">

	</form>
</div>
<script type="text/javascript">	AllTrimEdit();</script> <!-- ��� �������������� ����� ��� �������� �������� -->		
</body>
</html>
