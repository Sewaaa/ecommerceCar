package model.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger; 
import model.object.*;

public class brandDAO {

	/*Prendi tutti i brand*/
	 public List<brand>  getAllBrand() {
		  
		 try (Connection con = ConPool.getConnection();
		     PreparedStatement ps = con.prepareStatement ("select * from brand;")) {
	           ResultSet rs = ps.executeQuery();
	           List<brand> lista_brand = new ArrayList<>();
	           while (rs.next()) {
	            	brand b=new brand();
	            	b.setId(rs.getString(1));
	            	b.setNome(rs.getString(2));
	            	b.setPercorso(rs.getString(3));
	            
	                lista_brand.add(b);
	            }
	           return lista_brand;
		} catch (SQLException e) {
			Logger LOGGER =  Logger.getLogger(Logger.GLOBAL_LOGGER_NAME);     
			LOGGER.log(null, "context", e);
	        }
		
		  }
	 /*Prendi il nome del brand sapendo id*/
	 public String  getBrandFromId(String id_brand) {
		 String nome_brand="";
		 ResultSet rs=null;
		 try (Connection con = ConPool.getConnection();
				PreparedStatement ps = con.prepareStatement("select nome from brand where id=?;")) {
			
			ps.setString(1, id_brand);
	            rs = ps.executeQuery();
	          
	           while (rs.next()) {
	        	   nome_brand=rs.getString(1);
	            }
	           return nome_brand;
		      
	        } catch (SQLException e) {
	        	Logger LOGGER =  Logger.getLogger(Logger.GLOBAL_LOGGER_NAME);     
			LOGGER.log(null, "context", e);
	        }
		
		  }
	}

	
