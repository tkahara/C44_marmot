package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import model.User;
// ❌ import servlet.Login;  <-- クラス名衝突の原因になるため削除しました

public class UsersDAO {
    private final String JDBC_URL = "jdbc:mysql://localhost/keg_db?useSSL=false&allowPublicKeyRetrieval=true";
    private final String DB_USER = "keg_user";
    private final String DB_PASS = "keg_pass";

    // 1. ログイン処理（引数を model.Login に明示的に変更）
    public User findByLogin(model.Login login) {
        User user = null;
        try { 
            Class.forName("com.mysql.cj.jdbc.Driver"); 
        } catch (ClassNotFoundException e) { 
            throw new IllegalStateException("JDBCドライバを読み込めませんでした"); 
        }
        
        String sql = "SELECT user_id, user_name, password, postal_code, address, email, phone_number, card_number, card_name, card_expiration "
                   + "FROM USERS WHERE user_id = ? AND password = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
             
            // 🌟 model.Login 型として認識されるため、正常にメソッドが呼べるようになります
            pStmt.setString(1, login.getUserId());
            pStmt.setString(2, login.getPass());
            
            try (ResultSet rs = pStmt.executeQuery()) {
                if (rs.next()) {
                    String userId = rs.getString("user_id");
                    String userName = rs.getString("user_name");
                    String password = rs.getString("password");
                    String postalCode = rs.getString("postal_code");
                    String address = rs.getString("address");
                    String email = rs.getString("email");
                    String phoneNumber = rs.getString("phone_number");
                    String cardNumber = rs.getString("card_number");
                    String cardName = rs.getString("card_name");
                    String cardExpiration = rs.getString("card_expiration");
                    
                    user = new User(userId, userName, password, postalCode, address, email, phoneNumber, cardNumber, cardName, cardExpiration);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
        return user;
    }

    // 2. ID重複チェック用
    public boolean existsUserId(String userId) {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) { throw new IllegalStateException(e); }

        String sql = "SELECT COUNT(*) FROM USERS WHERE user_id = ?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            pStmt.setString(1, userId);
            try (ResultSet rs = pStmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. 新規登録用
    public boolean register(User user) {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) { throw new IllegalStateException(e); }

        String sql = "INSERT INTO USERS (user_id, user_name, password, postal_code, address, email, phone_number, card_number, card_name, card_expiration) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
             PreparedStatement pStmt = conn.prepareStatement(sql)) {
            
            pStmt.setString(1, user.getUserId());
            pStmt.setString(2, user.getUserName());
            pStmt.setString(3, user.getPassword());
            pStmt.setString(4, user.getPostalCode());
            pStmt.setString(5, user.getAddress());
            pStmt.setString(6, user.getEmail());
            pStmt.setString(7, user.getPhoneNumber());
            
            if (user.getCardNumber() == null || user.getCardNumber().isEmpty()) {
                pStmt.setNull(8, java.sql.Types.VARCHAR);
            } else {
                pStmt.setString(8, user.getCardNumber());
            }
            
            if (user.getCardName() == null || user.getCardName().isEmpty()) {
                pStmt.setNull(9, java.sql.Types.VARCHAR);
            } else {
                pStmt.setString(9, user.getCardName());
            }
            
            if (user.getCardExpiration() == null || user.getCardExpiration().isEmpty()) {
                pStmt.setNull(10, java.sql.Types.VARCHAR);
            } else {
                pStmt.setString(10, user.getCardExpiration());
            }
            
            int result = pStmt.executeUpdate();
            return result == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. クレジットカード情報のみを消去
    public boolean deleteCardNum(String userId) {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) { throw new IllegalStateException(e); }

        String sql = "UPDATE USERS SET card_number = NULL, card_name = NULL, card_expiration = NULL WHERE user_id = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
             PreparedStatement pStmt = conn.prepareStatement(sql)) {

            pStmt.setString(1, userId); 
            int result = pStmt.executeUpdate();
            return result == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. 退会（アカウント完全削除）
 // 5. 退会（アカウント完全削除：購入履歴も一緒にクリア）
    public boolean deleteAccount(String userId) {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) { throw new IllegalStateException(e); }

        // 🌟 順番が超重要：先に子供（ORDERS）を消してから、親（USERS）を消します
        String deleteOrdersSql = "DELETE FROM ORDERS WHERE user_id = ?";
        String deleteUserSql = "DELETE FROM USERS WHERE user_id = ?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            // オートコミットをオフにして、両方成功したときだけ反映（トランザクション）
            conn.setAutoCommit(false);

            try (PreparedStatement pStmtOrder = conn.prepareStatement(deleteOrdersSql);
                 PreparedStatement pStmtUser = conn.prepareStatement(deleteUserSql)) {
                
                // 1. まず購入履歴を削除
                pStmtOrder.setString(1, userId);
                pStmtOrder.executeUpdate(); // 履歴は0件の場合もあるので、戻り値はチェックしなくてOK

                // 2. 次にユーザーアカウントを削除
                pStmtUser.setString(1, userId);
                int userResult = pStmtUser.executeUpdate();

                if (userResult == 1) {
                    conn.commit(); // 両方うまく行ったら確定
                    return true;
                } else {
                    conn.rollback(); // ユーザー削除に失敗したら巻き戻す
                    return false;
                }
            } catch (SQLException e) {
                conn.rollback(); // エラーが起きたら巻き戻す
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6. 購入履歴取得処理
    public List<model.Order> getOrderHistory(String userId) {
        List<model.Order> orderList = new ArrayList<>();
        String sql = "SELECT product_name, quantity, unit_price, total_price, order_date, payment_method " +
                     "FROM ORDERS WHERE user_id = ? ORDER BY order_date DESC";

        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) { throw new IllegalStateException(e); }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
             PreparedStatement pStmt = conn.prepareStatement(sql)) {

            pStmt.setString(1, userId);

            try (ResultSet rs = pStmt.executeQuery()) {
                while (rs.next()) {
                    String productName = rs.getString("product_name");
                    int quantity = rs.getInt("quantity");
                    int unitPrice = rs.getInt("unit_price");
                    int totalPrice = rs.getInt("total_price");
                    
                    LocalDateTime orderDate = rs.getTimestamp("order_date").toLocalDateTime();
                    String paymentMethod = rs.getString("payment_method");

                    model.Order order = new model.Order(userId, productName, quantity, unitPrice, totalPrice, orderDate, paymentMethod);
                    orderList.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderList;
    }
}