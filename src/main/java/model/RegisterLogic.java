package model;

import dao.UsersDAO;

public class RegisterLogic {
    public boolean execute(User account) {
        UsersDAO dao = new UsersDAO();
        
        // 1. 重複チェック
        if (dao.existsUserId(account.getUserId())) {
            return false; // すでに存在するIDの場合は登録失敗
        }
        
        // 2. 新規登録実行
        return dao.register(account);
    }
}