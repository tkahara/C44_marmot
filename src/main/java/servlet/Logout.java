package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Logout")
public class Logout extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 💡 ダイアログ内の form method="post" から呼ばれるため doPost を用意
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションを取得して破棄
        HttpSession session = request.getSession(false); // 既存セッションのみ取得
        if (session != null) {
            session.invalidate();
        }

        // ログアウト完了後、メイン画面（商品一覧）へリダイレクト
        response.sendRedirect("main");
    }

    // 必要であれば doGet も同様に設定
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}