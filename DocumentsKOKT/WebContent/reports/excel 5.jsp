<%@ page language="java" contentType="text/html; charset=windows-1251"
	pageEncoding="windows-1251"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="../config.jsp"%>
<!-- файл с глобальными настрайками и библиотеками -->
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>



<!-- файл с глобальными настрайками и библиотеками -->
<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1251">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 11">
<link rel=File-List href="excel%205.files/filelist.xml">
<link rel=Edit-Time-Data href="excel%205.files/editdata.mso">
<link rel=OLE-Object-Data href="excel%205.files/oledata.mso">
<title>Входящая документация (версия 1.3)</title>
<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:LastAuthor>Vikhlaev</o:LastAuthor>
  <o:LastPrinted>2013-10-11T06:59:34Z</o:LastPrinted>
  <o:Created>2013-10-11T07:00:47Z</o:Created>
  <o:LastSaved>2013-10-11T07:01:14Z</o:LastSaved>
  <o:Version>11.9999</o:Version>
 </o:DocumentProperties>
</xml><![endif]-->
<style>
<!--table
	{mso-displayed-decimal-separator:"\,";
	mso-displayed-thousand-separator:" ";}
@page
	{margin:.98in .79in .98in .79in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;}
.font7
	{color:#339966;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:"Arial Cyr";
	mso-generic-font-family:auto;
	mso-font-charset:204;}
.font8
	{color:#3366FF;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:"Arial Cyr";
	mso-generic-font-family:auto;
	mso-font-charset:204;}
tr
	{mso-height-source:auto;}
col
	{mso-width-source:auto;}
br
	{mso-data-placement:same-cell;}
.style0
	{mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	white-space:nowrap;
	mso-rotate:0;
	mso-background-source:auto;
	mso-pattern:auto;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:"Arial Cyr";
	mso-generic-font-family:auto;
	mso-font-charset:204;
	border:none;
	mso-protection:locked visible;
	mso-style-name:Обычный;
	mso-style-id:0;}
td
	{mso-style-parent:style0;
	padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:"Arial Cyr";
	mso-generic-font-family:auto;
	mso-font-charset:204;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border:none;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:locked visible;
	white-space:nowrap;
	mso-rotate:0;}
.xl24
	{mso-style-parent:style0;
	background:#99CC00;
	mso-pattern:auto none;}
