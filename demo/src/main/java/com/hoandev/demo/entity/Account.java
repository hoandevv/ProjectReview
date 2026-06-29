package com.hoandev.demo.entity;

import com.hoandev.demo.entity.enums.AuthProvider;
import com.hoandev.demo.entity.enums.CommonStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "ia_account")
public class Account extends AuditableEntity {

    @Column(name = "username", length = 100, nullable = false, unique = true)
    private String username;

    @Column(name = "password", nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "auth_provider", length = 30, nullable = false)
    private AuthProvider authProvider = AuthProvider.LOCAL;

    @Column(name = "provider_id", length = 150)
    private String providerId;

    @Column(name = "has_local_password", nullable = false)
    private Boolean hasLocalPassword = true;

    @Column(name = "full_name", length = 150, nullable = false)
    private String fullName;

    @Column(name = "email", length = 150, unique = true)
    private String email;

    @Column(name = "phone", length = 20, unique = true)
    private String phone;

    @Column(name = "avatar_url", length = 500)
    private String avatarUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 30, nullable = false)
    private CommonStatus status = CommonStatus.ACTIVE;

    @Column(name = "last_login_at")
    private LocalDateTime lastLoginAt;
}
