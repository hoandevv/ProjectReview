package com.hoandev.demo.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "Internal server error"),
    VALIDATION_ERROR(HttpStatus.BAD_REQUEST, "Validation error"),
    BAD_REQUEST(HttpStatus.BAD_REQUEST, "Bad request"),
    UNAUTHORIZED(HttpStatus.UNAUTHORIZED, "Unauthorized"),
    FORBIDDEN(HttpStatus.FORBIDDEN, "Forbidden"),
    RESOURCE_NOT_FOUND(HttpStatus.NOT_FOUND, "Resource not found"),
    INVALID_CREDENTIALS(HttpStatus.UNAUTHORIZED, "Invalid credentials"),

    BRANCH_NOT_FOUND(HttpStatus.NOT_FOUND, "Branch not found"),
    BRANCH_INACTIVE(HttpStatus.BAD_REQUEST, "Branch is inactive"),

    ACCOUNT_NOT_FOUND(HttpStatus.NOT_FOUND, "Account not found"),
    ROLE_NOT_FOUND(HttpStatus.NOT_FOUND, "Role not found"),
    PERMISSION_NOT_FOUND(HttpStatus.NOT_FOUND, "Permission not found"),
    PERMISSION_DENIED(HttpStatus.FORBIDDEN, "Permission denied"),

    CUSTOMER_NOT_FOUND(HttpStatus.NOT_FOUND, "Customer not found"),
    CUSTOMER_ADDRESS_NOT_FOUND(HttpStatus.NOT_FOUND, "Customer address not found"),

    CATEGORY_NOT_FOUND(HttpStatus.NOT_FOUND, "Category not found"),
    PRODUCT_NOT_FOUND(HttpStatus.NOT_FOUND, "Product not found"),
    VARIANT_NOT_FOUND(HttpStatus.NOT_FOUND, "Product variant not found"),
    PRODUCT_UNAVAILABLE(HttpStatus.BAD_REQUEST, "Product is unavailable"),

    CART_NOT_FOUND(HttpStatus.NOT_FOUND, "Cart not found"),
    CART_ITEM_NOT_FOUND(HttpStatus.NOT_FOUND, "Cart item not found"),
    CART_EMPTY(HttpStatus.BAD_REQUEST, "Cart is empty"),

    ORDER_NOT_FOUND(HttpStatus.NOT_FOUND, "Order not found"),
    INVALID_ORDER_STATUS(HttpStatus.BAD_REQUEST, "Invalid order status"),
    ORDER_DELIVERY_NOT_FOUND(HttpStatus.NOT_FOUND, "Order delivery not found"),

    VOUCHER_NOT_FOUND(HttpStatus.NOT_FOUND, "Voucher not found"),
    VOUCHER_INACTIVE(HttpStatus.BAD_REQUEST, "Voucher is inactive"),
    VOUCHER_EXPIRED(HttpStatus.BAD_REQUEST, "Voucher has expired"),
    VOUCHER_USAGE_LIMIT_EXCEEDED(HttpStatus.BAD_REQUEST, "Voucher usage limit exceeded");

    private final HttpStatus status;
    private final String message;

    ErrorCode(HttpStatus status, String message) {
        this.status = status;
        this.message = message;
    }
}
