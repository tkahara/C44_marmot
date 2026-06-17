package model;

import java.io.Serializable;
import java.util.Objects;

/**
 * 商品情報を管理するモデルクラス（JavaBeans）
 * クラス名を「Products」に統一し、商品ID（id）は保持しない設計
 */
public class Products implements Serializable {
    private static final long serialVersionUID = 1L;

    // フィールド（private で隠蔽）
    private String productName;    // 商品名
    private String description;    // 商品説明
    private int price;             // 値段
    private String imagePath;      // 画像パス

    // デフォルトコンストラクタ
    public Products() {
    }

    // 引数ありのコンストラクタ
    public Products(String productName, String description, int price, String imagePath) {
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
    }

    // ゲッター・セッター
    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    // =========================================================================
    // ★【重要】Mapのキーとして正しく動作させるためのメソッド（追加箇所）
    // =========================================================================
    
    @Override
    public int hashCode() {
        // 商品名（productName）を基準にハッシュ値を計算します
        return Objects.hash(productName);
    }

    @Override
    public boolean equals(Object obj) {
        // 自分自身と同じインスタンスなら文句なしでtrue
        if (this == obj) return true;
        // 比較相手が空っぽ（null）だったり、クラスの種類が違ったらfalse
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Products other = (Products) obj;
        // 商品名（productName）が完全に一致していれば「同じ商品」とみなす
        return Objects.equals(productName, other.productName);
    }
}