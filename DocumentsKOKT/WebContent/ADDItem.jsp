<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="config.jsp"%>
<!-- файл с глобальными настрайками и библиотеками -->
<%@page import="java.util.ArrayList"%>

<html>
<script type="text/javascript" language="JavaScript">

    <%@ include file="../../JSCode/Code_ControlDataEnter.js" %>   // подключение и форматирование вводимых данных
	function AddExecute(){	
	  error_message = "";
	  var t= AllTrim(); // Подготовка строк к сохранению 
	  //№ п/п
	  if(document.Add.addNumber.value == ""){
		  if(error_message == "") error_message += "Вы забыли ввести: ";
		  error_message += " № п/п";
	  }
	  //Машина
	  if(document.Add.addProduct.value == ""){
		  if(error_message == "") error_message += "Вы забыли ввести: ";
		  error_message += " Машину";
	  }
	  //Отправитель
	  if(document.Add.addOwner.value == ""){
		  if(error_message == "") error_message += "Вы забыли ввести: ";
		  error_message += " Отправителя";
	  }
	  //№ регистр.
	  if(document.Add.addRegNumber.value == ""){
		  if(error_message == "") error_message += "Вы забыли ввести: ";
		  error_message += " № регистр.";
	  }
	  //№ исход.
	  if(document.Add.addOutNumber.value == ""){
		  if(error_message == "") error_message += "Вы забыли ввести: ";
		  error_message += " № исход.";
	  }
	  //Вид документа
	  if(document.Add.addDocType.value == ""){
		  if(error_message == "") error_message += "Вы забыли ввести: ";
		  error_message += " Вид документа";
	  }
	  if(error_message == ""){
	  	document.Add.action.value="1";
	 	Add.submit();
	  }
	  else alert(error_message);
	}
	function CancelExecute(){
	  	document.Add.action.value="4";
	 	Add.submit();
	}
	function AddUserToTable(){
	  document.Add.action.value="2";
	  Add.submit();  
	}
	function AddDepartment(){
	  document.Add.action.value="3";
	  Add.submit();
	}
	function DeleteExecuter(element){
	  document.Add.DeleteExecuterIndex.value=element;
	  document.Add.action.value="5";
	  Add.submit();
	}
</script>
<script type="text/javascript" src="js/jquery-1.4.2.js"></script>
<script type="text/javascript" src="js/jquery.autocomplete.js"></script>
<link rel="stylesheet" href="css/AutocompleteStyle.css">
<link rel="stylesheet" href="css/bluedream.css">
<head>
<title><%=PROGRAMM_name%></title>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1251">
</head>
<body>

<div style="width: 100%; margin: 0 auto;">
<form name=Add>
		<!-- <input type="button" class="cl1" value=" Форматирование текста "onclick="AllTrim();"/>   -->
		<!-- <input type="button" class="cl1" value=" Форматирование текста "onclick="AllTrim();"/>   -->
		<%
