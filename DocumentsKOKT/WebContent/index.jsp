<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="config.jsp"%>
<!-- файл с глобальными настрайками и библиотеками -->
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>

<html>
<head>
<title><%=PROGRAMM_name%></title>
<style>
body {
	margin: 0px;  
	padding: 0px;
		  scrollbar-face-color:#5997CA; 
          scrollbar-shadow-color: #ffffff;
          scrollbar-highlight-color: #ffffff;
          scrollbar-3dlight-color: #5997CA;
          scrollbar-darkshadow-color: #5997CA; 
          scrollbar-track-color: #F6F6F6;
          scrollbar-arrow-color: #F6F6F6; 
}

/* кнопки снизу с пэйджингом (количеством записей) */
.paging {
	color: white;
	background-color: #5C443A;
	outline: none;
	width: 100px;
	height: 30px;
	border-width: 1px;
	padding: 5px;
	margin: 5px;
}

.inButton {
	height: 32px;
	width: 32px;
	outline: none;
	outline-width: 0;
}


</style>

<link rel='stylesheet' href='modules/calendar/calendar.css'	type='text/css'>
<script type='text/javascript' src='modules/calendar/calendar.js' charset="Windows-1251"></script>

<script type="text/javascript" language="JavaScript">
	function changeImg1(source) {  
		document.pict1.src = source + '.png';
 	};

	function ExecuteFilter(){
		Main.submit();
	}
</script>

<script src="js/jquery.min.js" type="text/javascript"></script>
<script src="js/jquery.loading.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="css/bluedream.css">


<meta http-equiv="Content-Type"	content="text/html; charset=windows-1251">
</head>
<body>
<a name="inTop"></a>

	<div style='left: 0px;; width: 20px; position: fixed; height: 100%;'>
		<div style="position: fixed; bottom: 10px; left: 10px">
			<a class="inButton" href="#inBottom"> <img class="inButton"	src="images/sort_desc.png" title="вниз"> <!-- вниз --> </a>
		</div>

		<div style="position: fixed; top: 60px; left: 10px">
			<a class="inButton" href="#inTop"> <img class="inButton" src="images/sort_asc.png" title="вверх"> <!--вверх -->	</a>
		</div>
	</div>
<%
//----------------------------------------------------------------------------------------
//                               ОБЪЯВЛЕНИЕ ПЕРЕМЕННЫХ 
//----------------------------------------------------------------------------------------
DateFormat dateformat = new SimpleDateFormat("dd.MM.yyyy");		
//данные о пользователе 
 String TYPESORTING="i";           /// тип сортировки (по отделу или пользователю) 
// String countItemInpage="500";    /// количество записей в таблице на странице
 String START_PAGING="";
 String END_PAGING="";
	
 String SessionUser = ""; 													//логин пользователя
 String FULLNAME = ""; 														//ФИО
 String DEPARTMENT = ""; 													//Отдел
 String ADMINISTRATOR = "false"; 											//Администратор
 //переменные фильтра
 String selOutNumber = "";													//№ исход
 String selDocType = "";													//Вид документа
 String selDescriptionText = "";											//Содержащий текст
 String selRegNumber = "";													//№ регистр.
 String selAuthor = "";														//Отправитель
 String selProduct = "";													//Машина
 String selIdDep="";														//№ П/П 
 String selByISPFamily="";													//фамилия исполнителя для сортировки
 String selStartDate="";													//начальная дата сортировки
 String selEndDate="";														//конечная дата сортировки
 String selOnControler="";                                                  //на контроле для поиска 
 
 //Адрес
 String URL = "";
 String URL_report="";
 String URL_USERS = "";
 String URL_DEPARTMENT = "";
 //количество
 String sUsersCount = "0";													//Количество исполнителей
 String sDepartmentCount = "0";												//Количество отделов (куда передана копия)
 //Для вывода в таблицу
 String ID = "";
 String PRODUCT = "";
 String AUTHOR = "";
 String REG_NUMBER = "";
 String OUT_NUMBER = "";
 String DOCTYPE= "";
 String DESCRIPTION = "";
 String STATUS = "";
 String EXECUTE = "";
 String sqlDEPARTMENT = "";
 String sqlFULLNAME = "";
 String NOTE = "";
 String CONTROL_STATUS = "";
 String DATE_OF_READ = "";
 String FILE_ID = "";
 //цвет для статуса
 String Color = "";
 //прочие переменные 
 int i;																		//счетчик
 String sTextOfExecutersStatus = "";										//текст для списка исполнителей
 String sTextOfExecutersExecute = "";										//текст для статуса
 String sTextOfDepartments = "";											//текст для списка отделов
 String sPreviousID = "";													//предыдущий ID
 boolean ClassAdd = false;													//для оформления таблицы
 //объявляем переменные и создаем объекты для работы с базой данных
 ProeuserSQLRequest ProeuserSQL = new ProeuserSQLRequest();
