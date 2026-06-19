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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
           
    /**
     * GETリクエスト時の処理（ログイン画面への遷移）
     */
    protected void doGet(HttpServletRequest request, 
            HttpServletResponse response) 
            throws ServletException, IOException {
        // ログイン画面（JSP）へフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher(
                "WEB-INF/jsp/login.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * POSTリクエスト時の処理（ログイン認証の実行）
     */
    protected void doPost(HttpServletRequest request, 
            HttpServletResponse response) 
            throws ServletException, IOException {
        
        // リクエストパラメータのエンコーディングと取得
        request.setCharacterEncoding("UTF-8");
        String userId = request.getParameter("userId");
        String pass = request.getParameter("pass");
        
        // コンソールへのデバッグ出力
        System.out.println("--- ログイン試行 ---");
        System.out.println("入力されたユーザーID: " + userId);
        System.out.println("入力されたパスワード: " + pass);
        
        // 入力値をもとにLoginモデルを生成し、認証処理を実行
        Login login = new Login(userId, pass);
        LoginLogic bo = new LoginLogic();
        
        // 真偽値ではなく、認証に成功したAccountオブジェクト（またはnull）を受け取る
//      Account account = bo.authenticate(login);
        Account account = bo.execute(login);
        
        System.out.println("認証結果（Account取得成否）: " + (account != null ? "成功" : "失敗"));
        
        // ログイン処理の成否により処理を分岐
        if (account != null) { // ログイン成功時
            
            // 💡【修正の核心】型 Account に合わせて、setPass から setPassword に変更します
            account.setPassword(pass); 
            
            // セッションスコープに "loginUser" という名前で、Accountオブジェクトを保存する
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", account); // loginUser という名前で account を格納
            
            // 💡【修正】コンソール確認用の名前取得メソッドも、getName() から getUserName() に変更
            System.out.println("セッションに登録したユーザーID: " + account.getUserId());
            System.out.println("セッションに登録した表示名: " + account.getUserName());
            
            // loginOK.jspへフォワード
            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("WEB-INF/jsp/loginOK.jsp");
            dispatcher.forward(request, response);       
        } else { // ログイン失敗時
            // ログイン画面へリダイレクトして再入力を促す
            response.sendRedirect("LoginServlet");
        }
    }
}