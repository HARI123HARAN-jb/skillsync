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

            if (url == null || username == null || password == null) {
                System.err.println("❌ Database Configuration Missing! URL: " + (url != null) + ", User: " + (username != null) + ", Pass: " + (password != null));
                return;
            }

            String sslParams = "useSSL=true&requireSSL=true&verifyServerCertificate=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&useLegacyDatetimeCode=false&enabledTLSProtocols=TLSv1.2&connectTimeout=10000&socketTimeout=30000";
            
            if (!url.contains("?")) {
                url += "?" + sslParams;
            } else if (!url.contains("useSSL")) {
                url += "&" + sslParams;
            }
            
            connection = DriverManager.getConnection(url, username, password);
            System.out.println("✅ Database Connected Successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ Database Driver Not Found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ Database Connection Failed: " + e.getMessage());
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