//----------------------------------------------------------------------------------------
//                               ОБЪЯВЛЕНИЕ ПЕРЕМЕННЫХ
//----------------------------------------------------------------------------------------
 //данные о пользователе 
 String TYPESORTING="";           /// тип сортировки (по отделу или пользователю)
 
 String ADMINISTRATOR = "false"; 											//Администратор
 String SessionUser = ""; 													//логин пользователя
 String FULLNAME = ""; 														//ФИО
 String DEPARTMENT = ""; 													//Отдел
 //переменные фильтра
 String selOutNumber = "";													//№ исход
 String selDocType = "";													//Вид документа
 String selDescriptionText = "";											//Содержащий текст
 String selRegNumber = "";													//№ регистр.
 String selAuthor = "";														//Отправитель
 String selProduct = "";													//Машина

   String selIdDep="";													       //№ П/П
   String selByISPFamily="";												   //фамилия исполнителя для сортировки
   String selStartDate="";													   //начальная дата сортировки
   String selEndDate="";													   //конечная дата сортировки
   String selOnControler="";                                                   //на контроле для поиска 
 
 
 
 
 //переменные формы добавления
 String addNumber = "";														//№ п/п
 String addProduct = "";													//Машина
 String addOwner = "";														//Отправитель
 String addRegNumber = "";													//№ регистр.
 String addOutNumber = "";													//№ исход.
 String addDocType = "";													//Вид документа
 String addDescription = "";												//Краткое содержание
 String addNote = "";														//Примечание
 String addControlStatus = "";												//На контроле
 String addDatafile = "";													//Файл
 String addUser = "";														//Для добавления пользователя в таблицу
 String addCopyToDepartment = "";											//Для добавления отдела в таблицу

 //Адрес
 String URL = "";
 //массивы
 ArrayList<String> lUsers;													//Список пользователей
 ArrayList<String> lUsersStatus;											//Статус пользователя
 ArrayList<String> lUsersExecute;											//Исполнение пользователя
 ArrayList<String> lDepartment;												//Список отделов (куда передана копия)
 ArrayList<String> lDateOfRead;												//дата ознакомления
 //прочие переменные
 String sUsersCount = "0";													//Количество исполнителей
 String sDepartmentCount = "0";												//Количество отделов (куда передана копия)
 String action = ""; 														//Действие
 String DeleteExecuterIndex = "";											//индекс удаляемого элемента
 int i;																		//счетчик
 String DEFAULT_ELEMENT_WIDTH = "500";										//ширина по умолчанию
 String DEFAULT_SELECT_ELEMENT_WIDTH = "505";								//ширина списков по умолчанию
 //объявляем переменные и создаем объекты для работы с базой данных
 ProeuserSQLRequest ProeuserSQL = new ProeuserSQLRequest();
 //инициализация массивов
 lUsers = new ArrayList<String>(); 
 lUsersStatus = new ArrayList<String>(); 
 lUsersExecute = new ArrayList<String>(); 
 lDepartment = new ArrayList<String>(); 
 lDateOfRead = new ArrayList<String>(); 
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
 //№ исход]
 if (request.getParameter("selOutNumber") != null) {
	selOutNumber = new String(request.getParameter("selOutNumber").getBytes("ISO-8859-1"));
	selOutNumber = URLDecoder.decode(selOutNumber, "windows-1251");
 }									
 //Вид документа
 if (request.getParameter("selDocType") != null) {
	 selDocType = new String(request.getParameter("selDocType").getBytes("ISO-8859-1"));
	 selDocType = URLDecoder.decode(selDocType, "windows-1251");
 }	
 //Содержащий текст
 if (request.getParameter("selDescriptionText") != null) {
	 selDescriptionText = new String(request.getParameter("selDescriptionText").getBytes("ISO-8859-1"));
	 selDescriptionText = URLDecoder.decode(selDescriptionText, "windows-1251");
 }	
 //№ регистр.
 if (request.getParameter("selRegNumber") != null) {
	 selRegNumber = new String(request.getParameter("selRegNumber").getBytes("ISO-8859-1"));
	 selRegNumber = URLDecoder.decode(selRegNumber, "windows-1251");
 }	
 //Отправитель
 if (request.getParameter("selAuthor") != null) {
	 selAuthor = new String(request.getParameter("selAuthor").getBytes("ISO-8859-1"));
	 selAuthor = URLDecoder.decode(selAuthor, "windows-1251");
 }	
 //Машина
 if (request.getParameter("selProduct") != null) {
	 selProduct = new String(request.getParameter("selProduct").getBytes("ISO-8859-1"));
	 //selProduct = URLDecoder.decode(selProduct, "windows-1251");
 }	
 //№ п/п
 if (request.getParameter("addNumber") != null) {
	 addNumber = new String(request.getParameter("addNumber").getBytes("ISO-8859-1"));
	 addNumber = URLDecoder.decode(addNumber, "windows-1251");
 }	
 else{
	 ProeuserSQL.GetFreeIDForDocument(SessionUser);
	 while(ProeuserSQL.oRs.next()){
	 	addNumber = ProeuserSQL.oRs.getString("FREE_ID");
	 	if(addNumber == null) addNumber = "1";
	 }
 }
 //Машина
 if (request.getParameter("addProduct") != null) {
	 addProduct = new String(request.getParameter("addProduct").getBytes("ISO-8859-1"));
	 addProduct = URLDecoder.decode(addProduct, "windows-1251");
 }	
 //Отправитель
 if (request.getParameter("addOwner") != null) {
	 addOwner = new String(request.getParameter("addOwner").getBytes("ISO-8859-1"));
	 addOwner = URLDecoder.decode(addOwner, "windows-1251");
 }	
 //№ регистр.
 if (request.getParameter("addRegNumber") != null) {
	 addRegNumber = new String(request.getParameter("addRegNumber").getBytes("ISO-8859-1"));
	 addRegNumber = URLDecoder.decode(addRegNumber, "windows-1251");
 }	
 //№ исход.
 if (request.getParameter("addOutNumber") != null) {
	 addOutNumber = new String(request.getParameter("addOutNumber").getBytes("ISO-8859-1"));
	 addOutNumber = URLDecoder.decode(addOutNumber, "windows-1251");
 }	
 //Вид документа
 if (request.getParameter("addDocType") != null) {
	 addDocType = new String(request.getParameter("addDocType").getBytes("ISO-8859-1"));
	 addDocType = URLDecoder.decode(addDocType, "windows-1251");
 }
 //Краткое содержание
 if (request.getParameter("addDescription") != null) {
	 addDescription = new String(request.getParameter("addDescription").getBytes("ISO-8859-1"));
	 addDescription = URLDecoder.decode(addDescription, "windows-1251");
 }
 //Примечание
 if (request.getParameter("addNote") != null) {
	 addNote = new String(request.getParameter("addNote").getBytes("ISO-8859-1"));
	 addNote = URLDecoder.decode(addNote, "windows-1251");
 }
 //На контроле
 if (request.getParameter("addControlStatus") != null) {
	 addControlStatus = new String(request.getParameter("addControlStatus").getBytes("ISO-8859-1"));
	 addControlStatus = URLDecoder.decode(addControlStatus, "windows-1251");
 }
 //Файл
 if (request.getParameter("addDatafile") != null) {
	 addDatafile = new String(request.getParameter("addDatafile").getBytes("ISO-8859-1"));
	 addDatafile = URLDecoder.decode(addDatafile, "windows-1251");
 }
 //Количество пользователей
 if (request.getParameter("sUsersCount") != null) {
	 sUsersCount = new String(request.getParameter("sUsersCount").getBytes("ISO-8859-1"));
	 sUsersCount = URLDecoder.decode(sUsersCount, "windows-1251");
 }		
 //Количество отделов
 if (request.getParameter("sDepartmentCount") != null) {
	 sDepartmentCount = new String(request.getParameter("sDepartmentCount").getBytes("ISO-8859-1"));
	 sDepartmentCount = URLDecoder.decode(sDepartmentCount, "windows-1251");
 }		
 //Для добавления пользователя в таблицу
 if (request.getParameter("addUser") != null) {
	 addUser = new String(request.getParameter("addUser").getBytes("ISO-8859-1"));
	 addUser = URLDecoder.decode(addUser, "windows-1251");
 }		
 //Для добавления отдела в таблицу
 if (request.getParameter("addCopyToDepartment") != null) {
	 addCopyToDepartment = new String(request.getParameter("addCopyToDepartment").getBytes("ISO-8859-1"));
	 addCopyToDepartment = URLDecoder.decode(addCopyToDepartment, "windows-1251");
 }		
 //Действие
 if (request.getParameter("action") != null) {
	 action = new String(request.getParameter("action").getBytes("ISO-8859-1"));
 }
 //Индекс удаляемого исполнителя
 if (request.getParameter("DeleteExecuterIndex") != null) {
	 DeleteExecuterIndex = new String(request.getParameter("DeleteExecuterIndex").getBytes("ISO-8859-1"));
 }