//----------------------------------------------------------------------------------------
//                      ПОЛУЧЕНИЕ ПАРАМЕТРОВ ПЕРЕДАННЫХ СТРАНИЦЕ
//----------------------------------------------------------------------------------------
 //Администратор
 if (request.getParameter("ADMINISTRATOR") != null) {
	ADMINISTRATOR = new String(request.getParameter("ADMINISTRATOR").getBytes("ISO-8859-1"));
	ADMINISTRATOR = URLDecoder.decode(ADMINISTRATOR, "windows-1251");
 } else ADMINISTRATOR = "false";
 
 //ТИП СОРТИРОВКИ
 if(request.getParameter("TYPESORTING")!=null){
   TYPESORTING = new String(request.getParameter("TYPESORTING").getBytes("ISO-8859-1"));
	TYPESORTING = URLDecoder.decode(TYPESORTING, "windows-1251");
 }else{	
	TYPESORTING = "i";
	if(ADMINISTRATOR == "false")	TYPESORTING = "all";
 } 
 
 //startPaging   начало блока пэйджинга
 if (request.getParameter("START_PAGING") != null) {
	 START_PAGING = new String(request.getParameter("START_PAGING").getBytes("ISO-8859-1"));
	 START_PAGING = URLDecoder.decode(START_PAGING, "windows-1251");
 } else START_PAGING = "";
 
 //endPaging   конец блока пэйджинга
 if (request.getParameter("END_PAGING") != null) {
	 END_PAGING = new String(request.getParameter("END_PAGING").getBytes("ISO-8859-1"));
	 END_PAGING = URLDecoder.decode(END_PAGING, "windows-1251");
 } else END_PAGING = ""; 
 
////////////////////////////////////////////////////////////////////////////////////
//date1
 Date date1 = new Date();
 //String selStartDate="";
 if (request.getParameter("selStartDate") != null) {
	 selStartDate = new String(request.getParameter("selStartDate").getBytes("ISO-8859-1"));
	 selStartDate = URLDecoder.decode(selStartDate, "windows-1251");
 } else selStartDate = "01.01.2000"; 
// date2
 Date date2 = new Date(); 
 String date_2="";
 if (request.getParameter("selEndDate") != null) {
	 selEndDate = new String(request.getParameter("selEndDate").getBytes("ISO-8859-1"));
	 selEndDate = URLDecoder.decode(selEndDate, "windows-1251");
 } else selEndDate = dateformat.format(new Date()).toString(); 
