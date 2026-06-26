package servlet;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Products;
import model.User; 

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. カートが空かどうかのチェック
        @SuppressWarnings("unchecked")
        Map<Products, Integer> cartMap = (Map<Products, Integer>) session.getAttribute("cartMap");
        if (cartMap == null || cartMap.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        // 2. ログイン状態のチェック
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            // 【ログインしていない場合】 ➔ ゲスト情報入力画面へフォワード
            request.getRequestDispatcher("/WEB-INF/jsp/guestInput.jsp").forward(request, response);
        } else {
            // =========================================================
            // すでにログインしている場合
            // 🛠️【大修正】リクエストスコープではなくセッションスコープに統一！
            // 確認画面(checkoutConfirm.jsp)やOrderCompleteServletとロッカーを合わせる。
            // =========================================================
            session.setAttribute("orderName",    nullToEmpty(loginUser.getUserName()));
            session.setAttribute("orderEmail",   nullToEmpty(loginUser.getEmail()));
            session.setAttribute("orderZip",     nullToEmpty(loginUser.getPostalCode()));
            session.setAttribute("orderAddress", nullToEmpty(loginUser.getAddress()));
            session.setAttribute("orderTel",     nullToEmpty(loginUser.getPhoneNumber()));

            // ➔ 直接、購入確認画面へフォワード
            request.getRequestDispatcher("/WEB-INF/jsp/checkoutConfirm.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * 🌟 null値を安全に空文字に変換するユーティリティメソッド
     */
    private String nullToEmpty(String val) {
        return (val == null) ? "" : val;
    }
}