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

        // 🌟【新規追加】決済情報の取得（ログイン/ゲスト共通）
        // JSPの <select name="payment"> から選択された値 ("credit", "bank", "cod" など) を取得
        String payment = request.getParameter("payment");
        session.setAttribute("payment", payment);

        // 💳 クレジットカード情報（"credit" が選ばれた場合のみ取得して保存）
        if ("credit".equals(payment)) {
            session.setAttribute("guestCardName", request.getParameter("guestCardName"));
            session.setAttribute("guestCardNumber", request.getParameter("guestCardNumber"));
            session.setAttribute("guestCardExpiry", request.getParameter("guestCardExpiry"));
        } else {
            // クレジットカード以外が選ばれた場合は、古い情報が残らないようセッションから削除
            session.removeAttribute("guestCardName");
            session.removeAttribute("guestCardNumber");
            session.removeAttribute("guestCardExpiry");
        }

        // 2. 個人情報をセッションへ保存（確認画面で使用）
        session.setAttribute("orderName", userName);
        session.setAttribute("orderEmail", email);
        session.setAttribute("orderZip", zip);
        session.setAttribute("orderAddress", address);
        session.setAttribute("orderTel", tel);
        
        // 3. 次の画面へ（checkoutConfirm.jsp）
        request.getRequestDispatcher("/WEB-INF/jsp/checkoutConfirm.jsp").forward(request, response);
    }
}