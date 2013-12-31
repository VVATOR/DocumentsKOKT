<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="../config.jsp"%>
<!-- файл с глобальными настрайками и библиотеками -->
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>

<html>
<head>
<title><%=PROGRAMM_name%></title>

<meta http-equiv="Content-Type"	content="text/html; charset=windows-1251">
</head>
<body>
	<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Content-disposition",  "attachment; filename=excel.xls" );
//----------------------------------------------------------------------------------------
//																	ОБЪЯВЛЕНИЕ ПЕРЕМЕННЫХ
//----------------------------------------------------------------------------------------
DateFormat dateformat = new SimpleDateFormat("dd.MM.yyyy");		
	//данные о пользователе 
	String TYPESORTING="";           /// тип сортировки (по отделу или пользователю)
	String countItemInpage="500";    /// количество записей в таблице на странице
	String START_PAGING="";
	String END_PAGING="";
	
	String SessionUser = ""; 													//логин пользователя
	String FULLNAME = ""; 														//ФИО
	String DEPARTMENT = ""; 													//Отдел
	String ADMINISTRATOR = "false"; 											//Администратор
	
	
	//переменные фильтра
	String selOutNumber = "";													//№ исход
	String selDocType = "";													    //Вид документа
	String selDescriptionText = "";											    //Содержащий текст
	String selRegNumber = "";													//№ регистр.
	String selAuthor = "";														//Отправитель
	String selProduct = "";													    //Машина
	String selIdDep="";													        //№ П/П
	 String selByISPFamily="";												     //фамилия исполнителя для сортировки
	 String selStartDate="";													 //начальная дата сортировки
	 String selEndDate="";														 //конечная дата сортировки
	 String selOnControler="";                                                   //на контроле для поиска 

	
	//Адрес
	String URL = "";
	String URL_USERS = "";
	String URL_DEPARTMENT = "";
	//количество
	String sUsersCount = "0";													//Количество исполнителей
	String sDepartmentCount = "0";												//Количество отделов (куда передана копия)
	//Для вывода в таблицу
	String ID = "";
	String ID_DEP = "";
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
	String REG_DATE="";
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
	//ПОЛУЧЕНИЕ ПАРАМЕТРОВ ПЕРЕДАННЫХ СТРАНИЦЕ
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
//date2
Date date2 = new Date(); 
String date_2="";
if (request.getParameter("selEndDate") != null) {
selEndDate = new String(request.getParameter("selEndDate").getBytes("ISO-8859-1"));
selEndDate = URLDecoder.decode(selEndDate, "windows-1251");
} else selEndDate = dateformat.format(new Date()).toString(); 
//////////////////////////////////////////////////////////////////////////////////////
	
	//ФИО текущего пользователя
	if(request.getParameter("FULLNAME")!=null){
		FULLNAME = new String(request.getParameter("FULLNAME").getBytes("ISO-8859-1"));
		FULLNAME = URLDecoder.decode(FULLNAME, "windows-1251");
	} else FULLNAME = "";
	//Логин текущего пользователя
	if(request.getParameter("SessionUser")!=null)
		SessionUser = new String(request.getParameter("SessionUser").getBytes("ISO-8859-1"));
	else SessionUser = "";
	//Отдел текущего пользователя
	if(request.getParameter("DEPARTMENT")!=null){
		DEPARTMENT = new String(request.getParameter("DEPARTMENT").getBytes("ISO-8859-1"));
		DEPARTMENT = URLDecoder.decode(DEPARTMENT, "windows-1251");
	} else DEPARTMENT = "";
	//№ исходяыщео
	if(request.getParameter("selOutNumber")!=null){
		selOutNumber = new String(request.getParameter("selOutNumber").getBytes("ISO-8859-1"));
		selOutNumber = URLDecoder.decode(selOutNumber, "windows-1251");
	}							
	//Вид документа
	if(request.getParameter("selDocType")!=null){
		selDocType = new String(request.getParameter("selDocType").getBytes("ISO-8859-1"));
		selDocType = URLDecoder.decode(selDocType, "windows-1251");
		if(selDocType.equals("")) selDocType = "Все";
	}	
	//Содержащий текст
	if(request.getParameter("selDescriptionText")!=null){
		selDescriptionText = new String(request.getParameter("selDescriptionText").getBytes("ISO-8859-1"));
		selDescriptionText = URLDecoder.decode(selDescriptionText, "windows-1251");
	}	
	//№ регистр
	if(request.getParameter("selRegNumber")!=null){
		selRegNumber = new String(request.getParameter("selRegNumber").getBytes("ISO-8859-1"));
		selRegNumber = URLDecoder.decode(selRegNumber, "windows-1251");
	}	
	//Отправитель
	if(request.getParameter("selAuthor")!=null){
		selAuthor = new String(request.getParameter("selAuthor").getBytes("ISO-8859-1"));
		selAuthor = URLDecoder.decode(selAuthor, "windows-1251");
		if(selAuthor.equals("")) selAuthor = "Все";
	}	
	//Машина
	if(request.getParameter("selProduct")!=null){
		selProduct = new String(request.getParameter("selProduct").getBytes("ISO-8859-1"));
		selProduct = URLDecoder.decode(selProduct, "windows-1251");
		if(selProduct.equals("")) selProduct = "Все";
	}	
	//№ П/П
	if(request.getParameter("selIdDep")!=null){
		selIdDep=new String(request.getParameter("selIdDep").getBytes("ISO-8859-1"));
	}
	//для поиска по исполнителю
	if (request.getParameter("selByISPFamily") != null) {
		selByISPFamily = new String(request.getParameter("selByISPFamily").getBytes("ISO-8859-1"));
		selByISPFamily = URLDecoder.decode(selByISPFamily, "windows-1251");
		if(selByISPFamily.equals("")) selByISPFamily = "Все";
	}	 
	//на контроле (галочка)
	if(request.getParameter("selOnControler")!=null){
		selOnControler=new String(request.getParameter("selOnControler").getBytes("ISO-8859-1"));
	}  

	/* //на контроле (галочка)
	 if (request.getParameter("selOnControler") != null){
		selOnControler=new String("checked");
	 } else selIdDep=new String("");*/
