package servlet;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import model.Account; // 💡新クラスをインポート
import model.GetMutterListLogic;
import model.Mutter;
import model.PostMutterLogic;

@WebServlet("/Main")
@MultipartConfig(
  fileSizeThreshold = 1024 * 1024, // 1MB
  maxFileSize = 5 * 1024 * 1024,     // 5MB
  maxRequestSize = 10 * 1024 * 1024  // 10MB
)
public class Main extends HttpServlet {
  private static final long serialVersionUID = 1L;
  
  // GET: 一覧表示
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    // セッションスコープの取得
	    HttpSession session = request.getSession();
	    Account loginUser = (Account) session.getAttribute("loginUser");

	    // 💡【追加】もしセッションにユーザー情報がない場合（ブラウザを開いた直後など）
	    if (loginUser == null) {
	        System.out.println("==========================================");
	        System.out.println("★ログイン情報がないため、keg_tester で自動ログインを実行します");
	        System.out.println("==========================================");
	        
	        // 自動ログインさせたいテストユーザーのIDとパスワードを設定
	        model.Login login = new model.Login("keg_tester", "1234");
	        dao.AccountsDAO dao = new dao.AccountsDAO();
	        
	        // データベースからユーザー情報を取得
	        loginUser = dao.findByLogin(login);
	        
	        if (loginUser != null) {
	            // セッションにユーザー情報を保存（これでメイン画面やマイページで名前が表示されます）
	            session.setAttribute("loginUser", loginUser);
//	            System.out.println("➔ 自動ログイン成功: " + loginUser.getName() + "さん");
	        } else {
	            System.err.println("➔ 【警告】自動ログインに失敗しました。keg_tester がDBに存在するか確認してください。");
	        }
	    }

	    // ─── ここから下は、元々 Main.java に書かれていた「つぶやき一覧の取得と表示」の処理 ───
	    // (※お使いの環境の既存コードに合わせてください。一般的な流れは以下のようになります)
	    
	    // つぶやきリストを取得してリクエストスコープに設定するロジックなど
	    // model.GetMutterListLogic getMutterListLogic = new model.GetMutterListLogic();
	    // List<Mutter> mutterList = getMutterListLogic.execute();
	    // request.setAttribute("mutterList", mutterList);

	    // メイン画面（main.jsp）へフォワード
	    RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/main.jsp");
	    dispatcher.forward(request, response);
	  }
  
  // POST: つぶやき投稿処理（画像アップロード対応）
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    String text = request.getParameter("text");
    
    // 入力値チェック
    if (text != null && text.length() != 0) {
      HttpSession session = request.getSession();
      Account loginUser = (Account) session.getAttribute("loginUser"); // ★ここもAccountに統一
      
      // ログインが切れていた場合の安全策
      if (loginUser == null) {
        response.sendRedirect("index.jsp");
        return;
      }
      
      // 画像データの取得
      Part imagePart = request.getPart("image");
      byte[] imageData = null;
      if (imagePart != null && imagePart.getSize() > 0) {
        try (InputStream is = imagePart.getInputStream();
             ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {
          byte[] data = new byte[1024];
          int nRead;
          while ((nRead = is.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
          }
          buffer.flush();
          imageData = buffer.toByteArray();
        }
      }
      
      // つぶやきオブジェクトの作成（※loginUser.getUserId() を使用）
      Mutter mutter = new Mutter(loginUser.getUserId(), text, imageData);
      
      // 投稿処理の実行
      PostMutterLogic postMutterLogic = new PostMutterLogic();
      postMutterLogic.execute(mutter);
    } else {
      request.setAttribute("errorMsg", "つぶやきが入力されていません");
    }
    
    // 最新のつぶやきリストを取得して画面表示
    GetMutterListLogic getMutterListLogic = new GetMutterListLogic();
    List<Mutter> mutterList = getMutterListLogic.execute();
    request.setAttribute("mutterList", mutterList);
    
    RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/main.jsp");
    dispatcher.forward(request, response);
  }
}