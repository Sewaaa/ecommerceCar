<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="it">
<head>
	<title>Filtro Ordini</title>
    <link rel="stylesheet" type="text/css" href="css/carrello.css">
</head>
<body>
  
        <%
        boolean hasResults = false;
        String dbUrl = "jdbc:mysql://localhost:3306/tsw_prog?serverTimezone=Europe/Rome";
        String user = "root";
        String password = "root";
        String emailUtente = request.getParameter("email");
        String orderOption = request.getParameter("order");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            try (Connection connection = DriverManager.getConnection(dbUrl, user, password);
                 Statement statement = connection.createStatement()) {

                String query = "SELECT o.id AS id_ordine, p.id AS id_prodotto, p.tipo AS tipo, p.nome AS nome_prodotto, b.nome AS nome_brand, m.percorso AS percorso_media, p.prezzo AS prezzo_prodotto, c.nome AS nome_colore, r.tipo AS tipo_ruote, i.tipo AS tipo_interni, o.email_utente as email_utente"
                        + " FROM ACQUISTI a"
                        + " JOIN ORDINI o ON a.id_ordine = o.id"
                        + " JOIN UTENTI u ON a.email_utente = u.email"
                        + " JOIN PRODOTTI p ON a.id_prodotto = p.id"
                        + " JOIN BRAND b ON p.id_brand = b.id"
                        + " JOIN MEDIA m ON p.id = m.id_prodotto"
                        + " LEFT JOIN COLORI c ON a.id_colore = c.id"
                        + " LEFT JOIN RUOTE r ON a.id_ruote = r.id"
                        + " LEFT JOIN INTERNI i ON a.id_interni = i.id";
                        
                if (emailUtente != null && !emailUtente.isEmpty()) {
        	        query = query + " WHERE o.email_utente = '" + emailUtente + "' ";
        	    }
        	    
                if ("recenti".equals(orderOption)) {
                    query += " ORDER BY o.id DESC";
                } else if ("vecchi".equals(orderOption)) {
                    query += " ORDER BY o.id ASC";
                }

                ResultSet resultSet = statement.executeQuery(query);
                String currentOrderId = "";

                while (resultSet.next()) {
                    hasResults = true;
                    String orderId = resultSet.getString("id_ordine");
                    if (!currentOrderId.equals(orderId)) {
                        Statement statement2 = connection.createStatement();
                        String query2 = "SELECT * FROM ordini WHERE id=" + orderId + " AND email_utente='" + resultSet.getString("email_utente") + "';";
                        System.out.println(query2);
                        ResultSet resultSet2 = statement2.executeQuery(query2);
                        resultSet2.next();

                        String dataOrdine = resultSet2.getString("data_ordine");
                        String prezzoTot = resultSet2.getString("prezzo_tot");
                        String emailUtente2 = resultSet2.getString("email_utente");

                        %>
                        <div class="item-ordine">
                            Utente: <%= emailUtente2 %>
                            <br>
                            ORDINE <%= orderId %>&#176; (<%= dataOrdine %>)
                            <br>
                            Totale: &euro;<%= prezzoTot %> (iva inclusa)
                        </div>
                        <%
                        currentOrderId = orderId;
                    }
                    %>

                    <div class="item">
                        <form action="shopServlet" method="get">
                            <button type="submit" class="invisible-button">
                                <img alt="immagine prodotto" class="item" src="<%= resultSet.getString("percorso_media") %>">
                            </button>
                            <input type="hidden" name="id_prodotto" value="<%= resultSet.getString("id_prodotto") %>">
                            <input type="hidden" name="tipo" value="<%= resultSet.getString("tipo") %>">
                        </form>

                        <form action="shopServlet" method="get">
                            <button type="submit" class="invisible-button">
                                <div class="title">
                                    <%= resultSet.getString("nome_brand") %>
                                    <%= resultSet.getString("nome_prodotto") %>
                                </div>

                                <% if (resultSet.getString("tipo").equals("macchina")) { %>
                                    <div class="personalizzazione">
                                        ( Colore: <b><%= resultSet.getString("nome_colore") %></b>-
                                        Ruote: <b><%= resultSet.getString("tipo_ruote") %></b>-
                                        Interni: <b><%= resultSet.getString("tipo_interni") %></b> )
                                    </div>
                                <% } %>

                            </button>

                            <input type="hidden" name="id_prodotto" value="<%= resultSet.getString("id_prodotto") %>">
                            <input type="hidden" name="tipo" value="<%= resultSet.getString("tipo") %>">
                        </form>

                        <div class="price">&euro;<%= resultSet.getString("prezzo_prodotto") %> +iva</div>
                    </div>

                    <%
                }
                if (!hasResults) {
                    %>
                    <div align="center"><b>Nessun Ordine Effettuato</b></div>
                    <%
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
 
</body>
</html>
