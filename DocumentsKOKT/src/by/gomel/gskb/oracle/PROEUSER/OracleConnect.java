package by.gomel.gskb.oracle.PROEUSER;
import java.sql.Connection;
import java.sql.DriverManager;
/**
 * @version 0.0.0.1
 * @author ������ �.�.
 */
//--------------------------------------------------------------------------------------
//�����             : ����������� � ���� ORACLE � ���������� ������������ PROEUSER
//�����������       : ���� "���� �� �������������� � �������������� �������"
//--------------------------------------------------------------------------------------
/**
 * @version 0.0.0.0 - ��� ����������
 * @version 0.0.0.1 - ������� �������� � ������ ������
 */
public class OracleConnect {
//--------------------------------------------------------------------------------------
//  �������� ������
//--------------------------------------------------------------------------------------
	/**
	 * ������ �����������
	*/
	private static Connection oCon;
	/**
	 * URL
	*/
	private String sUrl;
	/**
	 * ��� ������������
	*/
	private String sName;
	/**
	 * ������
	*/
	private String sPassword;
	/**
	 * ��� ������� ��� ��� IP �����
	*/
	private String sServerIP;
	/**
	 * ��� ���� ������
	*/
	private String sDatabaseName;
//--------------------------------------------------------------------------------------
//  ������ ������
//--------------------------------------------------------------------------------------
	 /**
	  * �����              ����������� ������
	  * @param             ���, ������, ������, ����
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
	  * �����              ����������� � ��
	  * @param             ����������
	  * @return            ������ �����������
	  * @since             0.0.0.1
	  */
	public Connection getConnection() throws Exception {
		    Class.forName("oracle.jdbc.driver.OracleDriver");
	        setCon(DriverManager.getConnection(sUrl, sName, sPassword));
		    return getCon();
		    }
	 /**
	  * �����              ���������� �� ��
	  * @param             ����������
	  * @return            ����������
	  * @since             0.0.0.1
	  */
	public void  Disconnected() throws Exception {
		if(oCon!=null){
			oCon.close();
	    }
	}
	 /**
	  * �����              ���������� URL
	  * @param             URL
	  * @return            ����������
	  * @since             0.0.0.1
	  */
	public void setUrl(String url) {
		sUrl = url;
	}
	 /**
	  * �����              �������� URL
	  * @param             ����������
	  * @return            URL
	  * @since             0.0.0.1
	  */
	public String getUrl() {
		return sUrl;
	}
	 /**
	  * �����              ���������� ��� ������������
	  * @param             ��� ������������
	  * @return            ����������
	  * @since             0.0.0.1
	  */
	public void setName(String name) {
		sName = name;
	}
	 /**
	  * �����              �������� ��� ������������
	  * @param             ����������
	  * @return            ��� ������������
	  * @since             0.0.0.1
	  */
	public String getName() {
		return sName;
	}
	 /**
	  * �����              ���������� ������
	  * @param             ������
	  * @return            ����������
	  * @since             0.0.0.1
	  */
	public void setPassword(String password) {
		sPassword = password;
	}
	 /**
	  * �����              �������� ������
	  * @param             ����������
	  * @return            ������
	  * @since             0.0.0.1
	  */
	public String getPassword() {
		return sPassword;
	}
	 /**
	  * �����              ���������� ����� �������
	  * @param             ����� �������
	  * @return            ����������
	  * @since             0.0.0.1
	  */
	public void setServerIP(String serverIP) {
		sServerIP = serverIP;
	}
	 /**
	  * �����              �������� ����� �������
	  * @param             ����������
	  * @return            ����� �������
	  * @since             0.0.0.1
	  */
	public String getServerIP() {
		return sServerIP;
	}
	 /**
	  * �����              ���������� ��� ���� ������
	  * @param             ��� ���� ������
	  * @return            ����������
	  * @since             0.0.0.1
	  */
	public void setDatabaseName(String databaseName) {
		sDatabaseName = databaseName;
	}
	 /**
	  * �����              �������� ��� ���� ������
	  * @param             ����������
	  * @return            ��� ���� ������
	  * @since             0.0.0.1
	  */
	public String getDatabaseName() {
		return sDatabaseName;
	}
	 /**
	  * �����              ���������� ������ ����������
	  * @param             ������ ����������
	  * @return            ����������
	  * @since             0.0.0.1
	  */
	public static void setCon(Connection con) {
		OracleConnect.oCon = con;
	}
	 /**
	  * �����              �������� ������ ����������
	  * @param             ����������
	  * @return            ������ ����������
	  * @since             0.0.0.1
	  */
	public Connection getCon() {
		return oCon;
	}
}
