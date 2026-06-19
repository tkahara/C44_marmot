package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.RegisterLogic; // 💡 作成した RegisterLogic をインポート
import model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/register.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 1. パラメータの取得（JSP側のname属性と一致させます）
        String userId = request.getParameter("userId");
        String pass = request.getParameter("pass");
        String name = request.getParameter("name");
        String postalCode = request.getParameter("postalCode"); 
        String address = request.getParameter("address");
        String mail = request.getParameter("mail");
        String tel = request.getParameter("tel");
        String cardNum = request.getParameter("cardNum");
        String cardName = request.getParameter("cardName");     
        String cardExpiration = request.getParameter("cardExpiration"); 
        
        // Userインスタンスの組み立て
        User newUser = new User(userId, name, pass, postalCode, address, mail, tel, cardNum, cardName, cardExpiration);
        
        // 💡 2. RegisterLogicに重複チェックから登録までを一任する
        RegisterLogic registerLogic = new RegisterLogic();
        boolean isSuccess = registerLogic.execute(newUser);
        
        // 3. 結果に応じた画面遷移
        if (isSuccess) {
            // 🌟 登録成功：自動ログイン状態にしてメイン画面へ
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", newUser); 
            
            response.sendRedirect("main");
        } else {
            // ❌ 登録失敗（ID重複またはDBエラー）
            request.setAttribute("msg", "このユーザーIDは既に登録されているか、入力エラーです。");
            request.setAttribute("registeredUser", newUser); // 💡 入力値をJSPへ送り返す
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/register.jsp");
            dispatcher.forward(request, response);
        }
    }
}