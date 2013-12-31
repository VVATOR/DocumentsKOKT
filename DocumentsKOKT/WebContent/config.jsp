<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<%@page import="by.gomel.gskb.oracle.PROEUSER.ProeuserSQLRequest"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%> 
<style>
img{
outline: none;
	border-width: 0px;
}

a {
	outline: none;
}

input{
outline: none;
}

input[type="button"] {
padding: 3px 5px;
font-size: 14px;
text-transform: none;
margin: 0 0px 0 0;
border-radius: 2px 2px 0 0;
background: none;
font-family: 'museo_sans_300regular',arial,helvetica,clean,sans-serif;
color: #666;
background: #f2f2f2;
font-weight: bold;
opacity: 1;
border-width: 1px;
border-color:black;
outline: none;
}

input[type="button"]:hover {
padding: 3px 5px;
font-size: 14px;
text-transform: none;
margin: 0 0px 0 0;
border-radius: 2px 2px 0 0;
font-family: 'museo_sans_300regular',arial,helvetica,clean,sans-serif;
color: white;
background: #4387fd;
opacity: 1;
border-width: 1px;
border-color:black;
outline: none;
}


input[type="file"]{
padding: 3px 5px;
font-size: 14px;
text-transform: none;
margin: 0 0px 0 0;
border-radius: 2px 2px 0 0;
background: none;
font-family: 'museo_sans_300regular',arial,helvetica,clean,sans-serif;
color: #ffffff;
background: #f2f2f2;
opacity: 1;
border-width: 1px;
border-color:black;
outline: none;
}

input[type="button"].button_cancel{
padding: 5px 5px;
font-size: 14px;
text-transform: none;
margin: 0 0px 0 0;
border-radius: 2px 2px 0 0;
font-family: 'museo_sans_300regular',arial,helvetica,clean,sans-serif;
color: red;
opacity: 1;
border-width: 1px;
border-color:black;
outline: none;
background-image: url("images/button_cancel_256.png") 100% 100% no-repeat;
background-size: cover;
}
</style>





<% 
String PROGRAMM_version = "1.3";
String PROGRAMM_name    = "Входящая документация (версия "+PROGRAMM_version+")";

String PROGRAMM_contakt = "";

String IMG_onControl ="<img src='images/Warning.png' width='16px' height='16px' title='На контроле'>&nbsp";//Stop
String IMG_date ="";//"<img src='images/calendar_edit.png' width='24px' height='24px' title='Дата'> &nbsp";//Stop
String IMG_add ="<img src='images/addU.png' width='24px' height='24px' title='добавить'> &nbsp";//Stop



String COLOR_onControl ="#FAFAD2";//"#E6E6FA";//"#FFF0F5";// "#FFF8DC";//"#7FFF00";   //#F5DEB3   #FFA07A ##F5DEB3


%>