////////////////////////////////////////////////////////////////////////////////////// 

 //ФИО текущего пользователя
 if (request.getParameter("FULLNAME") != null) {
	FULLNAME = new String(request.getParameter("FULLNAME").getBytes("ISO-8859-1"));
	FULLNAME = URLDecoder.decode(FULLNAME, "windows-1251");
 } else FULLNAME = "";
 //Логин текущего пользователя
 if (request.getParameter("SessionUser") != null)
	SessionUser = new String(request.getParameter("SessionUser").getBytes("ISO-8859-1"));
 else SessionUser = "";
 //Отдел текущего пользователя
 if (request.getParameter("DEPARTMENT") != null) {
 	DEPARTMENT = new String(request.getParameter("DEPARTMENT").getBytes("ISO-8859-1"));
	DEPARTMENT = URLDecoder.decode(DEPARTMENT, "windows-1251");
 } else DEPARTMENT = "";
 //№ исходящего
 if (request.getParameter("selOutNumber") != null) {
	 selOutNumber = new String(request.getParameter("selOutNumber").getBytes("ISO-8859-1"));
	 selOutNumber = URLDecoder.decode(selOutNumber, "windows-1251");
 }									
 //Вид документа
 if (request.getParameter("selDocType") != null) {
	 selDocType = new String(request.getParameter("selDocType").getBytes("ISO-8859-1"));
	 selDocType = URLDecoder.decode(selDocType, "windows-1251");
	 if(selDocType.equals("")) selDocType = "Все";
 }	
 //Содержащий текст
 if (request.getParameter("selDescriptionText") != null) {
	 selDescriptionText = new String(request.getParameter("selDescriptionText").getBytes("ISO-8859-1"));
	 selDescriptionText = URLDecoder.decode(selDescriptionText, "windows-1251");
 }	
 //№ регистр
 if (request.getParameter("selRegNumber") != null) {
	 selRegNumber = new String(request.getParameter("selRegNumber").getBytes("ISO-8859-1"));
	 selRegNumber = URLDecoder.decode(selRegNumber, "windows-1251");
 }	
 //Отправитель
 if (request.getParameter("selAuthor") != null) {
	 selAuthor = new String(request.getParameter("selAuthor").getBytes("ISO-8859-1"));
	 selAuthor = URLDecoder.decode(selAuthor, "windows-1251");
	 if(selAuthor.equals("")) selAuthor = "Все";
 }	
 //Машина
 if (request.getParameter("selProduct") != null) {
	 selProduct = new String(request.getParameter("selProduct").getBytes("ISO-8859-1"));
	 selProduct = URLDecoder.decode(selProduct, "windows-1251");
	 if(selProduct.equals("")) selProduct = "Все";
 }	  
 //№ П/П
 if(request.getParameter("selIdDep")!=null){
	 selIdDep=new String(request.getParameter("selIdDep").getBytes("ISO-8859-1"));
	 selIdDep = URLDecoder.decode(selIdDep, "windows-1251");
 } 
 //для поиска по исполнителю
 if (request.getParameter("selByISPFamily") != null) {
	 selByISPFamily = new String(request.getParameter("selByISPFamily").getBytes("ISO-8859-1"));
	 selByISPFamily = URLDecoder.decode(selByISPFamily, "windows-1251");
	 if(selByISPFamily.equals("")) selByISPFamily = "Все";
 }  
 //на контроле (галочка)
 if (request.getParameter("selOnControler") != null){
	selOnControler=new String("checked");
 } else selOnControler=new String("");

 
