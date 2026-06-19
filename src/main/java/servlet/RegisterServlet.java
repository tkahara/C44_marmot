package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.AccountsDAO;
import model.Account;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/register.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 1. JSPの入力フォームから各パラメータを取得
        String userId = request.getParameter("userId");
        String pass = request.getParameter("pass");
        String name = request.getParameter("name");
        String postalCode = request.getParameter("postalCode"); // 新設
        String address = request.getParameter("address");
        String mail = request.getParameter("mail");
        String tel = request.getParameter("tel");
        String cardNum = request.getParameter("cardNum");
        String cardName = request.getParameter("cardName");     // 新設
        String cardExpiration = request.getParameter("cardExpiration"); // 新設
        
        // 💡【修正の核心】新しい10個の引数を持つコンストラクタの順番に合わせてインスタンス化します
        // 順番: ID, 名前, パスワード, 郵便番号, 住所, メール, 電話番号, カード番号, カード名義, 有効期限
        Account newAccount = new Account(userId, name, pass, postalCode, address, mail, tel, cardNum, cardName, cardExpiration);
        
        AccountsDAO dao = new AccountsDAO();
        
        // 2. 重複チェック
        if (dao.existsUserId(userId)) {
            request.setAttribute("msg", "このユーザーIDは既に数字または文字列として使用されています。");
            request.setAttribute("isSuccess", false);
        } else {
            // 3. 重複がなければ登録実行
            boolean success = dao.register(newAccount);
            if (success) {
                request.setAttribute("isSuccess", true);
            } else {
                request.setAttribute("msg", "データベースエラーにより登録に失敗しました。");
                request.setAttribute("isSuccess", false);
            }
        }
        
        // 結果を持って登録画面（register.jsp）を再表示
        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/register.jsp");
        dispatcher.forward(request, response);
    }
}