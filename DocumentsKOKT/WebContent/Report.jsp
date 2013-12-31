<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="config.jsp"%>
<!-- ���� � ����������� ����������� � ������������ -->
<%@page import="java.util.*"%>

<html>
<head>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1251">
<title><%=PROGRAMM_name%> / �����</title>
<link rel="stylesheet" type="text/css"
	href="js/jquery-ui-1.8.2.custom.css" />
<script src="js/jquery-1.4.4.js"></script>
<script type="text/javascript" language="javascript"
	src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" language="javascript"
	src="js/jquery-ui-1.8.custom.min.js"></script>
<script src="js/calendar_ru.js"></script>

<script type="text/javascript">
	function page_number(){
		document.getElementById("PAGE_IND").value=document.getElementById("PAGE_IND").value-1;
	}
	function cancel_report(){
		history.go(document.getElementById("PAGE_IND").value);
	}
</script>

<%response.setHeader("Cache-Control", "no-cache"); %>
</head>
<body onload="page_number()">
	<%
//----------------------------------------------------------------------------------------
//���������� ����������
//----------------------------------------------------------------------------------------
//������ � ������������ 
    String TYPESORTING="i";           /// ��� ���������� (�� ������ ��� ������������) 
 
	String SessionUser = ""; 													//����� ������������
	String FULLNAME = ""; 														//���
	String DEPARTMENT = ""; 													//�����
	String DateFrom="";															//���� �																	
	String DateTo="";															//���� ��
	String PAGE_IND="";											                //����� �������� (�� ������ "-") � ������ ������� history, � ������� ����� ��������� �� ������ "������"
	int department_id=-1;														//id ������ �������� ������������
	int all_docs_count=0;														//����� ���������� ����������
	int all_executors_count=0;													//����� ���������� ������������
	ProeuserSQLRequest proeuser=new ProeuserSQLRequest();						//������ ��� ������ � ����� ������
 
//----------------------------------------------------------------------------------------
//��������� ���������� ���������� ��������
//----------------------------------------------------------------------------------------

	
	//��� �������� ������������
	if (request.getParameter("FULLNAME") != null) {
		FULLNAME = new String(request.getParameter("FULLNAME").getBytes("ISO-8859-1"));
		FULLNAME = URLDecoder.decode(FULLNAME, "windows-1251");
	} 
	//����� �������� ������������
	if (request.getParameter("SessionUser") != null){
		SessionUser = new String(request.getParameter("SessionUser").getBytes("ISO-8859-1"));
	}
	//����� �������� ������������
	if (request.getParameter("DEPARTMENT") != null) {
		DEPARTMENT = new String(request.getParameter("DEPARTMENT").getBytes("ISO-8859-1"));
		DEPARTMENT = URLDecoder.decode(DEPARTMENT, "windows-1251");
	} 
	//���� �
	if(request.getParameter("DateFrom")!=null){
		DateFrom=new String(request.getParameter("DateFrom").getBytes("ISO-8859-1"));
	}
	//���� ��
	if(request.getParameter("DateTo")!=null){
		DateTo=new String(request.getParameter("DateTo").getBytes("ISO-8859-1"));
	}
	//����� �������� �� ������ "-"
	if(request.getParameter("PAGE_IND")!=null){
		PAGE_IND=new String(request.getParameter("PAGE_IND").getBytes("ISO-8859-1"));
	}
	
	
//----------------------------------------------------------------------------------------
//  ������� ������ � ������������
//----------------------------------------------------------------------------------------
	if (!FULLNAME.equals("")) {
		out.println("<img src=\"images/personal.png\" width=\"16\" height=\"16\"/>  �� �������������� � ������� ���: ");
		out.println(FULLNAME + "  (" + DEPARTMENT + ")");
	}
