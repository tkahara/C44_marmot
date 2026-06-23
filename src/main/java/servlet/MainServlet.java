package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.ProductsDAO;
import model.Products;

@WebServlet("/main") 
public class MainServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();

        // =========================================================
        // 🌟【ここを追加！】メイン画面に来たら「注文済みフラグ」をリセットし、
        // 次の新しい買い物ができるようにする
        // =========================================================
        session.removeAttribute("alreadyOrdered");

        // セッションからエラーメッセージ（または識別子）を取得
        String error = (String) session.getAttribute("errorMessage");
        
        // メッセージが存在すればリクエストスコープに移し、セッションからは即座に削除
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("errorMessage");
        }
        
        // 1. 商品リストを取得
        ProductsDAO dao = new ProductsDAO();
        List<Products> productsList = dao.findAll();
        
        // 2. リクエストスコープに保存
        request.setAttribute("productsList", productsList);
        
        // 3. JSPへフォワード
        request.getRequestDispatcher("/WEB-INF/jsp/main.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}