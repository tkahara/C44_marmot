package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.UsersDAO; // 明示的にインポート
import model.User;

@WebServlet("/DeleteFieldServlet")
public class DeleteFieldServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("Main");
            return;
        }

        try {
            UsersDAO databaseAccessObject = new UsersDAO();
            
            // クレジットカード削除の専用メソッドを呼び出す（内部で番号・名義・期限をNULLにします）
            boolean result = databaseAccessObject.deleteCardNum(loginUser.getUserId());
            
            System.out.println("================================");
            System.out.println("★クレジットカード情報削除結果: " + result);
            System.out.println("================================");
            
            if (result) {
                // DB更新が成功した場合、セッション内の各種クレジットカード情報をすべて空にする
                loginUser.setCardNumber("");     // 旧: setCardNum("") から変更
                loginUser.setCardName("");       // 新設された名義のクリア
                loginUser.setCardExpiration(""); // 新設された有効期限のクリア
                
                // 状態が変わったオブジェクトをセッションに再格納して同期
                session.setAttribute("loginUser", loginUser);
            }
            
        } catch (Exception e) {
            System.err.println("【エラー】クレジットカードの削除中に問題が発生しました。");
            e.printStackTrace();
        }

        // マイページ画面（メイン）へ戻る
        response.sendRedirect("MyPageServlet");
    }
}