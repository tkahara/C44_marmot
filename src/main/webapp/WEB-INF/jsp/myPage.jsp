<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ page import="java.text.NumberFormat"%>
<%
// ここで唯一、nfを生成し、pageContextに保存する
NumberFormat nf = NumberFormat.getNumberInstance();
pageContext.setAttribute("nf", nf);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>マイページ - Tea Salon</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
/* ☕ 紅茶ブランドをイメージしたカスタムカラーテーマ（共通同期） */
:root {
	--tea-primary: #6F4E37; /* 深みのあるプレーンな紅茶・ブラウン */
	--tea-dark: #4A3325; /* アッサムのような濃厚なダークブラウン */
	--tea-accent: #C5A059; /* 贅沢なゴールド・プレミアムベージュ */
	--tea-bg-page: #F5EFEB; /* ほんのり甘いミルクティーをイメージした温かみのある背景色 */
	--tea-badge-required: #A94442; /* 落ち着いたアンティークレッド（退会・必須用） */
	--tea-warn: #D9822B; /* 落ち着いたアンティークオレンジ（カード削除・警告用） */
}

body.tea-theme {
	background-color: var(--tea-bg-page) !important;
	color: var(--tea-dark);
	font-family: 'Helvetica Neue', Arial, 'Hiragino Kaku Gothic ProN',
		'Segoe UI', sans-serif;
}

/* エレガントなカードデザイン */
.tea-card {
	border: 1px solid rgba(111, 78, 55, 0.12);
	border-radius: 14px;
	box-shadow: 0 6px 25px rgba(74, 51, 37, 0.07) !important;
	background-color: #FFFFFF !important;
}

.tea-title {
	color: var(--tea-dark);
	letter-spacing: 0.05em;
	position: relative;
	display: inline-block;
	padding-bottom: 10px;
}

.tea-title::after {
	content: '';
	position: absolute;
	left: 50%;
	bottom: 0;
	transform: translateX(-50%);
	width: 45px;
	height: 2px;
	background-color: var(--tea-accent);
}

/* テーブルの美装化（紅茶のトーンに馴染ませる） */
.tea-table {
	border-color: rgba(111, 78, 55, 0.15) !important;
}

.tea-table thead {
	background-color: rgba(111, 78, 55, 0.04) !important;
	color: var(--tea-dark);
}

.tea-table th, .tea-table td {
	border-color: rgba(111, 78, 55, 0.12) !important;
}

/* 各種カスタムボタン */
.btn-tea-primary {
	background-color: var(--tea-primary);
	border-color: var(--tea-primary);
	color: #FFF;
	font-weight: bold;
	transition: all 0.2s;
}

.btn-tea-primary:hover {
	background-color: var(--tea-dark);
	border-color: var(--tea-dark);
	color: #FFF;
}

.btn-tea-outline {
	color: var(--tea-primary);
	border-color: rgba(111, 78, 55, 0.4);
	font-weight: 500;
	transition: all 0.2s;
}

.btn-tea-outline:hover {
	background-color: rgba(111, 78, 55, 0.05);
	color: var(--tea-dark);
	border-color: var(--tea-primary);
}

.btn-tea-warn {
	background-color: var(--tea-warn);
	border-color: var(--tea-warn);
	color: #FFF;
	font-weight: bold;
	transition: all 0.2s;
}

.btn-tea-warn:hover {
	background-color: #B86614;
	border-color: #B86614;
	color: #FFF;
}

.btn-tea-danger {
	background-color: var(--tea-badge-required);
	border-color: var(--tea-badge-required);
	color: #FFF;
	font-weight: bold;
	transition: all 0.2s;
}

.btn-tea-danger:hover {
	background-color: #8A3331;
	border-color: #8A3331;
	color: #FFF;
}

