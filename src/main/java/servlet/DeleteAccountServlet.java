package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.UsersDAO;
import model.User;

@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        // ログインしていない場合はメインへ
        if (loginUser == null) {
            response.sendRedirect("Main");
            return;
        }

        // DAOを呼び出して、履歴とアカウントを削除
        UsersDAO usersDAO = new UsersDAO();
        boolean isSuccess = usersDAO.deleteAccount(loginUser.getUserId());

     // --- DeleteAccountServlet.java の成功時の処理部分 ---

        if (isSuccess) {
            session.invalidate();
            System.out.println("★退会処理が正常に完了しました。セッションを破棄しました。");
            
            // 🌟 修正：URLの末尾に「?withdrawn=true」という目印を付与してリダイレクト
            response.sendRedirect(request.getContextPath() + "/main?withdrawn=true");
            return;
        } else {
            System.err.println("【エラー】退会処理に失敗しました。");
            // 失敗した場合はひとまずマイページ（Mainなど環境に合わせたURL）に戻す
            response.sendRedirect("main"); 
        }
    }
}