%>
	<table border="1" cellspacing="1" align=center width="1200"
		class="bluedream">
		<!--<caption>Регистрацыя входящей корреспонденции КО КТ</caption>-->
		<thead>
			<tr>
				<th scope="col">№ п/п</th>
				<th scope="col">Машина</th>
				<th scope="col">Отправитель</th>
				<th scope="col">№ регистр.</th>
				<th scope="col">№ исход</th>
				<th scope="col">Вид документа</th>
				<th scope="col">Краткое содержание</th>
				<th scope="col">Примечание</th>
				<th scope="col">Список исполнителей</th>
				<th scope="col">Исполнение</th>
				<th scope="col">Дата</th>
			</tr>
		</thead>
		<tbody>

			<%	
	if(!TYPESORTING.equals("i") || (TYPESORTING==null)){	
		ProeuserSQL.GetAllDocs(selOutNumber, selDocType, selDescriptionText, selRegNumber, selAuthor, selProduct,SessionUser, selIdDep, countItemInpage, START_PAGING, END_PAGING, selStartDate, selEndDate, selByISPFamily, selOnControler);
		/*ProeuserSQL.GetAllDocsForPaging(selOutNumber, selDocType, selDescriptionText, selRegNumber, selAuthor, selProduct,SessionUser,selIdDep, countItemInpage, START_PAGING, END_PAGING);*/
	}else{
		ProeuserSQL.docOnlyI(selOutNumber, selDocType, selDescriptionText, selRegNumber, selAuthor, selProduct,SessionUser,selIdDep, countItemInpage, START_PAGING, END_PAGING, selStartDate, selEndDate, selByISPFamily, selOnControler);
	}
	 
	i=0;
	while(ProeuserSQL.oRs.next()){		
		//------------------------------------------------------------------------
		//                      ФОРМИРУЕМ СТРОКИ ДЛЯ КОЛОНОК:
		//                          -- список исполнителей
		//                          -- исполнение
		//------------------------------------------------------------------------
		if(STATUS.equals("ожидает")) Color = "708090";
		if(STATUS.equals("ознакамливается")) Color = "ff6c36";
		if(STATUS.equals("ознакомлен")) Color = "4169E1";
		if(STATUS.equals("хранение")) Color = "339933";
		//создаем текстовку
		if((!sTextOfDepartments.contains(sqlDEPARTMENT)) && (!sqlDEPARTMENT.equals(""))){
			URL_DEPARTMENT += "&Department" + sDepartmentCount + "=" + URLEncoder.encode(sqlDEPARTMENT, "windows-1251");
			sDepartmentCount = Integer.valueOf(Integer.parseInt(sDepartmentCount) + 1).toString();
			sTextOfDepartments += sqlDEPARTMENT + "<BR>";
		}
		if((!sTextOfExecutersStatus.contains(sqlFULLNAME + "<font color=#" + Color + "> - " + STATUS + " (" + DATE_OF_READ + ")</font>")) && (!sqlFULLNAME.equals(""))){
			URL_USERS += "&User" + sUsersCount + "=" + URLEncoder.encode(sqlFULLNAME, "windows-1251");
			URL_USERS += "&Status" + sUsersCount + "=" + URLEncoder.encode(STATUS, "windows-1251");
			if(!sTextOfExecutersExecute.contains(sqlFULLNAME + " - <font color=#4169E1>" + EXECUTE + "</font>")){
				sTextOfExecutersExecute += sqlFULLNAME + " - <font color=#4169E1>" + EXECUTE + "</font>" + "<BR>";
				URL_USERS += "&Execute" + sUsersCount + "=" + URLEncoder.encode(EXECUTE, "windows-1251");
			}
			URL_USERS += "&DateOfRead" + sUsersCount + "=" + URLEncoder.encode(DATE_OF_READ, "windows-1251");
			sUsersCount = Integer.valueOf(Integer.parseInt(sUsersCount) + 1).toString();
			sTextOfExecutersStatus += sqlFULLNAME + "<font color=#" + Color + "> - " + STATUS + " (" + DATE_OF_READ + ")</font>" + "<BR>";
		}
		URL = "EDITItem.jsp?" +
				  "SessionUser="+SessionUser+
				  "&ADMINISTRATOR="+URLEncoder.encode(ADMINISTRATOR, "windows-1251")+
				  "&FULLNAME="+URLEncoder.encode(FULLNAME, "windows-1251")+
				  "&DEPARTMENT="+URLEncoder.encode(DEPARTMENT, "windows-1251") +
				  
				  "&editNumber=" + URLEncoder.encode(ID, "windows-1251") +
				  "&editNumberDep=" + URLEncoder.encode(ID_DEP, "windows-1251") +
				  "&editProduct=" + URLEncoder.encode(PRODUCT, "windows-1251") +
				  "&editOwner=" +URLEncoder.encode(AUTHOR, "windows-1251") +   /// валило бд
				  "&editRegNumber=" + URLEncoder.encode(REG_NUMBER, "windows-1251") +
				  "&editOutNumber=" + URLEncoder.encode(OUT_NUMBER, "windows-1251") +
				  "&editDocType=" + URLEncoder.encode(DOCTYPE, "windows-1251") +
				  "&editDescription=" + URLEncoder.encode(DESCRIPTION, "windows-1251") +
				  "&editNote=" + URLEncoder.encode(NOTE, "windows-1251") +
				  "&editControlStatus=" + URLEncoder.encode(CONTROL_STATUS, "windows-1251") +
				  URL_USERS + URL_DEPARTMENT +
				  "&sUsersCount=" + URLEncoder.encode(sUsersCount, "windows-1251") +
				  "&sDepartmentCount=" + URLEncoder.encode(sDepartmentCount, "windows-1251") +
			  	  "&sCurrentUsersCount=" + URLEncoder.encode(sUsersCount, "windows-1251") +
			  	  "&sCurrentDepartmentCount=" + URLEncoder.encode(sDepartmentCount, "windows-1251")+
				  "&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251") +
				  "&START_PAGING="+URLEncoder.encode(START_PAGING, "windows-1251") +
				  "&END_PAGING="+URLEncoder.encode(END_PAGING, "windows-1251") +
				  "&selByISPFamily="+URLEncoder.encode(selByISPFamily, "windows-1251")+
				  "&selStartDate="+URLEncoder.encode(selStartDate, "windows-1251")+
				  "&selEndDate="+URLEncoder.encode(selEndDate, "windows-1251")+
				  "&selOnControler="+URLEncoder.encode(selOnControler, "windows-1251");
		//------------------------------------------------------------------------
		//                   ЗАПИСЬ ПОМЕНЯЛАСЬ. ВЫВОДИМ ЕЕ В ТАБЛИЦУ
		//------------------------------------------------------------------------
		if((!sPreviousID.equals(ProeuserSQL.oRs.getString("ID"))) && (!sPreviousID.equals(""))){
			if(CONTROL_STATUS.equals("Да")){
				out.println("<tr STYLE='background-color:"+COLOR_onControl+"'>");  //
				out.println("	<th>"); 
				out.println("   " + ID_DEP + "</font></th>");
				out.println("	<th scope=\"row\"><font color=\"#FF0000\">" + PRODUCT + "</font></th>");
				out.println("	<th scope=\"row\"><font color=\"#FF0000\">" + AUTHOR + "</font></th>");
				out.println("	<th scope=\"row\"><font color=\"#FF0000\">" + REG_NUMBER + "</font></th>");
				out.println("	<th scope=\"row\"><font color=\"#FF0000\">" + OUT_NUMBER + "</font></th>");
			}
			else{
				//выводим запись в таблицу
				if(ClassAdd)
				out.println("<tr class=\"odd\">");
				else
				out.println("<tr>");				
				out.println("	<th>" + ID_DEP + "</th>");
				out.println("	<th scope=\"row\">" + PRODUCT + "</th>");
				out.println("	<th scope=\"row\">" + AUTHOR + "</th>");
				out.println("	<th scope=\"row\">" + REG_NUMBER + "</th>");
				out.println("	<th scope=\"row\">" + OUT_NUMBER + "</th>");				
			}
			if(FILE_ID != null)
				out.println("	<th scope=\"row\"><a href=\"FilePreview.jsp?DOC_ID=" + ID + "\"><img src=\"images/File.png\" width=\"24\" height=\"24\" border=\"0\"/></a>" + DOCTYPE + "</th>");
			else
				out.println("	<th scope=\"row\">" + DOCTYPE + "</th>");
			out.println("		<th scope=\"row\">" + DESCRIPTION + "</th>");
			out.println("		<th scope=\"row\">" + NOTE + "</th>");
			out.println("		<th scope=\"row\">" + sTextOfExecutersStatus + "</th>");
			out.println("		<th scope=\"row\">" + sTextOfExecutersExecute + "</th>");
			out.println("		<th scope=\"row\">" + REG_DATE + "</th>");
			out.println(	"</tr>");
			
			i++;
			if(ClassAdd == true) ClassAdd= false;
			else ClassAdd = true;
			sUsersCount = "0";
			sDepartmentCount = "0";
			URL_DEPARTMENT = "";
			URL_USERS = "";
			sTextOfDepartments = "";
			sTextOfExecutersStatus = "";
			sTextOfExecutersExecute = "";
		}		
			
		//------------------------------------------------------------------------
		//             ЗАПОМИНАЕМ ПАРАМЕТРЫ ДЛЯ СЛЕДУЮЩЕЙ ИТЕРАЦИИ
		//------------------------------------------------------------------------
		ID = ProeuserSQL.oRs.getString("ID");
		ID_DEP = ProeuserSQL.oRs.getString("ID_DEP");
		PRODUCT = ProeuserSQL.oRs.getString("PRODUCT");
		AUTHOR = ProeuserSQL.oRs.getString("AUTHOR");
		REG_NUMBER = ProeuserSQL.oRs.getString("REG_NUMBER");
		OUT_NUMBER = ProeuserSQL.oRs.getString("OUT_NUMBER");
		DOCTYPE= ProeuserSQL.oRs.getString("DOCTYPE");
		DESCRIPTION = ProeuserSQL.oRs.getString("DESCRIPTION");
		STATUS = ProeuserSQL.oRs.getString("STATUS");
		EXECUTE = ProeuserSQL.oRs.getString("EXECUTE");
		NOTE = ProeuserSQL.oRs.getString("NOTE");
		CONTROL_STATUS = ProeuserSQL.oRs.getString("CONTROL_STATUS");
		FILE_ID = ProeuserSQL.oRs.getString("FILE_ID");
		sqlDEPARTMENT = ProeuserSQL.oRs.getString("DEPARTMENT");
		sqlFULLNAME = ProeuserSQL.oRs.getString("FULLNAME");
		DATE_OF_READ = ProeuserSQL.oRs.getString("DATE_OF_READ");
		
		Date dateall=new Date();
		dateall = ProeuserSQL.oRs.getDate("REG_DATE");
		REG_DATE=(dateformat.format(dateall));///
		
		//try{
		sPreviousID = ProeuserSQL.oRs.getString("ID");
		if(ID == null) ID = "";
		if(ID_DEP == null) ID_DEP = "";
		if(PRODUCT == null) EXECUTE = "";
		if(AUTHOR == null) AUTHOR = "";
		if(REG_NUMBER == null) REG_NUMBER = "";
		if(OUT_NUMBER == null) OUT_NUMBER = "";
		if(DOCTYPE == null) DOCTYPE = "";
		if(DESCRIPTION == null) DESCRIPTION = "";
		if(STATUS == null) STATUS = "";
		if(EXECUTE == null) EXECUTE = "";
		if(NOTE == null) NOTE = "";
		if(CONTROL_STATUS == null) CONTROL_STATUS = "";
		if(sqlDEPARTMENT == null) sqlDEPARTMENT = "";
		if(sqlFULLNAME == null) sqlFULLNAME = "";
		if(DATE_OF_READ == null) DATE_OF_READ = "";
		if(sPreviousID == null) sPreviousID = "";
		if(REG_DATE == null) REG_DATE = "";
		if(TYPESORTING == null) TYPESORTING = "";
	//	}
	//	catch
	//	(Exception e){System.out.print("ERROR");}
		URL = "EDITItem.jsp?" +
				  "SessionUser="+SessionUser+
				  "&ADMINISTRATOR="+URLEncoder.encode(ADMINISTRATOR, "windows-1251")+
				  "&FULLNAME="+URLEncoder.encode(FULLNAME, "windows-1251")+
				  "&DEPARTMENT="+URLEncoder.encode(DEPARTMENT, "windows-1251") +
				  "&editNumber=" + URLEncoder.encode(ID, "windows-1251") +
				  "&editNumberDep=" + URLEncoder.encode(ID_DEP, "windows-1251") +
				  "&editProduct=" + URLEncoder.encode(PRODUCT, "windows-1251") +
				  "&editOwner=" + URLEncoder.encode(AUTHOR, "windows-1251") +     /// валило бд
				  "&editRegNumber=" + URLEncoder.encode(REG_NUMBER, "windows-1251") +
				  "&editOutNumber=" + URLEncoder.encode(OUT_NUMBER, "windows-1251") +
				  "&editDocType=" + URLEncoder.encode(DOCTYPE, "windows-1251") +
				  "&editDescription=" + URLEncoder.encode(DESCRIPTION, "windows-1251") +
				  "&editNote=" + URLEncoder.encode(NOTE, "windows-1251") +
				  "&editControlStatus=" + URLEncoder.encode(CONTROL_STATUS, "windows-1251") +
				  URL_USERS + URL_DEPARTMENT +
				  "&sUsersCount=" + URLEncoder.encode(sUsersCount, "windows-1251") +
				  "&sDepartmentCount=" + URLEncoder.encode(sDepartmentCount, "windows-1251") +
			  	  "&sCurrentUsersCount=" + URLEncoder.encode(sUsersCount, "windows-1251") +
			  	  "&sCurrentDepartmentCount=" + URLEncoder.encode(sDepartmentCount, "windows-1251")+
				  "&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251") +
				  "&START_PAGING="+URLEncoder.encode(START_PAGING, "windows-1251") +
				  "&END_PAGING="+URLEncoder.encode(END_PAGING, "windows-1251") +
				  "&selByISPFamily="+URLEncoder.encode(selByISPFamily, "windows-1251")+
				  "&selStartDate="+URLEncoder.encode(selStartDate, "windows-1251")+
				  "&selEndDate="+URLEncoder.encode(selEndDate, "windows-1251")+
				  "&selOnControler="+URLEncoder.encode(selOnControler, "windows-1251");
	}

