<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="config.jsp"%>
<!-- ���� � ����������� ����������� � ������������ -->

<html>
<head>
<link rel="stylesheet" title="default" href="css/highslide.css"
	type="text/css" />
<link rel="stylesheet" href="css/bluedream.css">
<script type="text/javascript" src="js/highslide-full.packed.js"></script>
<script language="javascript" type="text/javascript"> 
  hs.graphicsDir = 'http://ucozua.ru/highslide/graphics/'; 
  hs.transitions = ["fade"]; 
  hs.outlineType = 'beveled'; 
  hs.zIndexCounter = '2000'; 
  hs.align = 'center'; 
  hs.numberOfImagesToPreload = 0; 
  hs.showCredits = false; 
  hs.lang = { 
  loadingText : '��������...', 
  playTitle : '�������� �������� (������)', 
  pauseTitle: '�����', 
  previousTitle : '���������� �����������', 
  nextTitle : '��������� �����������', 
  moveTitle : '�����������', 
  closeTitle : '������� (Esc)', 
  fullExpandTitle : '���������� �� ������� �������', 
  restoreTitle : '�������� ��� �������� ��������, ������� � ����������� ��� �����������', 
  focusTitle : '�������������', 
  loadingTitle : '������� ��� ������' 
  }; 
  hs.addSlideshow({ 
  interval: 4000, 
  repeat: false, 
  useControls: true, 
  fixedControls: 'fit', 
  overlayOptions: { 
  opacity: .75, 
  position: 'bottom center', 
  hideOnMouseOut: true 
  } 
  }); 
//--> 
</script>
<title><%=PROGRAMM_name%></title>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1251">

</head>
<body>
	<%
//----------------------------------------------------------------------------------------
//                               ���������� ����������
//----------------------------------------------------------------------------------------
 String TYPESORTING="";
 String ADMINISTRATOR = "false"; 											//�������������
 String SessionUser = ""; 													//����� ������������
 String FULLNAME = ""; 														//���
 String DEPARTMENT = ""; 													//�����
 String DOC_ID= "";															//������������� ���������������� ���������
 int i;																		//�������
 //��������� ���������� � ������� ������� ��� ������ � ����� ������
 ProeuserSQLRequest ProeuserSQL = new ProeuserSQLRequest();
//----------------------------------------------------------------------------------------
//                      ��������� ���������� ���������� ��������
//----------------------------------------------------------------------------------------
  //�������������
 if (request.getParameter("ADMINISTRATOR") != null) {
	ADMINISTRATOR = new String(request.getParameter("ADMINISTRATOR").getBytes("ISO-8859-1"));
	ADMINISTRATOR = URLDecoder.decode(ADMINISTRATOR, "windows-1251");
 } else ADMINISTRATOR = "false";
 
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
 //�������� ������������� ���������
 if (request.getParameter("DOC_ID") != null)
	 DOC_ID = new String(request.getParameter("DOC_ID").getBytes("ISO-8859-1"));

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
			DEPARTMENT = ProeuserSQL.oRs.getString("DEPARTMENT");
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
	out.println("<BR>");
	out.println("<a href=\"image.jsp?DOC_ID=" + DOC_ID + "\" class=\"highslide\" onclick=\"return hs.expand(this)\"> ");
	out.println("<img src=\"image.jsp?DOC_ID=" + DOC_ID + "\" style=\"max-width: 350px;border: 1px solid rgb(204, 204, 204);\" title=\"������� ����� ���������\"> ");
	out.println("</a>");
	ProeuserSQL.Disconnect();
%>
	<form></form>

</body>
</html>