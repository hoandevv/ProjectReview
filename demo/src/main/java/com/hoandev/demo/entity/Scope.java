package com.hoandev.demo.entity;

import com.hoandev.demo.entity.enums.CommonStatus;
import com.hoandev.demo.entity.enums.ScopeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "ia_scope")
public class Scope extends AuditableEntity {

    @Enumerated(EnumType.STRING)
    @Column(name = "scope_type", length = 30, nullable = false)
    private ScopeType scopeType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "branch_id")
    private Branch branch;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 30, nullable = false)
    private CommonStatus status = CommonStatus.ACTIVE;
}
