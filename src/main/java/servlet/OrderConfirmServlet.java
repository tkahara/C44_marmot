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
        
        // リクエストの文字化け防止
        request.setCharacterEncoding("UTF-8");
        
        // guestInput.jsp から送られてきた入力値を取得
        // 🌟【修正】JSPの name="guestName" に合わせて受け取り口を変更しました
        String userName = request.getParameter("guestName");
        String email = request.getParameter("email");
        String zipCode = request.getParameter("zipCode");
        String address = request.getParameter("address");
        String tel = request.getParameter("tel");
        String payment = request.getParameter("payment");
        
        // クレジットカード情報の取得
        String guestCardName = request.getParameter("guestCardName");
        String guestCardNumber = request.getParameter("guestCardNumber");
        String guestCardExpiry = request.getParameter("guestCardExpiry");
        
        // 入力された情報を次の画面でも使えるようにセッションに保存
        HttpSession session = request.getSession();
        session.setAttribute("guestName", userName); // ここは変更なしでOK
        session.setAttribute("guestEmail", email);
        session.setAttribute("guestZip", zipCode);
        session.setAttribute("guestAddress", address);
        session.setAttribute("guestPayment", payment);
        session.setAttribute("guestTel", tel);
        
        // クレジットカード情報をセッションに保存
        session.setAttribute("guestCardName", guestCardName);
        session.setAttribute("guestCardNumber", guestCardNumber);
        session.setAttribute("guestCardExpiration", guestCardExpiry);
        
        // 購入確認画面（checkoutConfirm.jsp）へフォワード
        request.getRequestDispatcher("/WEB-INF/jsp/checkoutConfirm.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/main");
    }
}