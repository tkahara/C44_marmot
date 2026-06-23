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
import model.User; // 🌟Userモデルをインポート

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

        // 2. ログイン状態のチェック
        // 🌟【修正】User型にキャストして取得することで、メソッドを使えるようにします
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            // 【ログインしていない場合】 ➔ ゲスト情報入力画面へフォワード
            request.getRequestDispatcher("/WEB-INF/jsp/guestInput.jsp").forward(request, response);
        } else {
            // =========================================================
            // 🌟【追加】すでにログインしている場合
            // 確認画面(checkoutConfirm.jsp)が表示で使用する「共通の箱」に
            // usersテーブルから取得してある会員情報をしっかりと詰め込む！
            // =========================================================
            session.setAttribute("orderName", loginUser.getUserName());
            session.setAttribute("orderEmail", loginUser.getEmail());
            session.setAttribute("orderZip", loginUser.getPostalCode());
            session.setAttribute("orderAddress", loginUser.getAddress());
            session.setAttribute("orderTel", loginUser.getPhoneNumber());

            // ➔ 直接、購入確認画面へフォワード
            request.getRequestDispatcher("/WEB-INF/jsp/checkoutConfirm.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}