package model;

import java.io.Serializable;

/**
 * ログイン時に入力された値（IDとパスワード）のみを保持する簡易Beanクラス
 */
public class Login implements Serializable {
    private static final long serialVersionUID = 1L;

    private String userId; // ユーザーID
    private String pass;   // パスワード

    // 1. 引数なしのデフォルトコンストラクタ（JavaBeansの必須ルール）
    public Login() {}

    // 2. サーブレット側で値を一括セットするためのコンストラクタ
    public Login(String userId, String pass) {
        this.userId = userId;
        this.pass = pass;
    }

    // ==========================================
    // 3. Getter / Setter メソッド
    // ==========================================

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getPass() { return pass; }
    public void setPass(String pass) { this.pass = pass; }
}