package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.ProductsDAO;
import model.Products;

@WebServlet("/productDetail")
public class ProductDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 商品詳細画面を通常表示する処理（リンクをクリックした時など）
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productName = request.getParameter("productName");
        
        if (productName != null && !productName.isEmpty()) {
            ProductsDAO dao = new ProductsDAO();
            Products products = dao.findByName(productName);
            request.setAttribute("products", products);
        }
        
        request.getRequestDispatcher("WEB-INF/jsp/ProductDetail.jsp").forward(request, response);
    }

    /**
     * ★【追加】詳細画面で「カートに追加」ボタンを押した時の処理
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. 画面のフォームから「商品名」と選ばれた「数量」を取得
        String productName = request.getParameter("productName");
        String qtyStr = request.getParameter("quantity");
        
        int quantity = 1; // デフォルトは1点
        if (qtyStr != null && !qtyStr.isEmpty()) {
            quantity = Integer.parseInt(qtyStr); // 画面から送られてきた数字に変換
        }
        
        if (productName != null && !productName.isEmpty()) {
            ProductsDAO dao = new ProductsDAO();
            Products selectedProduct = dao.findByName(productName);
            
            if (selectedProduct != null) {
                // 2. セッションスコープから現在のカート（リスト）を取得
                HttpSession session = request.getSession();
                List<Products> cart = (List<Products>) session.getAttribute("cart");
                
                // 初めてカートに商品を入れる場合は、新しくリストを作る
                if (cart == null) {
                    cart = new ArrayList<>();
                }
                
                // ★【重要】選ばれた数量の数だけ、同じ商品をカートのリストに連続で追加する
                for (int i = 0; i < quantity; i++) {
                    cart.add(selectedProduct);
                }
                
                // 3. カートをセッションに上書き保存
                session.setAttribute("cart", cart);
            }
        }
        
        // 4. 追加が終わったら、商品名と「added=true」という目印をつけて、自分自身（doGet）にリダイレクト！
        response.sendRedirect("productDetail?productName=" + java.net.URLEncoder.encode(productName, "UTF-8") + "&added=true");
    }
}