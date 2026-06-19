package model;

import dao.AccountsDAO;
import servlet.Login;

public class LoginLogic {
    public Account execute(Login login) {  
        AccountsDAO dao = new AccountsDAO();
        // AccountsDAOのfindByLoginを呼び出して、Accountオブジェクトを取得
        return dao.findByLogin(login);
    }
}