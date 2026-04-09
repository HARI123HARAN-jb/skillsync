package Database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DbConnection {

    private Connection connection;

    public DbConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            // Credentials loaded from environment variables (set in Render dashboard)
            String url = System.getenv("DB_URL");
            String username = System.getenv("DB_USER");
            String password = System.getenv("DB_PASS");

            if (url != null && !url.contains("?")) {
                url += "?useSSL=true&requireSSL=true&verifyServerCertificate=false";
            } else if (url != null && !url.contains("useSSL")) {
                url += "&useSSL=true&requireSSL=true&verifyServerCertificate=false";
            }
            
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }

    public ResultSet Select(String query) {
        ResultSet rs = null;
        try {
            PreparedStatement statement = connection.prepareStatement(query);
            rs = statement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rs;
    }

    public int insert(String query, Object... params) {
        int rowsAffected = 0;
        try {
            PreparedStatement pstmt = connection.prepareStatement(query);
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            rowsAffected = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowsAffected;
    }

    public int update(String query, Object... params) throws SQLException {
        PreparedStatement pstmt = connection.prepareStatement(query);
        for (int i = 0; i < params.length; i++) {
            pstmt.setObject(i + 1, params[i]);
        }
        return pstmt.executeUpdate();
    }

    public void close() {
        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean ExecuteUpdate(String query) {
        boolean result = false;
        try {
            PreparedStatement pstmt = connection.prepareStatement(query);
            int rowsAffected = pstmt.executeUpdate();
            result = rowsAffected > 0; // returns true if at least one row was affected
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
