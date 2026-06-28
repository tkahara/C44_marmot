package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Products;

public class ProductsDAO {
    // ※接続情報はお使いの環境（パスワードなど）に合わせて微調整してください
	//private final String JDBC_URL = "jdbc:mysql://localhost/keg_db?characterEncoding=UTF-8&useSSL=false";
	private final String JDBC_URL = "jdbc:mysql://localhost/keg_db";
	private final String DB_USER = "keg_user";
	private final String DB_PASS = "keg_pass";
    
    /**
     * 商品一覧をすべて取得するメソッド（SQL文の大文字に合わせました）
     */
    public List<Products> findAll() {
        List<Products> list = new ArrayList<>();
        // ★SQLのカラム名を大文字のテーブル定義に完全一致させました
        String sql = "SELECT product_name, description, price, image_path FROM products";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(JDBC_URL,DB_USER,DB_PASS);
                 PreparedStatement pStmt = conn.prepareStatement(sql);
                 ResultSet rs = pStmt.executeQuery()) {
                
                while (rs.next()) {
                    Products p = new Products();
                    // ★rs.getString内も、SQLの定義通り小文字（または大文字）で正確にマッピング
                    p.setProductName(rs.getString("product_name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getInt("price"));
                    p.setImagePath(rs.getString("image_path"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 商品名（product_name）を条件にして商品詳細情報を取得するメソッド
     */
    public Products findByName(String searchName) {
        Products products = null;
        // ★SQL文から「id」を完全に排除し、大文字のPRODUCTSテーブルから取得
        String sql = "SELECT product_name, description, price, image_path FROM products WHERE product_name = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(JDBC_URL,DB_USER,DB_PASS);
                 PreparedStatement pStmt = conn.prepareStatement(sql)) {
                
                pStmt.setString(1, searchName);
                
                try (ResultSet rs = pStmt.executeQuery()) {
                    if (rs.next()) {
                        products = new Products();
                        products.setProductName(rs.getString("product_name"));
                        products.setDescription(rs.getString("description"));
                        products.setPrice(rs.getInt("price"));
                        products.setImagePath(rs.getString("image_path"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }
}