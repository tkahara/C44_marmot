package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.ProductsDAO;
import model.Products;

@WebServlet("/main") // ★ブラウザからは「http://.../main」でアクセスします
public class MainServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. DAOを呼び出して、全商品のリストを取得
        ProductsDAO dao = new ProductsDAO();
        List<Products> productsList = dao.findAll();
        
        // 2. リクエストスコープに「productsList」という名前で保存
        request.setAttribute("productsList", productsList);
        
        // 3. main.jsp（商品一覧画面）へフォワード
        request.getRequestDispatcher("main.jsp").forward(request, response);
    }
}