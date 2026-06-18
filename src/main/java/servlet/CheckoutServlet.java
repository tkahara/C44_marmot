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

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. カートが空かどうかのチェック
        Map<Products, Integer> cartMap = (Map<Products, Integer>) session.getAttribute("cartMap");
        if (cartMap == null || cartMap.isEmpty()) {
            // カートが空ならメイン画面（商品一覧）にリダイレクト
            response.sendRedirect(request.getContextPath() + "/MainServlet");
            return;
        }

        // 2. ログイン状態のチェック（セッションにログインユーザー情報があるか）
        // ※あなたの現在のログイン機能に合わせて "loginUser" などのキー名は適宜書き換えてください
        Object loginUser = session.getAttribute("loginUser");

        if (loginUser == null) {
            // 【ログインしていない場合】 ➔ ゲスト情報入力画面へフォワード
            request.getRequestDispatcher("/WEB-INF/jsp/guestInput.jsp").forward(request, response);
        } else {
            // 【すでにログインしている場合】 ➔ 直接、購入確認画面（のちほど作成）へフォワード
            request.getRequestDispatcher("/WEB-INF/jsp/checkoutConfirm.jsp").forward(request, response);
        }
    }

    // サイドカートのボタン（aタグ）からの遷移は通常GETリクエストになるため、
    // POSTで来ても処理できるようにdoGetを呼び出すようにしておきます
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
