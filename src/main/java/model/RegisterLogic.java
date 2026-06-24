package model;

import dao.UsersDAO;

public class RegisterLogic {
    /**
     * 会員登録処理を実行する
     * @param account 登録するユーザー情報
     * @return エラーメッセージ（登録成功時は null）
     */
    public String execute(User account) {
        UsersDAO dao = new UsersDAO();
        
        // 1. 重複チェック
        if (dao.existsUserId(account.getUserId())) {
            // IDが既に存在する場合、固有のエラーメッセージを返す
            return "・このユーザーIDは既に登録されています。別のIDをお試しください。";
        }
        
        // 2. 新規登録実行
        boolean isSuccess = dao.register(account);
        if (!isSuccess) {
            // 重複以外のエラー（桁数オーバー、型エラー、DB切断など）の場合
            return "・システムエラーが発生しました。入力内容（文字数など）を確認するか、しばらく経ってから再度お試しください。";
        }
        
        // ✨ 一切エラーがなければ null を返す（成功の証）
        return null;
    }
}