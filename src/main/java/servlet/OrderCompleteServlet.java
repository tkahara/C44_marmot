package servlet;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.OrderDAO;
import model.Products;
import model.User;

@WebServlet("/OrderCompleteServlet")
public class OrderCompleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();

		// ==============================
		// ① すでに注文済みチェック
		// ==============================
		Boolean alreadyOrdered = (Boolean) session.getAttribute("alreadyOrdered");

		if (alreadyOrdered != null && alreadyOrdered) {
			session.setAttribute("errorMessage",
					"この注文はすでに完了しています。再度購入する場合はカートからやり直してください。");
			response.sendRedirect(request.getContextPath() + "/main");
			return;
		}

		// 1. カート情報の取得
		Map<Products, Integer> cartMap = (Map<Products, Integer>) session.getAttribute("cartMap");

		if (cartMap == null || cartMap.isEmpty()) {
			session.setAttribute("errorMessage", "カートが空のため購入できません。");
			response.sendRedirect(request.getContextPath() + "/main");
			return;
		}

		// 2. 決済方法
		String paymentMethod = request.getParameter("payment");
		if (paymentMethod == null || paymentMethod.isEmpty()) {
			paymentMethod = (String) session.getAttribute("payment"); // 💡「payment」に統一
		}

		// 3. ユーザー情報の取得
		User loginUser = (User) session.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : null;

		// =========================================================
		// 🛑 クレジットカード情報の最終防衛バリデーション
		// =========================================================
		// =========================================================
		// 🛑 クレジットカード情報の最終防衛バリデーション
		// =========================================================
		if ("credit".equals(paymentMethod)) {
			boolean isCardEmpty = false;

			if (loginUser != null) {
				// 👤 会員の場合：ログインユーザーの保持するカード番号をチェック
				if (loginUser.getCardNumber() == null || loginUser.getCardNumber().trim().isEmpty()) {
					isCardEmpty = true;
				}
			} else {
				// 👥 ゲストの場合：セッションに保存されたゲスト用カード番号をチェック
				String guestCardNum = (String) session.getAttribute("guestCardNumber");
				if (guestCardNum == null || guestCardNum.trim().isEmpty()) {
					isCardEmpty = true;
				}
			}

			// カード情報がどちらのルートでも見つからなかった場合のみ、確認画面に押し戻す
			if (isCardEmpty) {
				session.setAttribute("payment", "bank"); // 決済方法を安全な銀行振込に強制変更
				session.setAttribute("errorMessage", "クレジットカード情報が正しく入力されていないか、登録されていません。別の決済方法を選択してください。");

				request.getRequestDispatcher("/WEB-INF/jsp/checkoutConfirm.jsp").forward(request, response);
				return;
			}
		}

		// =========================================================
		// 🛠️【大修正】すべてセッションスコープから直接、安全に一発取得
		// =========================================================
		String name = (String) session.getAttribute("orderName");
		String zip = (String) session.getAttribute("orderZip");
		String address = (String) session.getAttribute("orderAddress");
		String email = (String) session.getAttribute("orderEmail");
		String phone = (String) session.getAttribute("orderTel");

		// クレジットカード情報（セッションから取得）
		String cardNumber = (String) session.getAttribute("guestCardNumber");
		String cardName = (String) session.getAttribute("guestCardName");
		String cardExpiration = (String) session.getAttribute("guestCardExpiry"); // キー名を統一

		// 🌟【安全対策】DB処理や予期せぬエラーで画面が真っ白になるのを防ぐ
		try {
			// 4. DB保存
			OrderDAO orderDAO = new OrderDAO();

			boolean isSuccess = orderDAO.insertOrders(
					userId, paymentMethod, name, zip, address, email, phone,
					cardNumber, cardName, cardExpiration, cartMap);

			if (isSuccess) {
				// ==============================
				// ② 成功時フラグセット
				// ==============================
				session.setAttribute("alreadyOrdered", true);
				session.setAttribute("isOrderCompleted", true);

				// 🌟【追加】会員とゲストで、完了画面に渡すカード番号を切り分ける
				String displayCardNumber = null;
				if ("credit".equals(paymentMethod)) {
					if (loginUser != null) {
						// 会員の場合：ログインユーザーオブジェクトから取得
						displayCardNumber = loginUser.getCardNumber();
					} else {
						// ゲストの場合：事前にセッションから読み込んだcardNumberを使用
						displayCardNumber = cardNumber;
					}
				}

				// 🌟 complete.jsp が表示で使用するデータをセッションに退避
				session.setAttribute("confirmedCart", cartMap);
				session.setAttribute("confirmedCardNumber", displayCardNumber); // 🛠️ 適切に切り分けた番号をセット
				session.setAttribute("confirmedName", name);
				session.setAttribute("confirmedAddress", address);
				session.setAttribute("confirmedPayment", paymentMethod);

				// カート削除
				session.removeAttribute("cartMap");

				// 🧹【お掃除】使い終わった共通オーダー情報をセッションから綺麗に削除
				session.removeAttribute("orderName");
				session.removeAttribute("orderEmail");
				session.removeAttribute("orderZip");
				session.removeAttribute("orderAddress");
				session.removeAttribute("orderTel");

				// ゲスト用決済情報の削除
				session.removeAttribute("payment");
				session.removeAttribute("guestCardNumber");
				session.removeAttribute("guestCardName");
				session.removeAttribute("guestCardExpiry");

				response.sendRedirect(request.getContextPath() + "/complete.jsp");

			} else {
				session.setAttribute("errorMessage", "注文処理中に問題が発生しました。再度お試しください。");
				response.sendRedirect(request.getContextPath() + "/main");
			}

		} catch (Exception e) {
			e.printStackTrace();
			session.setAttribute("errorMessage", "注文処理中に予期せぬエラーが発生しました。");
			response.sendRedirect(request.getContextPath() + "/main");
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.sendRedirect(request.getContextPath() + "/main");
	}
}