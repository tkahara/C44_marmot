package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.LoginLogic;
import model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
            
    // GET: 直接このサーブレットが呼ばれた場合（通常はログイン画面へ）
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/login.jsp");
        dispatcher.forward(request, response);
    }

    // POST: ログインフォームからの送信
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String userId = request.getParameter("userId");
        String pass = request.getParameter("pass");
        
        // 🌟【追加】どこからログインボタンが押されたか（元のページのURL）を取得
        String referer = request.getHeader("Referer");
        
        model.Login login = new model.Login(userId, pass);
        LoginLogic bo = new LoginLogic();
        User account = bo.execute(login);
        
        HttpSession session = request.getSession();
        
        if (account != null) { 
            // 成功時：セッションに保存してメイン画面へリダイレクト
            account.setPassword(pass); 
            session.setAttribute("loginUser", account);
            response.sendRedirect("main"); 
        } else { 
            // 🔴 失敗時：リダイレクトされてもメッセージが消えないよう【セッション】に保存
            session.setAttribute("loginError", "IDまたはパスワードが正しくありません。");
            
            // 🌟【ここを大幅修正】JSPへの直接フォワードを廃止し、元のURLへリダイレクトする
            if (referer != null && !referer.contains("LoginServlet")) {
                // 商品詳細画面やカート画面など、ログインボタンを押した「その場」へ戻す
                response.sendRedirect(referer);
            } else {
                // 保険：元のページが取れなかった場合は、商品一覧の「サーブレット（main）」へリダイレクト
                response.sendRedirect("main");
            }
        }
    }
}