package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.RegisterLogic;
import model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/register.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 1. パラメータの取得
        String userId = request.getParameter("userId");
        String pass = request.getParameter("pass");
        String name = request.getParameter("name");
        String postalCode = request.getParameter("postalCode"); 
        String address = request.getParameter("address");
        String mail = request.getParameter("mail");
        String tel = request.getParameter("tel");
        String cardNum = request.getParameter("cardNum");
        String cardName = request.getParameter("cardName");     
        String cardExpiration = request.getParameter("cardExpiration"); 
        
        // Userインスタンスを作る前に、郵便番号と電話番号のハイフン（数字以外）を完全に消去して上書き
        if (postalCode != null) { postalCode = postalCode.replaceAll("\\D", ""); }
        if (tel != null) { tel = tel.replaceAll("\\D", ""); }
        
        // 数字だけになった postalCode と tel を使って、Userインスタンスを組み立てる
        User newUser = new User(userId, name, pass, postalCode, address, mail, tel, cardNum, cardName, cardExpiration);
        
        // バリデーション（入力チェック）ロジック
        StringBuilder errorMsg = new StringBuilder();

        // 👤 ユーザーIDチェック
        if (userId == null || !userId.matches("^[a-zA-Z][a-zA-Z0-9_]{3,19}$")) {
            errorMsg.append("・ユーザーIDは半角英数字と(_)のみ、4〜20文字（先頭は英文字）で入力してください。<br>");
        }

        // 🔑 パスワードチェック
        if (pass == null || pass.length() < 6) {
            errorMsg.append("・パスワードは6文字以上で入力してください。<br>");
        }

        // 📛 お名前チェック
        if (name == null || name.trim().isEmpty()) {
            errorMsg.append("・お名前を入力してください。<br>");
        }

        // ✉️ メールアドレスチェック
        String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        if (mail == null || !mail.matches(emailPattern)) {
            errorMsg.append("・メールアドレスの形式が正しくありません。<br>");
        }

        // 📮 郵便番号チェック
        if (postalCode == null || postalCode.length() != 7) {
            errorMsg.append("・郵便番号は7桁の数字で入力してください。<br>");
        }

        // 📍 住所チェック
        if (address == null || address.trim().isEmpty()) {
            errorMsg.append("・ご住所を入力してください。<br>");
        }

        // 📞 電話番号チェック
        if (tel == null || tel.length() < 10 || tel.length() > 11) {
            errorMsg.append("・電話番号は10桁または11桁の数字で入力してください。<br>");
        }

        // 🚨 形式エラーが1つでもあれば、JSPへ戻す
        if (errorMsg.length() > 0) {
            request.setAttribute("msg", errorMsg.toString());
            request.setAttribute("registeredUser", newUser);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // 💡 2. 形式がすべて正常なら、RegisterLogicに一任する
        RegisterLogic registerLogic = new RegisterLogic();
        
        // 🌟【ここを変更】boolean ではなく String で詳細なエラーメッセージを受け取る
        String dbErrorMsg = registerLogic.execute(newUser);
        
        // 3. 結果に応じた画面遷移
        if (dbErrorMsg == null) {
            // 🟢 登録成功（エラーメッセージがない）場合：自動ログイン状態にしてメイン画面へ
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", newUser); 
            
            response.sendRedirect("main");
        } else {
            // 🔴 登録失敗：Logic から戻ってきた具体的なメッセージ（重複 or システムエラー）をそのまま画面にセット
            request.setAttribute("msg", dbErrorMsg);
            request.setAttribute("registeredUser", newUser);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/register.jsp");
            dispatcher.forward(request, response);
        }
    }
}