//System.out.print("OK");
	
	//------------------------------------------------------------------------
	//                      ВЫВОДИМ ПОСЛЕДНЮЮ ЗАПИСЬ
	//------------------------------------------------------------------------
	if(STATUS.equals("ожидает")) Color = "708090";
	if(STATUS.equals("ознакамливается")) Color = "ff6c36";
	if(STATUS.equals("ознакомлен")) Color = "4169E1";
	if(STATUS.equals("хранение")) Color = "339933";
	if((!sTextOfDepartments.contains(sqlDEPARTMENT)) && (!sqlDEPARTMENT.equals(""))){
		URL_DEPARTMENT += "&Department" + sDepartmentCount + "=" + URLEncoder.encode(sqlDEPARTMENT, "windows-1251");
		sDepartmentCount = Integer.valueOf(Integer.parseInt(sDepartmentCount) + 1).toString();
		sTextOfDepartments += sqlDEPARTMENT + "<BR>";
	}
	if((!sTextOfExecutersStatus.contains(sqlFULLNAME + "<font color=#" + Color + "> - " + STATUS + " (" + DATE_OF_READ + ")</font>")) && (!sqlFULLNAME.equals(""))){
		URL_USERS += "&User" + sUsersCount + "=" + URLEncoder.encode(sqlFULLNAME, "windows-1251");
		URL_USERS += "&Status" + sUsersCount + "=" + URLEncoder.encode(STATUS, "windows-1251");
		if(!sTextOfExecutersExecute.contains(sqlFULLNAME + " - <font color=#4169E1>" + EXECUTE + "</font>")){
			sTextOfExecutersExecute += sqlFULLNAME + " - <font color=#4169E1>" + EXECUTE + "</font>" + "<BR>";
			URL_USERS += "&Execute" + sUsersCount + "=" + URLEncoder.encode(EXECUTE, "windows-1251");
		}
		URL_USERS += "&DateOfRead" + sUsersCount + "=" + URLEncoder.encode(DATE_OF_READ, "windows-1251");
		sUsersCount = Integer.valueOf(Integer.parseInt(sUsersCount) + 1).toString();
		sTextOfExecutersStatus += sqlFULLNAME + "<font color=#" + Color + "> - " + STATUS + " (" + DATE_OF_READ + ")</font>" + "<BR>";
	}
		URL = "EDITItem.jsp?" +
		  "SessionUser="+SessionUser+
		  "&ADMINISTRATOR="+URLEncoder.encode(ADMINISTRATOR, "windows-1251")+
		  "&FULLNAME="+URLEncoder.encode(FULLNAME, "windows-1251")+
		  "&DEPARTMENT="+URLEncoder.encode(DEPARTMENT, "windows-1251") +
		  "&editNumber=" + URLEncoder.encode(ID, "windows-1251") +
		  "&editNumberDep=" + URLEncoder.encode(ID_DEP, "windows-1251") +
		  "&editProduct=" + URLEncoder.encode(PRODUCT, "windows-1251") +
		  "&editOwner=" + URLEncoder.encode(AUTHOR, "windows-1251") +    /// валило бд
		  "&editRegNumber=" + URLEncoder.encode(REG_NUMBER, "windows-1251") +
		  "&editOutNumber=" + URLEncoder.encode(OUT_NUMBER, "windows-1251") +
		  "&editDocType=" + URLEncoder.encode(DOCTYPE, "windows-1251") +
		  "&editDescription=" + URLEncoder.encode(DESCRIPTION, "windows-1251") +
		  "&editNote=" + URLEncoder.encode(NOTE, "windows-1251") +
		  "&editControlStatus=" + URLEncoder.encode(CONTROL_STATUS, "windows-1251") +
		  URL_USERS + URL_DEPARTMENT +
		  "&sUsersCount=" + URLEncoder.encode(sUsersCount, "windows-1251") +
		  "&sDepartmentCount=" + URLEncoder.encode(sDepartmentCount, "windows-1251") +
		  "&sCurrentUsersCount=" + URLEncoder.encode(sUsersCount, "windows-1251") +
		  "&sCurrentDepartmentCount=" + URLEncoder.encode(sDepartmentCount, "windows-1251")+
		  "&TYPESORTING="+URLEncoder.encode(TYPESORTING, "windows-1251") +
		  "&START_PAGING="+URLEncoder.encode(START_PAGING, "windows-1251") +
		  "&END_PAGING="+URLEncoder.encode(END_PAGING, "windows-1251") +
		  "&selByISPFamily="+URLEncoder.encode(selByISPFamily, "windows-1251")+
		  "&selStartDate="+URLEncoder.encode(selStartDate, "windows-1251")+
		  "&selEndDate="+URLEncoder.encode(selEndDate, "windows-1251")+
		  "&selOnControler="+URLEncoder.encode(selOnControler, "windows-1251");
		
		
		
		