%>

	<h3 align=center>����� � �������� ���������������</h3>
	<form name=filters>
		<hr>
		<table align=center border=0>
			<tr>
				<td>�</td>
				<td width=200><input type="text" name="DateFrom" id="DateFrom"
					value="dd-mm-yy" onfocus="this.select();lcs(this)"
					onclick="event.cancelBubble=true;this.select();lcs(this)">
				</td>
				<td>��</td>
				<td width=200><input type="text" name="DateTo" id="DateTo"
					value="dd-mm-yy" onfocus="this.select();lcs(this)"
					onclick="event.cancelBubble=true;this.select();lcs(this)">
				</td>
				<td><input type="submit" name=ReportButton
					value="������������ �����"></td>
				<td width=120 align="right"><input type="button"
					name=CancelButton value="������" onClick="cancel_report()">
				</td>
			</tr>
		</table>
		<script type="text/javascript">
					<%
						Calendar today=Calendar.getInstance(); //������� Calendar-������ ��� ��������� �� ��������� ��������� ������� � �������� �����
						int day=today.get(Calendar.DATE); //�������� ������� �����
						String month="";
						int temp;
						int year=today.get(Calendar.YEAR);//�������� ������� ���
						temp=today.get(Calendar.MONTH)+1;//�������� ������� �����
						if(temp<10)
							month+='0';
						month+=temp;
						String cur_date="";
						if(day<10)
							cur_date+='0';
						cur_date+=""+day+'.'+month+'.'+year; //��������� ������� ����
					
						Calendar first=Calendar.getInstance();
						first.add(Calendar.MONTH,-1);//������������ �� ����� �����
						int first_day=first.get(Calendar.DATE); //�������� �����
						String first_month="";
						int first_temp;
						int first_year=first.get(Calendar.YEAR);//�������� ���
						first_temp=first.get(Calendar.MONTH)+1;//�������� �����
						if(first_temp<10)
							first_month+='0';
						first_month+=first_temp;
						String first_date="";
						if(first_day<10)
							first_date+='0';
						first_date+=""+first_day+'.'+first_month+'.'+first_year;  //��������� ���� �� 10 ���� ������
					
					
						String from_str="";
						if(request.getParameter("DateFrom") != null)
							from_str=new String(request.getParameter("DateFrom").getBytes("ISO-8859-1"));
						else{ 
							from_str=first_date;// ��������� ���� �� ��������� �� ����� ������
							DateFrom=first_date;
						}
						out.println("document.filters.DateFrom.value='"+from_str+"';");
						String to_str="";
						if(request.getParameter("DateTo")!=null)
							to_str=new String(request.getParameter("DateTo").getBytes("ISO-8859-1"));
						else{
							to_str=cur_date;// �������� ������� ���� �� �����
							DateTo=cur_date;
						}
						out.println("document.filters.DateTo.value='"+to_str+"';");
					%>
				</script>
		<hr>
		<input type="hidden" name=SessionUser value=<%=SessionUser%>>
		<input type="hidden" name=FULLNAME
			value=<%=URLEncoder.encode(FULLNAME, "windows-1251")%>> <input
			type="hidden" name=DEPARTMENT
			value=<%=URLEncoder.encode(DEPARTMENT, "windows-1251")%>> <input
			type="hidden" name=PAGE_IND id=PAGE_IND value=<%=PAGE_IND%>>
	</form>

	<table align="center" border=3 bgcolor="#D3E4E5">
		<tr bgcolor="#9ecdd0">
			<!-- #D3E4E5 -->
			<td>��������</td>
			<td>���������� ����������</td>
		</tr>
		<%
		if(!DateTo.equals("") && !DateFrom.equals("")){
			department_id=proeuser.GetDepartmentId(DEPARTMENT);
			all_docs_count=proeuser.GetReport(DateFrom, DateTo, department_id);
			while(proeuser.oRs.next()){
				out.println("<tr>");
				out.println("<td>");
				out.println(proeuser.oRs.getString("PRODUCT"));
				out.println("</td>");
				out.println("<td align=right>");
				out.println(proeuser.oRs.getString("res_count"));
				out.println("</td>");
				out.println("</tr>");
			}
			out.println("<tr>");
			out.println("<td>");
			out.println("����� ����������");
			out.println("</td>");
			out.println("<td>");
			out.println(all_docs_count);
			out.println("</td>");
			out.println("</tr>");
			all_executors_count=proeuser.GetExecutorsCount(DateFrom, DateTo, department_id);
			out.println("<tr>");
			out.println("<td>");
			out.println("���������� ������������");
			out.println("</td>");
			out.println("<td>");
			out.println(all_executors_count);
			out.println("</td>");
			out.println("</tr>");
		}
		proeuser.Disconnect();
	%>
	</table>
</body>
</html>