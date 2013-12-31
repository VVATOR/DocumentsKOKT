package by.gomel.gskb.oracle.PROEUSER;
import java.sql.Connection;
import java.sql.DriverManager;
/**
 * @version 0.0.0.1
 * @author КОРЖОВ А.В.
 */
//--------------------------------------------------------------------------------------
//Класс             : ПОДКЛЮЧЕНИЕ К БАЗЕ ORACLE К ТАБЛИЧНОМУ ПРОСТРАНСТВУ PROEUSER
//Организация       : РКУП "ГСКБ ПО ЗЕРНОУБОРОЧНОЙ И КОРМОУБОРОЧНОЙ ТЕХНИКЕ"
//--------------------------------------------------------------------------------------
/**
 * @version 0.0.0.0 - без реализации
 * @version 0.0.0.1 - описаны свойства и методы класса
 */
public class OracleConnect {
//--------------------------------------------------------------------------------------
//  СВОЙСТВА КЛАССА
//--------------------------------------------------------------------------------------
	/**
	 * объект подключения
	*/
	private static Connection oCon;
	/**
	 * URL
	*/
	private String sUrl;
	/**
	 * имя пользователя
	*/
	private String sName;
	/**
	 * пароль
	*/
	private String sPassword;
	/**
	 * имя сервера или его IP адрес
	*/
	private String sServerIP;
	/**
	 * имя базы данных
	*/
	private String sDatabaseName;
//--------------------------------------------------------------------------------------
//  МЕТОДЫ КЛАССА
//--------------------------------------------------------------------------------------
	 /**
	  * МЕТОД              конструктор класса
	  * @param             имя, пароль, сервер, база
	  * @since             0.0.0.1
	  */
	public OracleConnect(String sName,String sPassword,String sServerIP, String sDatabaseName) {
		this.sName = sName;
		this.sPassword = sPassword;
		this.sServerIP = sServerIP;
		this.sDatabaseName = sDatabaseName;
		setUrl("jdbc:oracle:thin:@" + sServerIP + ":1521:" + sDatabaseName);
	}
	 /**
	  * МЕТОД              подключение к БД
	  * @param             отсуствуют
	  * @return            объект подключения
	  * @since             0.0.0.1
	  */
	public Connection getConnection() throws Exception {
		    Class.forName("oracle.jdbc.driver.OracleDriver");
	        setCon(DriverManager.getConnection(sUrl, sName, sPassword));
		    return getCon();
		    }
	 /**
	  * МЕТОД              отключение от БД
	  * @param             отсуствуют
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void  Disconnected() throws Exception {
		if(oCon!=null){
			oCon.close();
	    }
	}
	 /**
	  * МЕТОД              установить URL
	  * @param             URL
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void setUrl(String url) {
		sUrl = url;
	}
	 /**
	  * МЕТОД              получить URL
	  * @param             отсуствуют
	  * @return            URL
	  * @since             0.0.0.1
	  */
	public String getUrl() {
		return sUrl;
	}
	 /**
	  * МЕТОД              установить имя пользователя
	  * @param             имя пользователя
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void setName(String name) {
		sName = name;
	}
	 /**
	  * МЕТОД              получить имя пользователя
	  * @param             отсуствуют
	  * @return            имя пользователя
	  * @since             0.0.0.1
	  */
	public String getName() {
		return sName;
	}
	 /**
	  * МЕТОД              установить пароль
	  * @param             пароль
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void setPassword(String password) {
		sPassword = password;
	}
	 /**
	  * МЕТОД              получить пароль
	  * @param             отсуствуют
	  * @return            пароль
	  * @since             0.0.0.1
	  */
	public String getPassword() {
		return sPassword;
	}
	 /**
	  * МЕТОД              установить адрес сервера
	  * @param             адрес сервера
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void setServerIP(String serverIP) {
		sServerIP = serverIP;
	}
	 /**
	  * МЕТОД              получить адрес сервера
	  * @param             отсуствуют
	  * @return            адрес сервера
	  * @since             0.0.0.1
	  */
	public String getServerIP() {
		return sServerIP;
	}
	 /**
	  * МЕТОД              устанвоить имя базы данных
	  * @param             имя базы данных
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public void setDatabaseName(String databaseName) {
		sDatabaseName = databaseName;
	}
	 /**
	  * МЕТОД              получить имя базы данных
	  * @param             отсуствуют
	  * @return            имя базы данных
	  * @since             0.0.0.1
	  */
	public String getDatabaseName() {
		return sDatabaseName;
	}
	 /**
	  * МЕТОД              устаноаить объект соединение
	  * @param             объект соединение
	  * @return            отсуствуют
	  * @since             0.0.0.1
	  */
	public static void setCon(Connection con) {
		OracleConnect.oCon = con;
	}
	 /**
	  * МЕТОД              получить объект соединение
	  * @param             отсуствуют
	  * @return            объект соединение
	  * @since             0.0.0.1
	  */
	public Connection getCon() {
		return oCon;
	}
}
