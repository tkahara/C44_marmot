<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="offcanvas offcanvas-end" tabindex="-1" id="sideCart" aria-labelledby="sideCartLabel">
    
    <div class="offcanvas-header bg-light">
        <h5 class="offcanvas-title fw-bold" id="sideCartLabel">🛒 あなたのカート</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    
    <div class="offcanvas-body">
        
        <div class="d-flex justify-content-between border-bottom pb-2 mb-3">
            <div>
                <h6 class="mb-0">商品名</h6>
                <small class="text-muted">数量</small>
            </div>
            <span>値段</span>
        </div>
        
        <div class="mt-4">
            <h5 class="text-end fw-bold mb-3">合計</h5>
            <div class="d-grid gap-2">
                <a href="checkout.jsp" class="btn btn-success btn-lg">購入手続きへ進む</a>
            </div>
        </div>
        
    </div>
</div>