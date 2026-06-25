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
        
        // 1. パラメータの取得（ユーザーが画面に入力したそのままの生データ）
        String userId = request.getParameter("userId");
        String pass = request.getParameter("pass");
        String name = request.getParameter("name");
        String postalCodeRaw = request.getParameter("postalCode"); 
        String address = request.getParameter("address");
        String mail = request.getParameter("mail");
        String telRaw = request.getParameter("tel");
        String cardNumRaw = request.getParameter("cardNum");
        String cardNameRaw = request.getParameter("cardName");     
        String cardExpirationRaw = request.getParameter("cardExpiration"); 
        
        // 🌟 バリデーションおよびDB保存用に数値をクレンジング
        String postalCode = (postalCodeRaw != null) ? postalCodeRaw.replaceAll("\\D", "") : "";
        String tel = (telRaw != null) ? telRaw.replaceAll("\\D", "") : "";
        String cardNum = (cardNumRaw != null) ? cardNumRaw.replaceAll("\\D", "") : "";
        String cardName = (cardNameRaw != null) ? cardNameRaw.trim().toUpperCase() : "";
        String cardExpiration = (cardExpirationRaw != null) ? cardExpirationRaw.trim() : "";
        
        // 🚨 登録失敗時に「画面の入力状態（ハイフンあり）」をそのまま復元するためのバックアップ用インスタンス
        User backupUser = new User(userId, name, pass, postalCodeRaw, address, mail, telRaw, cardNumRaw, cardNameRaw, cardExpirationRaw);
        
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

        // 📮 郵便番号チェック（クレンジング後の桁数で判定）
        if (postalCode == null || postalCode.length() != 7) {
            errorMsg.append("・郵便番号は7桁の数字で入力してください。<br>");
        }

        // 📍 住所チェック
        if (address == null || address.trim().isEmpty()) {
            errorMsg.append("・ご住所を入力してください。<br>");
        }

        // 📞 電話番号チェック（クレンジング後の桁数で判定）
        if (tel == null || tel.length() < 10 || tel.length() > 11) {
            errorMsg.append("・電話番号は10桁または11桁の数字で入力してください。<br>");
        }

        // 💳 クレジットカードバリデーション（連動型）
        boolean hasCardName = (cardName != null && !cardName.isEmpty());
        boolean hasCardNum = (cardNum != null && !cardNum.isEmpty());
        boolean hasCardExpiry = (cardExpiration != null && !cardExpiration.isEmpty());

        // どこか1つでも入力されている場合のみチェック
        if (hasCardName || hasCardNum || hasCardExpiry) {
            if (!hasCardName || !hasCardNum || !hasCardExpiry) {
                errorMsg.append("・クレジットカード情報を登録する場合は、名義人・番号・有効期限をすべて入力してください。<br>");
            } else {
                // カード番号桁数チェック
                if (cardNum.length() != 16) {
                    errorMsg.append("・カード番号は16桁の数字で入力してください。<br>");
                }
                // 有効期限形式チェック (MM/YY)
                if (!cardExpiration.matches("^\\d{2}/\\d{2}$")) {
                    errorMsg.append("・有効期限は「月月/年年 (例: 12/29)」の形式で入力してください。<br>");
                } else {
                    // 月が01〜12の範囲内か
                    try {
                        int month = Integer.parseInt(cardExpiration.split("/")[0]);
                        if (month < 1 || month > 12) {
                            errorMsg.append("・有効期限の「月']は01〜12の間で指定してください。<br>");
                        }
                    } catch (Exception e) {
                        errorMsg.append("・有効期限の形式が不正です。<br>");
                    }
                }
            }
        }

        // 🚨 形式エラーが1つでもあれば、JSPへ戻す（画面の見た目を維持するため backupUser を渡す）
        if (errorMsg.length() > 0) {
            request.setAttribute("msg", errorMsg.toString());
            request.setAttribute("registeredUser", backupUser);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/register.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // 💡 2. 形式がすべて正常なら、ここで初めて【DB保存用のクレンジング済データ】でUserインスタンスを作成
        User newUser = new User(userId, name, pass, postalCode, address, mail, tel, cardNum, cardName, cardExpiration);
        
        // RegisterLogicに一任する
        RegisterLogic registerLogic = new RegisterLogic();
        
        // 🌟 String で詳細なエラーメッセージを受け取る
        String dbErrorMsg = registerLogic.execute(newUser);
        
        // 3. 結果に応じた画面遷移
        if (dbErrorMsg == null) {
            // 🟢 登録成功（エラーメッセージがない）場合：自動ログイン状態にしてメイン画面へ
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", newUser); 
            
            // 🌟 登録成功フラグをセッションに入れる（main.jsp側などのポップアップ表示トリガーになります）
            session.setAttribute("registerSuccess", true);
            
            response.sendRedirect("main");
        } else {
            // 🔴 登録失敗（IDやメアドのDB重複など）：画面表示用にハイフンありの backupUser をセットして戻す
            request.setAttribute("msg", dbErrorMsg);
            request.setAttribute("registeredUser", backupUser);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/register.jsp");
            dispatcher.forward(request, response);
        }
    }
}