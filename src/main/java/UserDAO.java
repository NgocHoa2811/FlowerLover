import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public void layTatCaNguoiDung() {
        String sql = "SELECT * FROM users"; // Chỉnh sửa bảng cho đúng
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            System.out.println("\n📌 Danh sach nguoi dung:");
            while (rs.next()) {
                System.out.println("👤 Email: " + rs.getString("email") +
                                   ", Vai tro: " + rs.getString("role"));
            }
        } catch (SQLException e) {
            System.out.println("❌ Loi lay du lieu: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        new UserDAO().layTatCaNguoiDung();  // Goi phuong thuc de kiem tra
    }
}
