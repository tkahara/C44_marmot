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

        // ==============================
        // 🔥① すでに注文済みチェック
        // ==============================
        Boolean alreadyOrdered = (Boolean) session.getAttribute("alreadyOrdered");

        if (alreadyOrdered != null && alreadyOrdered) {
            session.setAttribute("errorMessage",
                    "この注文はすでに完了しています。再度購入する場合はカートからやり直してください。");
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        // 1. カート情報の取得
        Map<Products, Integer> cartMap =
                (Map<Products, Integer>) session.getAttribute("cartMap");

        if (cartMap == null || cartMap.isEmpty()) {
            session.setAttribute("errorMessage", "カートが空のため購入できません。");
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        // 2. 決済方法
        String paymentMethod = request.getParameter("payment");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = (String) session.getAttribute("guestPayment");
        }

        // 3. ユーザー情報の取得
        // 🌟 userId はデータベース連携（会員かゲストかの判別）のために loginUser から取得
        User loginUser = (User) session.getAttribute("loginUser");
        String userId = (loginUser != null) ? loginUser.getUserId() : null;

        // 🌟【大修正】OrderConfirmServletが一本化してくれた共通セッション（order〜）から直接取得
        String name = (String) session.getAttribute("orderName");
        String zip = (String) session.getAttribute("orderZip");
        String address = (String) session.getAttribute("orderAddress");
        String email = (String) session.getAttribute("orderEmail");
        String phone = (String) session.getAttribute("orderTel");

        // クレジットカード情報（確認画面等の実装に合わせて適宜調整）
        String cardNumber = (String) session.getAttribute("guestCardNumber");
        String cardName = (String) session.getAttribute("guestCardName");
        String cardExpiration = (String) session.getAttribute("guestCardExpiration");

        // 🌟【安全対策】DB処理や予期せぬエラーで画面が真っ白(500エラー)になるのを防ぐ
        try {
            // 4. DB保存
            OrderDAO orderDAO = new OrderDAO();

            boolean isSuccess = orderDAO.insertOrders(
                    userId, paymentMethod, name, zip, address, email, phone,
                    cardNumber, cardName, cardExpiration, cartMap
            );

            if (isSuccess) {
                // ==============================
                // 🔥② 成功時フラグセット
                // ==============================
                session.setAttribute("alreadyOrdered", true);
                session.setAttribute("isOrderCompleted", true);
                
                // 🌟 complete.jsp が表示で使用するデータをセッションに退避
                session.setAttribute("confirmedCart", cartMap);
                session.setAttribute("confirmedCardNumber", cardNumber);
                session.setAttribute("confirmedName", name);
                session.setAttribute("confirmedAddress", address);
                session.setAttribute("confirmedPayment", paymentMethod);

                // カート削除
                session.removeAttribute("cartMap");

                // 🌟【修正】使い終わった共通オーダー情報をセッションから綺麗にお掃除
                session.removeAttribute("orderName");
                session.removeAttribute("orderEmail");
                session.removeAttribute("orderZip");
                session.removeAttribute("orderAddress");
                session.removeAttribute("orderTel");
                
                // ゲスト用決済情報の削除
                session.removeAttribute("guestPayment");
                session.removeAttribute("guestCardNumber");
                session.removeAttribute("guestCardName");
                session.removeAttribute("guestCardExpiration");

                response.sendRedirect(request.getContextPath() + "/complete.jsp");

            } else {
                session.setAttribute("errorMessage", "注文処理中に問題が発生しました。再度お試しください。");
                response.sendRedirect(request.getContextPath() + "/main");
            }
            
        } catch (Exception e) {
            e.printStackTrace(); 
            session.setAttribute("errorMessage", "注文処理中に予期せぬエラーが発生しました。");
            response.sendRedirect(request.getContextPath() + "/main");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/main");
    }
}