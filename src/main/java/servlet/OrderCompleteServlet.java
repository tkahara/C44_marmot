package servlet;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.OrderDAO;
import model.Products;
import model.User;

@WebServlet("/OrderCompleteServlet")
public class OrderCompleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // 1. カート情報の取得
        Map<Products, Integer> cartMap = (Map<Products, Integer>) session.getAttribute("cartMap");
        if (cartMap == null || cartMap.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        // 2. 決済方法の取得
        String paymentMethod = request.getParameter("payment");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = (String) session.getAttribute("guestPayment");
        }

        // 3. ユーザー情報の取得
        User loginUser = (User) session.getAttribute("loginUser");
        Integer userId = (loginUser != null) ? Integer.parseInt(loginUser.getUserId()) : null;
        
        String name = (loginUser != null) ? loginUser.getUserName() : (String) session.getAttribute("guestName");
        String zip = (loginUser != null) ? loginUser.getPostalCode() : (String) session.getAttribute("guestZip");
        String address = (loginUser != null) ? loginUser.getAddress() : (String) session.getAttribute("guestAddress");
        String email = (loginUser != null) ? loginUser.getEmail() : (String) session.getAttribute("guestEmail");
        String phone = (loginUser != null) ? loginUser.getPhoneNumber() : (String) session.getAttribute("guestTel");

        String cardNumber = (String) session.getAttribute("guestCardNumber");
        String cardName = (String) session.getAttribute("guestCardName");
        String cardExpiration = (String) session.getAttribute("guestCardExpiration");

        // 4. DB保存処理
        OrderDAO orderDAO = new OrderDAO();
        boolean isSuccess = orderDAO.insertOrders(
            userId, paymentMethod, name, zip, address, email, phone, 
            cardNumber, cardName, cardExpiration, cartMap
        );

        if (isSuccess) {
            // 成功：注文完了フラグをセットして完了画面へ
            session.setAttribute("isOrderCompleted", true);
            
            session.setAttribute("confirmedName", name);
            session.setAttribute("confirmedAddress", address);
            session.setAttribute("confirmedPayment", paymentMethod);
            
            // カートとゲスト情報のクリア
            session.removeAttribute("cartMap");
            session.removeAttribute("guestName");
            session.removeAttribute("guestZip");
            session.removeAttribute("guestAddress");
            session.removeAttribute("guestEmail");
            session.removeAttribute("guestTel");
            session.removeAttribute("guestPayment");
            session.removeAttribute("guestCardNumber");
            session.removeAttribute("guestCardName");
            session.removeAttribute("guestCardExpiration");

            response.sendRedirect(request.getContextPath() + "/complete.jsp");
        } else {
            // 失敗：セッションにエラーメッセージをセットしてメインへ
            session.setAttribute("errorMessage", "注文処理中に問題が発生しました。再度お試しください。");
            response.sendRedirect(request.getContextPath() + "/main");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/main");
    }
}