//----------------------------------------------------------------------------------------
//                         ПОЛУЧАЕМ ПЕРЕДАННЫЕ СТРАНИЦЕ МАССИВЫ
//----------------------------------------------------------------------------------------
 //получаем переданные массивы
 for(i=0;i<Integer.parseInt(sUsersCount);i++){
	lUsers.add(URLDecoder.decode(new String(request.getParameter("User" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1"), "windows-1251")));													
	lUsersStatus.add(URLDecoder.decode(new String(request.getParameter("Status" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1"), "windows-1251")));
	lUsersExecute.add(URLDecoder.decode(new String(request.getParameter("Execute" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1"), "windows-1251")));
	lDateOfRead.add(URLDecoder.decode(new String(request.getParameter("DateOfRead" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1"), "windows-1251")));
 }
 for(i=0;i<Integer.parseInt(sDepartmentCount);i++){
	lDepartment.add(URLDecoder.decode(new String(request.getParameter("Department" + Integer.valueOf(i).toString()).getBytes("ISO-8859-1"), "windows-1251")));													
 }
//----------------------------------------------------------------------------------------
//        ВЫПОЛНЕНИЯ ДЕЙСТВИЯ В ЗАВИСИМОСТИ ОТ ЗНАЧЕНИЯ ПАРАМЕТРА ACTION
//                   АCTION=1 - ДОБАВЛЕНИЕ ДОКУМЕНТА
//                   АCTION=2 - ДОБАВЛЕНИЕ ПОЛЬЗОВАТЕЛЯ
//                   АCTION=3 - ДОБАВЛЕНИЕ ОТДЕЛА
//
//----------------------------------------------------------------------------------------
 if(action.equals("1")){ //добавить документ
	//Выполняем добавление
	
	
	if(addProduct == null) addProduct = "Общее"; //заплатка, если забыли ввести продукт
	if(ProeuserSQL.AddDocument(addNumber,addProduct,addOwner,addRegNumber,addOutNumber,addDocType,addDescription,addNote, addControlStatus,addDatafile,lUsers,lUsersStatus,lUsersExecute,lDepartment,lDateOfRead,Integer.parseInt(sUsersCount),Integer.parseInt(sDepartmentCount),SessionUser,DEPARTMENT) == false)
	{	
		//и возвращаемся на главную страницу
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
 if(action.equals("2")){ //добавить исполнителя
	sUsersCount = Integer.valueOf(Integer.parseInt(sUsersCount) + 1).toString();
	lUsers.add(addUser);													
	lUsersStatus.add("ожидает");
	lUsersExecute.add("");
	lDateOfRead.add("");
 }
 if(action.equals("3")){ //добавить отдел в рассылку копий
	sDepartmentCount = Integer.valueOf(Integer.parseInt(sDepartmentCount) + 1).toString();
	lDepartment.add(addCopyToDepartment);
 }
 if(action.equals("4")){ //отмена
		//возвращаемся на главную страницу
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
 if(action.equals("5")){ //удалить исполнителя
	 	//System.out.println("INFO: Delete executer index - " + DeleteExecuterIndex + " User = " + lUsers.get(Integer.parseInt(DeleteExecuterIndex)));
		sUsersCount = Integer.valueOf(Integer.parseInt(sUsersCount) - 1).toString();
		lUsers.remove(Integer.parseInt(DeleteExecuterIndex));								
		lUsersStatus.remove(Integer.parseInt(DeleteExecuterIndex));	
		lUsersExecute.remove(Integer.parseInt(DeleteExecuterIndex));	
		lDateOfRead.remove(Integer.parseInt(DeleteExecuterIndex));
 }
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
		SessionUser = s;
		//получаем ФИО этого пользователя
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
//                           ВЫВОДИМ ДАННЫЕ О ПОЛЬЗОВАТЕЛЕ
//----------------------------------------------------------------------------------------
	if (!FULLNAME.equals("")) {
		out.println("<img src=\"images/personal.png\" width=\"16\" height=\"16\"/>  Вы авторизированы в системе как: ");
		out.println(FULLNAME + "  (" + DEPARTMENT + ")");
	}
%>

		<hr>
		<h4 align=center>Заполните таблицу и нажмите кнопку ДОБАВИТЬ</h4>
		<hr>

		<table class="bluedream">
		
			<tr>
				<td>№ п/п</td>
				<td><input type="text" name="addNumber"
					style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
					value="<% out.print(addNumber); %>"></td>
			</tr>
			<tr>
				<td>Машина</td>

				<%
		out.println("			<td><input type=\"text\" name=addProduct id=addProduct style=\"width: " + DEFAULT_ELEMENT_WIDTH + "px\" value=\""+ addProduct + "\"></td>");
		out.println("			<script type=\"text/javascript\">");
		out.println("				$(document).ready(function(){");
		out.println("				function liFormat (row, i, num) {");
		out.println("					var result = row[0] + '</p>';");
		out.println("					return result;");
		out.println("				}");
		out.println("				function selectItem(li) {");
		out.println("					if( li == null ) var sValue = 'А ничего не выбрано!';");
		out.println("					if( !!li.extra ) var sValue = li.extra[2];");
		out.println("					else var sValue = li.selectValue;");
		out.println("					f();");
		out.println("				}");
		out.println("				$(\"#addProduct\").autocomplete(\"AJAXAutocompleteProduct.jsp\", {");
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
				<td>Отправитель</td>
				<%
		out.println("			<td><input type=\"text\" name=addOwner id=addOwner style=\"width: " + DEFAULT_ELEMENT_WIDTH + "px\" value=\""+ addOwner + "\"></td>");
		out.println("			<script type=\"text/javascript\">");
		out.println("				$(document).ready(function(){");
		out.println("				function liFormat (row, i, num) {");
		out.println("					var result = row[0] + '</p>';");
		out.println("					return result;");
		out.println("				}");
		out.println("				function selectItem(li) {");
		out.println("					if( li == null ) var sValue = 'А ничего не выбрано!';");
		out.println("					if( !!li.extra ) var sValue = li.extra[2];");
		out.println("					else var sValue = li.selectValue;");
		out.println("					f();");
		out.println("				}");
		out.println("				$(\"#addOwner\").autocomplete(\"AJAXAutocompleteOwner.jsp\", {");
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
				<td>№ регистр.</td>
				<td><input type="text" name="addRegNumber"
					style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
					value="<% out.print(addRegNumber); %>"></td>
			</tr>
			<tr>
				<td>№ исход</td>
				<td><input type="text" name="addOutNumber"
					style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px"
					value="<% out.print(addOutNumber); %>"></td>
			</tr>
			<tr>
				<td>Вид документа</td>
				<%
		out.println("			<td><input type=\"text\" name=addDocType id=addDocType style=\"width: " + DEFAULT_ELEMENT_WIDTH + "px\" value=\""+ addDocType + "\"></td>");
		out.println("			<script type=\"text/javascript\">");
		out.println("				$(document).ready(function(){");
		out.println("				function liFormat (row, i, num) {");
		out.println("					var result = row[0] + '</p>';");
		out.println("					return result;");
		out.println("				}");
		out.println("				function selectItem(li) {");
		out.println("					if( li == null ) var sValue = 'А ничего не выбрано!';");
		out.println("					if( !!li.extra ) var sValue = li.extra[2];");
		out.println("					else var sValue = li.selectValue;");
		out.println("					f();");
		out.println("				}");
		out.println("				$(\"#addDocType\").autocomplete(\"AJAXAutocompleteDocType.jsp\", {");
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
				<td>Краткое содержание</td>
				<td><textarea cols="10" rows="4" name="addDescription"
						style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px">
						<% out.print(addDescription); %>
					</textarea></td>
			</tr>
			<tr>
				<td>Примечание</td>
				<td><textarea cols="10" rows="4" name="addNote"
						style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px">
						<% out.print(addNote); %>
					</textarea></td>
			</tr>
			<tr style="background-color: <%=COLOR_onControl%>;">
				<td> <div style="width: 110px;"><%=IMG_onControl%>На контроле</div>	</td>
				<%
		out.println("					<td><select name=\"addControlStatus\" style=\"width: 130px\" value=\"" + addControlStatus + "\">");
		if(addControlStatus.equals("Нет"))
			out.println("						<option selected style=\"background-color: #33CCFF\">Нет</option>");
		else
			out.println("						<option style=\"background-color: #33CCFF\">Нет</option>");
		if(addControlStatus.equals("Да"))
			out.println("						<option selected style=\"background-color: #FF6699\">Да</option>");
		else
			out.println("						<option style=\"background-color: #FF6699\">Да</option>");
		out.println("					</select></td>");		
		%>
			</tr>
			<tr>
				<td>Список исполнителей</td>
				<td><select name="addUser"
					style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px">
						<%
						ProeuserSQL.GetUsersWorkingInDepartment(DEPARTMENT);
						while(ProeuserSQL.oRs.next()){
							if(addUser.equals(ProeuserSQL.oRs.getString("FULLNAME")))
								out.println("						<option selected>" + ProeuserSQL.oRs.getString("FULLNAME") + "</option>");
							else
								out.println("						<option>" + ProeuserSQL.oRs.getString("FULLNAME") + "</option>");		
						}	
						%>
				</select>
			  	<input type=button value=Добавить onClick=AddUserToTable()>

				<table class="bluedream" width="100%">
					<%
					if(Integer.parseInt(sUsersCount)>0){
						out.println("<tr>");		
						out.println("<td width=20></td>");		
						out.println("<td width=100>ФИО</td>");		
						out.println("<td width=100>Статус</td>");		
						out.println("<td width=100>Исполнение</td>");		
						out.println("<td width=100>Дата ознакомления</td>");		
						out.println("</tr>");		
					}
					   for(i=0;i<Integer.parseInt(sUsersCount);i++){
						out.println("			<tr>");		
						//out.println("				<td><input type=button class='button_cancel' value=DEL onClick=DeleteExecuter(" + i + ")></td>");
						out.println("				<td><img src='images/button_cancel_256.png' width=16px height=16px title='Удалить из списка исполнителей'  onClick=DeleteExecuter(" + i + ")></td>");
						out.println("				<td><input type=\"text\" name=\"User" + Integer.valueOf(i).toString() + "\" style=\"width: 100 px\" value=\"" + lUsers.get(i) + "\"></td>");
						out.println("				<td>");
						out.println("					<select name=\"Status" + Integer.valueOf(i).toString() + "\" style=\"width: 130px\" value=\"" + lUsersStatus.get(i) + "\">");
						if(lUsersStatus.get(i).equals("ожидает"))
							out.println("						<option selected style=\"background-color: #708090\">ожидает</option>");
						else
							out.println("						<option style=\"background-color: #708090\">ожидает</option>");
						if(lUsersStatus.get(i).equals("ознакамливается"))
							out.println("						<option selected style=\"background-color: #ff6c36\">ознакамливается</option>");
						else
							out.println("						<option style=\"background-color: #ff6c36\">ознакамливается</option>");
						if(lUsersStatus.get(i).equals("ознакомлен"))
							out.println("						<option selected style=\"background-color: #4169E1\">ознакомлен</option>");
						else
							out.println("						<option style=\"background-color: #4169E1\">ознакомлен</option>");
						if(lUsersStatus.get(i).equals("хранение"))
							out.println("						<option selected style=\"background-color: #339933\">хранение</option>");
						else
							out.println("						<option style=\"background-color: #339933\">хранение</option>");
						out.println("					</select>");
						out.println("				</td>");
						out.println("				<td><input type=\"text\" name=\"Execute" + Integer.valueOf(i).toString() + "\" style=\"width: 100px\" value=\"" + lUsersExecute.get(i) + "\"></td>");
						out.println("				<td><input type=\"text\" name=\"DateOfRead" + Integer.valueOf(i).toString() + "\" style=\"width: 100px\" value=\"" + lDateOfRead.get(i) + "\"></td>");
						out.println("			</tr>");
					}
					%>
				</table> 
				<br>
			</td>
			</tr>
			<tr>
				<td>Копия передана в отделы</td>
				<td>
				<select name="addCopyToDepartment"
						style="width: <% out.print(DEFAULT_ELEMENT_WIDTH); %>px">
					<%
					ProeuserSQL.GetAllDepartment();
					while(ProeuserSQL.oRs.next()){
						if(addCopyToDepartment.equals(ProeuserSQL.oRs.getString("DEPARTMENT")))
							out.println("						<option selected>" + ProeuserSQL.oRs.getString("DEPARTMENT") + "</option>");
						else
							out.println("						<option>" + ProeuserSQL.oRs.getString("DEPARTMENT") + "</option>");		
					}	
					%>
					</select> 
				<input type=button value=Добавить onClick=AddDepartment()>
					
				<table class='bluedream'  width='100%'>
				<%
					//таблица со списком отделов в которые передана копия 
					if(Integer.parseInt(sDepartmentCount)>0){								
						out.println("<tr>");	
						out.println("<td width='100%'>Отдел</td>");	
						out.println("</tr>");	
					}

					for(i=0;i<Integer.parseInt(sDepartmentCount);i++){
						out.println("			<tr>");
						out.println("				<td>");
						out.println("					<select name=\"Department" + Integer.valueOf(i).toString() + "\" style=\"width: style='width: "+DEFAULT_ELEMENT_WIDTH+ "px'\" value=\"" + lDepartment.get(i) + "\">");
						ProeuserSQL.GetAllDepartment();
						while(ProeuserSQL.oRs.next()){
							if(lDepartment.get(i).equals(ProeuserSQL.oRs.getString("DEPARTMENT")))
								out.println("						<option selected>" + ProeuserSQL.oRs.getString("DEPARTMENT") + "</option>");
							else
								out.println("						<option>" + ProeuserSQL.oRs.getString("DEPARTMENT") + "</option>");			
						}
						out.println("					</select>");
						out.println("				</td>");
						out.println("			</tr>"); 
					}
					ProeuserSQL.Disconnect();
				%>
				</table>
			</td>
			</tr>
			<tr>
				<td>Файл</td>
				<td><input type="file" name="addDatafile"
					style="width: 100%"
					value="<% out.print(addDatafile); %>"></td>
			</tr>
		</table>
		<hr>
		<input type=hidden name=action> 
		<input type=hidden name=DeleteExecuterIndex> 
		<input type=hidden name=SessionUser	value="<% out.print(SessionUser);%>"> 
		<input type=hidden name=ADMINISTRATOR value="<% out.print(ADMINISTRATOR);%>"> 
		<input type=hidden name=FULLNAME value="<% out.print(FULLNAME);%>">
		<input type=hidden name=DEPARTMENT value="<% out.print(DEPARTMENT);%>">
		<input type=hidden name=sUsersCount	value="<% out.print(sUsersCount);%>"> 
		<input type=hidden name=sDepartmentCount value="<% out.print(sDepartmentCount);%>">
		<input type=hidden name=selOutNumber value="<% out.print(selOutNumber);%>"> 
		<input type=hidden name=selDocType value="<% out.print(selDocType);%>"> 
		<input type=hidden name=selDescriptionText	value="<% out.print(selDescriptionText);%>"> 
		<input type=hidden name=selRegNumber value="<% out.print(selRegNumber);%>">
		<input type=hidden name=selAuthor value="<% out.print(selAuthor);%>">
		<input type=hidden name=selProduct value="<% out.print(selProduct);%>">
		<input type=hidden name=TYPESORTING	value="<% out.print(TYPESORTING);%>">
		
		<!-- 1 - добавление записи в таблицу и преход на главную страницу -->
		<!-- 2 - добавление пользователя -->
		<!-- 3 - добавление отдела -->
		<!-- 4 - отмена -->
		<!-- 5 - удаление исполнителя -->
		
		<input type=button value=Сохранить onClick=AddExecute()> 
		<input type=button value=Отмена onClick=CancelExecute()>

	</form> 
</div>
<script type="text/javascript">	AllTrim(); </script> <!-- ДЛЯ ФОРМАТИРОВАНИЯ ПОЛЕЙ ПРИ ОТКРЫТИИ СТРАНИЦЫ -->		
</body>
</html>