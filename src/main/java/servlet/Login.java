package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Account;
import model.LoginLogic;

@WebServlet("/Login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // フォームのinputのname属性に合わせて取得（画面遷移図の「id」と「パスワード」）
        // もしJSP側の入力項目名が "userId" の場合は、ここを "userId" に変更してください
        String name = request.getParameter("name"); 
        String pass = request.getParameter("pass");

        model.Login login = new model.Login(name, pass);

        // ログイン処理を実行（Accountオブジェクトが返ってくる）
        LoginLogic loginLogic = new LoginLogic();
        Account account = loginLogic.execute(login); 

        if (account != null) {    
            // ログイン成功時：ユーザー情報（Account）をセッションに保存
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", account);
        } else {
            // ログイン失敗時：エラーメッセージをリクエストに詰める
            request.setAttribute("errorMsg", "ユーザーIDまたはパスワードが不正です。");
        }
        
        // ログイン結果画面にフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/loginResult.jsp");
        dispatcher.forward(request, response);
    }
}