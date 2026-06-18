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

@WebServlet("/OrderCompleteServlet")
public class OrderCompleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. セッションからカート情報(cartMap)を取得
        Map<Products, Integer> cartMap = (Map<Products, Integer>) session.getAttribute("cartMap");
        
        // カートが空の場合は、不正なアクセスとしてトップに戻す
        if (cartMap == null || cartMap.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }

        // 2. セッションからゲスト情報、およびログインユーザー情報を取得
        Integer userId = null; 
        // ※将来的にログイン機能と紐付ける場合はここに追記

        String guestName = (String) session.getAttribute("guestName");
        String guestPostalCode = (String) session.getAttribute("guestZip");
        String guestAddress = (String) session.getAttribute("guestAddress");
        String guestEmail = (String) session.getAttribute("guestEmail");
        String guestPhone = (String) session.getAttribute("guestTel");
        String paymentMethod = (String) session.getAttribute("guestPayment");

        // 🌟【追加】セッションからクレジットカード情報を取得
        String guestCardNumber = (String) session.getAttribute("guestCardNumber");
        String guestCardName = (String) session.getAttribute("guestCardName");
        String guestCardExpiration = (String) session.getAttribute("guestCardExpiration");

        // 3. OrderDAO を使ってデータベース（MySQL）に注文情報を保存
        OrderDAO orderDAO = new OrderDAO();
        // 🌟【修正】新しく拡張した引数（3つのカード情報）をDAOに渡すように変更
        boolean isSuccess = orderDAO.insertOrders(
            userId, paymentMethod, 
            guestName, guestPostalCode, guestAddress, guestEmail, guestPhone, 
            guestCardNumber, guestCardName, guestCardExpiration, 
            cartMap
        );

        if (isSuccess) {
            // 【変更】リダイレクト先（complete.jsp）でもデータを表示できるよう、一時的にセッションに保存します
            session.setAttribute("confirmedCart", cartMap);
            session.setAttribute("confirmedPayment", paymentMethod);
            session.setAttribute("confirmedName", guestName);
            session.setAttribute("confirmedAddress", guestAddress);
            
            // 🌟【追加】完了画面（complete.jsp）でマスク表示をするためにカード番号をセッションに退避
            session.setAttribute("confirmedCardNumber", guestCardNumber);

            // カートの中身をクリア
            session.removeAttribute("cartMap");
            
            // 入力用ゲスト情報のクリア
            session.removeAttribute("guestName");
            session.removeAttribute("guestZip");
            session.removeAttribute("guestAddress");
            session.removeAttribute("guestEmail");
            session.removeAttribute("guestTel");
            session.removeAttribute("guestPayment");
            
            // 🌟【追加】用済みになったセッション内の生カード情報を確実にクリア（セキュリティ対策）
            session.removeAttribute("guestCardNumber");
            session.removeAttribute("guestCardName");
            session.removeAttribute("guestCardExpiration");

            // 【最終解決策】フォワードをやめ、webapp直下に置くcomplete.jspへリダイレクト
            response.sendRedirect(request.getContextPath() + "/complete.jsp");
            
        } else {
            // 万が一、DB保存に失敗した場合
            System.out.println("【エラー】注文情報のデータベース保存に失敗しました。");
            response.sendRedirect(request.getContextPath() + "/main");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/main");
    }
}