.xl25
	{mso-style-parent:style0;
	font-weight:700;
	text-align:center;
	vertical-align:middle;
	border:.5pt solid black;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl26
	{mso-style-parent:style0;
	color:red;
	font-weight:700;
	text-align:center;
	vertical-align:middle;
	border:.5pt solid black;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl27
	{mso-style-parent:style0;
	font-weight:700;
	mso-number-format:"Short Date";
	text-align:center;
	vertical-align:middle;
	border:.5pt solid black;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl28
	{mso-style-parent:style0;
	border-top:.5pt solid black;
	border-right:none;
	border-bottom:.5pt solid black;
	border-left:.5pt solid black;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl29
	{mso-style-parent:style0;
	border-top:.5pt solid black;
	border-right:none;
	border-bottom:.5pt solid black;
	border-left:none;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl30
	{mso-style-parent:style0;
	border-top:.5pt solid black;
	border-right:.5pt solid black;
	border-bottom:.5pt solid black;
	border-left:none;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl31
	{mso-style-parent:style0;
	border:.5pt solid black;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
-->
</style>
<!--[if gte mso 9]><xml>
 <x:ExcelWorkbook>
  <x:ExcelWorksheets>
   <x:ExcelWorksheet>
    <x:Name>excel 4 </x:Name>
    <x:WorksheetOptions>
     <x:Print>
      <x:ValidPrinterInfo/>
      <x:PaperSizeIndex>9</x:PaperSizeIndex>
      <x:Scale>33</x:Scale>
      <x:HorizontalResolution>600</x:HorizontalResolution>
      <x:VerticalResolution>600</x:VerticalResolution>
     </x:Print>
     <x:ShowPageBreakZoom/>
     <x:PageBreakZoom>100</x:PageBreakZoom>
     <x:Selected/>
     <x:DoNotDisplayGridlines/>
     <x:Panes>
      <x:Pane>
       <x:Number>3</x:Number>
       <x:ActiveRow>2</x:ActiveRow>
       <x:ActiveCol>8</x:ActiveCol>
      </x:Pane>
     </x:Panes>
     <x:ProtectContents>False</x:ProtectContents>
     <x:ProtectObjects>False</x:ProtectObjects>
     <x:ProtectScenarios>False</x:ProtectScenarios>
    </x:WorksheetOptions>
   </x:ExcelWorksheet>
  </x:ExcelWorksheets>
  <x:WindowHeight>13545</x:WindowHeight>
  <x:WindowWidth>28635</x:WindowWidth>
  <x:WindowTopX>0</x:WindowTopX>
  <x:WindowTopY>30</x:WindowTopY>
  <x:ProtectStructure>False</x:ProtectStructure>
  <x:ProtectWindows>False</x:ProtectWindows>
 </x:ExcelWorkbook>
</xml><![endif]-->
</head>

<body link=blue vlink=purple>
<%	response.setHeader("Content-disposition",  "attachment; filename=excel.xls" );%>
<table x:str border=0 cellpadding=0 cellspacing=0 width=1748 style='border-collapse:
 collapse;table-layout:fixed;width:1311pt'>
<!--<caption>Регистрацыя входящей корреспонденции КО КТ</caption>-->
 <col width=114 style='mso-width-source:userset;mso-width-alt:4169;width:86pt'>
 <col width=64 style='width:48pt'>
 <col width=111 style='mso-width-source:userset;mso-width-alt:4059;width:83pt'>
 <col width=123 style='mso-width-source:userset;mso-width-alt:4498;width:92pt'>
 <col width=153 style='mso-width-source:userset;mso-width-alt:5595;width:115pt'>
 <col width=160 style='mso-width-source:userset;mso-width-alt:5851;width:120pt'>
 <col width=256 span=3 style='mso-width-source:userset;mso-width-alt:9362;
 width:192pt'>
 <col width=184 style='mso-width-source:userset;mso-width-alt:6729;width:138pt'>
 <col width=71 style='mso-width-source:userset;mso-width-alt:2596;width:53pt'>
 <tr height=17 style='height:12.75pt'>
  <td height=17 class=xl25 width=114 style='height:12.75pt;width:86pt'>№ п/п</td>
  <td class=xl25 width=64 style='border-left:none;width:48pt'>Машина</td>
  <td class=xl25 width=111 style='border-left:none;width:83pt'>Отправитель</td>
  <td class=xl25 width=123 style='border-left:none;width:92pt'>№ регистр.</td>
  <td class=xl25 width=153 style='border-left:none;width:115pt'>№ исход</td>
  <td class=xl25 width=160 style='border-left:none;width:120pt'>Вид документа</td>
  <td class=xl25 width=256 style='border-left:none;width:192pt'>Краткое
  содержание</td>
  <td class=xl25 width=256 style='border-left:none;width:192pt'>Примечание</td>
  <td class=xl25 width=256 style='border-left:none;width:192pt'>Список
  исполнителей</td>
  <td class=xl25 width=184 style='border-left:none;width:138pt'>Исполнение</td>
  <td class=xl25 width=71 style='border-left:none;width:53pt'>Дата</td>
 </tr>
 <tr class=xl24 height=51 style='height:38.25pt'>
  <td height=51 class=xl25 width=114 style='height:38.25pt;border-top:none;
  width:86pt' x:num>319</td>
  <td class=xl26 width=64 style='border-top:none;border-left:none;width:48pt'>Общее</td>
  <td class=xl26 width=111 style='border-top:none;border-left:none;width:83pt'>Рехлицкий
  О.В.</td>
  <td class=xl26 width=123 style='border-top:none;border-left:none;width:92pt'>б/н</td>
  <td class=xl26 width=153 style='border-top:none;border-left:none;width:115pt'>б/н
  от 01.10.2013</td>
  <td class=xl25 width=160 style='border-top:none;border-left:none;width:120pt'>Задание</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Задание
  на закупку комплекса средств контроля информационных потоков</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Срок
  выполнения 02.10.2013</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Козлов
  В.И.<font class="font7"> - хранение (01.10.2013)</font></td>
  <td class=xl25 width=184 style='border-top:none;border-left:none;width:138pt'
  x:str="Козлов В.И. - ">Козлов В.И. -<span style='mso-spacerun:yes'> </span></td>
  <td class=xl27 width=71 style='border-top:none;border-left:none;width:53pt'
  x:num="41548">01.10.2013</td>
 </tr>
 <tr class=xl24 height=323 style='height:242.25pt'>
  <td height=323 class=xl25 width=114 style='height:242.25pt;border-top:none;
  width:86pt' x:num>259</td>
  <td class=xl26 width=64 style='border-top:none;border-left:none;width:48pt'>Общее</td>
  <td class=xl26 width=111 style='border-top:none;border-left:none;width:83pt'>МинПром
  РБ</td>
  <td class=xl26 width=123 style='border-top:none;border-left:none;width:92pt'>2082
  от 29.08.2013</td>
  <td class=xl26 width=153 style='border-top:none;border-left:none;width:115pt'>18-12/352
  от 27.08.2013</td>
  <td class=xl25 width=160 style='border-top:none;border-left:none;width:120pt'>Контрольная
  карточка</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Об
  информировании. Министерство промышленности информирует, что министерством
  здравоохранения принято постановление от 28.06.2013г. №59 &quot;Об
  утверждении санитарных норм и правил &quot;Требования при работе с видео
  дисплейными терминалами&quot;, Гигиенического норматива
  &quot;Предельно-допустимые уровни нормируемых параметров при работе при
  работе с видеодисплейными терминалами и электронно-вычислительными
  машинами&quot; и признании утратившими силу постановлений Главного
  государственного санитарного врача РБ от 10. ноября 2000г.№53 и от 30 мая
  2006г.№70&quot;</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Для
  проработки и подготовки мероприятий по приведению в соотв.с треб.
  постановления №59 Срок выполнения: 09.09.2013</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Козлов
  В.И.<font class="font8"> - ознакомлен (02.08.2013)</font></td>
  <td class=xl25 width=184 style='border-top:none;border-left:none;width:138pt'
  x:str="Козлов В.И. - ">Козлов В.И. -<span style='mso-spacerun:yes'> </span></td>
  <td class=xl27 width=71 style='border-top:none;border-left:none;width:53pt'
  x:num="41519">02.09.2013</td>
 </tr>
 <tr class=xl24 height=51 style='height:38.25pt'>
  <td height=51 class=xl25 width=114 style='height:38.25pt;border-top:none;
  width:86pt' x:num>151</td>
  <td class=xl26 width=64 style='border-top:none;border-left:none;width:48pt'>Общее</td>
  <td class=xl26 width=111 style='border-top:none;border-left:none;width:83pt'>Псырков
  Н.В.</td>
  <td class=xl26 width=123 style='border-top:none;border-left:none;width:92pt'>б/н</td>
  <td class=xl26 width=153 style='border-top:none;border-left:none;width:115pt'>б/н</td>
  <td class=xl25 width=160 style='border-top:none;border-left:none;width:120pt'>План</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>План
  работы главного инженера на июль 2013 года</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Срок
  выполнения 24.07.2013 - Для подготовки вопросов и предложений к совещанию</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>&nbsp;</td>
  <td class=xl25 width=184 style='border-top:none;border-left:none;width:138pt'>&nbsp;</td>
  <td class=xl27 width=71 style='border-top:none;border-left:none;width:53pt'
  x:num="41457">02.07.2013</td>
 </tr>
 <tr class=xl24 height=34 style='height:25.5pt'>
  <td height=34 class=xl25 width=114 style='height:25.5pt;border-top:none;
  width:86pt' x:num>124</td>
  <td class=xl26 width=64 style='border-top:none;border-left:none;width:48pt'>КВК-8060</td>
  <td class=xl26 width=111 style='border-top:none;border-left:none;width:83pt'>Рехлицкий
  О.В.</td>
  <td class=xl26 width=123 style='border-top:none;border-left:none;width:92pt'>б/н</td>
  <td class=xl26 width=153 style='border-top:none;border-left:none;width:115pt'>б/н
  от 14.06.2013</td>
  <td class=xl25 width=160 style='border-top:none;border-left:none;width:120pt'>Отчет</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Информация
  по работе комплекса КВК-8060</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>&nbsp;</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Козлов
  В.И.<font class="font8"> - ознакомлен (17.06.2013)</font></td>
  <td class=xl25 width=184 style='border-top:none;border-left:none;width:138pt'>Козлов
  В.И. - <font class="font8">до 28.06.2013</font></td>
  <td class=xl27 width=71 style='border-top:none;border-left:none;width:53pt'
  x:num="41442">17.06.2013</td>
 </tr>
 <tr class=xl24 height=34 style='height:25.5pt'>
  <td height=34 class=xl25 width=114 style='height:25.5pt;border-top:none;
  width:86pt' x:num>81</td>
  <td class=xl26 width=64 style='border-top:none;border-left:none;width:48pt'>Общее</td>
  <td class=xl26 width=111 style='border-top:none;border-left:none;width:83pt'>Рехлицкий
  О.В.</td>
  <td class=xl26 width=123 style='border-top:none;border-left:none;width:92pt'>б/н</td>
  <td class=xl26 width=153 style='border-top:none;border-left:none;width:115pt'>18
  от 27.05.2013</td>
  <td class=xl25 width=160 style='border-top:none;border-left:none;width:120pt'>Протокол</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Совещание
  с руководителями структурных подразделений</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Снята
  с контроля 31.05.2013</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>&nbsp;</td>
  <td class=xl25 width=184 style='border-top:none;border-left:none;width:138pt'>&nbsp;</td>
  <td class=xl27 width=71 style='border-top:none;border-left:none;width:53pt'
  x:num="41423">29.05.2013</td>
 </tr>
 <tr class=xl24 height=34 style='height:25.5pt'>
  <td height=34 class=xl26 width=114 style='height:25.5pt;border-top:none;
  width:86pt' x:num>52</td>
  <td class=xl26 width=64 style='border-top:none;border-left:none;width:48pt'>Общее</td>
  <td class=xl26 width=111 style='border-top:none;border-left:none;width:83pt'>Рехлицкий
  О.В.</td>
  <td class=xl26 width=123 style='border-top:none;border-left:none;width:92pt'>б/н</td>
  <td class=xl26 width=153 style='border-top:none;border-left:none;width:115pt'>б/н</td>
  <td class=xl25 width=160 style='border-top:none;border-left:none;width:120pt'>Письмо</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Спецификация
  от SoftLine</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>&nbsp;</td>
  <td class=xl25 width=256 style='border-top:none;border-left:none;width:192pt'>Козлов
  В.И.<font class="font8"> - ознакомлен (17.05.2013)</font></td>
  <td class=xl25 width=184 style='border-top:none;border-left:none;width:138pt'
  x:str="Козлов В.И. - ">Козлов В.И. -<span style='mso-spacerun:yes'> </span></td>
  <td class=xl27 width=71 style='border-top:none;border-left:none;width:53pt'
  x:num="41411">17.05.2013</td>
 </tr>
 <tr height=17 style='height:12.75pt'>
  <td height=17 class=xl25 width=114 style='height:12.75pt;border-top:none;
  width:86pt'>Всего 6 записей</td>
  <td colspan=9 class=xl28 width=1563 style='border-right:.5pt solid black;
  border-left:none;width:1172pt'>&nbsp;</td>
  <td class=xl31 width=71 style='border-top:none;border-left:none;width:53pt'>&nbsp;</td>
 </tr>
 <![if supportMisalignedColumns]>
 <tr height=0 style='display:none'>
  <td width=114 style='width:86pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=111 style='width:83pt'></td>
  <td width=123 style='width:92pt'></td>
  <td width=153 style='width:115pt'></td>
  <td width=160 style='width:120pt'></td>
  <td width=256 style='width:192pt'></td>
  <td width=256 style='width:192pt'></td>
  <td width=256 style='width:192pt'></td>
  <td width=184 style='width:138pt'></td>
  <td width=71 style='width:53pt'></td>
 </tr>
 <![endif]>
</table>

</body>

</html>