/* 決済方法用の上品なバッジ */
.badge-tea {
	background-color: rgba(111, 78, 55, 0.06) !important;
	color: var(--tea-primary) !important;
	border: 1px solid rgba(111, 78, 55, 0.2) !important;
	font-weight: 600;
}
</style>
</head>
<body class="tea-theme">

	<%-- 🌟 これまでの画面と共通のテンプレート読み込み --%>
	<%@ include file="template/header.jsp"%>
	<%@ include file="template/dialogs.jsp"%>
	<%@ include file="template/cartSideBar.jsp"%>

	<div class="container my-5" style="max-width: 900px;">

		<div class="text-center mb-5">
			<div class="mb-2"
				style="font-size: 2.2rem; color: var(--tea-primary);">☕</div>
			<h2 class="fw-bold tea-title">マイページ</h2>
			<p class="text-muted small mt-2">ご登録情報およびこれまでのご注文履歴をご確認いただけます。</p>
		</div>

		<div class="card p-4 tea-card mb-4">
			<h5 class="fw-bold mb-3" style="color: var(--tea-dark);">📋
				ご登録情報</h5>
			<div class="table-responsive">
				<table class="table table-bordered align-middle tea-table m-0">
					<thead class="table-light">
						<tr>
							<th style="width: 28%;">項目</th>
							<th>内容</th>
							<th style="width: 15%;" class="text-center">操作</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="fw-bold text-muted small">ユーザーID</td>
							<td class="fw-bold"><c:out value="${loginUser.userId}" /></td>
							<td class="text-center"><span class="text-muted small"
								style="font-size: 0.8rem;">変更不可</span></td>
						</tr>
						<tr>
							<td class="fw-bold text-muted small">パスワード</td>
							<td class="font-monospace">******</td>
							<td class="text-center"><a
								href="EditAccountServlet?field=password"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
						<tr>
							<td class="fw-bold text-muted small">氏名</td>
							<td><c:out value="${loginUser.userName}" /> 様</td>
							<td class="text-center"><a
								href="EditAccountServlet?field=user_name"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
						<tr>
							<td class="fw-bold text-muted small">郵便番号</td>
							<td><c:choose>
									<c:when
										test="${not empty loginUser.postalCode and loginUser.postalCode.length() == 7}">
										〒<c:out value="${loginUser.postalCode.substring(0, 3)}" />-<c:out
											value="${loginUser.postalCode.substring(3)}" />
									</c:when>
									<c:otherwise>
										<c:out value="${loginUser.postalCode}" />
									</c:otherwise>
								</c:choose></td>
							<td class="text-center"><a
								href="EditAccountServlet?field=postal_code"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
						<tr>
							<td class="fw-bold text-muted small">配送先住所</td>
							<td><c:out value="${loginUser.address}" /></td>
							<td class="text-center"><a
								href="EditAccountServlet?field=address"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
						<tr>
							<td class="fw-bold text-muted small">メールアドレス</td>
							<td><c:out value="${loginUser.email}" /></td>
							<td class="text-center"><a
								href="EditAccountServlet?field=email"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
						<tr>
							<td class="fw-bold text-muted small">電話番号</td>
							<td><c:choose>
									<%-- 📱 11桁の携帯電話等の場合 (例: 090-1234-5678) --%>
									<c:when
										test="${not empty loginUser.phoneNumber and loginUser.phoneNumber.length() == 11}">
										<c:out value="${loginUser.phoneNumber.substring(0, 3)}" />-<c:out
											value="${loginUser.phoneNumber.substring(3, 7)}" />-<c:out
											value="${loginUser.phoneNumber.substring(7)}" />
									</c:when>

									<%-- 📞 10桁の固定電話等の場合 --%>
									<c:when
										test="${not empty loginUser.phoneNumber and loginUser.phoneNumber.length() == 10}">
										<c:choose>
											<%-- 東京(03)や大阪(06)などの2桁市外局番 (例: 03-1234-5678) --%>
											<c:when
												test="${loginUser.phoneNumber.startsWith('03') or loginUser.phoneNumber.startsWith('06')}">
												<c:out value="${loginUser.phoneNumber.substring(0, 2)}" />-<c:out
													value="${loginUser.phoneNumber.substring(2, 6)}" />-<c:out
													value="${loginUser.phoneNumber.substring(6)}" />
											</c:when>
											<%-- 通常の3桁市外局番 (例: 079-123-4567) --%>
											<c:otherwise>
												<c:out value="${loginUser.phoneNumber.substring(0, 3)}" />-<c:out
													value="${loginUser.phoneNumber.substring(3, 6)}" />-<c:out
													value="${loginUser.phoneNumber.substring(6)}" />
											</c:otherwise>
										</c:choose>
									</c:when>

									<%-- 万が一桁数がそれ以外、または空ならそのまま出力 --%>
									<c:otherwise>
										<c:out value="${loginUser.phoneNumber}" />
									</c:otherwise>
								</c:choose></td>
							<td class="text-center"><a
								href="EditAccountServlet?field=phone_number"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<div class="card p-4 tea-card mb-5">
			<h5 class="fw-bold mb-3" style="color: var(--tea-dark);">💳
				お支払い情報</h5>
			<div class="table-responsive">
				<table class="table table-bordered align-middle tea-table m-0">
					<thead class="table-light">
						<tr>
							<th style="width: 28%;">項目</th>
							<th>内容</th>
							<th style="width: 15%;" class="text-center">操作</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="fw-bold text-muted small">クレジットカード番号</td>
							<td class="font-monospace"><c:choose>
									<c:when test="${empty loginUser.cardNumber}">
										<span class="text-muted small">（未登録）</span>
									</c:when>
									<c:otherwise>
										<c:out value="${loginUser.cardNumber}" />
									</c:otherwise>
								</c:choose></td>
							<td class="text-center"><a
								href="EditAccountServlet?field=card_number"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
						<tr>
							<td class="fw-bold text-muted small">クレジットカード名義</td>
							<td class="text-uppercase"><c:choose>
									<c:when test="${empty loginUser.cardName}">
										<span class="text-muted small">（未登録）</span>
									</c:when>
									<c:otherwise>
										<c:out value="${loginUser.cardName}" />
									</c:otherwise>
								</c:choose></td>
							<td class="text-center"><a
								href="EditAccountServlet?field=card_name"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
						<tr>
							<td class="fw-bold text-muted small">カード有効期限</td>
							<td><c:choose>
									<c:when test="${empty loginUser.cardExpiration}">
										<span class="text-muted small">（未登録）</span>
									</c:when>
									<c:otherwise>
										<c:out value="${loginUser.cardExpiration}" />
									</c:otherwise>
								</c:choose></td>
							<td class="text-center"><a
								href="EditAccountServlet?field=card_expiration"
								class="btn btn-sm btn-tea-outline px-3">編集</a></td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="d-flex justify-content-end mt-3">
				<button type="button" class="btn btn-tea-warn btn-sm px-3"
					data-bs-toggle="modal" data-bs-target="#deleteCardModal">
					💳 登録カード情報の削除</button>
			</div>
		</div>

		<div class="modal fade" id="deleteCardModal" tabindex="-1"
			aria-labelledby="deleteCardModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content"
					style="border-radius: 14px; border: 1px solid rgba(111, 78, 55, 0.15); background-color: #FFFFFF;">

					<div class="modal-header"
						style="background-color: rgba(111, 78, 55, 0.03); border-bottom: 1px solid rgba(111, 78, 55, 0.1);">
						<h5 class="modal-title fw-bold" id="deleteCardModalLabel"
							style="color: var(--tea-dark);">確認</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>

					<div class="modal-body py-4 text-center">
						<div class="mb-3" style="font-size: 2.5rem;">⚠️</div>
						<h6 class="fw-bold mb-2" style="color: var(--tea-dark);">クレジットカード情報を削除してもよろしいですか？</h6>
						<p class="text-muted small mb-0">この操作を行うと、登録されているお支払い情報がすべて消去されます。</p>
					</div>

					<div class="modal-footer justify-content-center"
						style="border-top: 1px solid rgba(111, 78, 55, 0.1); background-color: rgba(111, 78, 55, 0.01);">
						<button type="button" class="btn btn-tea-outline px-4"
							data-bs-dismiss="modal">キャンセル</button>

						<form action="DeleteFieldServlet" method="post" class="m-0">
							<button type="submit" class="btn btn-tea-warn px-4">削除する</button>
						</form>
					</div>

				</div>
			</div>
		</div>

		<div class="card p-4 tea-card mb-4">
			<h5 class="fw-bold mb-3" style="color: var(--tea-dark);">📦 購入履歴</h5>
			<c:choose>
				<c:when test="${empty orderHistory}">
					<p class="text-muted text-center my-4">購入履歴はまだありません。</p>
				</c:when>
				<c:otherwise>
					<div class="table-responsive">
						<table class="table table-hover align-middle tea-table m-0 text-nowrap">
							<thead>
								<tr>
									<th>注文日時</th>
									<th>商品名</th>
									<th class="text-center">単価</th>
									<th class="text-center">数量</th>
									<th class="text-end">合計金額</th>
									<th class="text-center">決済方法</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="order" items="${orderHistory}">
									<tr>
										<td class="text-muted" style="font-size: 0.9rem;"><c:out
												value="${order.orderDate.toString().replace('T', ' ').substring(0, 16)}" />
										</td>
										<td><span class="fw-bold"
											style="color: var(--tea-dark);"> <c:out
													value="${order.productName}" />
										</span></td>
										<td class="text-center"><fmt:formatNumber
												value="${order.unitPrice}" type="currency"
												currencySymbol="¥" maxFractionDigits="0" /></td>
										<td class="text-center"><c:out value="${order.quantity}" />
										</td>
										<td class="text-end fw-bold"
											style="color: var(--tea-primary);"><fmt:formatNumber
												value="${order.totalPrice}" type="currency"
												currencySymbol="¥" maxFractionDigits="0" /></td>
										<td class="text-center"><span class="badge badge-tea">
												<c:choose>
													<c:when test="${order.paymentMethod == 'credit'}">クレジットカード</c:when>
													<c:when test="${order.paymentMethod == 'bank'}">銀行振込</c:when>
													<c:when test="${order.paymentMethod == 'convenience'}">コンビニ決済</c:when>
													<c:when test="${order.paymentMethod == 'cod'}">代金引換</c:when>
													<c:otherwise>
														<c:out value="${order.paymentMethod}" />
													</c:otherwise>
												</c:choose>
										</span></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</c:otherwise>
			</c:choose>
		</div>

		<div class="row g-3 justify-content-between align-items-center mt-3">
			<div class="col-sm-auto">
				<a href="${pageContext.request.contextPath}/main"
					class="btn btn-tea-outline px-4"> ↩️ メイン画面へ戻る </a>
			</div>
			<div class="col-sm-auto">
				<button type="button" class="btn btn-tea-danger px-3"
					data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
					⚠️ 退会する</button>
			</div>
		</div>

		<div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content"
					style="border-radius: 14px; border: 1px solid rgba(111, 78, 55, 0.15); background-color: #FFFFFF;">
					<div class="modal-header"
						style="background-color: rgba(169, 68, 66, 0.03); border-bottom: 1px solid rgba(111, 78, 55, 0.1);">
						<h5 class="modal-title fw-bold"
							style="color: var(--tea-badge-required);">退会の確認</h5>
						<button type="button" class="btn-close"
							data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body py-4 text-center">
						<div class="mb-3" style="font-size: 2.5rem;">⚠️</div>
						<h6 class="fw-bold mb-2" style="color: var(--tea-dark);">本当に退会（アカウント削除）しますか？</h6>
						<p class="text-muted small mb-0">この操作は取り消せません。これまでの購入履歴もすべて削除されます。</p>
					</div>
					<div class="modal-footer justify-content-center"
						style="border-top: 1px solid rgba(111, 78, 55, 0.1); background-color: rgba(111, 78, 55, 0.01);">
						<button type="button" class="btn btn-tea-outline px-4"
							data-bs-dismiss="modal">キャンセル</button>

						<form action="DeleteAccountServlet" method="post" class="m-0">
							<button type="submit" class="btn btn-tea-danger px-4">退会する</button>
						</form>
					</div>
				</div>
			</div>
		</div>

	</div>

	<%@ include file="template/footer.jsp"%>

	<%-- 🌟【重要追加】商品詳細・メイン画面と同期！数量変更パラメータ（added=true）を検知してサイドカートを自動展開するスクリプト --%>
	<script type="text/javascript">
		window.addEventListener('DOMContentLoaded', function() {
			const urlParams = new URLSearchParams(window.location.search);

			if (urlParams.get('added') === 'true') {
				// 正しい要素ID「sideCart」を指定
				const sideCartElement = document.getElementById('sideCart');
				
				if (sideCartElement) {
					if (window.bootstrap && bootstrap.Offcanvas) {
						const bsOffcanvas = new bootstrap.Offcanvas(sideCartElement);
						bsOffcanvas.show();
					} else {
						sideCartElement.classList.add('show');
						sideCartElement.style.visibility = 'visible';
					}
					
					// メイン画面の退会モーダル同様、URLを綺麗に書き換えてリロード時の多重起動を防ぐ
					history.replaceState(null, '', window.location.pathname);
				}
			}
		});
	</script>
</body>
</html>