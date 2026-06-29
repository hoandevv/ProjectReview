package com.hoandev.demo.entity;

import com.hoandev.demo.entity.enums.CommonStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@Entity
@Table(name = "ce_branch")
public class Branch extends AuditableEntity {

    @Column(name = "code", length = 50, nullable = false, unique = true)
    private String code;

    @Column(name = "name", length = 150, nullable = false)
    private String name;

    @Column(name = "address")
    private String address;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "email", length = 150)
    private String email;

    @Column(name = "latitude", precision = 10, scale = 7)
    private BigDecimal latitude;

    @Column(name = "longitude", precision = 10, scale = 7)
    private BigDecimal longitude;

    @Column(name = "timezone", length = 50, nullable = false)
    private String timezone = "Asia/Ho_Chi_Minh";

    @Column(name = "supports_pickup", nullable = false)
    private Boolean supportsPickup = true;

    @Column(name = "supports_delivery", nullable = false)
    private Boolean supportsDelivery = false;

    @Column(name = "average_preparation_minutes", nullable = false)
    private Integer averagePreparationMinutes = 15;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 30, nullable = false)
    private CommonStatus status = CommonStatus.ACTIVE;
}
