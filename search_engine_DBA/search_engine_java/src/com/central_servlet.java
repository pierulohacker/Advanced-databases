package com;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class central_servlet
 */
@WebServlet("/central_servlet")
public class central_servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public central_servlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//try{
		switch(request.getParameter("idreq")){
		//			case "1":
		//				utils.insertNewTicketSmall(request, response);
		//				break;
		case "2":
			utils.logout(request, response);
			break;

		case "3":
			utils.admin_stats(request, response);
			break;
		case "4":
			utils.show_page(request, response);
			break;
			//			}
		}
		//}
		//		catch(ServletException | ClassNotFoundException e){
		//			e.printStackTrace();
		//			//response.sendRedirect("http://localhost:8080/Cinemas/html/error_page.jsp");
		//		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		try{
			switch(request.getParameter("idreq")){
			case "1":
				utils.login(request, response);
				break;
			case "2":
				utils.admin_login(request, response);
				break;
			case "3":
				utils.insert_new_page(request, response);
				break;
			case "5":
				utils.run_search_query(request, response);
				break;
				//			case "6":
				//				utils.getFilmScreeningsInCinema(request, response);
				//				break;
			case "7":
				utils.register_user(request, response);
				break;
			}
		}
		catch(ServletException e){
			e.printStackTrace();
			//response.sendRedirect("http://localhost:8080/Cinemas/html/error_page.jsp");
		}

	}
}
