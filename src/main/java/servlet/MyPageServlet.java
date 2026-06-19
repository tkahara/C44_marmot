package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.UsersDAO;
import model.User;
import model.Order;

@WebServlet("/MyPageServlet") // 💡実際の遷移先URLマッピングに合わせてください
public class MyPageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * マイページ表示要求（GETリクエスト）を受信したときの処理
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. セッションスコープからログイン状態のユーザー情報を取得
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        // ログインしていない場合は、ログイン画面へ強制リダイレクト
        if (loginUser == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // 2. 💡【重要】DAOを使って、ログイン中ユーザーの購入履歴をDB（ORDERSテーブル）から取得
        UsersDAO dao = new UsersDAO();
        List<Order> orderHistory = dao.getOrderHistory(loginUser.getUserId());

        // 3. 💡【重要】取得した購入履歴リストをリクエストスコープに保存（JSPへ引き渡すため）
        request.setAttribute("orderHistory", orderHistory);

        // 4. マイページ画面（myPage.jsp）へフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/myPage.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * POSTリクエスト時も同様にマイページを表示するよう設定
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}