if(!ID.equals("")){	
	if(CONTROL_STATUS.equals("Да")){
		out.println("<tr STYLE='background-color:"+COLOR_onControl+"'>");  
		out.println("<th><font color=\"#FF0000\">" + ID_DEP + "</font></th>");
		out.println("	<th scope=\"row\"><font color=\"#FF0000\">" + PRODUCT + "</font></th>");
		out.println("	<th scope=\"row\"><font color=\"#FF0000\">" + AUTHOR + "</font></th>");
		out.println("	<th scope=\"row\"><font color=\"#FF0000\">" + REG_NUMBER + "</font></th>");
		out.println("	<th scope=\"row\"><font color=\"#FF0000\">" + OUT_NUMBER + "</font></th>");
	}
	else{
		//выводим запись в таблицу
		if(ClassAdd)
		out.println("<tr class=\"odd\">");
		else
		out.println("<tr>");		
		out.println("	<th scope=\"row\">" + ID_DEP + "</th>");
		out.println("	<th scope=\"row\">" + PRODUCT + "</th>");
		out.println("	<th scope=\"row\">" + AUTHOR + "</th>");
		out.println("	<th scope=\"row\">" + REG_NUMBER + "</th>");
		out.println("	<th scope=\"row\">" + OUT_NUMBER + "</th>");				
	}
	if(FILE_ID != null)
		out.println("	<th scope=\"row\"><a href=\"FilePreview.jsp?DOC_ID=" + ID + "\"><img src=\"images/File.png\" width=\"24\" height=\"24\" border=\"0\"/></a>" + DOCTYPE + "</th>");
	else
		out.println("	<th scope=\"row\">" + DOCTYPE + "</th>");
	
	out.println("	<th scope=\"row\">" + DESCRIPTION + "</th>");
	out.println("	<th scope=\"row\">" + NOTE + "</th>");
	out.println("	<th scope=\"row\">" + sTextOfExecutersStatus + "</th>");
	out.println("	<th scope=\"row\">" + sTextOfExecutersExecute + "</th>");
	out.println("	<th scope=\"row\">" + REG_DATE + "</th>");
	out.println("</tr>");
	i++;
} else i=0;
	%>
		</tbody>
		<%
	out.println("		<tfoot>");
	out.println("			<tr>");
	out.println("				<th scope=\"row\">Всего " + i + "");
								switch (i%10){
								case 1:	out.println("запись"); break;
								case 2:	
								case 3:
								case 4:	out.println("записи"); break;
								default :	out.println("записей");		
								}	
	out.println("			   </th>");
