package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.object.*;
import model.dao.*;

@WebServlet("/shopSERVLET")
public class shopSERVLET extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
 
    public shopSERVLET() {
        super();
       
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		prodottoDAO prodDAO= new prodottoDAO();
		prodotto p;
		
		RequestDispatcher dispatcher;
		
		p = prodDAO.getSelectedProdotto(request.getParameter("id_prodotto")); 
		
		session.setAttribute("prodottoSelected", p);
		
		dispatcher = request.getRequestDispatcher("/shop.jsp");
        dispatcher.forward(request,response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		doGet(request, response);
	}

}
