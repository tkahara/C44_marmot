package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;

@WebServlet("/EditAccountServlet")
public class EditAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String JDBC_URL = "jdbc:mysql://localhost/keg_db?useSSL=false&allowPublicKeyRetrieval=true";
    private final String DB_USER = "keg_user";
    private final String DB_PASS = "keg_pass";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String field = request.getParameter("field");
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String fieldLabel = "";
        String currentValue = "";

        if (field != null) {
            field = field.toLowerCase();
            if (field.equals("pass")) field = "password";
            if (field.equals("name")) field = "user_name";
            if (field.equals("mail")) field = "email";
            if (field.equals("tel")) field = "phone_number";
            if (field.equals("card_num")) field = "card_number";
        }

        switch (field) {
            case "password":
                fieldLabel = "パスワード";
                currentValue = loginUser.getPassword();
                break;
            case "user_name":
                fieldLabel = "氏名";
                currentValue = loginUser.getUserName();
                break;
            case "postal_code": 
                fieldLabel = "郵便番号";
                currentValue = loginUser.getPostalCode();
                break;
            case "address":
                fieldLabel = "配送先住所";
                currentValue = loginUser.getAddress();
                break;
            case "email":
                fieldLabel = "メールアドレス";
                currentValue = loginUser.getEmail();
                break;
            case "phone_number":
                fieldLabel = "電話番号";
                currentValue = loginUser.getPhoneNumber();
                break;
            case "card_number":
                fieldLabel = "クレジットカード番号";
                currentValue = loginUser.getCardNumber();
                break;
            case "card_name": 
                fieldLabel = "カード名義";
                currentValue = loginUser.getCardName();
                break;
            case "card_expiration": 
                fieldLabel = "カード有効期限";
                currentValue = loginUser.getCardExpiration();
                break;
        }

        request.setAttribute("field", field);
        request.setAttribute("fieldLabel", fieldLabel);
        request.setAttribute("currentValue", currentValue);

        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/editAccount.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String field = request.getParameter("field");
        String newValue = request.getParameter("newValue");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        if (field != null) {
            field = field.toLowerCase();
            if (field.equals("pass")) field = "password";
            if (field.equals("name")) field = "user_name";
            if (field.equals("mail")) field = "email";
            if (field.equals("tel")) field = "phone_number";
            if (field.equals("card_num")) field = "card_number";
        }

        String sql = "UPDATE USERS SET " + field + " = ? WHERE user_id = ?";

        try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) { throw new IllegalStateException(e); }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
             PreparedStatement pStmt = conn.prepareStatement(sql)) {

            if (newValue == null || newValue.isEmpty()) {
                if (field.equals("card_number") || field.equals("card_name") || field.equals("card_expiration")) {
                    pStmt.setNull(1, java.sql.Types.VARCHAR);
                } else {
                    pStmt.setString(1, newValue);
                }
            } else {
                pStmt.setString(1, newValue);
            }
            
            pStmt.setString(2, loginUser.getUserId());
            int result = pStmt.executeUpdate();

            if (result == 1) {
                switch (field) {
                    case "password":
                        loginUser.setPassword(newValue);
                        break;
                    case "user_name":
                        loginUser.setUserName(newValue);
                        break;
                    case "postal_code":
                        loginUser.setPostalCode(newValue);
                        break;
                    case "address":
                        loginUser.setAddress(newValue);
                        break;
                    case "email":
                        loginUser.setEmail(newValue);
                        break;
                    case "phone_number":
                        loginUser.setPhoneNumber(newValue);
                        break;
                    case "card_number":
                        loginUser.setCardNumber(newValue);
                        break;
                    case "card_name":
                        loginUser.setCardName(newValue);
                        break;
                    case "card_expiration":
                        loginUser.setCardExpiration(newValue);
                        break;
                }
                session.setAttribute("loginUser", loginUser);
            }
         // ⭕ 修正後（エラーが起きたらTomcatのエラー画面を表示して原因を教えてくれる）
        } catch (SQLException e) {
            e.printStackTrace();
            // 🌟発生したSQLエラーをそのままスローして画面に表示させる
            throw new ServletException("データベースの更新に失敗しました。カラム名やデータ型、入力値を確認してください。", e);
        }

        // 🌟正常に更新できたときだけリダイレクトする
        response.sendRedirect(request.getContextPath() + "/MyPageServlet");
    }
}