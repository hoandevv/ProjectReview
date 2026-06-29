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
@Table(name = "pr_product")
public class Product extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(name = "code", length = 50, nullable = false, unique = true)
    private String code;

    @Column(name = "name", length = 150, nullable = false)
    private String name;

    @Column(name = "description", length = 500)
    private String description;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "base_price", precision = 12, scale = 2, nullable = false)
    private BigDecimal basePrice;

    @Column(name = "preparation_minutes", nullable = false)
    private Integer preparationMinutes = 10;

    @Column(name = "is_featured", nullable = false)
    private Boolean featured = false;

    @Column(name = "is_best_seller", nullable = false)
    private Boolean bestSeller = false;

    @Column(name = "available_ice_levels", length = 50, nullable = false)
    private String availableIceLevels = "0,30,50,70,100";

    @Column(name = "available_sugar_levels", length = 50, nullable = false)
    private String availableSugarLevels = "0,30,50,70,100";

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 30, nullable = false)
    private CommonStatus status = CommonStatus.ACTIVE;
}
