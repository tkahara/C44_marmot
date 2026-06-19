package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/OrderConfirmServlet")
public class OrderConfirmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // 1. ログインユーザー情報を取得
        model.User loginUser = (model.User) session.getAttribute("loginUser");
        
        String userName, email, zip, address, tel;

        if (loginUser != null) {
            // 🌟 ログイン中の場合：Userクラスのメソッドを呼び出す
            userName = loginUser.getUserName();
            email = loginUser.getEmail();
            zip = loginUser.getPostalCode();
            address = loginUser.getAddress();
            tel = loginUser.getPhoneNumber();
        } else {
            // ゲストの場合：フォームからの入力値を取得
            userName = request.getParameter("guestName");
            email = request.getParameter("email");
            zip = request.getParameter("zipCode");
            address = request.getParameter("address");
            tel = request.getParameter("tel");
        }

        // 2. セッションへ保存（確認画面で使用）
        session.setAttribute("orderName", userName);
        session.setAttribute("orderEmail", email);
        session.setAttribute("orderZip", zip);
        session.setAttribute("orderAddress", address);
        session.setAttribute("orderTel", tel);
        
        // 3. 次の画面へ
        request.getRequestDispatcher("/WEB-INF/jsp/checkoutConfirm.jsp").forward(request, response);
    }
}