//	out.println("					<td colspan=\"9\">запись(ей)");
	

							
out.println("    <td colspan=\"9\">");
		
		
//PAGING
int kol=0;
  if(TYPESORTING.equals("i"))
   	kol=ProeuserSQL.countOnlyI(SessionUser);
  else
 	kol=ProeuserSQL.countAllForDepartment(SessionUser,selOutNumber, selDocType, selDescriptionText, selRegNumber, selAuthor, selProduct,selIdDep);
	//kol = ProeuserSQL.maxNomDocInDep(SessionUser);
int j=0;
int n=1;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Paging А-Z    (кнопки со страницами )  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
/*
								
								if (kol>500){
									while(j<kol ){											
										j+=500;
										//if (j>kol){	out.print("<input type='button' class='paging' onclick='START_PAGING.value=\""+((j+1)-500)+"\";  END_PAGING.value=\"" + kol + "\"'  value='"+ ((j+1)-500) +".." + kol + "'>");}
										//else      {	out.print("<input type='button' class='paging' onclick='START_PAGING.value=\""+((j+1)-500)+"\";  END_PAGING.value=\"" + j   + "\"'  value='"+ ((j+1)-500)+ ".." + j   + "'>");}
										
										if (j>kol){	out.print("<button class='paging' onclick='START_PAGING.value=\""+((j+1)-500)+"\";  END_PAGING.value=\"" + kol + "\"'>"+((j+1)-500) + ".." + kol + "</button>");}
										else      {	out.print("<button class='paging' onclick='START_PAGING.value=\""+((j+1)-500)+"\";  END_PAGING.value=\"" + j   + "\"'>"+((j+1)-500) + ".." + j   + "</button>");}
										
										//out.print("<button>"+j+"</button>");
										n++;
									}
								}else{out.print("<button class='paging' onclick='START_PAGING.value=\"1\";  END_PAGING.value=\""+kol+"\"'>1.."+kol+"</button>");}		
		out.println("				</td>");
*/  	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Paging Z-A     (кнопки со страницами )  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*    j=kol;
	n=1;
	while(j>0 ){             											
		
		j-=500;
		if (j==kol){out.print(  "<button class='paging' onclick='END_PAGING.value=\""+(j+500)+"\";  START_PAGING.value=\"" + j + "\"'>"+(j+500) + ".." + j + "</button>");}
		else    
			if (j>0) {out.print("<button class='paging' title='Диапазон записей' onclick='END_PAGING.value=\""+(j+500)+"\";  START_PAGING.value=\"" + j + "\"'>"+(j+500) + ".." + j + "</button>");}
			else     {out.print("<button class='paging' title='Диапазон записей' onclick='END_PAGING.value=\""+(j+500)+"\";  START_PAGING.value=\"0\"'>"+(j+500) + "..0</button>");}
	
		n++;
	}*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
out.println("	</td>");		
	out.println("<td></td>");
	out.println("			</tr>");
	out.println("		</tfoot>");

ProeuserSQL.Disconnect();
	%>
	</table>
</body>
</html>