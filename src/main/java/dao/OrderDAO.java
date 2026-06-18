package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;

import model.Products;

public class OrderDAO {
    
    private final String JDBC_URL = "jdbc:mysql://localhost/keg_db?characterEncoding=UTF-8&useSSL=false";
    private final String DB_USER = "keg_user";
    private final String DB_PASS = "keg_pass";

    /**
     * 注文情報をDB（ordersテーブル）に一括保存するメソッド（クレジットカード情報対応版）
     */
    public boolean insertOrders(Integer userId, String paymentMethod, 
                                String guestName, String guestPostalCode, String guestAddress, 
                                String guestEmail, String guestPhone, 
                                String guestCardNumber, String guestCardName, String guestCardExpiration, // 🌟【追加】引数を3つ追加
                                Map<Products, Integer> cartMap) {
        
        Connection con = null;
        PreparedStatement ps = null;
        
        // 🌟【追加】SQLに3つのカード情報カラムを追加し、VALUESの「?」を14個に増やしました
        String sql = "INSERT INTO orders (user_id, product_name, quantity, unit_price, total_price, "
                   + "payment_method, guest_name, guest_postal_code, guest_address, guest_email, guest_phone, "
                   + "guest_card_number, guest_card_name, guest_card_expiration) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
            
            // トランザクション開始
            con.setAutoCommit(false);
            
            ps = con.prepareStatement(sql);
            
            // カート内の商品をループ処理
            for (Map.Entry<Products, Integer> entry : cartMap.entrySet()) {
                Products product = entry.getKey();
                int qty = entry.getValue();
                int unitPrice = product.getPrice();
                int totalPrice = unitPrice * qty;
                
                // 1. user_id
                if (userId != null) {
                    ps.setInt(1, userId);
                } else {
                    ps.setNull(1, java.sql.Types.INTEGER);
                }
                
                // 2. 注文商品データ
                ps.setString(2, product.getProductName()); // 商品名
                ps.setInt(3, qty);                         // 数量
                ps.setInt(4, unitPrice);                   // 単価
                ps.setInt(5, totalPrice);                  // 合計金額
                ps.setString(6, paymentMethod);            // 決済方法
                
                // 3. ゲスト情報
                ps.setString(7, guestName);
                ps.setString(8, guestPostalCode);
                ps.setString(9, guestAddress);
                ps.setString(10, guestEmail);
                ps.setString(11, guestPhone);
                
                // 🌟【追加】4. クレジットカード情報（12, 13, 14番目の?にセット）
                // 決済方法が「credit」の時のみ値を保存し、それ以外はDBにNULLを保存する安全設計
                if ("credit".equals(paymentMethod)) {
                    ps.setString(12, guestCardNumber);
                    ps.setString(13, guestCardName);
                    ps.setString(14, guestCardExpiration);
                } else {
                    ps.setNull(12, java.sql.Types.VARCHAR);
                    ps.setNull(13, java.sql.Types.VARCHAR);
                    ps.setNull(14, java.sql.Types.VARCHAR);
                }
                
                ps.addBatch();
            }
            
            ps.executeBatch();
            con.commit(); // 確定
            return true;
            
        } catch (Exception e) {
            System.out.println("【デバッグ】❌ SQL実行中にエラーが発生しました！原因は以下を確認してください：");
            e.printStackTrace(); 
            
            if (con != null) {
                try {
                    System.out.println("【デバッグ】処理をロールバック（巻き戻し）します。");
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}