<%@ page language="java" contentType="text/html; charset=windows-1251"
	import="by.gomel.gskb.oracle.PROEUSER.ProeuserSQLRequest"%>
<%
  //�������� ���������� ��������
  String QString = "";
  int i = 0;
  if(request.getParameter("q") != null){
		QString = new String (request.getParameter("q").getBytes("ISO-8859-1")).replaceAll("  ", " ").trim();
  }
  //������� ������ ��� ��
  ProeuserSQLRequest sql = new ProeuserSQLRequest();
  //��������� ������
  sql.GetAllDocType(QString.trim().replaceAll("  ", " "));
  //���� �� �������
  while(sql.oRs.next()){
	  //������� ������
	  out.println(sql.oRs.getString("DOCTYPE") + "\n");
	  i++;
	  //e��� ������ 10 �������, �� ������ �� �������
	  //if(i>50) break;
  }
  sql.Disconnect();
%>