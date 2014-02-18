package by.gomel.gskb.oracle.PROEUSER;
import java.io.File;
import java.io.FileInputStream;
import java.sql.Blob;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Formatter;
import java.util.ResourceBundle;



/**
 * @version 0.0.0.1
 * @author КОРЖОВ А.В.
 */
//--------------------------------------------------------------------------------------
//Класс             : ВЫПОЛНЕНИЕ ЗАПРОСОВ В БАЗЕ ORACLE В ТАБЛИЧНОМ ПРОСТРАНСТВЕ PROEUSER
//Организация       : РКУП "ГСКБ ПО ЗЕРНОУБОРОЧНОЙ И КОРМОУБОРОЧНОЙ ТЕХНИКЕ"
//--------------------------------------------------------------------------------------
/**
 * @version 0.0.0.0 - без реализации
 * @version 0.0.0.1 - описаны свойства и методы класса
 */
public class ProeuserSQLRequest {
//--------------------------------------------------------------------------------------
//  СВОЙСТВА КЛАССА
//--------------------------------------------------------------------------------------
	/**
	 * таймаут запроса
	*/
	private int iQUERY_TIMEOUT = 2400;//240;
	/**
	 * объект результирующего набора записей
	*/
	public ResultSet oRs = null;
	/**
	 * объект Statement
	*/
	private Statement oStmt = null;
	/**
	 * объект подключения к БД ORACLE табличное пространство PROEUSER
	*/
	private OracleConnect oOC;
//--------------------------------------------------------------------------------------
//  МЕТОДЫ КЛАССА
//--------------------------------------------------------------------------------------
	/**
	* МЕТОД              конструктор класса
	* @param             отсуствуют
	* @since             0.0.0.1
	*/	
	public ProeuserSQLRequest() throws Exception{		
		ResourceBundle resource = ResourceBundle.getBundle("database");
		String name =resource.getString("name");
		String password =resource.getString("password");
		String host =resource.getString("host");
		String server =resource.getString("server");
		String port =resource.getString("port");
		
		oOC = new OracleConnect(name,password,host,server,port);
		 
		//String sName, sPassword, sServerIP,  sDatabaseName,  sPort
		
		//вызываем метод подключения к базе данных Oracle
		//oOC = new OracleConnect("proeuser","proeuser","plm.gskbgomel.by","SEARCH","1521");
		// oOC = new OracleConnect("PROEUSER","masterkey","VVATOR_PC","VVATOR");
			
		  //подключить
		  oOC.getConnection();
			//Создаем statment (оператор) для выполнения SQL-запроса
		  oStmt = oOC.getCon().createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	}


	
	

	
	
	/**
	 * МЕТОД              отключение от БД
	 * @param             отсуствуют
	 * @return            отсуствуют
	 * @since             0.0.0.1
	*/
	public void Disconnect () throws Exception{
		if(oRs!=null){
			oRs.close();
		}
		if(oStmt!=null){
			oStmt.close();
		}
		if(oOC!=null){
			oOC.Disconnected();
		}
	}
	/**
	 * МЕТОД              получить таймаут запроса
	 * @param             отсуствуют
	 * @return            таймаут запроса
	 * @since             0.0.0.1
	*/
	public int getiQUERY_TIMEOUT() {
		return iQUERY_TIMEOUT;
	}
	 /**
	  * МЕТОД              установить таймаут запроса
	  * @param             таймаут запроса
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void setiQUERY_TIMEOUT(int iQUERY_TIMEOUT) {
		this.iQUERY_TIMEOUT = iQUERY_TIMEOUT;
	}
	 /**
	  * МЕТОД              получить объект Statement
	  * @param             отсуствуют
	  * @return            объект Statement
	  * @since             0.0.0.1
	  */
	public Statement getoStmt() {
		return oStmt;
	}
	 /**
	  * МЕТОД              установить объект Statement
	  * @param             объект Statement
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void setoStmt(Statement oStmt) {
		this.oStmt = oStmt;
	}
	 /**
	  * МЕТОД              получить объект подключения к БД
	  * @param             отсуствуют
	  * @return            объект подключения к БД
	  * @since             0.0.0.1
	  */
	public OracleConnect getoOC() {
		return oOC;
	}
	 /**
	  * МЕТОД              установить объект подключения к БД
	  * @param             объект подключения к БД
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void setoOC(OracleConnect oOC) {
		this.oOC = oOC;
	}
	
	 /**
	  * МЕТОД              получить ФИО и отдел пользователя по логину
	  * @param             логин
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetUserFioAndDepartmentFromLogin (String Login) throws Exception{
		  String sql = "SELECT ";
		  sql = sql + " USERS.LOGIN,";
		  sql = sql + " USERS.FULLNAME,";
		  sql = sql + " DEPARTMENT.DEPARTMENT,";
		  sql = sql + " DEPARTMENT.DEPARTMENT_ABB,";
		  sql = sql + " DEPARTMENT.DEPARTMENT_CHIEF,";
		  sql = sql + " DOC_PERMISSION.PERMISSION";
		  sql = sql + " FROM USERS";
		  sql = sql + " INNER JOIN DEPARTMENT ON USERS.DEPARTMENT_ID = DEPARTMENT.ID";
		  sql = sql + " LEFT JOIN DOC_PERMISSION ON DOC_PERMISSION.LOGIN_ID = USERS.ID";
		  sql = sql + " WHERE";
		  sql = sql + " UPPER(TRIM(USERS.LOGIN)) = UPPER('" + Login + "')";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              получить пользователей, работающих в отделе
	  * @param             отдел
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetUsersWorkingInDepartment (String Department) throws Exception{
		String sql = "";
		if(Department.equals("КИО ВС")){
			sql="SELECT FULLNAME FROM USERS,DEPARTMENT "+
					"WHERE USERS.DEPARTMENT_ID = DEPARTMENT.ID AND DEPARTMENT.DEPARTMENT_ABB = '" + Department + "' "+
			  	   		"and USER_STATUS=1 "+
				" union "+
		  	   	"  (Select FULLNAME from USERS "+
		  	   	"    where DEPARTMENT_ID=17 and USER_STATUS=1 and BOSS=1 )"+
		  	   	
		  	    " union "+
		  	   	"  (Select FULLNAME from USERS " +
		  	   	"    where DEPARTMENT_ID=40 and USER_STATUS=1 and BOSS=0 and id=205) "+		  	   	
		  	   	"ORDER BY FULLNAME";
			
		}
		else{
			sql="SELECT FULLNAME FROM USERS,DEPARTMENT "+
			  	   "WHERE USERS.DEPARTMENT_ID = DEPARTMENT.ID AND DEPARTMENT.DEPARTMENT_ABB = '" + Department + "' "+
			  	   		"and USER_STATUS=1 "+
			  	   "ORDER BY FULLNAME";
		}
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs = oStmt.executeQuery(sql);
	}
	
	 /**
	  * МЕТОД              получить все отделы
	  * @param             отсуствуют
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetAllDepartment () throws Exception{
		  String sql = "SELECT DEPARTMENT FROM DEPARTMENT ORDER BY DEPARTMENT";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              получить всех отправителей
	  * @param             отсуствуют
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetAllAuthors () throws Exception{
		  String sql = "SELECT distinct trim(AUTHOR) AUTHOR FROM DOC_AUTHORS ORDER BY AUTHOR";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	/**
	 * МЕТОД  получить количество сообщений именно Пользователю (который вошел)///
	 * @throws SQLException 
	 * 
	 */
	public int countOnlyI(String user) throws SQLException{
		
		String sql="SELECT count(*)"+ 
		 "FROM "+
		 "PROEUSER.DOC_ALLDOCS "+
				  "LEFT JOIN PROEUSER.DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID "+
				  "LEFT JOIN PROEUSER.DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID "+
				  "LEFT JOIN PROEUSER.DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID "+
				  "LEFT JOIN PROEUSER.DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID "+
				  "LEFT JOIN PROEUSER.USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID "+
				  "LEFT JOIN PROEUSER.DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID "+
				  "LEFT JOIN PROEUSER.DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID "+
				  "LEFT JOIN PROEUSER.DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID "+
				  "LEFT JOIN PROEUSER.DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID "+
		  "where " +
		  "LOGIN=UPPER('"+user+"')";
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs = oStmt.executeQuery(sql);
		oRs.next();
		int i=oRs.getInt(1);
		return i;
		}
	
