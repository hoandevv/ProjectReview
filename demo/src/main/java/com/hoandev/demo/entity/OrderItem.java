package com.hoandev.demo.entity;

import com.hoandev.demo.entity.enums.CommonStatus;
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

import java.math.BigDecimal;

@Getter
@Setter
@Entity
@Table(name = "od_order_item")
public class OrderItem extends AuditableEntity {

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 30, nullable = false)
    private CommonStatus status = CommonStatus.ACTIVE;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "order_id", nullable = false)
    private CustomerOrder order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id")
    private ProductVariant variant;

    @Column(name = "product_code", length = 50, nullable = false)
    private String productCode;

    @Column(name = "product_name", length = 150, nullable = false)
    private String productName;

    @Column(name = "variant_name", length = 100)
    private String variantName;

    @Column(name = "quantity", nullable = false)
    private Integer quantity;

    @Column(name = "sugar_level", length = 30, nullable = false)
    private String sugarLevel = "NORMAL";

    @Column(name = "ice_level", length = 30, nullable = false)
    private String iceLevel = "NORMAL";

    @Column(name = "note")
    private String note;

    @Column(name = "unit_price", precision = 12, scale = 2, nullable = false)
    private BigDecimal unitPrice;

    @Column(name = "total_price", precision = 12, scale = 2, nullable = false)
    private BigDecimal totalPrice;
}
