package com.hoandev.demo.exception;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleMethodArgumentNotValid(
            MethodArgumentNotValidException exception,
            HttpServletRequest request
    ) {
        List<ApiFieldError> fieldErrors = exception.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(this::toApiFieldError)
                .toList();

        return buildResponse(ErrorCode.VALIDATION_ERROR, request, fieldErrors);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiError> handleConstraintViolation(
            ConstraintViolationException exception,
            HttpServletRequest request
    ) {
        List<ApiFieldError> fieldErrors = exception.getConstraintViolations()
                .stream()
                .map(violation -> new ApiFieldError(
                        violation.getPropertyPath().toString(),
                        violation.getMessage()
                ))
                .toList();

        return buildResponse(ErrorCode.VALIDATION_ERROR, request, fieldErrors);
    }

    @ExceptionHandler({
            MissingServletRequestParameterException.class,
            MethodArgumentTypeMismatchException.class,
            HttpMessageNotReadableException.class,
            IllegalArgumentException.class
    })
    public ResponseEntity<ApiError> handleBadRequest(Exception exception, HttpServletRequest request) {
        return buildResponse(ErrorCode.BAD_REQUEST, exception.getMessage(), request, List.of());
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiError> handleAuthentication(AuthenticationException exception, HttpServletRequest request) {
        return buildResponse(ErrorCode.UNAUTHORIZED, request, List.of());
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiError> handleAccessDenied(AccessDeniedException exception, HttpServletRequest request) {
        return buildResponse(ErrorCode.FORBIDDEN, request, List.of());
    }

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<ApiError> handleResponseStatus(ResponseStatusException exception, HttpServletRequest request) {
        HttpStatus status = HttpStatus.resolve(exception.getStatusCode().value());
        ErrorCode errorCode = status == HttpStatus.NOT_FOUND ? ErrorCode.RESOURCE_NOT_FOUND : ErrorCode.BAD_REQUEST;
        String message = exception.getReason() != null ? exception.getReason() : errorCode.getMessage();

        return buildResponse(errorCode, message, request, List.of());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleException(Exception exception, HttpServletRequest request) {
        return buildResponse(ErrorCode.INTERNAL_SERVER_ERROR, request, List.of());
    }

    private ApiFieldError toApiFieldError(FieldError fieldError) {
        return new ApiFieldError(fieldError.getField(), fieldError.getDefaultMessage());
    }

    private ResponseEntity<ApiError> buildResponse(
            ErrorCode errorCode,
            HttpServletRequest request,
            List<ApiFieldError> fieldErrors
    ) {
        return buildResponse(errorCode, errorCode.getMessage(), request, fieldErrors);
    }

    private ResponseEntity<ApiError> buildResponse(
            ErrorCode errorCode,
            String message,
            HttpServletRequest request,
            List<ApiFieldError> fieldErrors
    ) {
        ApiError body = new ApiError(
                errorCode.name(),
                message,
                errorCode.getStatus().value(),
                request.getRequestURI(),
                LocalDateTime.now(),
                fieldErrors
        );

        return ResponseEntity.status(errorCode.getStatus()).body(body);
    }

    public record ApiError(
            String code,
            String message,
            int status,
            String path,
            LocalDateTime timestamp,
            List<ApiFieldError> errors
    ) {
    }

    public record ApiFieldError(
            String field,
            String message
    ) {
    }
}
