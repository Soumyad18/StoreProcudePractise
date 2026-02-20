package dev.practice;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class ProcedureDemo {

    private static final String URL = "jdbc:mysql://127.0.0.1:3306/store_practice";
    private static final String USER = "app_user";
    private static final String PASSWORD = "app_pass";

    public static void main(String[] args) {
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD)) {
            int newId = addProduct(connection, "Potato", "Vegetable", new BigDecimal("1.50"), 75);
            System.out.println("Inserted product with id: " + newId);

            int vegetableCount = countByCategory(connection, "Vegetable");
            System.out.println("Vegetable count: " + vegetableCount);

            System.out.println("Products in Fruit category:");
            printProductsByCategory(connection, "Fruit");
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        }
    }

    private static int addProduct(Connection connection, String name, String category, BigDecimal price, int stock)
            throws SQLException {
        try (CallableStatement statement = connection.prepareCall("{call add_product(?, ?, ?, ?, ?)}")) {
            statement.setString(1, name);
            statement.setString(2, category);
            statement.setBigDecimal(3, price);
            statement.setInt(4, stock);
            statement.registerOutParameter(5, Types.INTEGER);

            statement.execute();
            return statement.getInt(5);
        }
    }

    private static int countByCategory(Connection connection, String category) throws SQLException {
        try (CallableStatement statement = connection.prepareCall("{call get_product_count_by_category(?, ?)}")) {
            statement.setString(1, category);
            statement.registerOutParameter(2, Types.INTEGER);

            statement.execute();
            return statement.getInt(2);
        }
    }

    private static void printProductsByCategory(Connection connection, String category) throws SQLException {
        try (CallableStatement statement = connection.prepareCall("{call list_products_by_category(?)}")) {
            statement.setString(1, category);

            boolean hasResultSet = statement.execute();
            if (!hasResultSet) {
                return;
            }

            try (ResultSet rs = statement.getResultSet()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String cat = rs.getString("category");
                    BigDecimal price = rs.getBigDecimal("price");
                    int stock = rs.getInt("stock");

                    System.out.printf("- [%d] %s (%s) price=%s stock=%d%n", id, name, cat, price, stock);
                }
            }
        }
    }
}
