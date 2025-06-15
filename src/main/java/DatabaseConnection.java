import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/flowerlover";
    private static final String USER = "root";
    private static final String PASSWORD = "ngocHoa2811@";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Nạp driver JDBC (Không bắt buộc với JDBC 4.0+ nhưng tốt để đảm bảo)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Kết nối đến MySQL
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Ket noi thanh cong!");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ L0i: Khong tim thay Driver MySQL!");
        } catch (SQLException e) {
            System.out.println("❌ Loi ket noi MySQL: " + e.getMessage());
        }
        return conn;
    }

    public static void main(String[] args) {
        // Sử dụng try-with-resources để tự động đóng kết nối
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✅ Kiem tra: Ket noi dang hoat đong!");
            } else {
                System.out.println("❌ Kiem tra: Ket noi that bai!");
            }
        } catch (Exception e) {
            System.out.println("❌ Loi khi kiem tra ket noi: " + e.getMessage());
        }
    }
}
