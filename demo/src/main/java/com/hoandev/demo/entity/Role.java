package com.hoandev.demo.entity;

import com.hoandev.demo.entity.enums.CommonStatus;
import com.hoandev.demo.entity.enums.RoleType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "ia_role")
public class Role extends AuditableEntity {

    @Column(name = "code", length = 80, nullable = false, unique = true)
    private String code;

    @Column(name = "name", length = 150, nullable = false)
    private String name;

    @Column(name = "description")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "role_type", length = 30, nullable = false)
    private RoleType roleType = RoleType.SYSTEM;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 30, nullable = false)
    private CommonStatus status = CommonStatus.ACTIVE;
}
