import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DisplayAcountTable {
    public static void main(String[] args) {
        // Thông tin kết nối MySQL
        String url = "jdbc:mysql://localhost:3306/flowerlover"; // Thay bằng tên database của bạn
        String user = "root"; // Thay bằng username của bạn
        String dbPassword = "ngocHoa2811@"; // Thay bằng password của bạn

        try {
            // 1️⃣ Kết nối đến database
            Connection conn = DriverManager.getConnection(url, user, dbPassword);
            System.out.println("✅ Kết nối MySQL thành công!");

            // 2️⃣ Tạo và thực thi truy vấn SQL
            Statement stmt = conn.createStatement();
            String sql = "SELECT * FROM users"; // Đổi từ 'user' thành 'users'

            ResultSet rs = stmt.executeQuery(sql);
            
            // 3️⃣ Hiển thị dữ liệu từ bảng users
            System.out.println("\n📌 Dữ liệu trong bảng users:");
            System.out.println("+------------------------+------------+---------+");
            System.out.println("| Email                  | Password   | Role    |");
            System.out.println("+------------------------+------------+---------+");
            while (rs.next()) {
                String email = rs.getString("email");
                String password = rs.getString("password");
                String role = rs.getString("role");

                System.out.printf("| %-22s | %-10s | %-7s |\n", email, password, role);
            }
            System.out.println("+------------------------+------------+---------+");

            // 4️⃣ Đóng kết nối
            rs.close();
            stmt.close();
            conn.close();
            System.out.println("\n✅ Đã hiển thị dữ liệu thành công!");

        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi kết nối hoặc truy vấn MySQL: " + e.getMessage());
        }
    }
}
