package model.dao;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;
import java.sql.Connection;
import java.sql.SQLException;

public class ConPool {
	private ConPool(){}
	 private static DataSource datasource;

	    public static Connection getConnection() throws SQLException {
	        if (datasource == null) {
	            PoolProperties p = new PoolProperties();
	            p.setUrl("jdbc:mysql://localhost:3306/tsw_prog");
	            p.setDriverClassName("com.mysql.cj.jdbc.Driver");
	            p.setUsername("root");
	            p.setPassword("root");
	            p.setMaxActive(100);
	            p.setInitialSize(10);
	            p.setMinIdle(10);
	            p.setRemoveAbandonedTimeout(60);
	            p.setRemoveAbandoned(true);
	            datasource = new DataSource();
	            datasource.setPoolProperties(p);
	        }
	        return datasource.getConnection();
	    }
	
}