//----------------------------------------------------------------------------------------
//                          Получение текущего пользователя
//         выполняется, если странице не были переданы данные о пользователе
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
		//убираем лишние символы
		i = 0;
		String str1 = "";
		while (i < s.length()) {
			str1 += s.charAt(i);
			i = i + 2;
		}
		s = str1;
		//out.print(str1+"=username");
	    //s="LENAVG";
		//s="IHVOST";
		//s="Ura";
		//s="MTD";
		//s="Daa";
		//s = "VIKAVG";
		//s = "olegVV";
     	//s = "ZNA"; //boss=1
    	//s = "MSN"; //boss=2
     	//s = "DAA";		
		//s = "AVDEEVA";
		//s = "ZURAA";
		//s = "MSN";
		//s="ANTONGK";
		//s="SERGV";
		//s="ALEXNT";
		//s="EGORVK";
		//s="KRUCHAA";
		//s="OLAG";
		//s="ULIAVS";
		SessionUser = s;
		//получаем ФИО этого пользователя
		FULLNAME = "";
		DEPARTMENT = ""; 
		ProeuserSQL.GetUserFioAndDepartmentFromLogin(s);
		while (ProeuserSQL.oRs.next()) {
			FULLNAME = ProeuserSQL.oRs.getString("FULLNAME");
			DEPARTMENT = ProeuserSQL.oRs.getString("DEPARTMENT_ABB");
			if(ProeuserSQL.oRs.getString("PERMISSION") != null)
				if(ProeuserSQL.oRs.getString("PERMISSION").equals("1")) ADMINISTRATOR = "true";
		}
	}	
 
	//ТИП СОРТИРОВКИ
	if(request.getParameter("TYPESORTING")!=null){
	  	TYPESORTING = new String(request.getParameter("TYPESORTING").getBytes("ISO-8859-1"));
	  	TYPESORTING = URLDecoder.decode(TYPESORTING, "windows-1251");
	}else{	
	 	TYPESORTING = "i";
	 	if(ADMINISTRATOR == "true"){
	  	TYPESORTING = "all";
	 	}		
	}
}

/*
//----------------------------------------------------------------------------------------
//                           ВЫВОДИМ ДАННЫЕ О ПОЛЬЗОВАТЕЛЕ
//----------------------------------------------------------------------------------------
*/
%> 

	<table border=0 CELLPADDING=0 CELLSPACING=0> 
		<tr>
			<td width=585 rowspan="2"><img 	src="images/<%//System.out.println("INFO: Department = " + DEPARTMENT);
											 boolean dep_lbl = false;
											 if(DEPARTMENT.equals("КО КТ"))  { out.print("1_KT.png"); dep_lbl = true;}; 
											 if(DEPARTMENT.equals("КО УЭС")) { out.print("1_UES.png"); dep_lbl = true;};  
											 if(DEPARTMENT.equals("КИО ВС")) { out.print("1_KIOVS.png"); dep_lbl = true;};
											 if(dep_lbl == false) out.print("1_1.png"); //картинка по умолчанию (без отдела)
							%>"></img>
			</td> 
			<% 
			if(!FULLNAME.equals(""))
				out.println("<td height=30 width=100% background=\"images/2.png\"><div align=right>Вы авторизированы в системе как: " + FULLNAME + "</div></td>");
			else
				out.println("<td height=30 width=100% background=\"images/2.png\"><div align=right></div></td>");
			%>
		</tr>
		<tr>
			<td style="text-align: right;">
				<a href="Notes.jsp"	style="color: black;"> Предложения </a>
			</td>
		</tr>
		<tr height=30>
		</tr>
	</table>
	
	
	

