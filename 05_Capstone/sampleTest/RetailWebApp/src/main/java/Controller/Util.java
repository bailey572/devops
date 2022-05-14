package Controller;
import argo.jdom.JdomParser;
import argo.jdom.JsonNode;
import argo.jdom.JsonRootNode;

import java.sql.*;
import java.util.*;

import org.apache.log4j.Logger;

public class Util {
	private static Logger logger = Logger.getLogger("retailone");
	public Connection db()
    {
    	Connection connection = null;
    try {
    	
        String vcap_services = System.getenv("VCAP_SERVICES");
        String hostname = "";
        String dbname = "";
        String user = "";
        String password = "";
        String port = "";
        
    	if (vcap_services != null && vcap_services.length() > 0) {
    		logger.info("Loading mysql from PCF context");
    		JsonRootNode root = new JdomParser().parse(vcap_services);

            JsonNode mysqlNode = root.getNode("p-mysql");
            JsonNode credentials = mysqlNode.getNode(0).getNode(
                    "credentials");

            dbname = credentials.getStringValue("name");
            hostname = credentials.getStringValue("hostname");
            user = credentials.getStringValue("username");
            password = credentials.getStringValue("password");
            port = credentials.getNumberValue("port");

            String dbUrl = "jdbc:mysql://" + hostname + ":" + port + "/"
                    + dbname;
            System.out.println(dbUrl);
            System.out.println(user + "password " + password);

            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(dbUrl, user, password);
            return connection;
        } else {
        		//for local configuration
	            Class.forName("com.mysql.jdbc.Driver");
	            logger.info("Loading mysql from local context");
	            //String url = "jdbc:mysql://127.0.0.1:10100/db8dad2d02e114ef6bc9d24e68367e33e"	
	            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/retaildb","root","password"); 
	            return connection;

        }

    } catch (Exception e) {

        e.printStackTrace();
        return connection;
    }
	

    }

}
