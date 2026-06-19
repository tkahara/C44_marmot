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
        
        model.Login login = new model.Login(userId, pass);
        LoginLogic bo = new LoginLogic();
        User account = bo.execute(login);
        
        if (account != null) { 
            // 🌟 成功時：セッションに保存してメイン画面へリダイレクト
            account.setPassword(pass); 
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", account);
            response.sendRedirect("main"); 
        } else { 
            // 失敗時
            request.setAttribute("loginError", "IDまたはパスワードが正しくありません。");
            
            // 💡 main ではなく、商品一覧を表示しているJSPへフォワードする
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/main.jsp");
            dispatcher.forward(request, response);
        }
    }
}