package model;

import dao.UsersDAO;
// ❌ import servlet.Login;  <-- サーブレットのインポートは不要なので削除

public class LoginLogic {
    // 💡 引数を model パッケージ内の Login クラス（model.Login）として扱います
    public User execute(Login login) {  
        UsersDAO dao = new UsersDAO();
        
        // 🌟 UsersDAO の findByLogin(model.Login login) と型が完全に一致するため、
        // エラーなく綺麗に User オブジェクトがリターンされます。
        return dao.findByLogin(login);
    }
}