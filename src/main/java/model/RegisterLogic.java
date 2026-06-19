package model;

import dao.AccountsDAO;

public class RegisterLogic {
    public boolean execute(Account account) {
        AccountsDAO dao = new AccountsDAO();
        
        // 1. 重複チェック
        if (dao.existsUserId(account.getUserId())) {
            return false; // すでに存在するIDの場合は登録失敗
        }
        
        // 2. 新規登録実行
        return dao.register(account);
    }
}