	/**	
	 * МЕТОД  получить количество ЛИЧНЫХ сообщений по результатам поиска
	 * @throws SQLException 
	 * 
	 */
	public int countFOUNDForI(String SessionUser, String selOutNumber, String selDocType, String selDescriptionText, String selRegNumber,
			  String selAuthor, String selProduct, String selId_Dep) throws Exception{
			  boolean Where_Label = false;

			  
			  String sql ="select count(*) from ";
			  sql += "(SELECT distinct DOC_ALLDOCS.id";
			  sql += " FROM ";
			  sql += " PROEUSER.DOC_ALLDOCS ";
			  sql += " LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID";
			  sql += " LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID";  
			  sql += " LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID";
			  sql += " LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID ";
			  sql += " LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID";
			  sql += " LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID"; 
			  sql += " LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID"; 
			  sql += " LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID";
			  sql += " LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID";
			  if((!SessionUser.equals("")) && (SessionUser != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  //sql += " DOC_ALLDOCS.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM USERS WHERE LOGIN=UPPER('" + SessionUser + "'))";
				 
				  sql += "LOGIN=UPPER('"+SessionUser+"')";
			  }
				  
				  
				  
				  
			  if((!selDescriptionText.equals("")) && (selDescriptionText != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " UPPER(DOC_ALLDOCS.DESCRIPTION) LIKE UPPER('%" + selDescriptionText + "%')";
			  }
			  if((!selRegNumber.equals("")) && (selRegNumber != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " UPPER(DOC_ALLDOCS.REG_NUMBER) LIKE UPPER('%" + selRegNumber + "%')";
			  }
			  if((!selOutNumber.equals("")) && (selOutNumber != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.OUT_NUMBER LIKE '%" + selOutNumber + "%'";
			  }
			  if((!selDocType.equals("Все")) && (!selDocType.equals("")) && (selDocType != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.DOCTYPE_ID = (SELECT ID FROM DOC_DOCTYPES WHERE DOCTYPE = '" + selDocType + "')";
			  }
			  if((!selAuthor.equals("Все")) && (!selAuthor.equals("")) && (selAuthor != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.AUTHOR_ID = (SELECT ID FROM DOC_AUTHORS WHERE AUTHOR = '" + selAuthor + "')";
			  }
			  if((!selProduct.equals("Все")) && (!selProduct.equals("")) && (selProduct != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.PRODUCT_ID = (SELECT ID FROM DOC_PRODUCTS WHERE PRODUCT = '" + selProduct + "')";
			  }
			  if((!selId_Dep.equals(""))){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql+=" DOC_ALLDOCS.ID_DEP="+selId_Dep;
			  }
			  sql += " GROUP BY DOC_ALLDOCS.id ";
			  sql += ")";
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs = oStmt.executeQuery(sql);
		oRs.next();
		int i=oRs.getInt(1);
		return i;
	}
	
	
	
	 /**	
	 * МЕТОД  получить количество сообщений по результатам поиска,в отделе Пользователя (который вошел)
	 * @throws SQLException 
	 * 
	 */
	public int countFOUNDForDepartment(String SessionUser, String selOutNumber, String selDocType, String selDescriptionText, String selRegNumber,
			  String selAuthor, String selProduct, String selId_Dep) throws Exception{
			  boolean Where_Label = false;

			  
			  String sql ="select count(*) from ";
			  sql += "(SELECT distinct DOC_ALLDOCS.id";
			  sql += " FROM ";
			  sql += " PROEUSER.DOC_ALLDOCS ";
			  sql += " LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID";
			  sql += " LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID";  
			  sql += " LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID";
			  sql += " LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID ";
			  sql += " LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID";
			  sql += " LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID"; 
			  sql += " LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID"; 
			  sql += " LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID";
			  sql += " LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID";
			  if((!SessionUser.equals("")) && (SessionUser != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM USERS WHERE LOGIN=UPPER('" + SessionUser + "'))";
			  }
			  if((!selDescriptionText.equals("")) && (selDescriptionText != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " UPPER(DOC_ALLDOCS.DESCRIPTION) LIKE UPPER('%" + selDescriptionText + "%')";
			  }
			  if((!selRegNumber.equals("")) && (selRegNumber != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " UPPER(DOC_ALLDOCS.REG_NUMBER) LIKE UPPER('%" + selRegNumber + "%')";
			  }
			  if((!selOutNumber.equals("")) && (selOutNumber != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.OUT_NUMBER LIKE '%" + selOutNumber + "%'";
			  }
			  if((!selDocType.equals("Все")) && (!selDocType.equals("")) && (selDocType != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.DOCTYPE_ID = (SELECT ID FROM DOC_DOCTYPES WHERE DOCTYPE = '" + selDocType + "')";
			  }
			  if((!selAuthor.equals("Все")) && (!selAuthor.equals("")) && (selAuthor != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.AUTHOR_ID = (SELECT ID FROM DOC_AUTHORS WHERE AUTHOR = '" + selAuthor + "')";
			  }
			  if((!selProduct.equals("Все")) && (!selProduct.equals("")) && (selProduct != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.PRODUCT_ID = (SELECT ID FROM DOC_PRODUCTS WHERE PRODUCT = '" + selProduct + "')";
			  }
			  if((!selId_Dep.equals(""))){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql+=" DOC_ALLDOCS.ID_DEP="+selId_Dep;
			  }
			  sql += " GROUP BY DOC_ALLDOCS.id ";
			  sql += ")";
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs = oStmt.executeQuery(sql);
		oRs.next();
		int i=oRs.getInt(1);
		return i;
	}
	
	
	 /**	
	 * МЕТОД  МЕТОД  получить количество сообщений по отделу Пользователя (который вошел)
	 * @throws SQLException 
	 * 
	 */
	public int countAllForDepartment(String SessionUser, String selOutNumber, String selDocType, String selDescriptionText, String selRegNumber,
			  String selAuthor, String selProduct, String selId_Dep) throws Exception{
			  boolean Where_Label = false;

			  
			  String sql ="select count(*) from ";
			  sql += "(SELECT distinct DOC_ALLDOCS.id";
			  sql += " FROM ";
			  sql += " PROEUSER.DOC_ALLDOCS ";
			  sql += " LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID";
			  sql += " LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID";  
			  sql += " LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID";
			  sql += " LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID ";
			  sql += " LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID";
			  sql += " LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID"; 
			  sql += " LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID"; 
			  sql += " LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID";
			  sql += " LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID";
			  if((!SessionUser.equals("")) && (SessionUser != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM USERS WHERE LOGIN=UPPER('" + SessionUser + "'))";
				  sql += " ) ";
			  }		
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs = oStmt.executeQuery(sql);
		oRs.next();
		int i=oRs.getInt(1);
		return i;
	}
	
	
	 /**	
		 * МЕТОД  получить количество сообщений по отделу Пользователя (который вошел)
		 * @throws SQLException 
		 * 
		 */
		public int countAllForDepartmentDate(String SessionUser, String selOutNumber, String selDocType, String selDescriptionText, String selRegNumber,
				  String selAuthor, String selProduct, String selId_Dep,String date) throws Exception{
				  boolean Where_Label = false;

				  
				  String sql ="select count(*) from ";
				  sql += "(SELECT  DOC_ALLDOCS.id";
				  sql += " FROM ";
				  sql += " PROEUSER.DOC_ALLDOCS ";
				  sql += " LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID";
				  sql += " LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID";  
				  sql += " LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID";
				  sql += " LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID ";
				  sql += " LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID";
				  sql += " LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID"; 
				  sql += " LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID"; 
				  sql += " LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID";
				  sql += " LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID";
				  if((!SessionUser.equals("")) && (SessionUser != null)){
					  if(Where_Label == true){
						  sql += " AND ";  
					  }
					  if(Where_Label == false){
						  sql += " WHERE ";
						  Where_Label = true;
					  }
					  sql += " DOC_ALLDOCS.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM USERS WHERE LOGIN=UPPER('" + SessionUser + "'))";
				  }
				  if((!selDescriptionText.equals("")) && (selDescriptionText != null)){
					  if(Where_Label == true){
						  sql += " AND ";  
					  }
					  if(Where_Label == false){
						  sql += " WHERE ";
						  Where_Label = true;
					  }
					  sql += " UPPER(DOC_ALLDOCS.DESCRIPTION) LIKE UPPER('%" + selDescriptionText + "%')";
				  }
				  if((!selRegNumber.equals("")) && (selRegNumber != null)){
					  if(Where_Label == true){
						  sql += " AND ";  
					  }
					  if(Where_Label == false){
						  sql += " WHERE ";
						  Where_Label = true;
					  }
					  sql += " UPPER(DOC_ALLDOCS.REG_NUMBER) LIKE UPPER('%" + selRegNumber + "%')";
				  }
				  if((!selOutNumber.equals("")) && (selOutNumber != null)){
					  if(Where_Label == true){
						  sql += " AND ";  
					  }
					  if(Where_Label == false){
						  sql += " WHERE ";
						  Where_Label = true;
					  }
					  sql += " DOC_ALLDOCS.OUT_NUMBER LIKE '%" + selOutNumber + "%'";
				  }
				  if((!selDocType.equals("Все")) && (!selDocType.equals("")) && (selDocType != null)){
					  if(Where_Label == true){
						  sql += " AND ";  
					  }
					  if(Where_Label == false){
						  sql += " WHERE ";
						  Where_Label = true;
					  }
					  sql += " DOC_ALLDOCS.DOCTYPE_ID = (SELECT ID FROM DOC_DOCTYPES WHERE DOCTYPE = '" + selDocType + "')";
				  }
				  if((!selAuthor.equals("Все")) && (!selAuthor.equals("")) && (selAuthor != null)){
					  if(Where_Label == true){
						  sql += " AND ";  
					  }
					  if(Where_Label == false){
						  sql += " WHERE ";
						  Where_Label = true;
					  }
					  sql += " DOC_ALLDOCS.AUTHOR_ID = (SELECT ID FROM DOC_AUTHORS WHERE AUTHOR = '" + selAuthor + "')";
				  }
				  if((!selProduct.equals("Все")) && (!selProduct.equals("")) && (selProduct != null)){
					  if(Where_Label == true){
						  sql += " AND ";  
					  }
					  if(Where_Label == false){
						  sql += " WHERE ";
						  Where_Label = true;
					  }
					  sql += " DOC_ALLDOCS.PRODUCT_ID = (SELECT ID FROM DOC_PRODUCTS WHERE PRODUCT = '" + selProduct + "')";
				  }
				  if((!selId_Dep.equals(""))){
					  if(Where_Label == true){
						  sql += " AND ";  
					  }
					  if(Where_Label == false){
						  sql += " WHERE ";
						  Where_Label = true;
					  }
					  sql+=" DOC_ALLDOCS.ID_DEP="+selId_Dep;
				  }
				  
				  
				  
				  sql +=" and  DOC_ALLDOCS.REG_DATE>'"+date+"'";
				  
				  sql += " GROUP BY DOC_ALLDOCS.id ";
				  sql += ")";
				
			oStmt.setQueryTimeout(iQUERY_TIMEOUT);
			oRs = oStmt.executeQuery(sql);
			oRs.next();
			int i=oRs.getInt(1);
			return i;
		}
	
	
	
	
	
	 /**
	  * МЕТОД получить всю документацию
	  * @param № п/п от
	  * @param № п/п до
	  * @param Вид документа
	  * @param Содержащий текст
	  * @param № регистр. от
	  * @param № регистр. до
	  * @param Отправитель
	  * @param Машина
	  * @return отсуствуют
	  * @since 0.0.0.1
	  */
	public void GetAllDocsForPaging(String selOutNumber, String selDocType, String selDescriptionText, String selRegNumber,
		  String selAuthor, String selProduct, String SessionUser,String selId_Dep,           String countItemInpage, String startPaging, String endPaging) throws Exception{
		  boolean Where_Label = false;
		  String 
		  sql  ="select * from";		  
		  sql += "(SELECT ";
		  sql += " DOC_ALLDOCS.ID, ";
		  sql += " DOC_ALLDOCS.ID_DEP, ";
		  sql += " DOC_PRODUCTS.PRODUCT,  ";
		  sql += " DOC_AUTHORS.AUTHOR,  ";
		  sql += " DOC_ALLDOCS.REG_NUMBER,  ";
		  sql += " DOC_ALLDOCS.OUT_NUMBER,  ";
		  sql += " DOC_DOCTYPES.DOCTYPE,  ";
		  sql += " DOC_ALLDOCS.DESCRIPTION,  ";
		  sql += " DOC_ALLDOCS.NOTE, ";
		  sql += " DOC_ALLDOCS.CONTROL_STATUS, ";
		  sql += " USERS.FULLNAME,  ";
		  sql += " DOC_STATUS.STATUS,  ";
		  sql += " DOC_STATUS.ID AS STATUS_ID,  ";
		  sql += " DOC_EXECUTERS.EXECUTE,  ";
		  sql += " DOC_EXECUTERS.DATE_OF_READ,  ";
		  sql += " DOC_ALLDOCS.REG_DATE,  ";
		  sql += " DEPARTMENT.DEPARTMENT, ";
		  sql += " DOC_FILES.ID AS FILE_ID ";
		  sql += " FROM ";
		  sql += " PROEUSER.DOC_ALLDOCS ";
		  sql += " LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID";
		  sql += " LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID";  
		  sql += " LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID";
		  sql += " LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID ";
		  sql += " LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID";
		  sql += " LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID"; 
		  sql += " LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID"; 
		  sql += " LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID";
		  sql += " LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID";
		  if((!SessionUser.equals("")) && (SessionUser != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM USERS WHERE LOGIN=UPPER('" + SessionUser + "'))";
		  }
		  if((!selDescriptionText.equals("")) && (selDescriptionText != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " UPPER(DOC_ALLDOCS.DESCRIPTION) LIKE UPPER('%" + selDescriptionText + "%')";
		  }
		  if((!selRegNumber.equals("")) && (selRegNumber != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " UPPER(DOC_ALLDOCS.REG_NUMBER) LIKE UPPER('%" + selRegNumber + "%')";
		  }
		  if((!selOutNumber.equals("")) && (selOutNumber != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.OUT_NUMBER LIKE '%" + selOutNumber + "%'";
		  }
		  if((!selDocType.equals("Все")) && (!selDocType.equals("")) && (selDocType != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.DOCTYPE_ID = (SELECT ID FROM DOC_DOCTYPES WHERE DOCTYPE = '" + selDocType + "')";
		  }
		  if((!selAuthor.equals("Все")) && (!selAuthor.equals("")) && (selAuthor != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.AUTHOR_ID = (SELECT ID FROM DOC_AUTHORS WHERE AUTHOR = '" + selAuthor + "')";
		  }
		  if((!selProduct.equals("Все")) && (!selProduct.equals("")) && (selProduct != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.PRODUCT_ID = (SELECT ID FROM DOC_PRODUCTS WHERE PRODUCT = '" + selProduct + "')";
		  }
		  if((!selId_Dep.equals(""))){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql+=" DOC_ALLDOCS.ID_DEP="+selId_Dep;
		  }
		  
		  
		  
		 // sql += " GROUP BY DOC_ALLDOCS.id ";
		  sql += " ORDER BY DOC_ALLDOCS.ID_DEP DESC";		  
		  sql += ") ";
		  
		 if(startPaging.equals("")||endPaging.equals(""))
		 {
			 sql += " where  rownum<=500 ";			 
		 }else{
			 sql += " where  id_dep>="+startPaging+" and  id_dep<="+endPaging+" ";
		 }	  
		  
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		 }
	
	
	
	 /**
	  * МЕТОД получить всю документацию
	  * @param № п/п от
	  * @param № п/п до
	  * @param Вид документа
	  * @param Содержащий текст
	  * @param № регистр. от
	  * @param № регистр. до
	  * @param Отправитель
	  * @param Машина
	  * @return отсуствуют
	  * @since 0.0.0.1
	  */
	public void GetAllDocs(String selOutNumber, String selDocType, String selDescriptionText, String selRegNumber,
		  String selAuthor, String selProduct, String SessionUser,String selId_Dep, 
          String countItemInpage, String startPaging, String endPaging, String dateInterval1,String dateInterval2, String selByISPFamily,
          String selOnControler) 
    throws Exception{
		  boolean Where_Label = false;		  
		  String 
		  sql = " select * from " +
		  		" (SELECT DOC_ALLDOCS.ID, " +
		  		" 		  DOC_ALLDOCS.ID_DEP, " +
		  		" 		  DOC_PRODUCTS.PRODUCT, " +
		  		" 		  DOC_AUTHORS.AUTHOR, " +
		  		" 		  DOC_ALLDOCS.REG_NUMBER, " +
		  		" 		  DOC_ALLDOCS.OUT_NUMBER,  " +
		  		" 		  DOC_DOCTYPES.DOCTYPE, " +
		  		" 		  DOC_ALLDOCS.DESCRIPTION, " +
		  		" 		  DOC_ALLDOCS.NOTE, " +
		  		" 		  DOC_ALLDOCS.CONTROL_STATUS, " +
		  		"  		  USERS.FULLNAME, " +
		  		" 		  DOC_STATUS.STATUS, " +
		  		" 		  DOC_STATUS.ID AS STATUS_ID, " +
		  		"         DOC_EXECUTERS.EXECUTE, " +
		  		"         DOC_EXECUTERS.DATE_OF_READ, " +
		  		"         DOC_ALLDOCS.REG_DATE, " +
		  		"         DEPARTMENT.DEPARTMENT, " +
		  		"         DOC_FILES.ID AS FILE_ID " +
		  		"   FROM " +
		  		"    DOC_ALLDOCS LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID " +
		  		"                LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID " +
		  		"                LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID " +
		  		"                LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID " +
		  		"                LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID " +
		  		"                LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID " +
		  		"                LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID " +
		  		"                LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID " +
		  		"                LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID ";
		  
		  if((!SessionUser.equals("")) && (SessionUser != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.department_id = (SELECT DEPARTMENT_ID FROM USERS WHERE trim(UPPER(LOGIN))=trim(UPPER('" + SessionUser + "'))) ";
		  }
		  
		  if((!selDescriptionText.equals("")) && (selDescriptionText != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " trim(UPPER(DOC_ALLDOCS.DESCRIPTION)) LIKE trim(UPPER('%" + selDescriptionText + "%'))";
		  }
		  
		  if((!selRegNumber.equals("")) && (selRegNumber != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " trim(UPPER(DOC_ALLDOCS.REG_NUMBER)) LIKE trim(UPPER('%" + selRegNumber + "%')) ";
		  }
		  
		  if((!selOutNumber.equals("")) && (selOutNumber != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " trim(UPPER(DOC_ALLDOCS.OUT_NUMBER)) LIKE trim(UPPER('%" + selOutNumber + "%')) ";
		  }		  
		  
		  if((!selDocType.equals("Все")) && (!selDocType.equals("")) && (selDocType != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.DOCTYPE_ID in (SELECT ID FROM DOC_DOCTYPES WHERE trim(UPPER(DOCTYPE)) = trim(UPPER('" + selDocType + "'))) ";
		  }		  
		  
		  if((!selAuthor.equals("Все")) && (!selAuthor.equals("")) && (selAuthor != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.AUTHOR_ID in (SELECT ID FROM DOC_AUTHORS WHERE trim(UPPER(AUTHOR)) like trim(UPPER('%" + selAuthor + "%'))) ";
		  }
		  
		  if((!selProduct.equals("Все")) && (!selProduct.equals("")) && (selProduct != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.PRODUCT_ID in (SELECT ID FROM DOC_PRODUCTS WHERE trim(UPPER(PRODUCT)) like trim(UPPER('%" + selProduct + "%'))) ";
		  }
		  
		  if((!selId_Dep.equals(""))){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql+=" DOC_ALLDOCS.ID_DEP = "+selId_Dep+" ";
		  }		  		  
		 
		  if((!selByISPFamily.equals("Все")) && (!selByISPFamily.equals("")) && (selByISPFamily != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  
			  sql += " trim(UPPER(USERS.fullname)) = trim(UPPER('" + selByISPFamily + "')) ";
		  }	  			  
		  
		  if((!dateInterval1.equals(""))&&(!dateInterval2.equals(""))){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  // + (86399/86400)  добавляет к дате день чтобы выбирались записи 
			  sql += " (DOC_ALLDOCS.REG_DATE BETWEEN to_date('"+dateInterval1+"') and to_date('"+dateInterval2+"') + (86399/86400)) ";
  }
		  
		  if(selOnControler.equals("checked")){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }			  
			  sql += " (CONTROL_STATUS ='Да') ";
		  } 
			  
		  sql += " ORDER BY DOC_ALLDOCS.ID_DEP DESC "
		       + ") ";		  			  

	 // System.out.println(sql);
	  sql=sql.replaceAll("'", "\'");       //чтобы не следить за ковычками в запросе
	  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
	  oRs = oStmt.executeQuery(sql);
	}
	
	
	 /**
	  * МЕТОД получить всю документацию
	  * @param № п/п от
	  * @param № п/п до
	  * @param Вид документа
	  * @param Содержащий текст
	  * @param № регистр. от
	  * @param № регистр. до
	  * @param Отправитель
	  * @param Машина
	  * @return отсуствуют
	  * @since 0.0.0.1
	  */
	public void docOnlyI(String selOutNumber, String selDocType, String selDescriptionText, String selRegNumber,
			  String selAuthor, String selProduct, String SessionUser,String selId_Dep, 
	          String countItemInpage, String startPaging, String endPaging, String dateInterval1,String dateInterval2, String selByISPFamily,
	          String selOnControler) 
	    throws Exception{
			  boolean Where_Label = false;		  
			  String 
			  sql = " select * from " +
			  		" (SELECT DOC_ALLDOCS.ID, " +
			  		" 		  DOC_ALLDOCS.ID_DEP, " +
			  		" 		  DOC_PRODUCTS.PRODUCT, " +
			  		" 		  DOC_AUTHORS.AUTHOR, " +
			  		" 		  DOC_ALLDOCS.REG_NUMBER, " +
			  		" 		  DOC_ALLDOCS.OUT_NUMBER,  " +
			  		" 		  DOC_DOCTYPES.DOCTYPE, " +
			  		" 		  DOC_ALLDOCS.DESCRIPTION, " +
			  		" 		  DOC_ALLDOCS.NOTE, " +
			  		" 		  DOC_ALLDOCS.CONTROL_STATUS, " +
			  		"  		  USERS.FULLNAME, " +
			  		" 		  DOC_STATUS.STATUS, " +
			  		" 		  DOC_STATUS.ID AS STATUS_ID, " +
			  		"         DOC_EXECUTERS.EXECUTE, " +
			  		"         DOC_EXECUTERS.DATE_OF_READ, " +
			  		"         DOC_ALLDOCS.REG_DATE, " +
			  		"         DEPARTMENT.DEPARTMENT, " +
			  		"         DOC_FILES.ID AS FILE_ID " +
			  		"   FROM " +
			  		"    DOC_ALLDOCS LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID " +
			  		"                LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID " +
			  		"                LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID " +
			  		"                LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID " +
			  		"                LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID " +
			  		"                LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID " +
			  		"                LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID " +
			  		"                LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID " +
			  		"                LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID ";
			  
			  if((!SessionUser.equals("")) && (SessionUser != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				//  sql += " DOC_ALLDOCS.department_id = (SELECT DEPARTMENT_ID FROM USERS WHERE trim(UPPER(LOGIN))=trim(UPPER('" + SessionUser + "'))) ";
				  sql += " DOC_ALLDOCS.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM USERS WHERE trim(UPPER(LOGIN)) = trim(UPPER('"+SessionUser+"'))) "+
				  	     " and "+
				         " trim(UPPER(LOGIN)) = trim(UPPER('"+SessionUser+"')) ";
			  }
			  
			  if((!selDescriptionText.equals("")) && (selDescriptionText != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " trim(UPPER(DOC_ALLDOCS.DESCRIPTION)) LIKE trim(UPPER('%" + selDescriptionText + "%'))";
			  }
			  
			  if((!selRegNumber.equals("")) && (selRegNumber != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " trim(UPPER(DOC_ALLDOCS.REG_NUMBER)) LIKE trim(UPPER('%" + selRegNumber + "%')) ";
			  }
			  
			  if((!selOutNumber.equals("")) && (selOutNumber != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " trim(UPPER(DOC_ALLDOCS.OUT_NUMBER)) LIKE trim(UPPER('%" + selOutNumber + "%')) ";
			  }		  
			  
			  if((!selDocType.equals("Все")) && (!selDocType.equals("")) && (selDocType != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.DOCTYPE_ID in (SELECT ID FROM DOC_DOCTYPES WHERE trim(UPPER(DOCTYPE)) = trim(UPPER('" + selDocType + "'))) ";
			  }		  
			  
			  if((!selAuthor.equals("Все")) && (!selAuthor.equals("")) && (selAuthor != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.AUTHOR_ID in (SELECT ID FROM DOC_AUTHORS WHERE trim(UPPER(AUTHOR)) like trim(UPPER('%" + selAuthor + "%'))) ";
			  }
			  
			  if((!selProduct.equals("Все")) && (!selProduct.equals("")) && (selProduct != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql += " DOC_ALLDOCS.PRODUCT_ID in (SELECT ID FROM DOC_PRODUCTS WHERE trim(UPPER(PRODUCT)) like trim(UPPER('%" + selProduct + "%'))) ";
			  }
			  
			  if((!selId_Dep.equals(""))){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  sql+=" DOC_ALLDOCS.ID_DEP = "+selId_Dep+" ";
			  }		  		  
			 
			  if((!selByISPFamily.equals("Все")) && (!selByISPFamily.equals("")) && (selByISPFamily != null)){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  
				  sql += " trim(UPPER(USERS.fullname)) = trim(UPPER('" + selByISPFamily + "')) ";
			  }	  			  
			  
			  if((!dateInterval1.equals(""))&&(!dateInterval2.equals(""))){
				  if(Where_Label == true){
					  sql += " AND ";  
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }
				  
				  sql += " (DOC_ALLDOCS.REG_DATE BETWEEN to_date('"+dateInterval1+"') and to_date('"+dateInterval2+"') + (86399/86400)) ";
			  }	  		  
			  
			  if(selOnControler.equals("checked")){
				  if(Where_Label == true){
					  sql += " AND ";   
				  }
				  if(Where_Label == false){
					  sql += " WHERE ";
					  Where_Label = true;
				  }			  
				  sql += " (CONTROL_STATUS ='Да') ";
			  }
			  
			  sql += " ORDER BY DOC_ALLDOCS.ID_DEP DESC "
			       + ") ";		  			  

		  //System.out.println(sql);
		  sql=sql.replaceAll("'", "\'");       //чтобы не следить за ковычками в запросе
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	
	
	/**
	 * @throws SQLException 
	 * 
	 * 
	 * 
	 */
	public int maxNomDocInDep(String SessionUser) throws SQLException{
		
		String  sql="(SELECT  ";
			  	sql +="max(id_dep) ";
			  	sql +="from  ";
			  	sql +="(SELECT ";
			  	sql +="DOC_ALLDOCS.ID_DEP ";
			  	sql +="FROM  ";
			  	sql +="PROEUSER.DOC_ALLDOCS ";
			  	sql +="LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID ";
			  	sql +="LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID  ";
			  	sql +="LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID ";
			  	sql +="LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID ";
			  	sql +="LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID  ";
			  	sql +="LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID  ";
			  	sql +="LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID ";
			  	sql +="LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID ";
			  	sql +="LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID ";
			  	sql +="where ";
			  	sql +="DOC_ALLDOCS.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM USERS WHERE LOGIN=UPPER('"+SessionUser+"')) "; 
				sql +="order by id_dep asc ";
			  	sql +=") ";      

		
    	  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		  oRs.next();
			
			int i=oRs.getInt(1);
			return i;
	}
	
	
	
	
	 /**
	  * МЕТОД получить выбранную документацию
	  * @param № п/п от
	  * @param № п/п до
	  * @param Вид документа
	  * @param Содержащий текст
	  * @param № регистр. от
	  * @param № регистр. до
	  * @param Отправитель
	  * @param Машина
	  * @param Логин
	  * @param Код статуса
	  * @return отсуствуют
	  * @since 0.0.0.1
	  */
	public void GetSelectedDocs(String selOutNumber, String selDocType, String selDescriptionText, String selRegNumber,
		  String selAuthor, String selProduct, String Login, String Status, String DEPARTMENT_ABB) throws Exception{
		  boolean Where_Label = false;
		  String sql = "SELECT * FROM (SELECT";
		  sql += " DISTINCT DOC_ALLDOCS.ID, ";
		  sql += " DOC_PRODUCTS.PRODUCT,  ";
		  sql += " DOC_AUTHORS.AUTHOR,  ";
		  sql += " DOC_ALLDOCS.REG_NUMBER,  ";
		  sql += " DOC_ALLDOCS.OUT_NUMBER,  ";
		  sql += " DOC_DOCTYPES.DOCTYPE,  ";
		  sql += " DOC_ALLDOCS.DESCRIPTION,  ";
		  sql += " DOC_ALLDOCS.NOTE, ";
		  sql += " DOC_ALLDOCS.CONTROL_STATUS ";
		  sql += " FROM ";
		  sql += " PROEUSER.DOC_ALLDOCS ";
		  sql += " LEFT JOIN DOC_AUTHORS ON DOC_ALLDOCS.AUTHOR_ID = DOC_AUTHORS.ID";
		  sql += " LEFT JOIN DOC_PRODUCTS ON DOC_ALLDOCS.PRODUCT_ID = DOC_PRODUCTS.ID";  
		  sql += " LEFT JOIN DOC_DOCTYPES ON DOC_ALLDOCS.DOCTYPE_ID = DOC_DOCTYPES.ID";
		  sql += " LEFT JOIN DOC_EXECUTERS ON DOC_EXECUTERS.DOC_ID = DOC_ALLDOCS.ID ";
		  sql += " LEFT JOIN USERS ON DOC_EXECUTERS.EXECUTER_ID = USERS.ID";
		  sql += " LEFT JOIN DOC_STATUS ON DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID"; 
		  sql += " LEFT JOIN DOC_COPY_TO_DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DOC_ID = DOC_ALLDOCS.ID"; 
		  sql += " LEFT JOIN DEPARTMENT ON DOC_COPY_TO_DEPARTMENT.DEPARTMENT_ID = DEPARTMENT.ID";
		  sql += " LEFT JOIN DOC_FILES ON DOC_FILES.DOC_ID = DOC_ALLDOCS.ID";
		  if((!selDescriptionText.equals("")) && (selDescriptionText != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " UPPER(DOC_ALLDOCS.DESCRIPTION) LIKE UPPER('%" + selDescriptionText + "%')";
		  }
		  if((!selRegNumber.equals("")) && (selRegNumber != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " UPPER(DOC_ALLDOCS.REG_NUMBER) LIKE UPPER('%" + selRegNumber + "%')";
		  }
		  if((!selOutNumber.equals("")) && (selOutNumber != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.OUT_NUMBER LIKE '%" + selOutNumber + "%'";
		  }
		  if((!selDocType.equals("Все")) && (!selDocType.equals("")) && (selDocType != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.DOCTYPE_ID = (SELECT ID FROM DOC_DOCTYPES WHERE DOCTYPE = '" + selDocType + "')";
		  }
		  if((!selAuthor.equals("Все")) && (!selAuthor.equals("")) && (selAuthor != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.AUTHOR_ID = (SELECT ID FROM DOC_AUTHORS WHERE AUTHOR = '" + selAuthor + "')";
		  }
		  if((!selProduct.equals("Все")) && (!selProduct.equals("")) && (selProduct != null)){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.PRODUCT_ID = (SELECT ID FROM DOC_PRODUCTS WHERE PRODUCT = '" + selProduct + "')";
		  }
		  if(!Login.equals("")){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " USERS.LOGIN = '" + Login + "'";
		  }
		  if(!Status.equals("")){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_STATUS.ID = " + Status;
			  switch(Integer.parseInt(Status)){
			  	case(3): sql+=" AND DOC_STATUS.ID <> 2 AND DOC_STATUS.ID <> 1";
			  			break;
			  	case(2): sql+=" AND DOC_STATUS.ID <> 3 AND DOC_STATUS.ID <> 4";
			  }
		  }
		  if(!DEPARTMENT_ABB.equals("")){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_ALLDOCS.DEPARTMENT_ID=(SELECT ID FROM DEPARTMENT WHERE DEPARTMENT.DEPARTMENT_ABB='" + DEPARTMENT_ABB + "') ";
		  }
		  sql += " ORDER BY DOC_ALLDOCS.ID DESC) WHERE ROWNUM<=100";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              получить все отделы
	  * @param             отсуствуют
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetMetadataForDocID (String ID) throws Exception{
		  String sql = " SELECT ";
		  sql += "   USERS.FULLNAME, ";
		  sql += "   DOC_STATUS.ID AS STATUS_ID";
		  sql += " FROM";
		  sql += "   DOC_EXECUTERS, ";
		  sql += "   DOC_STATUS,";
		  sql += "   USERS";
		  sql += " WHERE";
		  sql += "   DOC_EXECUTERS.STATUS_ID = DOC_STATUS.ID  AND ";
		  sql += "   DOC_EXECUTERS.EXECUTER_ID = USERS.ID AND";
		  sql += "   DOC_EXECUTERS.DOC_ID = " + ID;
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              получить свободный идентификатор для докумнета
	  * @param             пользователь
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetFreeIDForDocument (String SessionUser) throws Exception{
		  String sql = "SELECT MAX(ID_DEP) + 1 AS FREE_ID FROM DOC_ALLDOCS WHERE DEPARTMENT_ID=(SELECT DEPARTMENT_ID FROM USERS WHERE LOGIN=UPPER('" + SessionUser + "'))";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              
	  * @param             
	  * @return            
	  * @since             0.0.0.1
	  */
	public void GetFreeIDForDocumentAllDep (String SessionUser) throws Exception{
		  String sql = "SELECT MAX(ID) + 1 AS FREE_ID FROM DOC_ALLDOCS";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              получить количество документов пользователя
	  * @param             логин
	  * @return            количество
	  * @since             0.0.0.1
	  */
	public int GetUserDocCount (String Login, String Status, String DEPARTMENT_ABB) throws Exception{
		  boolean Where_Label=false;
		  String sql = "SELECT COUNT(DISTINCT DOC_ID) AS KOL FROM DOC_EXECUTERS ";
		  sql += " INNER JOIN USERS ON USERS.ID = DOC_EXECUTERS.EXECUTER_ID ";
		  if(!Login.equals("")){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_EXECUTERS.EXECUTER_ID = (SELECT ID FROM USERS WHERE USERS.LOGIN='" + Login + "')";
		  }
		  if(!Status.equals("")){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " DOC_EXECUTERS.STATUS_ID = " + Status;
			  switch(Integer.parseInt(Status)){
			  	case(3): sql+=" AND DOC_EXECUTERS.STATUS_ID <> 2 AND DOC_EXECUTERS.STATUS_ID <> 1";
			  			break;
			  	case(2): sql+=" AND DOC_EXECUTERS.STATUS_ID <> 3 AND DOC_EXECUTERS.STATUS_ID <> 4";
			  }
		  }
		  if(!DEPARTMENT_ABB.equals("")){
			  if(Where_Label == true){
				  sql += " AND ";  
			  }
			  if(Where_Label == false){
				  sql += " WHERE ";
				  Where_Label = true;
			  }
			  sql += " USERS.DEPARTMENT_ID=(SELECT ID FROM DEPARTMENT WHERE DEPARTMENT.DEPARTMENT_ABB='" + DEPARTMENT_ABB + "') ";
		  }
		  //Выполняем запрос
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		  if(oRs.next()) return oRs.getInt("KOL");
		  else return 0;
		}
	
	 /**
	  * МЕТОД              получить все изделия
	  * @param             отсуствуют
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetAllProduct (String sPartOfProduct) throws Exception{
		  String //sql = "SELECT DISTINCT trim(PRODUCT) PRODUCT FROM DOC_PRODUCTS WHERE trim(UPPER(PRODUCT)) LIKE trim(Upper('%" + sPartOfProduct.toUpperCase().trim().replaceAll("  ", " ")+ "%'))   ORDER BY PRODUCT";
		  sql="SELECT distinct trim(regexp_replace(PRODUCT,\'([ ][ ])*\',\'\')) PRODUCT FROM DOC_PRODUCTS where trim(UPPER(PRODUCT))  LIKE trim(Upper(\'%" + sPartOfProduct.toUpperCase().replaceAll("  ", " ").trim() + "%\'))   ORDER BY PRODUCT";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              получить всех отправителей
	  * @param             отсуствуют
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetAllOwner (String sPartOfOwner) throws Exception{
		String// sql = "SELECT distinct trim(AUTHOR) AUTHOR FROM DOC_AUTHORS WHERE  trim(UPPER(AUTHOR)) LIKE trim(Upper('%" + sPartOfOwner.toUpperCase().trim().replaceAll("  ", " ")+ "%'))  ORDER BY AUTHOR";
		sql = "SELECT distinct trim(regexp_replace(AUTHOR,\'([ ][ ])*\',\'\')) AUTHOR   FROM DOC_AUTHORS where trim(UPPER(AUTHOR))  LIKE trim(Upper(\'%" + sPartOfOwner.toUpperCase().replaceAll("  ", " ").trim() + "%\'))  ORDER BY AUTHOR";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              получить всех типы документов
	  * @param             отсуствуют
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void GetAllDocType (String sPartOfDocType) throws Exception{
		String //sql = "SELECT distinct trim(DOCTYPE) DOCTYPE FROM DOC_DOCTYPES WHERE  trim(UPPER(DOCTYPE)) LIKE trim(Upper('%" + sPartOfDocType.toUpperCase().trim().replaceAll("  ", " ") + "%'))  ORDER BY DOCTYPE";
		sql="SELECT distinct trim(regexp_replace(DOCTYPE,\'([ ][ ])*\',\'\')) DOCTYPE  FROM doc_doctypes where trim(UPPER(DOCTYPE))  LIKE trim(Upper(\'%" + sPartOfDocType.toUpperCase().replaceAll("  ", " ").trim() + "%\'))  ORDER BY DOCTYPE";
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		}
	
	 /**
	  * МЕТОД              проверить и при необходимости добавить автора
	  * @param             автор
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void CheckAndAddAuthor (String addOwner) throws Exception{
		  //объявление переменных
		  boolean result = false;
		  boolean error = false;
		  String SQL_INSERT = "";
		  String sql = "SELECT AUTHOR FROM DOC_AUTHORS WHERE UPPER(AUTHOR) = '" + addOwner.toUpperCase() + "'";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		  while(oRs.next()){
				if(oRs.getString("AUTHOR") != null)
					result = true;
		  }
		  if(result == false){
			  //в базе не найдено такого отправителя, надо его добавить
			  SQL_INSERT = "INSERT INTO DOC_AUTHORS (ID,AUTHOR) VALUES ((SELECT MAX(ID)+1 FROM DOC_AUTHORS),'" + addOwner + "')";
			  try {
				  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
				  oStmt.executeUpdate(SQL_INSERT);
			  }
			  catch (Exception e){  
				   error=true;
			  }
			  if (error == false)
				  oOC.getCon().commit();
			  else
				  oOC.getCon().rollback();
		  }
		}
	
	 /**
	  * МЕТОД              проверить и при необходимости добавить изделие
	  * @param             изделие
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void CheckAndAddProduct (String addProduct) throws Exception{
		  //объявление переменных
		  boolean result = false;
		  boolean error = false;
		  String SQL_INSERT = "";
		  String sql = "SELECT PRODUCT FROM DOC_PRODUCTS WHERE UPPER(PRODUCT) = '" + addProduct.toUpperCase() + "'";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		  while(oRs.next()){
				if(oRs.getString("PRODUCT") != null)
					result = true;
		  }
		  if(result == false){
			  //в базе не найдено такого отправителя, надо его добавить
			  SQL_INSERT = "INSERT INTO DOC_PRODUCTS (ID,PRODUCT) VALUES ((SELECT MAX(ID)+1 FROM DOC_PRODUCTS),'" + addProduct + "')";
			  try {
				  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
				  oStmt.executeUpdate(SQL_INSERT);
			  }
			  catch (Exception e){  
				   error=true;
			  }
			  if (error == false)
				  oOC.getCon().commit();
			  else
				  oOC.getCon().rollback();
		  }
		}
	
	 /**
	  * МЕТОД              проверить и при необходимости добавить тип документа
	  * @param             тип документа
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void CheckAndAddDocType (String addDocType) throws Exception{
		  //объявление переменных
		  boolean result = false;
		  boolean error = false;
		  String SQL_INSERT = "";
		  String sql = "SELECT DOCTYPE FROM DOC_DOCTYPES WHERE UPPER(DOCTYPE) = '" + addDocType.toUpperCase() + "'";
		  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		  oRs = oStmt.executeQuery(sql);
		  while(oRs.next()){
				if(oRs.getString("DOCTYPE") != null)
					result = true;
		  }
		  if(result == false){
			  //в базе не найдено такого отправителя, надо его добавить
			  SQL_INSERT = "INSERT INTO DOC_DOCTYPES (ID,DOCTYPE) VALUES ((SELECT MAX(ID)+1 FROM DOC_DOCTYPES),'" + addDocType + "')";
			  try {
				  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
				  oStmt.executeUpdate(SQL_INSERT);
			  }
			  catch (Exception e){  
				   error=true;
			  }
			  if (error == false)
				  oOC.getCon().commit();
			  else
				  oOC.getCon().rollback();
		  }
		}

	 /**
	  * МЕТОД считать изображение для документа
	  * @param номер документа
	  * @return массив байтов
	  * @since 0.0.0.1
	  */
	public byte[] GetImageForDocument (String DOC_ID) throws Exception{
		Blob img ;
	    byte[] imgData = null ;
		String sql = "SELECT FILEDATA FROM DOC_FILES WHERE DOC_ID = " + DOC_ID;
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs = oStmt.executeQuery(sql);
		while (oRs.next ())
	    {    
	      img = oRs.getBlob(1);
	      imgData = img.getBytes(1,(int)img.length());
	    }   
		oRs.close();
		oStmt.close();
		return imgData ;
		}
	
	 /**
	  * МЕТОД сохранить файл в БД
	  * @param путь и имя файла
	  * @return
	  * @since 0.0.0.1
	  */
	public void SaveImageToDatabase (String DOC_ID, String FileName) throws Exception{
		FileInputStream fis = null;
	    PreparedStatement ps = null;
		File file = new File(FileName);
	    fis = new FileInputStream(file);
		String sql = "INSERT INTO DOC_FILES (ID,DOC_ID,FILEDATA) VALUES ((SELECT MAX(ID)+1 FROM DOC_FILES)," + DOC_ID +",?)";
		ps = oOC.getCon().prepareStatement(sql);
		ps.setBinaryStream(1, fis, (int) file.length());
		ps.executeUpdate();
		oOC.getCon().commit();
		ps.close();
	    fis.close();

		}
	
	 /**
	  * МЕТОД записать в базу документацию
	  * @param № п/п
	  * @param Машина
	  * @param Отправитель
	  * @param № регистр.
	  * @param № исход.
	  * @param Вид документа
	  * @param Краткое содержание
	  * @param массив пользователей
	  * @param массив статусов пользователей
	  * @param массив выполнения пользователями
	  * @param массив отделов
	  * @param количество пользователей
	  * @param количество отделов
	  * @return отсуствуют
	  * @since 0.0.0.1
	  */
	public boolean AddDocument(String addNumber,String addProduct,String addOwner,String addRegNumber,String addOutNumber,String addDocType,String addDescription,
			String addNote,String addControlStatus,String addDatafile,
			ArrayList<String> lUsers,
			ArrayList<String> lUsersStatus,
			ArrayList<String> lUsersExecute,
			ArrayList<String> lDepartment,
			ArrayList<String> lDateOfRead,
			int iUsersCount,
			int iDepartmentCount,
			String SessionUser, String DEPARTMENT_ABB) throws Exception{
		addOwner = addOwner.replaceAll("''", "\"");
		String iRegID = "";
		GetFreeIDForDocumentAllDep(SessionUser);
		while(oRs.next()){
			iRegID = oRs.getString("FREE_ID");
		 	if(iRegID == null) iRegID = "1";
		 }
		//объявляем переменные запросов
		String INSERT_ALLDOCS = "";
		String INSERT_EXECUTER = "";
		String INSERT_DEPARTMENT = "";
		//переменные идентификаторов
		String STATUS_ID = "";
		int i = 0;
		boolean error = false;
		if(addProduct == null)return false; //есдли не задан продукт то ошибка 
		//проверяем нужно ли добавлять записи в справочники и при необходимости добавляем
		CheckAndAddAuthor(addOwner);
		CheckAndAddProduct(addProduct);
		CheckAndAddDocType(addDocType);
		//формируем запросы для пользователей
		try {
			oStmt.setQueryTimeout(iQUERY_TIMEOUT);
			INSERT_ALLDOCS = "INSERT INTO DOC_ALLDOCS (ID,ID_DEP,PRODUCT_ID,AUTHOR_ID,REG_NUMBER,OUT_NUMBER,DOCTYPE_ID,DESCRIPTION,REG_DATE,NOTE,CONTROL_STATUS,SESSION_USER,DEPARTMENT_ID,STATUS_ID) VALUES (";
			INSERT_ALLDOCS += iRegID + ",";
			INSERT_ALLDOCS += addNumber + ",";
			INSERT_ALLDOCS += "(SELECT ID FROM DOC_PRODUCTS WHERE trim(UPPER(PRODUCT)) = trim(UPPER(\'" + addProduct + "\')) and rownum=1),";
			INSERT_ALLDOCS += "(SELECT ID FROM DOC_AUTHORS  WHERE trim(UPPER(AUTHOR))  = trim(UPPER(\'" + addOwner   + "\')) and rownum=1),\'";
			INSERT_ALLDOCS += addRegNumber + "\',\'";
			INSERT_ALLDOCS += addOutNumber + "\',";
			INSERT_ALLDOCS += "(SELECT ID FROM DOC_DOCTYPES WHERE trim(Upper(DOCTYPE)) = trim(Upper(\'" + addDocType  +"\')) and rownum=1),\'";
			INSERT_ALLDOCS += addDescription + "\',SYSDATE,\'";
			INSERT_ALLDOCS += addNote + "\',\'";
			INSERT_ALLDOCS += addControlStatus + "\',\'" + SessionUser + "\',";
			INSERT_ALLDOCS += "(SELECT ID FROM DEPARTMENT   WHERE trim(Upper(DEPARTMENT.DEPARTMENT_ABB))=trim(Upper(\'" + DEPARTMENT_ABB + "\')) and rownum=1)";
			INSERT_ALLDOCS += ",1)";
			
			
			oStmt.executeUpdate(INSERT_ALLDOCS);
			for(i=0;i<iUsersCount;i++){
				//для списков с фиксированными значениями берем ID
				if(lUsersStatus.get(i).equals("ожидает")) STATUS_ID = "1";
				if(lUsersStatus.get(i).equals("ознакамливается")) STATUS_ID = "2";
				if(lUsersStatus.get(i).equals("ознакомлен")) STATUS_ID = "3";
				if(lUsersStatus.get(i).equals("хранение")) STATUS_ID = "4";
				INSERT_EXECUTER = "INSERT INTO DOC_EXECUTERS (ID,EXECUTER_ID,STATUS_ID,EXECUTE,DOC_ID,DATE_OF_READ) VALUES (";
				INSERT_EXECUTER += "(SELECT MAX(ID)+1 FROM DOC_EXECUTERS),";
				INSERT_EXECUTER += "(SELECT ID FROM USERS WHERE trim(Upper(FULLNAME)) = trim(Upper(\'" + lUsers.get(i) +"\')) and rownum=1),";
				INSERT_EXECUTER += STATUS_ID + ",\'";
				INSERT_EXECUTER += lUsersExecute.get(i) + "\',";
				INSERT_EXECUTER += iRegID + ",\'";
				INSERT_EXECUTER += lDateOfRead.get(i) + "\')";
				oStmt.executeUpdate(INSERT_EXECUTER);
			}
			//формируем запросы для отделов
			for(i=0;i<iDepartmentCount;i++){
				INSERT_DEPARTMENT = "INSERT INTO DOC_COPY_TO_DEPARTMENT (ID,DEPARTMENT_ID,DOC_ID) VALUES (";
				INSERT_DEPARTMENT += "(SELECT MAX(ID)+1 FROM DOC_COPY_TO_DEPARTMENT),";
				INSERT_DEPARTMENT += "(SELECT ID FROM DEPARTMENT WHERE trim(Upper(DEPARTMENT)) = trim(Upper(\'" + lDepartment.get(i) + "\')) and rownum=1),";
				INSERT_DEPARTMENT += iRegID + ")";
				oStmt.executeUpdate(INSERT_DEPARTMENT);		
			}
		}
		catch (Exception e){  
		  error=true;
		}
		if (error == false)
		  oOC.getCon().commit();
		else
		  oOC.getCon().rollback();
		//если выбран какой-то файл и небыло ошибок то записываем этот файл
		try {
			if(!addDatafile.equals(""))
				if(error == false) SaveImageToDatabase(iRegID,addDatafile);
		}
		catch (Exception e){ 
		  error=true;
		}
		return error;
	}
	
	 /**
	  * МЕТОД редактирование документации в базе
	  * @param № п/п
	  * @param Машина
	  * @param Отправитель
	  * @param № регистр.
	  * @param № исход.
	  * @param Вид документа
	  * @param Краткое содержание
	  * @param массив пользователей
	  * @param массив статусов пользователей
	  * @param массив выполнения пользователями
	  * @param массив отделов
	  * @param количество пользователей
	  * @param количество отделов
	  * @return отсуствуют
	  * @since 0.0.0.1
	  */
	public boolean EditDocument(String editNumber,String editProduct,String editOwner,String editRegNumber,String editOutNumber,String editDocType,String editDescription,
			String editNote,String editControlStatus,String editDatafile,
			ArrayList<String> lUsers,
			ArrayList<String> lUsersStatus,
			ArrayList<String> lUsersExecute,
			ArrayList<String> lDepartment,
			ArrayList<String> lDateOfRead,
			int iUsersCount,
			int iDepartmentCount,
			int iCurrentUsersCount,
			int iCurrentDepartmentCount) throws Exception{
		editOwner = editOwner.replaceAll("''", "\"");
		//объявляем переменные запросов
		String SQL_UPDATE = "";
		String INSERT_EXECUTER = "";
		String INSERT_DEPARTMENT = "";
		String UPDATE_EXECUTER = "";
		//переменные идентификаторов
		String STATUS_ID = "";
		int i = 0;
		boolean error = false;
		//проверяем нужно ли добавлять записи в справочники и при необходимости добавляем
		CheckAndAddAuthor(editOwner);
		CheckAndAddProduct(editProduct);
		CheckAndAddDocType(editDocType);
		//формируем запрос
		try {
			SQL_UPDATE =  " UPDATE DOC_ALLDOCS SET ";
			SQL_UPDATE += " PRODUCT_ID = (SELECT ID FROM DOC_PRODUCTS WHERE trim(UPPER(PRODUCT)) = trim(UPPER(\'" + editProduct + "\')) and rownum=1),";
			SQL_UPDATE += " AUTHOR_ID = (SELECT ID FROM DOC_AUTHORS   WHERE trim(UPPER(AUTHOR))  = trim(UPPER(\'" + editOwner + "\'))   and rownum=1),";
			SQL_UPDATE += " REG_NUMBER = \'" + editRegNumber + "\',";
			SQL_UPDATE += " OUT_NUMBER = \'" + editOutNumber + "\',";
			SQL_UPDATE += " DOCTYPE_ID = (SELECT ID FROM DOC_DOCTYPES WHERE trim(Upper(DOCTYPE)) = trim(Upper(\'" + editDocType  +"\')) and rownum=1),";
			SQL_UPDATE += " DESCRIPTION = \'" + editDescription + "\',";
			SQL_UPDATE += " NOTE = \'" + editNote + "\',";
			SQL_UPDATE += " CONTROL_STATUS = \'" + editControlStatus + "\'";
			SQL_UPDATE += " WHERE ID = " + editNumber;
			oStmt.executeUpdate(SQL_UPDATE);
			for(i=0;i<iCurrentUsersCount;i++){
				if(lUsersStatus.get(i).equals("ожидает")) STATUS_ID = "1";
				if(lUsersStatus.get(i).equals("ознакамливается")) STATUS_ID = "2";
				if(lUsersStatus.get(i).equals("ознакомлен")) STATUS_ID = "3";
				if(lUsersStatus.get(i).equals("хранение")) STATUS_ID = "4";
				UPDATE_EXECUTER =  " UPDATE DOC_EXECUTERS SET";
				UPDATE_EXECUTER += " STATUS_ID  = " + STATUS_ID + ",";
				UPDATE_EXECUTER += " EXECUTE  = \'" + lUsersExecute.get(i) + "\',";
				UPDATE_EXECUTER += " DATE_OF_READ  = \'" + lDateOfRead.get(i) + "\'";
				UPDATE_EXECUTER += " WHERE DOC_ID = " + editNumber + " AND ";
				UPDATE_EXECUTER += " EXECUTER_ID  = (SELECT ID FROM USERS WHERE trim(UPPER(FULLNAME)) = trim(UPPER(\'" + lUsers.get(i) + "\')) and rownum=1)";
				oStmt.executeUpdate(UPDATE_EXECUTER);
				
			}
			for(i=iCurrentUsersCount;i<iUsersCount;i++){
				//для списков с фиксированными значениями берем ID
				if(lUsersStatus.get(i).equals("ожидает")) STATUS_ID = "1";
				if(lUsersStatus.get(i).equals("ознакамливается")) STATUS_ID = "2";
				if(lUsersStatus.get(i).equals("ознакомлен")) STATUS_ID = "3";
				if(lUsersStatus.get(i).equals("хранение")) STATUS_ID = "4";
				INSERT_EXECUTER = "INSERT INTO DOC_EXECUTERS (ID,EXECUTER_ID,STATUS_ID,EXECUTE,DOC_ID,DATE_OF_READ) VALUES (";
				INSERT_EXECUTER += "(SELECT MAX(ID)+1 FROM DOC_EXECUTERS),";
				INSERT_EXECUTER += "(SELECT ID FROM USERS WHERE trim(UPPER(FULLNAME)) = trim(UPPER(\'" + lUsers.get(i) +"\')) and rownum=1),";
				INSERT_EXECUTER += STATUS_ID + ",\'";
				INSERT_EXECUTER += lUsersExecute.get(i) + "\',";
				INSERT_EXECUTER += editNumber + ",'";
				INSERT_EXECUTER += lDateOfRead.get(i) + "\')";
				oStmt.executeUpdate(INSERT_EXECUTER);
			}
			for(i=iCurrentDepartmentCount;i<iDepartmentCount;i++){
				INSERT_DEPARTMENT = "INSERT INTO DOC_COPY_TO_DEPARTMENT (ID,DEPARTMENT_ID,DOC_ID) VALUES (";
				INSERT_DEPARTMENT += "(SELECT MAX(ID)+1 FROM DOC_COPY_TO_DEPARTMENT),";
				INSERT_DEPARTMENT += "(SELECT ID FROM DEPARTMENT WHERE trim(UPPER(DEPARTMENT)) = trim(UPPER(\'" + lDepartment.get(i) + "\')) and rownum=1),";
				INSERT_DEPARTMENT += editNumber + ")";
				oStmt.executeUpdate(INSERT_DEPARTMENT);
			}
		}
		catch (Exception e){  
		    error=true;
		}
		if (error == false)
		  oOC.getCon().commit();
		else
		  oOC.getCon().rollback();
		//если выбран какой-то файл и небыло ошибок то записываем этот файл
		try {
			if(!editDatafile.equals(""))
				if(error == false) SaveImageToDatabase(editNumber,editDatafile);
		}
		catch (Exception e){ 
		  error=true;
		}
		return error;
	}
	
	 /**
	  * МЕТОД удаление документа в базе
	  * @return отсуствуют
	  * @since 0.0.0.1
	  */
	public boolean DeleteDocument(String editNumber) throws Exception{
		boolean error = false;
		String SQL_DELETE = "";
		try {
			SQL_DELETE = "DELETE FROM DOC_ALLDOCS WHERE ID = " + editNumber;
			oStmt.executeUpdate(SQL_DELETE);
			SQL_DELETE = "DELETE FROM DOC_COPY_TO_DEPARTMENT WHERE DOC_ID = " + editNumber;
			oStmt.executeUpdate(SQL_DELETE);
			SQL_DELETE = "DELETE FROM DOC_EXECUTERS WHERE DOC_ID = " + editNumber;
			oStmt.executeUpdate(SQL_DELETE);
		}
		catch (Exception e){  
			error=true;
		}
		if (error == false)
			oOC.getCon().commit();
		else
			oOC.getCon().rollback();
		return error;
	}
	
//----------------------------------------------------------------------------------------------------------------------	
	/**
	  * МЕТОД получения данных для отчета
	  * @param дата с, дата по, id отдела
	  * @return общее число документов за указанный период
	 * @throws SQLException 
	 * @throws ParseException 
	  * @since 0.0.0.1
	  */
	public int GetReport(String date_from,String date_to,int id_dep) throws SQLException, ParseException{
		int result=0;
		DateFormat df=DateFormat.getDateInstance(DateFormat.MEDIUM);
		Date dt=df.parse(date_to);
		Calendar cd=Calendar.getInstance();
		cd.setTime(dt);
		cd.add(Calendar.DAY_OF_YEAR, 1); //формируем дату, следующую за date_to, чтобы документы, зарегистрированные за date_to, также были включены в отчет
		Date dt1=cd.getTime();
		String sql="Select count(*) as res_count "+
				   "from PROEUSER.DOC_ALLDOCS, PROEUSER.DOC_AUTHORS, PROEUSER.DOC_DOCTYPES, PROEUSER.DOC_PRODUCTS "+
				   "where PROEUSER.DOC_ALLDOCS.DEPARTMENT_ID="+id_dep+
				   " AND PROEUSER.DOC_ALLDOCS.AUTHOR_ID=PROEUSER.DOC_AUTHORS.ID"+
				   " AND PROEUSER.DOC_ALLDOCS.DOCTYPE_ID=PROEUSER.DOC_DOCTYPES.ID"+
				   " AND PROEUSER.DOC_ALLDOCS.PRODUCT_ID = PROEUSER.DOC_PRODUCTS.ID"+
				   " AND (PROEUSER.DOC_ALLDOCS.REG_DATE>=to_date('"+date_from+"','DD.MM.YYYY')"+
				   		" AND PROEUSER.DOC_ALLDOCS.REG_DATE<=to_date('"+df.format(dt1)+"','DD.MM.YYYY'))";
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs=oStmt.executeQuery(sql);
		while(oRs.next()){
			result=Integer.parseInt(oRs.getString("res_count"));
		}
		sql="Select DOC_PRODUCTS.PRODUCT,count(DOC_ALLDOCS.REG_NUMBER) as res_count "+
			"from PROEUSER.DOC_ALLDOCS, PROEUSER.DOC_AUTHORS, PROEUSER.DOC_DOCTYPES, PROEUSER.DOC_PRODUCTS "+
			"where PROEUSER.DOC_ALLDOCS.DEPARTMENT_ID="+id_dep+
			" AND PROEUSER.DOC_ALLDOCS.AUTHOR_ID=PROEUSER.DOC_AUTHORS.ID"+
			" AND PROEUSER.DOC_ALLDOCS.DOCTYPE_ID=PROEUSER.DOC_DOCTYPES.ID"+
			" AND PROEUSER.DOC_ALLDOCS.PRODUCT_ID=PROEUSER.DOC_PRODUCTS.ID"+
			" AND (PROEUSER.DOC_ALLDOCS.REG_DATE>=to_date('"+date_from+"','DD.MM.YYYY')"+
				" AND PROEUSER.DOC_ALLDOCS.REG_DATE<=to_date('"+df.format(dt1)+"','DD.MM.YYYY')) "+
			"Group by DOC_PRODUCTS.PRODUCT "+
			"Order by DOC_PRODUCTS.PRODUCT";
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs=oStmt.executeQuery(sql);
		return result;
	}
	
	/**
	  * МЕТОД получения id отдела
	  * @param аббревиатура отдела
	  * @return id отдела
	 * @throws SQLException 
	  * @since 0.0.0.1
	  */
	public int GetDepartmentId(String dep) throws SQLException{
		int result=-1;
		String sql="Select ID from DEPARTMENT where DEPARTMENT_ABB='"+dep+"'";
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs=oStmt.executeQuery(sql);
		while(oRs.next()){
			result=Integer.parseInt(oRs.getString("ID"));
		}
		return result;
	}
	
	/**
	  * МЕТОД получения общего количества исполнителей
	  * @param дата с, дата по, id отдела
	  * @return общее количество исполнителей
	 * @throws SQLException 
	  * @since 0.0.0.1
	  */
	public int GetExecutorsCount(String date_from,String date_to,int dep_id) throws SQLException{
		int result=0;
		String sql="Select count(*) as res_count "+
				   "from DOC_ALLDOCS,DOC_EXECUTERS "+
				   "where DOC_EXECUTERS.DOC_ID=DOC_ALLDOCS.ID and "+ 
				   		"DOC_ALLDOCS.DEPARTMENT_ID="+dep_id+" and "+ 
				   		"(DOC_ALLDOCS.REG_DATE>=to_date('"+date_from+"','dd.mm.yyyy') and "+ 
				   		 "DOC_ALLDOCS.REG_DATE<=to_date('"+date_to+"','dd.mm.yyyy'))";
		oStmt.setQueryTimeout(iQUERY_TIMEOUT);
		oRs=oStmt.executeQuery(sql);
		while(oRs.next()){
			result=Integer.parseInt(oRs.getString("res_count"));
		}
		return result;
	}
	
	
	//----------------------------------------------------------------------------------------------
		/**
		  * МЕТОД              добавить замечание
		  * @param             параметры для замечания
		  * @return            отсутствуют
		 * @throws SQLException 
		  * @since             0.0.0.1
		  */
		
		public void InsertNote(String FULLNAME, String TYPE, String TEXT) throws Exception{
			String ID = "0";
			int iID = 0;
			//получаем последний ID
			GetLastNoteId();
			if(oRs.next()){
				 if(oRs.getString("MAX(ID)") != null){
					 ID = oRs.getString("MAX(ID)");
					 //если ID не первый увеличиваем его на 1
					 iID = Integer.parseInt(ID);
					 iID++;
					 ID = String.valueOf(iID).toString();
				 }
				 else ID = "0";
			}else 
				ID = "0";
			Calendar today=Calendar.getInstance();
			Formatter f=new Formatter();
			
			String sql="Insert into NOTE_REPORT(ID,PROGRAM_ID,QUESTION,QUESTION_AUTHOR_ID,QUESTION_DATE,"+
												"ANSWER,ANSWER_AUTHOR_ID,ANSWER_DATE,STATUS_ID,TYPE_ID) "+ 
						"values("+ID+",(Select ID from NOTE_PROGRAM where PROGRAM_NAME like 'Журнал входящей корреспонденции'), '"+TEXT+"', "+
									  "(Select ID from USERS where FULLNAME like '"+FULLNAME+"'), '"+f.format("%td.%tm.%tY", today,today,today)+"',"+
						"null,null,null,(Select ID from NOTE_STATUS where STATUS like 'Ожидает'),(Select ID from NOTE_TYPE where type LIKE '"+TYPE+"'))";
			
			
			//выполняем запрос
			
			oStmt.setQueryTimeout(iQUERY_TIMEOUT);
			oStmt.executeUpdate(sql);
			
		}
		
		/**
		  * МЕТОД              получить id последнего замечания
		  * @param             отсутствуют
		  * @return            отсутствуют
		 * @throws SQLException 
		  * @since             0.0.0.1
		  */
		
		public void GetLastNoteId() throws SQLException{
			String sql = "SELECT MAX(ID) FROM NOTE_REPORT";
			oStmt.setQueryTimeout(iQUERY_TIMEOUT);
			oRs = oStmt.executeQuery(sql);
		}
		
		
		/**
		  * МЕТОД              получить все замечания
		  * @param             отсутствуют
		  * @return            отсутствуют
		 * @throws SQLException 
		  * @since             0.0.0.1
		  */
		
		public void GetAllNotes() throws Exception{
			String sql="Select NOTE_REPORT.ID,TYPE,QUESTION as TEXT,FULLNAME,ANSWER,STATUS_ID as FINISH "+
						"from NOTE_REPORT,NOTE_TYPE,USERS,NOTE_PROGRAM "+
						"where NOTE_TYPE.ID=NOTE_REPORT.TYPE_ID and NOTE_REPORT.QUESTION_AUTHOR_ID=USERS.ID and "+
						"NOTE_REPORT.PROGRAM_ID=NOTE_PROGRAM.ID and NOTE_PROGRAM.PROGRAM_NAME like 'Журнал входящей корреспонденции' "+
						"Order by NOTE_REPORT.ID";
			  oStmt.setQueryTimeout(iQUERY_TIMEOUT);
			  oRs = oStmt.executeQuery(sql);
		}
		
		
		/**
		  * МЕТОД              получить все замечания
		  * @param             отсутствуют
		  * @return            отсутствуют
		 * @throws SQLException 
		  * @since             0.0.0.1
		  */
		public void GetAllNoteTypes() throws SQLException{
			String sql="Select TYPE from NOTE_TYPE";
			oStmt.setQueryTimeout(iQUERY_TIMEOUT);
			oRs=oStmt.executeQuery(sql);
		}
}
