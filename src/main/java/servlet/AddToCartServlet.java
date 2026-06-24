package servlet;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.ProductsDAO;
import model.Products;

@WebServlet("/addToCart") 
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. 詳細画面から送られてきた「商品名」と「選択された数量」を受け取る
        request.setCharacterEncoding("UTF-8"); // 文字化け防止を先頭に追加
        String productName = request.getParameter("productName");
        String qtyStr = request.getParameter("quantity");
        
        // 数量の初期値は1にしておき、JSPから送られてたら数値に変換する
        int quantity = 1;
        if (qtyStr != null && !qtyStr.isEmpty()) {
            quantity = Integer.parseInt(qtyStr);
        }
        
        // 2. セッションから現在のカート（Map構造）を取得（なければ新規作成）
        HttpSession session = request.getSession();
        Map<Products, Integer> cartMap = (Map<Products, Integer>) session.getAttribute("cartMap");
        if (cartMap == null) {
            cartMap = new LinkedHashMap<>(); // 順番を保持できるMap
        }
        
        // 3. データベースから商品を取得し、カート（Map）に追加・合算する
        if (productName != null && !productName.isEmpty()) {
            ProductsDAO dao = new ProductsDAO();
            Products selectedProduct = dao.findByName(productName);
            
            if (selectedProduct != null) {
                // すでにカート内に同じ商品名が存在するかチェック
                Products existProduct = null;
                for (Products p : cartMap.keySet()) {
                    if (p.getProductName().equals(selectedProduct.getProductName())) {
                        existProduct = p;
                        break;
                    }
                }
                
                if (existProduct != null) {
                    // 🌟すでにある場合は、現在の数量に新しく選ばれた数量を足し算（合算）
                    int totalQuantity = cartMap.get(existProduct) + quantity;
                    
                    // 【追加】合算して10個を超えていたら、強制的に10個にする
                    if (totalQuantity > 10) {
                        totalQuantity = 10;
                    }
                    
                    cartMap.put(existProduct, totalQuantity);
                } else {
                    // 🌟初めて追加する商品の場合は、そのまま数量をセット
                    int totalQuantity = quantity;
                    
                    // 【追加】念のため、最初から10個より多く選ばれていた場合も10個にする
                    if (totalQuantity > 10) {
                        totalQuantity = 10;
                    }
                    
                    cartMap.put(selectedProduct, totalQuantity);
                }
            }
        }
        // セッションに「cartMap」という名前で上書き保存
        session.setAttribute("cartMap", cartMap);
        
        // ================================================================
        // ★【Map版】元の画面へ戻し、さらにサイドカートを自動で開く処理
        // ================================================================
        String referer = request.getHeader("Referer");
        
        if (referer != null && !referer.isEmpty()) {
            String redirectUrl;
            if (referer.contains("added=true")) {
                redirectUrl = referer;
            } else if (referer.contains("?")) {
                redirectUrl = referer + "&added=true";
            } else {
                redirectUrl = referer + "?added=true";
            }
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("MainServlet");
        }
    }
}