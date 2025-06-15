import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestMySql {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/flowerlover";
        String user = "root";
        String password = "ngocHoa2811@";

        try {
            // Nạp driver MySQL (Không bắt buộc nhưng tốt để đảm bảo)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Sử dụng try-with-resources để tự động đóng kết nối
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                System.out.println("✅ Ket noi MySQL thanh cong!");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Loi: Khong tim thay Driver MySQL!");
        } catch (SQLException e) {
            System.out.println("❌ Loi ket noi MySQL: " + e.getMessage());
        }
    }
}