<form name="Main">
	<table border="0" cellspacing="1" align=center width="1200" class="bluedream">
		
	
		<tr style="background-color: white; border-width: 0px;">
			<th colspan="8">
				<script type="text/javascript">
					function allSort(parObj){
					 document.Main.TYPESORTING.value=parObj;				 
					 document.Main.START_PAGING.value ="";
					 document.Main.END_PAGING.value  ="";							
					 Main.submit();				 
					};
				</script> 
				<input
				type="button"
				style="background: url(images/e_mail32.png) no-repeat; width: 70px; height: 50px; padding: 20px; margin: 3px; outline: none; border-width: 0px; color: BLUE; font-weight: bold;"
				value="<%out.println(ProeuserSQL.countOnlyI(SessionUser)); %>"
				title="Корреспонденция для вас" onclick="document.forms.Main.reset(); window.location = 'index.jsp?TYPESORTING=i';// allSort('i');" />
				<%		    // вывод колличества для кнопки личной корреспонденции		
				   			// все записи  
				   			//int kolAllInI = ProeuserSQL.countOnlyI(SessionUser);
				   		    //out.println("<span style='color:green; ' title='Всего' onclick='allSort(\"i\");'>"+ kolAllInI+"</span>");
				   			
				   			// найдено в личных
				   			//int kolFindInI = ProeuserSQL.countFOUNDForI(SessionUser,selOutNumber, selDocType, selDescriptionText, selRegNumber, selAuthor, selProduct,selIdDep);	
							//if(kolFindInI!=kolAllInI) out.println(" / <span style='color:orange;' title='Найдено'>" +kolFindInI+ "</span>");									 		
				%>
				
				<input type="button"
				style="background: url(images/mail.png) no-repeat; width: 70px; height: 50px; padding: 20px; margin: 3px; outline: none; border-width: 0px; color: red; font-weight: bolder;"
				value="<%out.println(ProeuserSQL.countAllForDepartment(SessionUser,selOutNumber, selDocType, selDescriptionText, selRegNumber, selAuthor, selProduct,selIdDep)); %>"
				title="Корреспонденция вашего отдела" onclick="document.forms.Main.reset(); window.location = 'index.jsp?TYPESORTING=all';//allSort('all');" />
				<%		    // вывод колличества для кнопки отдела		
				   			// все записи
				   			//int kolAllInDep = ProeuserSQL.countAllForDepartment(SessionUser,selOutNumber, selDocType, selDescriptionText, selRegNumber, selAuthor, selProduct,selIdDep);
				   			//out.println("<span style='color:green; ' title='Всего' onclick='allSort(\"all\");'>"+ kolAllInDep+"</span>");
				   			
				   			// найдено в отделе
				   			//int kolFind = ProeuserSQL.countFOUNDForDepartment(SessionUser,selOutNumber, selDocType, selDescriptionText, selRegNumber, selAuthor, selProduct,selIdDep);	
							//if(kolFind!=kolAllInDep) out.println(" / <span style='color:orange;' title='Найдено'>" +kolFind+ "</span>");									 		

							
							
				///////////////////////////////////////////////////////////////////////////
				///мега вывод в Excel;
			    ///////////////////////////////////////////////////////////////////////////
				URL_report = "\"reports/reportMainTable.jsp?" + 
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
				"&selIdDep="+selIdDep+ 
				
				"&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251") +
 				"&START_PAGING="+URLEncoder.encode(START_PAGING, "windows-1251") +
				"&END_PAGING="+URLEncoder.encode(END_PAGING, "windows-1251") +
				"&selByISPFamily="+URLEncoder.encode(selByISPFamily, "windows-1251")+
				"&selStartDate="+URLEncoder.encode(selStartDate, "windows-1251")+
				"&selEndDate="+URLEncoder.encode(selEndDate, "windows-1251")+
				"&selOnControler="+URLEncoder.encode(selOnControler, "windows-1251")+
				"\"";
				%>
		
				<input type="button"
				style="right: 100px; background: url(images/excel_1.png)  no-repeat; width: 70px; height: 50px; padding: 20px; margin: 3px; outline: none; border-width: 0px; color: red; font-weight: bolder;"
				value=" "
				title="Вывести отчет в Excel" onclick='window.location=<% out.print(URL_report); %> ;'/>
								
			</th>

		</tr>  
	</table>

	<table border="0" cellspacing="1" align=center width="1200"
		class="bluedream">
		<tr>
			<td>№ исход :</td>
			<td><input type="text" name="selOutNumber"
				value="<%=selOutNumber%>" onchange="ExecuteFilter()">
			</td>
			<td>Вид документа:</td>
			<td><select name="selDocType" style="width: 150px" onchange="ExecuteFilter()">
				<%
				if(selDocType.equals("Все"))
					out.println("<option selected>Все</option>");
				else
					out.println("<option>Все</option>");
				ProeuserSQL.GetAllDocType("");
				while(ProeuserSQL.oRs.next()){
					if(selDocType.equals(ProeuserSQL.oRs.getString("DOCTYPE")))
						out.println("<option selected>" + ProeuserSQL.oRs.getString("DOCTYPE") + "</option>");
					else
						out.println("<option>" + ProeuserSQL.oRs.getString("DOCTYPE") + "</option>");
				}
				%>
				</select>
			</td>
			<td>Содержащий текст:</td>
			<td><input type="text" name="selDescriptionText"
				style="width: 200px" value="<% out.print(selDescriptionText); %>"
				onchange="ExecuteFilter()">
			</td>
			<td width='100px;'>№ П/П:</td>
			<td><input type="text" name="selIdDep"
				value="<%out.print(selIdDep); %>" onChange=ExecuteFilter()>
			</td>
		</tr>
		<tr>
			<td>№ регистр:</td>
			<td><input type="text" name="selRegNumber"
				value="<% out.print(selRegNumber); %>" onchange="ExecuteFilter();">
			</td>
			<td>Отправитель:</td>
			<td><select name="selAuthor" style="width: 150px"
				onchange="ExecuteFilter()">
				<%
				if(selAuthor.equals("Все"))
					out.println("<option selected>Все</option>");
				else
					out.println("<option>Все</option>");
				ProeuserSQL.GetAllAuthors();
				while(ProeuserSQL.oRs.next()){
				  if(ProeuserSQL.oRs.getString("AUTHOR") != null){
					if(selAuthor.equals(ProeuserSQL.oRs.getString("AUTHOR")))
						out.println("			<option selected>" + ProeuserSQL.oRs.getString("AUTHOR") + "</option>");
					else
						out.println("			<option>" + ProeuserSQL.oRs.getString("AUTHOR") + "</option>");
				  }
				}	
				%>
				</select>
			</td>
			<td>Машина:</td>
			<td><select name="selProduct" style="width: 200px" onchange="ExecuteFilter();">
				<%
				if(selProduct.equals("Все"))
					out.println("<option selected>Все</option>");
				else
					out.println("<option>Все</option>");
				ProeuserSQL.GetAllProduct("");
				while(ProeuserSQL.oRs.next()){
					if(selProduct.equals(ProeuserSQL.oRs.getString("PRODUCT")))
						out.println("<option selected>" + ProeuserSQL.oRs.getString("PRODUCT") + "</option>");
					else
						out.println("<option>" + ProeuserSQL.oRs.getString("PRODUCT") + "</option>");
				}
				%>
				</select>
			</td>
			
			<%  if (!TYPESORTING.equals("i")){

			out.println("	<td width='100px;'>Исполнитель:</td>");				
			out.println("	<td><select name='selByISPFamily' style='width: 150px' onchange='ExecuteFilter()'>");						
					if(selByISPFamily.equals("Все"))
						out.println("<option selected>Все</option>");
					else
						out.println("<option>Все</option>");					
					ProeuserSQL.GetUsersWorkingInDepartment(DEPARTMENT);
					while(ProeuserSQL.oRs.next()){
						if(selByISPFamily.equals(ProeuserSQL.oRs.getString("FULLNAME")))
					   		 out.println("<option selected>" + ProeuserSQL.oRs.getString("FULLNAME") + "</option>");
						else
					         out.println("<option>" + ProeuserSQL.oRs.getString("FULLNAME") + "</option>");						
					}					
			out.println("</select></td>");

			}else{
				out.println("<th colspan='2'></th>");				
			}
		 %>

		</tr>			
		
		
		
		  
		<tr>
		 <th colspan="6">с:
			
				<%=IMG_date %>
				<input name="selStartDate" type="text" class="date"
				onchange="ExecuteFilter();"
				value="<%out.println(selStartDate);%>"
				readonly>
			
			по:
			
				<%=IMG_date %>
				<input name="selEndDate" type="text" class="date"
					   onchange="ExecuteFilter();"
					   value="<%out.println(selEndDate);%>"
					   readonly>
		
			
				<input type="button" onclick="ExecuteFilter();" value="ok">
		</th>
			<th colspan="2" STYLE="background-color: <%=COLOR_onControl%>;"> 			
				<%=IMG_onControl %>
				<input type="checkbox" name="selOnControler"  onclick="ExecuteFilter()" value="<%=selOnControler%>" <%=selOnControler%>>			
				<span style=" margin-bottom: 5px; color: red; padding: 10px;">на контроле</span>
			 
			</th>
		</tr>
	 
	</table>
		
