//package 2026;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SupabaseDB {
    // 20260110 built by Claude Code
    // 20260201 updated: switched to pooler URL with SSL for reliable connectivity - SQL State xx000 Error Code: 0
    private static final String URL = "jdbc:postgresql://aws-0-us-west-1.pooler.supabase.com:6543/postgres?sslmode=require";
    private static final String USER = "postgres.jgbvuxzwasiqhvrgzusb";
    private static final String PASSWORD = "crimSon200$02";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void main(String[] args) {
        System.out.println("Attempting to connect to Supabase...");
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Connected to Supabase successfully!");
                System.out.println("Database: " + conn.getCatalog());
            }
        } catch (SQLException e) {
            System.err.println("Connection failed: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
        }
    }
}
