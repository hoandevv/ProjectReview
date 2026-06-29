CREATE TABLE ca_cart (
    id CHAR(36) NOT NULL,
    customer_id CHAR(36) NULL,
    branch_id CHAR(36) NOT NULL,
    session_id VARCHAR(120) NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ca_cart PRIMARY KEY (id),
    CONSTRAINT fk_ca_cart_customer FOREIGN KEY (customer_id) REFERENCES cu_customer_profile (id) ON DELETE CASCADE,
    CONSTRAINT fk_ca_cart_branch FOREIGN KEY (branch_id) REFERENCES ce_branch (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_ca_cart_customer_status ON ca_cart (customer_id, status);
CREATE INDEX idx_ca_cart_session_status ON ca_cart (session_id, status);
CREATE INDEX idx_ca_cart_branch ON ca_cart (branch_id);

CREATE TABLE ca_cart_item (
    id CHAR(36) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    cart_id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,
    variant_id CHAR(36) NULL,
    quantity INT NOT NULL,
    sugar_level VARCHAR(30) NOT NULL DEFAULT 'NORMAL',
    ice_level VARCHAR(30) NOT NULL DEFAULT 'NORMAL',
    note VARCHAR(255) NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ca_cart_item PRIMARY KEY (id),
    CONSTRAINT fk_ca_cart_item_cart FOREIGN KEY (cart_id) REFERENCES ca_cart (id) ON DELETE CASCADE,
    CONSTRAINT fk_ca_cart_item_product FOREIGN KEY (product_id) REFERENCES pr_product (id) ON DELETE RESTRICT,
    CONSTRAINT fk_ca_cart_item_variant FOREIGN KEY (variant_id) REFERENCES pr_product_variant (id) ON DELETE SET NULL,
    CONSTRAINT chk_ca_cart_item_quantity CHECK (quantity > 0),
    CONSTRAINT chk_ca_cart_item_unit_price CHECK (unit_price >= 0),
    CONSTRAINT chk_ca_cart_item_total_price CHECK (total_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_ca_cart_item_cart ON ca_cart_item (cart_id);
CREATE INDEX idx_ca_cart_item_product ON ca_cart_item (product_id);

CREATE TABLE od_order (
    id CHAR(36) NOT NULL,
    order_code VARCHAR(50) NOT NULL,
    branch_id CHAR(36) NOT NULL,
    customer_id CHAR(36) NULL,
    customer_name VARCHAR(150) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    customer_email VARCHAR(150) NULL,
    order_type VARCHAR(30) NOT NULL DEFAULT 'PICKUP',
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    payment_method VARCHAR(50) NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'UNPAID',
    subtotal_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    delivery_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    pickup_time DATETIME NULL,
    delivery_address VARCHAR(255) NULL,
    note VARCHAR(500) NULL,
    confirmed_at DATETIME NULL,
    prepared_at DATETIME NULL,
    ready_at DATETIME NULL,
    delivering_at DATETIME NULL,
    delivered_at DATETIME NULL,
    completed_at DATETIME NULL,
    cancelled_at DATETIME NULL,
    rejected_at DATETIME NULL,
    cancel_reason VARCHAR(255) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_od_order PRIMARY KEY (id),
    CONSTRAINT uk_od_order_order_code UNIQUE (order_code),
    CONSTRAINT fk_od_order_branch FOREIGN KEY (branch_id) REFERENCES ce_branch (id) ON DELETE RESTRICT,
    CONSTRAINT fk_od_order_customer FOREIGN KEY (customer_id) REFERENCES cu_customer_profile (id) ON DELETE SET NULL,
    CONSTRAINT chk_od_order_subtotal_amount CHECK (subtotal_amount >= 0),
    CONSTRAINT chk_od_order_discount_amount CHECK (discount_amount >= 0),
    CONSTRAINT chk_od_order_delivery_fee CHECK (delivery_fee >= 0),
    CONSTRAINT chk_od_order_total_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_od_order_status CHECK (status IN ('PENDING', 'CONFIRMED', 'PREPARING', 'READY', 'DELIVERING', 'COMPLETED', 'CANCELLED', 'REJECTED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_od_order_customer_created_at ON od_order (customer_id, created_at);
CREATE INDEX idx_od_order_branch_created_at ON od_order (branch_id, created_at);
CREATE INDEX idx_od_order_branch_status_created_at ON od_order (branch_id, status, created_at);
CREATE INDEX idx_od_order_branch_order_type_status_created_at ON od_order (branch_id, order_type, status, created_at);
CREATE INDEX idx_od_order_branch_payment_method_created_at ON od_order (branch_id, payment_method, created_at);
CREATE INDEX idx_od_order_branch_payment_status_created_at ON od_order (branch_id, payment_status, created_at);

CREATE TABLE od_order_item (
    id CHAR(36) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    order_id CHAR(36) NOT NULL,
    product_id CHAR(36) NULL,
    variant_id CHAR(36) NULL,
    product_code VARCHAR(50) NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    variant_name VARCHAR(100) NULL,
    quantity INT NOT NULL,
    sugar_level VARCHAR(30) NOT NULL DEFAULT 'NORMAL',
    ice_level VARCHAR(30) NOT NULL DEFAULT 'NORMAL',
    note VARCHAR(255) NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_od_order_item PRIMARY KEY (id),
    CONSTRAINT fk_od_order_item_order FOREIGN KEY (order_id) REFERENCES od_order (id) ON DELETE CASCADE,
    CONSTRAINT fk_od_order_item_product FOREIGN KEY (product_id) REFERENCES pr_product (id) ON DELETE SET NULL,
    CONSTRAINT fk_od_order_item_variant FOREIGN KEY (variant_id) REFERENCES pr_product_variant (id) ON DELETE SET NULL,
    CONSTRAINT chk_od_order_item_quantity CHECK (quantity > 0),
    CONSTRAINT chk_od_order_item_unit_price CHECK (unit_price >= 0),
    CONSTRAINT chk_od_order_item_total_price CHECK (total_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_od_order_item_order ON od_order_item (order_id);
CREATE INDEX idx_od_order_item_product ON od_order_item (product_id);

CREATE TABLE od_order_delivery (
    id CHAR(36) NOT NULL,
    order_id CHAR(36) NOT NULL,
    shipper_id CHAR(36) NULL,
    receiver_name VARCHAR(150) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    delivery_note VARCHAR(500) NULL,
    delivery_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    assigned_at DATETIME NULL,
    picked_up_at DATETIME NULL,
    delivered_at DATETIME NULL,
    failed_at DATETIME NULL,
    fail_reason VARCHAR(255) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_od_order_delivery PRIMARY KEY (id),
    CONSTRAINT uk_od_order_delivery_order UNIQUE (order_id),
    CONSTRAINT fk_od_order_delivery_order FOREIGN KEY (order_id) REFERENCES od_order (id) ON DELETE CASCADE,
    CONSTRAINT fk_od_order_delivery_shipper FOREIGN KEY (shipper_id) REFERENCES ia_account (id) ON DELETE SET NULL,
    CONSTRAINT chk_od_order_delivery_delivery_fee CHECK (delivery_fee >= 0),
    CONSTRAINT chk_od_order_delivery_status CHECK (status IN ('PENDING', 'ASSIGNED', 'PICKED_UP', 'DELIVERING', 'DELIVERED', 'FAILED', 'CANCELLED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_od_order_delivery_shipper_status_created_at ON od_order_delivery (shipper_id, status, created_at);
CREATE INDEX idx_od_order_delivery_status_created_at ON od_order_delivery (status, created_at);

CREATE TABLE od_order_status_history (
    id CHAR(36) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    order_id CHAR(36) NOT NULL,
    old_status VARCHAR(30) NULL,
    new_status VARCHAR(30) NOT NULL,
    reason VARCHAR(255) NULL,
    changed_by CHAR(36) NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_od_order_status_history PRIMARY KEY (id),
    CONSTRAINT fk_od_order_status_history_order FOREIGN KEY (order_id) REFERENCES od_order (id) ON DELETE CASCADE,
    CONSTRAINT fk_od_order_status_history_changed_by FOREIGN KEY (changed_by) REFERENCES ia_account (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_od_order_status_history_order_changed_at ON od_order_status_history (order_id, changed_at);
CREATE INDEX idx_od_order_status_history_new_status ON od_order_status_history (new_status);

CREATE TABLE vc_voucher (
    id CHAR(36) NOT NULL,
    code VARCHAR(80) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(500) NULL,
    discount_type VARCHAR(30) NOT NULL,
    discount_value DECIMAL(12,2) NOT NULL,
    max_discount_amount DECIMAL(12,2) NULL,
    min_order_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    usage_limit INT NULL,
    used_count INT NOT NULL DEFAULT 0,
    usage_limit_per_customer INT NULL,
    start_at DATETIME NOT NULL,
    end_at DATETIME NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_vc_voucher PRIMARY KEY (id),
    CONSTRAINT uk_vc_voucher_code UNIQUE (code),
    CONSTRAINT chk_vc_voucher_discount_value CHECK (discount_value >= 0),
    CONSTRAINT chk_vc_voucher_max_discount_amount CHECK (max_discount_amount IS NULL OR max_discount_amount >= 0),
    CONSTRAINT chk_vc_voucher_min_order_amount CHECK (min_order_amount >= 0),
    CONSTRAINT chk_vc_voucher_used_count CHECK (used_count >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_vc_voucher_status_start_end ON vc_voucher (status, start_at, end_at);

CREATE TABLE vc_voucher_usage (
    id CHAR(36) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    voucher_id CHAR(36) NOT NULL,
    order_id CHAR(36) NOT NULL,
    customer_id CHAR(36) NULL,
    discount_amount DECIMAL(12,2) NOT NULL,
    used_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_vc_voucher_usage PRIMARY KEY (id),
    CONSTRAINT uk_vc_voucher_usage_voucher_order UNIQUE (voucher_id, order_id),
    CONSTRAINT fk_vc_voucher_usage_voucher FOREIGN KEY (voucher_id) REFERENCES vc_voucher (id) ON DELETE RESTRICT,
    CONSTRAINT fk_vc_voucher_usage_order FOREIGN KEY (order_id) REFERENCES od_order (id) ON DELETE CASCADE,
    CONSTRAINT fk_vc_voucher_usage_customer FOREIGN KEY (customer_id) REFERENCES cu_customer_profile (id) ON DELETE SET NULL,
    CONSTRAINT chk_vc_voucher_usage_discount_amount CHECK (discount_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_vc_voucher_usage_customer_voucher ON vc_voucher_usage (customer_id, voucher_id);
CREATE INDEX idx_vc_voucher_usage_voucher_used_at ON vc_voucher_usage (voucher_id, used_at);