<br>
		
	<table align=center width="1200" border="0">
		<tr>
			<%	
			if(ADMINISTRATOR.equals("true")){
				URL = "ADDItem.jsp?" + 
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
						"&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251") +
						"&START_PAGING="+URLEncoder.encode(START_PAGING, "windows-1251") +
						"&END_PAGING="+URLEncoder.encode(END_PAGING, "windows-1251") +
						"&selByISPFamily="+URLEncoder.encode(selByISPFamily, "windows-1251")+
						"&selStartDate="+URLEncoder.encode(selStartDate, "windows-1251")+
						"&selEndDate="+URLEncoder.encode(selEndDate, "windows-1251")+
						"&selOnControler="+URLEncoder.encode(selOnControler, "windows-1251");
				
				out.println("<a href=\"" + URL + "\"><img src=\"images/Square1.png\" name=\"pict1\" border=0 width=\"178\" height=\"48\" onMouseOver=\"changeImg1('images/Square2')\" onMouseOut=\"changeImg1('images/Square1')\"></a>");
			}
			URL="Report.jsp?SessionUser="+SessionUser+"&FULLNAME="+URLEncoder.encode(FULLNAME, "windows-1251")+
				"&DEPARTMENT="+URLEncoder.encode(DEPARTMENT, "windows-1251");
			out.println("&nbsp&nbsp&nbsp&nbsp<a href="+URL+"><img src=\"images/Report.png\" name=pict2 border=0 width=178 height=48></a>");
			%>
		</tr>
	</table>
	<!-- ОСНОВНАЯ ТАБЛИЦА -->
	<div id="demo_loading_ajax"></div>
	<%
	URL = "MainTable.jsp?" + 
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
			"&selIdDep="+selIdDep+ 
			"&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251") +
			"&START_PAGING="+URLEncoder.encode(START_PAGING, "windows-1251") +
			"&END_PAGING="+URLEncoder.encode(END_PAGING, "windows-1251") +
			"&selByISPFamily="+URLEncoder.encode(selByISPFamily, "windows-1251")+
			"&selStartDate="+URLEncoder.encode(selStartDate, "windows-1251")+
			"&selEndDate="+URLEncoder.encode(selEndDate, "windows-1251")+
			"&selOnControler="+URLEncoder.encode(selOnControler, "windows-1251");
	response.setHeader("Cache-Control", "no-cache");
	%>
	<script type="text/javascript">
		(function($){
						$(window).load(function(){
											var url = "<%out.print(URL);%>";	
											$('#demo_loading_ajax').loading().load(url);
									   }
									  );
					} 
		)(jQuery);
	</script>
	<!-- КОНЕЦ ОСНОВНОЙ ТАБЛИЦЫ -->
	<input  type=hidden name=SessionUser   value="<% out.print(SessionUser); %>"> 
	<input  type=hidden	name=ADMINISTRATOR value="<% out.print(ADMINISTRATOR); %>"> 
	<input  type=hidden name=FULLNAME      value="<% out.print(FULLNAME); %>">
	<input  type=hidden name=DEPARTMENT    value="<% out.print(DEPARTMENT); %>">
	<input  type=hidden name=TYPESORTING   value="<% out.print(TYPESORTING); %>">
	<input  type=hidden	name=START_PAGING  value="<% out.print(START_PAGING); %>">
	<input	type=hidden name=END_PAGING    value="<% out.print(END_PAGING); %>">
</form> 
<%
ProeuserSQL.Disconnect();
%>
<a name="inBottom"></a>
</body>
</html>