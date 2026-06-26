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
        
        model.User loginUser = (model.User) session.getAttribute("loginUser");
        String userName, email, zip, address, tel;

        if (loginUser != null) {
            userName = loginUser.getUserName();
            email = loginUser.getEmail();
            zip = loginUser.getPostalCode();
            address = loginUser.getAddress();
            tel = loginUser.getPhoneNumber();
        } else {
            userName = request.getParameter("guestName");
            email = request.getParameter("email");
            zip = request.getParameter("zipCode");
            address = request.getParameter("address");
            tel = request.getParameter("tel");
        }

        String payment = request.getParameter("payment");

        // 🛑【サーバー側最終バリデーション】不完全ならセッションを書き換えずに送り返す
        if (loginUser == null && "credit".equals(payment)) {
            String cardName = request.getParameter("guestCardName");
            String cardNum = request.getParameter("guestCardNumber");
            String cardExpiry = request.getParameter("guestCardExpiry");

            if (cardName == null || cardName.trim().isEmpty() ||
                cardNum == null || cardNum.trim().isEmpty() || cardNum.length() != 16 ||
                cardExpiry == null || !cardExpiry.contains("/")) {
                
                request.setAttribute("errorMessage", "クレジットカード情報が正しく入力されていません。修正してください。");
                // 入力画面のJSPのパスに合わせてフォワード先を変更してください
                request.getRequestDispatcher("/WEB-INF/jsp/guestInput.jsp").forward(request, response);
                return; 
            }
        }

        // チェック通過後のみセッション情報を更新
        session.setAttribute("payment", payment);

        if ("credit".equals(payment)) {
            session.setAttribute("guestCardName", request.getParameter("guestCardName"));
            session.setAttribute("guestCardNumber", request.getParameter("guestCardNumber"));
            session.setAttribute("guestCardExpiry", request.getParameter("guestCardExpiry"));
        } else {
            session.removeAttribute("guestCardName");
            session.removeAttribute("guestCardNumber");
            session.removeAttribute("guestCardExpiry");
        }

        session.setAttribute("orderName", userName);
        session.setAttribute("orderEmail", email);
        session.setAttribute("orderZip", zip);
        session.setAttribute("orderAddress", address);
        session.setAttribute("orderTel", tel);
        
        request.getRequestDispatcher("/WEB-INF/jsp/checkoutConfirm.jsp").forward(request, response);
    }
}