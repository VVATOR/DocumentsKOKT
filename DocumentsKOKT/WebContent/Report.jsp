<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="config.jsp"%>
<!-- файл с глобальными настрайками и библиотеками -->
<%@page import="java.util.*"%>

<html>
<head>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1251">
<title><%=PROGRAMM_name%> / Отчет</title>
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
//ОБЪЯВЛЕНИЕ ПЕРЕМЕННЫХ
//----------------------------------------------------------------------------------------
//данные о пользователе 
    String TYPESORTING="i";           /// тип сортировки (по отделу или пользователю) 
 
	String SessionUser = ""; 													//логин пользователя
	String FULLNAME = ""; 														//ФИО
	String DEPARTMENT = ""; 													//Отдел
	String DateFrom="";															//дата с																	
	String DateTo="";															//дата по
	String PAGE_IND="";											                //номер страницы (со знаком "-") в списке страниц history, к которой нужно вернуться по кнопке "Отмена"
	int department_id=-1;														//id отдела текущего пользователя
	int all_docs_count=0;														//общее количество документов
	int all_executors_count=0;													//общее количество исполнителей
	ProeuserSQLRequest proeuser=new ProeuserSQLRequest();						//объект для работы с базой данных
 
//----------------------------------------------------------------------------------------
//ПОЛУЧЕНИЕ ПАРАМЕТРОВ ПЕРЕДАННЫХ СТРАНИЦЕ
//----------------------------------------------------------------------------------------

	
	//ФИО текущего пользователя
	if (request.getParameter("FULLNAME") != null) {
		FULLNAME = new String(request.getParameter("FULLNAME").getBytes("ISO-8859-1"));
		FULLNAME = URLDecoder.decode(FULLNAME, "windows-1251");
	} 
	//Логин текущего пользователя
	if (request.getParameter("SessionUser") != null){
		SessionUser = new String(request.getParameter("SessionUser").getBytes("ISO-8859-1"));
	}
	//Отдел текущего пользователя
	if (request.getParameter("DEPARTMENT") != null) {
		DEPARTMENT = new String(request.getParameter("DEPARTMENT").getBytes("ISO-8859-1"));
		DEPARTMENT = URLDecoder.decode(DEPARTMENT, "windows-1251");
	} 
	//дата с
	if(request.getParameter("DateFrom")!=null){
		DateFrom=new String(request.getParameter("DateFrom").getBytes("ISO-8859-1"));
	}
	//дата по
	if(request.getParameter("DateTo")!=null){
		DateTo=new String(request.getParameter("DateTo").getBytes("ISO-8859-1"));
	}
	//номер страницы со знаком "-"
	if(request.getParameter("PAGE_IND")!=null){
		PAGE_IND=new String(request.getParameter("PAGE_IND").getBytes("ISO-8859-1"));
	}
	
	
//----------------------------------------------------------------------------------------
//  ВЫВОДИМ ДАННЫЕ О ПОЛЬЗОВАТЕЛЕ
//----------------------------------------------------------------------------------------
	if (!FULLNAME.equals("")) {
		out.println("<img src=\"images/personal.png\" width=\"16\" height=\"16\"/>  Вы авторизированы в системе как: ");
		out.println(FULLNAME + "  (" + DEPARTMENT + ")");
	}
%>

	<h3 align=center>Отчет о входящей корреспонденции</h3>
	<form name=filters>
		<hr>
		<table align=center border=0>
			<tr>
				<td>С</td>
				<td width=200><input type="text" name="DateFrom" id="DateFrom"
					value="dd-mm-yy" onfocus="this.select();lcs(this)"
					onclick="event.cancelBubble=true;this.select();lcs(this)">
				</td>
				<td>По</td>
				<td width=200><input type="text" name="DateTo" id="DateTo"
					value="dd-mm-yy" onfocus="this.select();lcs(this)"
					onclick="event.cancelBubble=true;this.select();lcs(this)">
				</td>
				<td><input type="submit" name=ReportButton
					value="Сформировать отчет"></td>
				<td width=120 align="right"><input type="button"
					name=CancelButton value="Отмена" onClick="cancel_report()">
				</td>
			</tr>
		</table>
		<script type="text/javascript">
					<%
						Calendar today=Calendar.getInstance(); //создаем Calendar-объект для заданного по умолчанию языкового региона и часового пояса
						int day=today.get(Calendar.DATE); //получаем текущее число
						String month="";
						int temp;
						int year=today.get(Calendar.YEAR);//получаем текущий год
						temp=today.get(Calendar.MONTH)+1;//получаем текущий месяц
						if(temp<10)
							month+='0';
						month+=temp;
						String cur_date="";
						if(day<10)
							cur_date+='0';
						cur_date+=""+day+'.'+month+'.'+year; //формируем текущую дату
					
						Calendar first=Calendar.getInstance();
						first.add(Calendar.MONTH,-1);//возвращаемся на месяц назад
						int first_day=first.get(Calendar.DATE); //получаем число
						String first_month="";
						int first_temp;
						int first_year=first.get(Calendar.YEAR);//получаем год
						first_temp=first.get(Calendar.MONTH)+1;//получаем месяц
						if(first_temp<10)
							first_month+='0';
						first_month+=first_temp;
						String first_date="";
						if(first_day<10)
							first_date+='0';
						first_date+=""+first_day+'.'+first_month+'.'+first_year;  //формируем дату на 10 дней раньше
					
					
						String from_str="";
						if(request.getParameter("DateFrom") != null)
							from_str=new String(request.getParameter("DateFrom").getBytes("ISO-8859-1"));
						else{ 
							from_str=first_date;// присвоить дату по умолчанию на месяц раньше
							DateFrom=first_date;
						}
						out.println("document.filters.DateFrom.value='"+from_str+"';");
						String to_str="";
						if(request.getParameter("DateTo")!=null)
							to_str=new String(request.getParameter("DateTo").getBytes("ISO-8859-1"));
						else{
							to_str=cur_date;// получить текущую дату на джаве
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
			<td>Тематика</td>
			<td>Количество документов</td>
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
			out.println("Всего документов");
			out.println("</td>");
			out.println("<td>");
			out.println(all_docs_count);
			out.println("</td>");
			out.println("</tr>");
			all_executors_count=proeuser.GetExecutorsCount(DateFrom, DateTo, department_id);
			out.println("<tr>");
			out.println("<td>");
			out.println("Количество исполнителей");
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