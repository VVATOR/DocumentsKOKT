<%@ page language="java" contentType="text/html; charset=windows-1251"
	import="by.gomel.gskb.oracle.PROEUSER.ProeuserSQLRequest"%>
<%
  //получаем перемаддый параметр
  String QString = "";
  int i = 0;
  if(request.getParameter("q") != null){
		QString = new String (request.getParameter("q").getBytes("ISO-8859-1")).replaceAll("  ", " ").trim();
  }
  //создаем объект для БД
  ProeuserSQLRequest sql = new ProeuserSQLRequest();
  //выполняем запрос
  sql.GetAllDocType(QString.trim().replaceAll("  ", " "));
  //идем по записям
  while(sql.oRs.next()){
	  //выводим запись
	  out.println(sql.oRs.getString("DOCTYPE") + "\n");
	  i++;
	  //eсли больше 10 записей, то дальше не выводим
	  //if(i>50) break;
  }
  sql.Disconnect();
%>