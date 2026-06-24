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

@WebServlet("/CartUpdateServlet")
public class CartUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // リクエストの文字化け防止
        request.setCharacterEncoding("UTF-8");
        
        // JSPから送られてくる値を受け取る
        String action = request.getParameter("action");
        String productName = request.getParameter("productName");
        String qtyStr = request.getParameter("quantity");
        
        HttpSession session = request.getSession();
        // ★最重要：List ではなく、JSPと統一した「cartMap」を取得する
        Map<Products, Integer> cartMap = (Map<Products, Integer>) session.getAttribute("cartMap");
        
        if (cartMap != null && productName != null && !productName.isEmpty()) {
            
            // カート内から商品名が一致するオブジェクトを探す
            Products targetProduct = null;
            for (Products p : cartMap.keySet()) {
                if (p.getProductName() != null && p.getProductName().equals(productName)) {
                    targetProduct = p;
                    break;
                }
            }
            
            // 対象の商品が見つかったら、アクションに応じて処理を分岐
            if (targetProduct != null) {
                if ("delete".equals(action)) {
                    // ★キャンセル処理：Mapから商品を完全に消去
                    cartMap.remove(targetProduct);
                } else if ("update".equals(action) && qtyStr != null) {
                    // ★数量変更処理：選択された新しい数量に書き換える
                    int newQty = Integer.parseInt(qtyStr);
                    
                    // 🌟【追加】上限ストッパー：もし10個を超えていたら強制的に10個にする
                    if (newQty > 10) {
                        newQty = 10;
                    }
                    
                    cartMap.put(targetProduct, newQty);
                }
            }
            
            // セッションのカート情報を最新の状態に上書き
            session.setAttribute("cartMap", cartMap);
        }
        
        // 元の画面（詳細画面 or 一覧画面）にサイドカートを開いた状態でリダイレクト
        String referer = request.getHeader("Referer");
        if (referer != null) {
            if (referer.contains("?")) {
                String cleanReferer = referer.replaceAll("[&?]added=true", "");
                String connector = cleanReferer.contains("?") ? "&" : "?";
                response.sendRedirect(cleanReferer + connector + "added=true");
            } else {
                response.sendRedirect(referer + "?added=true");
            }
        } else {
            response.sendRedirect("MainServlet");
        }
    }
}